# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains the Query System implementation from Section 4.4.4 of *Structure and Interpretation of Computer Programs* (SICP). It's a logic programming system written in Scheme that supports pattern matching, rules, and queries similar to Prolog.

The repository also includes an RDF/SPARQL version of the same database and queries, demonstrating how the SICP query concepts translate to modern semantic web technologies.

## Running the Query System

The query system requires a Scheme interpreter that supports streams. To use it:

1. Load the file into your Scheme interpreter:
   ```scheme
   (load "query.scm")
   ```

2. Initialize the database with the provided sample data:
   ```scheme
   (initialize-data-base microshaft-data-base)
   ```

3. Start the query driver loop:
   ```scheme
   (query-driver-loop)
   ```

4. Enter queries at the `;;; Query input:` prompt. Examples:
   ```scheme
   (job ?x (computer programmer))
   (and (job ?person (computer . ?type)) (address ?person ?where))
   (lives-near ?x (Bitdiddle Ben))
   ```

5. Add new assertions or rules:
   ```scheme
   (assert! (job (Doe John) (computer programmer)))
   ```

## RDF/SPARQL Version

The repository includes an RDF representation of the Microshaft database with equivalent SPARQL queries.

### Files

- `microshaft-data.ttl` - RDF Turtle file with the employee database
- `sample-queries.sparql` - 21 SPARQL queries demonstrating query patterns
- `run_queries.py` - Python script to execute queries using rdflib
- `RDF-README.md` - Complete documentation for the RDF version

### Running SPARQL Queries

```bash
# Install dependencies
pip install rdflib
# or
sudo apt install python3-rdflib

# List all available queries
python3 run_queries.py --list

# Run a specific query
python3 run_queries.py --query 1

# Run with verbose output (shows SPARQL text)
python3 run_queries.py --query 5 --verbose

# Run all queries interactively
python3 run_queries.py
```

### RDF Schema

The data uses standard vocabularies:
- **FOAF**: `foaf:Person`, `foaf:name`
- **ORG**: `org:reportsTo` for supervisor relationships
- **Custom namespace** (`:`): `:hasAddress`, `:hasJob`, `:salary`, `:jobTitle`, `:canDoJob`

### SPARQL vs Scheme Queries

Key differences:
- SPARQL uses property paths (`+`, `*`) for transitive closure instead of explicit rules
- Aggregation functions (COUNT, AVG, MIN, MAX) not available in SICP system
- Rules like `lives-near`, `wheel`, `outranked-by` are implemented as SPARQL patterns

Example translation:

| SICP Rule | SPARQL Implementation |
|-----------|----------------------|
| `(lives-near ?p1 ?p2)` | Filter on same city using JOIN |
| `(wheel ?person)` | Nested pattern: `?x org:reportsTo ?mid . ?mid org:reportsTo ?person` |
| `(outranked-by ?staff ?boss)` | Property path: `?staff org:reportsTo+ ?boss` |

## Scheme Code Architecture

### Core Components

The system is organized into distinct sections following SICP's structure:

- **Driver Loop (lines 18-54)**: `query-driver-loop` reads queries, processes them, and displays results by instantiating pattern variables from successful matches.

- **Evaluator (lines 56-132)**: `qeval` dispatches queries to specialized handlers. Simple queries use pattern matching; compound queries (`and`, `or`, `not`, `lisp-value`) are processed recursively.

- **Pattern Matching (lines 134-165)**: `pattern-match` and `find-assertions` match query patterns against database assertions using frame-based variable bindings.

- **Unification & Rules (lines 167-238)**: `apply-rules` and `unify-match` implement rule application with variable renaming to avoid conflicts. Unification is bidirectional (both patterns can contain variables).

- **Database Indexing (lines 240-321)**: Assertions and rules are stored in indexed streams for efficient retrieval. The index uses the first symbol of patterns as keys.

- **Stream Operations (lines 323-353)**: Delayed stream operations (`stream-append-delayed`, `interleave-delayed`) prevent infinite loops in recursive rules.

- **Syntax Processing (lines 356-438)**: Converts `?var` notation to internal representation `(? var)` and handles rule syntax.

- **Frame Management (lines 440-458)**: Frames are association lists mapping pattern variables to values.

### Key Design Patterns

**Stream-based evaluation**: All query results are returned as streams of frames, allowing lazy evaluation and handling of infinite result sets.

**Frame-based unification**: Variable bindings are accumulated in frames as patterns are matched, supporting backtracking through multiple frame streams.

**Table-driven dispatch**: The `qeval` function uses a dispatch table (`get`/`put`) to handle different query types (`and`, `or`, `not`, etc.).

**Delayed evaluation**: Rules that could produce infinite results (like transitive relations) use delayed streams to interleave results fairly.

### Data Structures

- **Frames**: Lists of variable-value bindings `((var . value) ...)`
- **Rules**: `(rule <conclusion> <body>)` where body is a query pattern
- **Assertions**: Simple facts like `(job (Doe John) (programmer))`
- **Patterns**: S-expressions with variables like `(job ?x ?role)`

## Implementation Notes

- The `put` and `get` operations are initialized by `initialize-data-base`, which sets up the operation table and registers query evaluators.
- Variables in rules are renamed during application to avoid capture (see `rename-variables-in`).
- The `depends-on?` check prevents circular variable bindings during unification.
- Stream operations must be carefully delayed to prevent premature evaluation of infinite streams.
