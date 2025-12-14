Scheme code from Chapter 4 of _Structure and Interpretation of Computer Programs_ - SICP

The Scheme code runs perfecty using `mid-scheme':

<https://www.gnu.org/software/mit-scheme/>

Here is a transcript of a run through of the examples from CLAUDE.md:


```
mshook@penguin:~/projects/sicp-query$ mit-scheme
MIT/GNU Scheme running under GNU/Linux
Type `^C' (control-C) followed by `H' to obtain information about interrupts.

Copyright (C) 2022 Massachusetts Institute of Technology
This is free software; see the source for copying conditions. There is NO warranty; not even for
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Image saved on Wednesday January 11, 2023 at 11:12:18 PM
  Release 12.1 || SF || LIAR/x86-64

1 ]=> (load "query.scm")

;Loading "query.scm"... done
;Value: microshaft-data-base

1 ]=> (initialize-data-base microshaft-data-base)

;Value: done

1 ]=> (query-driver-loop)


;;; Query input:
(job ?x (computer programmer))

;;; Query results:
(job (fect cy d) (computer programmer))
(job (hacker alyssa p) (computer programmer))

;;; Query input:
(and (job ?person (computer . ?type)) (address ?person ?where))

;;; Query results:
(and (job (reasoner louis) (computer programmer trainee)) (address (reasoner louis) (slumerville (pine tree road) 80)))
(and (job (tweakit lem e) (computer technician)) (address (tweakit lem e) (boston (bay state road) 22)))
(and (job (fect cy d) (computer programmer)) (address (fect cy d) (cambridge (ames street) 3)))
(and (job (hacker alyssa p) (computer programmer)) (address (hacker alyssa p) (cambridge (mass ave) 78)))
(and (job (bitdiddle ben) (computer wizard)) (address (bitdiddle ben) (slumerville (ridge road) 10)))

;;; Query input:
(lives-near ?x (Bitdiddle Ben))

;;; Query results:
(lives-near (aull dewitt) (bitdiddle ben))
(lives-near (reasoner louis) (bitdiddle ben))

;;; Query input:
(assert! (job (Doe John) (computer programmer)))

Assertion added to data base.

;;; Query input:
(job ?x (computer programmer))

;;; Query results:
(job (doe john) (computer programmer))
(job (fect cy d) (computer programmer))
(job (hacker alyssa p) (computer programmer))

;;; Query input:
End of input stream reached.
Fortitudine vincimus.
mshook@penguin:~/projects/sicp-query$
```
