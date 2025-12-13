# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains the Query System implementation from Section 4.4.4 of *Structure and Interpretation of Computer Programs* (SICP). It's a logic programming system written in Scheme that supports pattern matching, rules, and queries similar to Prolog.

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

## Code Architecture

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
