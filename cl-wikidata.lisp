(defpackage :cl-wikidata
            (:use :cl)
            (:use :cl-wikidata.app-utils
                  :alexandria :cl-json-pointer)
            (:export :-main))

(in-package :cl-wikidata)

(defparameter *SPARQL* "https://query.wikidata.org/sparql?query=\"~A\"&format=json")

(defparameter *query*
  "SELECT ?lemma ?item WHERE {
  VALUES ?lemma {
    \"Wikipedia\"@de
    \"Wikidata\"@de
    \"Berlin\"@de
    \"Technische Universität Berlin\"@de
  }
  ?sitelink schema:about ?item;
    schema:isPartOf <https://de.wikipedia.org/>;
    schema:name ?lemma.
}")



(defun -main (&optional args)
  (format t "~a~%" "I don't do much yet"))

