# RDF/SPARQL Version of SICP Query System

This directory contains an RDF representation of the Microshaft database from SICP Chapter 4.4.4, along with SPARQL queries that demonstrate equivalent functionality to the original Scheme query system.

## Files

- `microshaft-data.ttl` - RDF Turtle representation of the Microshaft employee database
- `sample-queries.sparql` - 21 SPARQL queries demonstrating query patterns from SICP
- `run_queries.py` - Python script to execute the queries using rdflib
- `requirements.txt` - Python dependencies

## Setup

Install the required Python package:

```bash
pip install -r requirements.txt
```

Or install rdflib directly:

```bash
pip install rdflib
```

## Usage

### Run all queries (interactive)

```bash
python3 run_queries.py
```

This will run each query one at a time, waiting for you to press Enter between queries.

### Run a specific query

```bash
python3 run_queries.py --query 1
```

### List available queries

```bash
python3 run_queries.py --list
```

### Show SPARQL query text with results

```bash
python3 run_queries.py --query 5 --verbose
```

### Use custom file paths

```bash
python3 run_queries.py --ttl my-data.ttl --sparql my-queries.sparql
```

## Query Examples

The sample queries include:

1. **Basic Pattern Matching**: Find computer programmers, addresses, salaries
2. **Supervisor Relationships**: Direct and transitive reporting relationships
3. **Lives-Near Rule**: Find people living in the same city
4. **Wheel Rule**: Find managers of managers
5. **Outranked-By Rule**: Transitive supervisor hierarchy using SPARQL property paths
6. **Can-Do-Job**: Job capability relationships with transitive closure
7. **Complex Queries**: Multi-condition filters (e.g., programmers in Cambridge making > $35K)
8. **Aggregations**: Statistics by job title, city, etc. (not available in original SICP system)

## RDF Schema

The data uses the following vocabularies:

- **FOAF** (Friend of a Friend): `foaf:Person`, `foaf:name`
- **ORG** (Organization): `org:reportsTo` for supervisor relationships
- **Custom namespace** (`:`) for domain-specific properties:
  - `:hasAddress`, `:hasJob`, `:salary`
  - `:city`, `:street`, `:streetNumber`
  - `:jobTitle`, `:canDoJob`

## Comparison with SICP Query System

### Similarities

- Pattern matching against facts (assertions)
- Logical queries with AND/OR conditions
- Transitive relationships (rules)
- Variable binding and unification

### Differences

**SPARQL Advantages:**
- Property paths (`+`, `*`) for transitive closure without explicit rules
- Aggregation functions (COUNT, AVG, MIN, MAX, SUM)
- Sorting and filtering with standard SQL-like syntax
- Integration with RDF/Linked Data ecosystem

**SICP Query System Advantages:**
- Interactive rule definition at runtime
- First-class support for Lisp predicates
- Educational clarity in demonstrating logic programming concepts
- Tight integration with Scheme code

### Rule Translation

The SICP rules are implemented in SPARQL as follows:

| SICP Rule | SPARQL Implementation |
|-----------|----------------------|
| `(lives-near ?p1 ?p2)` | Filter on same city using JOIN |
| `(wheel ?person)` | Nested pattern: `?x org:reportsTo ?mid . ?mid org:reportsTo ?person` |
| `(outranked-by ?staff ?boss)` | Property path: `?staff org:reportsTo+ ?boss` |
| `(can-do-job ?j1 ?j2)` | Property path: `:canDoJob+` |

## Example Session

```bash
$ python3 run_queries.py --query 1

================================================================================
Query: Find all computer programmers
================================================================================
person                                      | name
------------------------------------------------------------------
:AlyssaPHacker                              | Alyssa P Hacker
:CyDFect                                    | Cy D Fect

(2 results)

$ python3 run_queries.py --query 8

================================================================================
Query: Find people who live near Ben Bitdiddle (same city)
================================================================================
name             | city
--------------------------------
Louis Reasoner   | Slumerville
DeWitt Aull      | Slumerville

(2 results)
```

## Extending the System

To add more data:

1. Edit `microshaft-data.ttl` and add new RDF triples
2. Follow the existing patterns for persons, addresses, and job roles
3. Reload the data and run your queries

To add new queries:

1. Edit `sample-queries.sparql` and add your SPARQL query
2. Follow the naming convention: `# Query N: Description`
3. Run with `python3 run_queries.py --query N`
