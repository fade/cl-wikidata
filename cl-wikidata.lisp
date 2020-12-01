(defpackage :cl-wikidata
            (:use :cl)
            (:use :cl-wikidata.app-utils)
            (:export :-main))

(in-package :cl-wikidata)

(defun -main (&optional args)
  (format t "~a~%" "I don't do much yet"))

