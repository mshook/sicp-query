#!/usr/bin/env python3
"""
SPARQL Query Runner for Microshaft Database
Loads the RDF data and executes SPARQL queries using rdflib
"""

import re
from pathlib import Path
from rdflib import Graph
from rdflib.plugins.sparql import prepareQuery


def load_rdf_data(ttl_file):
    """Load RDF data from Turtle file."""
    print(f"Loading RDF data from {ttl_file}...")
    g = Graph()
    g.parse(ttl_file, format='turtle')
    print(f"Loaded {len(g)} triples\n")
    return g


def parse_sparql_file(sparql_file):
    """
    Parse SPARQL file and extract individual queries.
    Returns a list of (query_name, query_string) tuples.
    """
    with open(sparql_file, 'r') as f:
        content = f.read()

    # Split on comment headers that start with "# Query"
    query_pattern = r'# (Query \d+:.*?)\n(.*?)(?=\n# Query|\Z)'
    matches = re.findall(query_pattern, content, re.DOTALL)

    queries = []
    for title, query_text in matches:
        # Clean up the query text - remove comments but keep the actual SPARQL
        lines = query_text.split('\n')
        sparql_lines = []
        for line in lines:
            # Skip pure comment lines, but keep lines with SPARQL content
            if line.strip() and not line.strip().startswith('#'):
                sparql_lines.append(line)

        if sparql_lines:
            query_string = '\n'.join(sparql_lines)
            queries.append((title.strip(), query_string.strip()))

    return queries


def format_results(results):
    """Format SPARQL query results as a table."""
    if not results:
        return "No results"

    # Get column names
    vars = results.vars
    if not vars:
        return "Query executed successfully (no SELECT variables)"

    # Prepare data rows
    rows = []
    for row in results:
        rows.append([format_value(row[var]) for var in vars])

    if not rows:
        return "No results"

    # Calculate column widths
    headers = [str(var) for var in vars]
    col_widths = [len(h) for h in headers]

    for row in rows:
        for i, val in enumerate(row):
            col_widths[i] = max(col_widths[i], len(val))

    # Build table
    lines = []

    # Header
    header_line = " | ".join(h.ljust(w) for h, w in zip(headers, col_widths))
    lines.append(header_line)
    lines.append("-" * len(header_line))

    # Rows
    for row in rows:
        line = " | ".join(val.ljust(w) for val, w in zip(row, col_widths))
        lines.append(line)

    return "\n".join(lines)


def format_value(value):
    """Format a single RDF value for display."""
    if value is None:
        return ""

    # Convert to string
    s = str(value)

    # Remove namespace prefixes for cleaner display
    if "http://example.org/microshaft/" in s:
        s = s.replace("http://example.org/microshaft/", ":")
    if "http://xmlns.com/foaf/0.1/" in s:
        s = s.replace("http://xmlns.com/foaf/0.1/", "foaf:")

    return s


def run_query(graph, query_name, query_string, verbose=False):
    """Execute a single SPARQL query and display results."""
    print("=" * 80)
    print(f"Query: {query_name}")
    print("=" * 80)

    if verbose:
        print("\nSPARQL:")
        print(query_string)
        print()

    try:
        results = graph.query(query_string)

        # Format and display results
        formatted = format_results(results)
        print(formatted)

        # Count results
        if results.vars:
            count = len(list(results))
            print(f"\n({count} result{'s' if count != 1 else ''})")

    except Exception as e:
        print(f"ERROR executing query: {e}")

    print()


def main():
    """Main function to load data and run queries."""
    import argparse

    parser = argparse.ArgumentParser(
        description='Run SPARQL queries against the Microshaft RDF database'
    )
    parser.add_argument(
        '--ttl',
        default='microshaft-data.ttl',
        help='Path to Turtle RDF file (default: microshaft-data.ttl)'
    )
    parser.add_argument(
        '--sparql',
        default='sample-queries.sparql',
        help='Path to SPARQL queries file (default: sample-queries.sparql)'
    )
    parser.add_argument(
        '--query',
        type=int,
        help='Run only a specific query number (e.g., --query 1)'
    )
    parser.add_argument(
        '--verbose',
        '-v',
        action='store_true',
        help='Show the SPARQL query text before results'
    )
    parser.add_argument(
        '--list',
        '-l',
        action='store_true',
        help='List all available queries without running them'
    )

    args = parser.parse_args()

    # Parse queries
    queries = parse_sparql_file(args.sparql)

    if args.list:
        print("Available queries:")
        for i, (title, _) in enumerate(queries, 1):
            print(f"  {i}. {title}")
        return

    # Load RDF data
    graph = load_rdf_data(args.ttl)

    # Run queries
    if args.query:
        # Run specific query
        if 1 <= args.query <= len(queries):
            title, query_string = queries[args.query - 1]
            run_query(graph, title, query_string, args.verbose)
        else:
            print(f"Error: Query {args.query} not found. Valid range: 1-{len(queries)}")
    else:
        # Run all queries
        for title, query_string in queries:
            run_query(graph, title, query_string, args.verbose)
            input("Press Enter to continue to next query (or Ctrl+C to quit)...")


if __name__ == '__main__':
    main()
