(defpackage :cl-wikidata
            (:use :cl)
            (:use :cl-wikidata.app-utils
                  :alexandria :cl-json-pointer)
            (:export :-main))

(in-package :cl-wikidata)

;; (defparameter *SPARQL* "https://query.wikidata.org/sparql?query=\"~A\"&format=json")
(defparameter *wdataq* "https://query.wikidata.org/sparql"
  "the wikidata query endpoint..")

(defparameter *user-agent* "CL-WIKIDATA/0.0 (https://github.com/fade/cl-wikidata.git; fade@deepsky.com) sbcl/2.1.0"
  "This parameter holds the user agent string to identify this client
  with the wikidata sparql endpoint. Without it, wikidata would limit
  and then kill our service access.")

(defparameter *query*
  "SELECT DISTINCT ?airport ?airportLabel ?icaocode ?iatacode ?gps
WHERE
{
  ?airport wdt:P31 wd:Q1248784 ;
           wdt:P239 ?icaocode ;
           OPTIONAL {
             ?airport wdt:P238 ?iatacode .}
           OPTIONAL {
             ?airport wdt:P625 ?gps .}
  SERVICE wikibase:label {
    bd:serviceParam wikibase:language \"en\" .
  }
}
ORDER BY ?airportLabel"
  
  "airports of the world with iata and icao codes, names, and gps
  coordinates..")


(defparameter *getreturn* nil)

(defun getdata (&key (question nil) (endpoint *wdataq*) (user-agent *user-agent*))
  (let* ((q? (if question
                 question
                 *query*))
         (request (quri:make-uri :defaults endpoint
                                 :query `(("query" . ,q?)
                                          ("format" . "json")))))
    ;; (format t "~&[[~A]]~%" request)
    (multiple-value-bind (body status headers uri connection)
        (handler-case
            (dex:request request
                         :method :get
                         :headers `(("User-Agent" . ,user-agent)
                                    ("accept" . "application/json"))
                         :verbose t)
          (error (c) c))
      (setf *getreturn* body)
      (format t "~&~{~A~^~%~}" (list status headers (quri:render-uri uri) connection)))))

(defun get-icao-from-json (&key (json-string *getreturn*))
  (let
    ((obj (jsown:parse json-string))
     (cl-json-pointer:*json-object-flavor* :jsown))

    (loop for i from 0 to (length (get-by-json-pointer obj "/results/bindings"))
          :collect
          (list
           (get-by-json-pointer obj (format nil "/results/bindings/~D/airport/value" i))
           (get-by-json-pointer obj (format nil "/results/bindings/~D/airportLabel/value" i))
           (get-by-json-pointer obj (format nil "/results/bindings/~D/icaocode/value" i))
           (get-by-json-pointer obj (format nil "/results/bindings/~D/iatacode/value" i))
           (get-by-json-pointer obj (format nil "/results/bindings/~D/gps/value" i))))))

(defun print-icao-data (icao-data)
  "Given a list of lists representing the ?airport, ?airportLabel, ?icaocode, ?iatacode and ?gps data for the world airports, nown to the WikiMedia foundation's wikidata service, print that data."
  (loop for airport in icao-data
        for index from 0
        do (format t "~&[~05D]~{ ~A~^ || ~}~%" index airport)))

(defun write-json-to-file (json file)
  (with-open-file (s file :direction :output :if-exists :supersede)
    (write-sequence json s)))

(defun json-test (address)
  (multiple-value-bind (body status headers uri connection)
      (dexador:get address)
    (list body status headers uri connection)))

(defun -main (&optional args)
  (declare (ignorable args))
  (format t "~a~%" "I don't do much yet"))

