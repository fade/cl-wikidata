;;;; cl-wikidata.asd

(asdf:defsystem #:cl-wikidata
  :description "Common Lisp interface to the Wikidata SPARQL endpoint."
  :author "Brian O'Reilly <fade@deepsky.com>"
  :license "GNU General Public License v3 or later."
  :serial t
  :depends-on (#:ALEXANDRIA
               #:RUTILS
               #:DEXADOR
               #:CL-PPCRE
               #:CL-SPARQL
               #:CL-JSON-POINTER)
  :pathname "./"
  :components ((:file "app-utils")
               (:file "cl-wikidata")))

