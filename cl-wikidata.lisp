(defpackage :cl-wikidata
            (:use :cl)
            (:use :cl-wikidata.app-utils
                  :dexador :alexandria :cl-json-pointer)
            (:export :-main))

(in-package :cl-wikidata)

(defparameter *SPARQL* "https://query.wikidata.org/sparql?query=~A&format=json")

(defun -main (&optional args)
  (format t "~a~%" "I don't do much yet"))

