;;;; cl-wikidata.asd

(asdf:defsystem #:cl-wikidata
                :description "Common Lisp interface to the Wikidata SPARQL endpoint."
                :author "Brian O'Reilly <fade@deepsky.com>"
                :license "Modified BSD License"
                :serial t
                :depends-on (:ALEXANDRIA
:DEXADOR
:CL-PPCRE
:CL-SPARQL
:CL-JSON-POINTER
)
                :pathname "./"
                :components ((:file "app-utils")
                             (:file "cl-wikidata")
                             ))

