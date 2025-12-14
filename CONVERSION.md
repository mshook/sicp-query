# Converting SICP Query System to RDF/SPARQL

This document explains the conversion process from the Scheme assertions in `query.scm` to the RDF Turtle format in `microshaft-data.ttl`.

## The Source Data Structure

In query.scm (lines 581-653), the microshaft database is a list of Scheme assertions:

```scheme
(define microshaft-data-base
  '(
    (address (Bitdiddle Ben) (Slumerville (Ridge Road) 10))
    (job (Bitdiddle Ben) (computer wizard))
    (salary (Bitdiddle Ben) 60000)
    (supervisor (Hacker Alyssa P) (Bitdiddle Ben))
    ...
    (can-do-job (computer wizard) (computer programmer))
    ...
    (rule (lives-near ?person-1 ?person-2) ...)
  ))
```

## Conversion Decisions

### 1. Identifying Entities vs Properties

I analyzed the Scheme assertions and categorized them:

- **Entities** (things that exist): People, Addresses, Job Roles
- **Properties** (relationships): hasAddress, hasJob, salary, reportsTo, canDoJob

### 2. Choosing RDF Vocabularies

Instead of creating everything custom, I used standard vocabularies where appropriate:

- **FOAF (Friend of a Friend)**: Standard for representing people
  - `foaf:Person` for person entities
  - `foaf:name` for names

- **ORG (Organization Ontology)**: Standard for organizational structures
  - `org:reportsTo` for the supervisor relationship

- **Custom namespace** (`:`) for domain-specific properties:
  - `:hasAddress`, `:hasJob`, `:salary`, `:jobTitle`, `:canDoJob`

### 3. Entity Modeling

#### People

Converted from multiple assertions to unified resources:

**Scheme: Multiple separate assertions**
```scheme
(address (Bitdiddle Ben) (Slumerville (Ridge Road) 10))
(job (Bitdiddle Ben) (computer wizard))
(salary (Bitdiddle Ben) 60000)
(supervisor (Bitdiddle Ben) (Warbucks Oliver))
```

**RDF: Single resource with multiple properties**
```turtle
:BenBitdiddle a foaf:Person ;
    foaf:name "Ben Bitdiddle" ;
    :hasAddress :Address_BenBitdiddle ;
    :hasJob :Job_ComputerWizard ;
    :salary 60000 ;
    org:reportsTo :OliverWarbucks .
```

#### Addresses

Decomposed nested lists into structured resources:

**Scheme: Nested list structure**
```scheme
(address (Bitdiddle Ben) (Slumerville (Ridge Road) 10))
```

**RDF: Separate address resource with properties**
```turtle
:Address_BenBitdiddle a :Address ;
    :city "Slumerville" ;
    :street "Ridge Road" ;
    :streetNumber 10 .
```

#### Job Roles

Created as first-class resources instead of tuples:

**Scheme: Job as a tuple in assertions**
```scheme
(job (Bitdiddle Ben) (computer wizard))
(can-do-job (computer wizard) (computer programmer))
```

**RDF: Job roles are resources with their own properties**
```turtle
:Job_ComputerWizard a :JobRole ;
    :jobTitle "computer wizard" ;
    :canDoJob :Job_ComputerProgrammer ;
    :canDoJob :Job_ComputerTechnician .

:BenBitdiddle :hasJob :Job_ComputerWizard .
```

### 4. Naming Convention Transformations

I converted Scheme's list-based names to RDF URI-friendly identifiers:

| Scheme | RDF |
|--------|-----|
| `(Bitdiddle Ben)` | `:BenBitdiddle` |
| `(Hacker Alyssa P)` | `:AlyssaPHacker` |
| `(computer wizard)` | `:Job_ComputerWizard` |
| `(computer programmer)` | `:Job_ComputerProgrammer` |

**Rules for conversion:**
- Last name first → First name first
- Spaces removed
- CamelCase applied
- Prefixes added (`Job_`, `Address_`) for clarity

### 5. Relationship Direction

Reversed the supervisor relationship to match organizational patterns:

**Scheme: Points to supervisor**
```scheme
(supervisor (Hacker Alyssa P) (Bitdiddle Ben))
; Reads as: "Alyssa's supervisor is Ben"
```

**RDF: Uses org:reportsTo (same direction)**
```turtle
:AlyssaPHacker org:reportsTo :BenBitdiddle .
# Reads as: "Alyssa reports to Ben"
```

### 6. Handling Rules vs Data

#### Data (assertions)

Converted directly to RDF triples:

**Scheme:**
```scheme
(can-do-job (computer wizard) (computer programmer))
```

**RDF:**
```turtle
:Job_ComputerWizard :canDoJob :Job_ComputerProgrammer .
```

#### Rules

NOT converted to RDF data - these became SPARQL queries instead:

**Scheme rule:**
```scheme
(rule (lives-near ?person-1 ?person-2)
      (and (address ?person-1 (?town . ?rest-1))
           (address ?person-2 (?town . ?rest-2))
           (not (same ?person-1 ?person-2))))
```

**SPARQL query (Query 8 in sample-queries.sparql):**
```sparql
SELECT ?name ?city
WHERE {
    :BenBitdiddle :hasAddress ?benAddress .
    ?benAddress :city ?city .
    ?person :hasAddress ?address ;
            foaf:name ?name .
    ?address :city ?city .
    FILTER(?person != :BenBitdiddle)
}
```

### 7. Metadata and Schema

Added formal RDF property and class definitions at the bottom:

```turtle
:hasAddress a rdf:Property ;
    rdfs:label "has address" ;
    rdfs:domain foaf:Person ;
    rdfs:range :Address .

:Address a rdfs:Class ;
    rdfs:label "Address" ;
    rdfs:comment "A physical address with city, street, and street number" .
```

## Key Differences

| Aspect | Scheme | RDF/Turtle |
|--------|--------|------------|
| **Data model** | Flat assertions (predicates with tuples) | Graph with nodes and edges |
| **Entities** | Implicit (tuples in assertions) | Explicit (URIs for each entity) |
| **Identity** | Name tuples like `(Bitdiddle Ben)` | URIs like `:BenBitdiddle` |
| **Relationships** | Predicate name + position in tuple | Explicit property URIs |
| **Schema** | Implicit (inferred from usage) | Explicit (rdfs:Class, rdf:Property) |
| **Rules** | First-class (stored in database) | External (SPARQL queries) |
| **Vocabularies** | Custom predicates only | Mix of standard (FOAF, ORG) and custom |

## Summary

The conversion essentially transformed a **logic programming database** (optimized for pattern matching and unification) into a **semantic web knowledge graph** (optimized for linked data and standardized vocabularies).

### Key Transformations

1. **Reification**: Implicit entities (like addresses and job roles) became explicit resources with URIs
2. **Normalization**: Data about the same entity scattered across multiple assertions was consolidated
3. **Standardization**: Used well-known RDF vocabularies (FOAF, ORG) instead of custom predicates where possible
4. **Separation of concerns**: Rules moved from data to queries (SPARQL)
5. **Schema formalization**: Added explicit class and property definitions with documentation
