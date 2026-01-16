;; Microshaft RDF Data translated to Scheme triples for query.scm
;; Format: (predicate subject object) - matches RDF triple semantics
;; URIs simplified to atoms, strings become lists of atoms

(define microshaft-rdf-data
  '(
    ;; ============================================================
    ;; Person Instances
    ;; ============================================================

    ;; Ben Bitdiddle
    (type ben-bitdiddle person)
    (name ben-bitdiddle (ben bitdiddle))
    (has-address ben-bitdiddle address-ben-bitdiddle)
    (has-job ben-bitdiddle job-computer-wizard)
    (salary ben-bitdiddle 60000)
    (reports-to ben-bitdiddle oliver-warbucks)

    ;; Alyssa P Hacker
    (type alyssa-p-hacker person)
    (name alyssa-p-hacker (alyssa p hacker))
    (has-address alyssa-p-hacker address-alyssa-p-hacker)
    (has-job alyssa-p-hacker job-computer-programmer)
    (salary alyssa-p-hacker 40000)
    (reports-to alyssa-p-hacker ben-bitdiddle)

    ;; Cy D Fect
    (type cy-d-fect person)
    (name cy-d-fect (cy d fect))
    (has-address cy-d-fect address-cy-d-fect)
    (has-job cy-d-fect job-computer-programmer)
    (salary cy-d-fect 35000)
    (reports-to cy-d-fect ben-bitdiddle)

    ;; Lem E Tweakit
    (type lem-e-tweakit person)
    (name lem-e-tweakit (lem e tweakit))
    (has-address lem-e-tweakit address-lem-e-tweakit)
    (has-job lem-e-tweakit job-computer-technician)
    (salary lem-e-tweakit 25000)
    (reports-to lem-e-tweakit ben-bitdiddle)

    ;; Louis Reasoner
    (type louis-reasoner person)
    (name louis-reasoner (louis reasoner))
    (has-address louis-reasoner address-louis-reasoner)
    (has-job louis-reasoner job-computer-programmer-trainee)
    (salary louis-reasoner 30000)
    (reports-to louis-reasoner alyssa-p-hacker)

    ;; Oliver Warbucks (no supervisor - top of hierarchy)
    (type oliver-warbucks person)
    (name oliver-warbucks (oliver warbucks))
    (has-address oliver-warbucks address-oliver-warbucks)
    (has-job oliver-warbucks job-administration-big-wheel)
    (salary oliver-warbucks 150000)

    ;; Eben Scrooge
    (type eben-scrooge person)
    (name eben-scrooge (eben scrooge))
    (has-address eben-scrooge address-eben-scrooge)
    (has-job eben-scrooge job-accounting-chief-accountant)
    (salary eben-scrooge 75000)
    (reports-to eben-scrooge oliver-warbucks)

    ;; Robert Cratchet
    (type robert-cratchet person)
    (name robert-cratchet (robert cratchet))
    (has-address robert-cratchet address-robert-cratchet)
    (has-job robert-cratchet job-accounting-scrivener)
    (salary robert-cratchet 18000)
    (reports-to robert-cratchet eben-scrooge)

    ;; DeWitt Aull
    (type dewitt-aull person)
    (name dewitt-aull (dewitt aull))
    (has-address dewitt-aull address-dewitt-aull)
    (has-job dewitt-aull job-administration-secretary)
    (salary dewitt-aull 25000)
    (reports-to dewitt-aull oliver-warbucks)

    ;; ============================================================
    ;; Address Instances
    ;; ============================================================

    (type address-ben-bitdiddle address)
    (city address-ben-bitdiddle slumerville)
    (street address-ben-bitdiddle (ridge road))
    (street-number address-ben-bitdiddle 10)

    (type address-alyssa-p-hacker address)
    (city address-alyssa-p-hacker cambridge)
    (street address-alyssa-p-hacker (mass ave))
    (street-number address-alyssa-p-hacker 78)

    (type address-cy-d-fect address)
    (city address-cy-d-fect cambridge)
    (street address-cy-d-fect (ames street))
    (street-number address-cy-d-fect 3)

    (type address-lem-e-tweakit address)
    (city address-lem-e-tweakit boston)
    (street address-lem-e-tweakit (bay state road))
    (street-number address-lem-e-tweakit 22)

    (type address-louis-reasoner address)
    (city address-louis-reasoner slumerville)
    (street address-louis-reasoner (pine tree road))
    (street-number address-louis-reasoner 80)

    (type address-oliver-warbucks address)
    (city address-oliver-warbucks swellesley)
    (street address-oliver-warbucks (top heap road))
    ;; Note: no street number in original RDF

    (type address-eben-scrooge address)
    (city address-eben-scrooge weston)
    (street address-eben-scrooge (shady lane))
    (street-number address-eben-scrooge 10)

    (type address-robert-cratchet address)
    (city address-robert-cratchet allston)
    (street address-robert-cratchet (n harvard street))
    (street-number address-robert-cratchet 16)

    (type address-dewitt-aull address)
    (city address-dewitt-aull slumerville)
    (street address-dewitt-aull (onion square))
    (street-number address-dewitt-aull 5)

    ;; ============================================================
    ;; Job Role Instances
    ;; ============================================================

    (type job-computer-wizard job-role)
    (job-title job-computer-wizard (computer wizard))
    (can-do-job job-computer-wizard job-computer-programmer)
    (can-do-job job-computer-wizard job-computer-technician)

    (type job-computer-programmer job-role)
    (job-title job-computer-programmer (computer programmer))
    (can-do-job job-computer-programmer job-computer-programmer-trainee)

    (type job-computer-technician job-role)
    (job-title job-computer-technician (computer technician))

    (type job-computer-programmer-trainee job-role)
    (job-title job-computer-programmer-trainee (computer programmer trainee))

    (type job-administration-big-wheel job-role)
    (job-title job-administration-big-wheel (administration big wheel))

    (type job-administration-secretary job-role)
    (job-title job-administration-secretary (administration secretary))
    (can-do-job job-administration-secretary job-administration-big-wheel)

    (type job-accounting-chief-accountant job-role)
    (job-title job-accounting-chief-accountant (accounting chief accountant))

    (type job-accounting-scrivener job-role)
    (job-title job-accounting-scrivener (accounting scrivener))

    ;; ============================================================
    ;; RDFS Class Definitions (meta-level)
    ;; ============================================================

    (type person rdfs-class)
    (label person (person))

    (type address rdfs-class)
    (label address (address))
    (comment address (a physical address with city street and street number))

    (type job-role rdfs-class)
    (label job-role (job role))
    (comment job-role (a job position or role within the organization))

    ;; ============================================================
    ;; RDFS Property Definitions (meta-level)
    ;; ============================================================

    (type has-address rdf-property)
    (label has-address (has address))
    (domain has-address person)
    (range has-address address)

    (type has-job rdf-property)
    (label has-job (has job))
    (domain has-job person)
    (range has-job job-role)

    (type salary rdf-property)
    (label salary (salary))
    (domain salary person)
    (range salary xsd-integer)

    (type city rdf-property)
    (label city (city))
    (domain city address)
    (range city xsd-string)

    (type street rdf-property)
    (label street (street))
    (domain street address)
    (range street xsd-string)

    (type street-number rdf-property)
    (label street-number (street number))
    (domain street-number address)
    (range street-number xsd-integer)

    (type job-title rdf-property)
    (label job-title (job title))
    (domain job-title job-role)
    (range job-title xsd-string)

    (type can-do-job rdf-property)
    (label can-do-job (can do job))
    (comment can-do-job (indicates that a person with one job role can also perform another job role))
    (domain can-do-job job-role)
    (range can-do-job job-role)

    (type reports-to rdf-property)
    (label reports-to (reports to))
    (domain reports-to person)
    (range reports-to person)

    ;; ============================================================
    ;; Rules - Inference capabilities matching SPARQL queries
    ;; ============================================================

    ;; Rule: lives-near - two people live near each other if in same city
    ;; and they are different people
    (rule (lives-near ?person1 ?person2)
          (and (type ?person1 person)
               (type ?person2 person)
               (has-address ?person1 ?addr1)
               (has-address ?person2 ?addr2)
               (city ?addr1 ?city)
               (city ?addr2 ?city)
               (not (same ?person1 ?person2))))

    ;; Rule: same - identity check
    (rule (same ?x ?x))

    ;; Rule: wheel - someone who supervises a supervisor
    (rule (wheel ?person)
          (and (reports-to ?middle ?person)
               (reports-to ?someone ?middle)))

    ;; Rule: outranked-by - direct supervisor relationship
    (rule (outranked-by ?staff ?boss)
          (reports-to ?staff ?boss))

    ;; Rule: outranked-by - transitive supervisor relationship
    (rule (outranked-by ?staff ?boss)
          (and (reports-to ?staff ?middle)
               (outranked-by ?middle ?boss)))

    ;; Rule: can-replace - person1 can replace person2 if their job
    ;; can do person2's job and they're different people
    (rule (can-replace ?person1 ?person2)
          (and (has-job ?person1 ?job1)
               (has-job ?person2 ?job2)
               (can-do-job ?job1 ?job2)
               (not (same ?person1 ?person2))))

    ;; Rule: can-replace - same job means can replace
    (rule (can-replace ?person1 ?person2)
          (and (has-job ?person1 ?job)
               (has-job ?person2 ?job)
               (not (same ?person1 ?person2))))

    ;; Rule: big-shot - someone in a division with no supervisor in same division
    ;; First, extract division from job title (first word)
    (rule (works-in-division ?person ?division)
          (and (has-job ?person ?job)
               (job-title ?job (?division . ?rest))))

    ;; Rule: colleague - same supervisor
    (rule (colleague ?person1 ?person2)
          (and (reports-to ?person1 ?boss)
               (reports-to ?person2 ?boss)
               (not (same ?person1 ?person2))))

    ;; Rule: earns-more-than
    (rule (earns-more-than ?person1 ?person2)
          (and (salary ?person1 ?sal1)
               (salary ?person2 ?sal2)
               (lisp-value > ?sal1 ?sal2)))

    ;; Rule: subordinate chain (all people under someone, transitively)
    (rule (subordinate ?boss ?worker)
          (reports-to ?worker ?boss))

    (rule (subordinate ?boss ?worker)
          (and (reports-to ?worker ?middle)
               (subordinate ?boss ?middle)))
    ))
