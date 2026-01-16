# RDF to Scheme Triple Translation

This document describes how `microshaft-data.ttl` was translated to `microshaft-triples.scm` for use with the SICP query system.

## Triple Format

RDF triples are `(subject, predicate, object)`. The Scheme translation uses `(predicate subject object)` which matches SICP's assertion style where the relation comes first:

| RDF Turtle | Scheme |
|------------|--------|
| `:BenBitdiddle :salary 60000` | `(salary ben-bitdiddle 60000)` |
| `:BenBitdiddle org:reportsTo :OliverWarbucks` | `(reports-to ben-bitdiddle oliver-warbucks)` |

## URI Simplification

URIs are converted to hyphenated lowercase atoms:

| RDF URI | Scheme Atom |
|---------|-------------|
| `:BenBitdiddle` | `ben-bitdiddle` |
| `:AlyssaPHacker` | `alyssa-p-hacker` |
| `:Job_ComputerWizard` | `job-computer-wizard` |
| `:Address_BenBitdiddle` | `address-ben-bitdiddle` |
| `org:reportsTo` | `reports-to` |
| `foaf:Person` | `person` |
| `foaf:name` | `name` |
| `rdf:type` | `type` |

## String to List Conversion

RDF string literals become lists of lowercase atoms:

| RDF String | Scheme List |
|------------|-------------|
| `"Ben Bitdiddle"` | `(ben bitdiddle)` |
| `"Alyssa P Hacker"` | `(alyssa p hacker)` |
| `"computer wizard"` | `(computer wizard)` |
| `"Ridge Road"` | `(ridge road)` |
| `"Mass Ave"` | `(mass ave)` |

Single-word strings become atoms directly:

| RDF String | Scheme Atom |
|------------|-------------|
| `"Slumerville"` | `slumerville` |
| `"Cambridge"` | `cambridge` |

## Numeric Literals

Integers are preserved as-is:

| RDF | Scheme |
|-----|--------|
| `60000` (xsd:integer) | `60000` |
| `10` (xsd:integer) | `10` |

## Type Annotations

RDF `rdf:type` becomes the `type` predicate:

| RDF Turtle | Scheme |
|------------|--------|
| `:BenBitdiddle a foaf:Person` | `(type ben-bitdiddle person)` |
| `:Address_BenBitdiddle a :Address` | `(type address-ben-bitdiddle address)` |

## Property Mappings

| RDF Property | Scheme Predicate |
|--------------|------------------|
| `foaf:name` | `name` |
| `org:reportsTo` | `reports-to` |
| `:hasAddress` | `has-address` |
| `:hasJob` | `has-job` |
| `:salary` | `salary` |
| `:city` | `city` |
| `:street` | `street` |
| `:streetNumber` | `street-number` |
| `:jobTitle` | `job-title` |
| `:canDoJob` | `can-do-job` |

## RDFS Schema Translation

Class and property definitions are also translated:

```scheme
;; Class definition
(type person rdfs-class)
(label person (person))

;; Property definition
(type has-address rdf-property)
(label has-address (has address))
(domain has-address person)
(range has-address address)
```

## Inference Rules

SPARQL capabilities are replicated as Scheme rules:

### lives-near
Two people in the same city (excluding self-matches):
```scheme
(rule (lives-near ?person1 ?person2)
      (and (type ?person1 person)
           (type ?person2 person)
           (has-address ?person1 ?addr1)
           (has-address ?person2 ?addr2)
           (city ?addr1 ?city)
           (city ?addr2 ?city)
           (not (same ?person1 ?person2))))
```

### wheel
Someone who supervises a supervisor:
```scheme
(rule (wheel ?person)
      (and (reports-to ?middle ?person)
           (reports-to ?someone ?middle)))
```

### outranked-by
Transitive supervisor chain (equivalent to SPARQL property path `org:reportsTo+`):
```scheme
(rule (outranked-by ?staff ?boss)
      (reports-to ?staff ?boss))

(rule (outranked-by ?staff ?boss)
      (and (reports-to ?staff ?middle)
           (outranked-by ?middle ?boss)))
```

### can-replace
Person can do another's job:
```scheme
(rule (can-replace ?person1 ?person2)
      (and (has-job ?person1 ?job1)
           (has-job ?person2 ?job2)
           (can-do-job ?job1 ?job2)
           (not (same ?person1 ?person2))))
```

## Example Queries

After loading the data:

```scheme
;; Find all people
(type ?x person)

;; Find neighbors (same city)
(lives-near ?x ?y)

;; Find wheels (Oliver and Ben)
(wheel ?person)

;; Find Louis's entire management chain
(outranked-by louis-reasoner ?boss)

;; Who can replace Alyssa?
(can-replace ?x alyssa-p-hacker)

;; Find computer division employees
(works-in-division ?person computer)

;; Find colleagues (same boss)
(colleague ?x ?y)
```

## Differences from Original SICP Format

The original SICP database uses a more compact nested format:

| SICP Original | RDF Translation |
|---------------|-----------------|
| `(job (Bitdiddle Ben) (computer wizard))` | `(has-job ben-bitdiddle job-computer-wizard)` + `(job-title job-computer-wizard (computer wizard))` |
| `(address (Bitdiddle Ben) (Slumerville (Ridge Road) 10))` | `(has-address ben-bitdiddle address-ben-bitdiddle)` + separate city/street/number triples |

The RDF translation is more normalized (3NF-style) with explicit entities for addresses and jobs, enabling:
- Queries on address components independently
- Job role reuse across people
- Schema-level reasoning about property domains/ranges
