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
  "SELECT
  ?item ?itemLabel
  ?value ?valueLabel
# valueLabel is only useful for properties with item-datatype
WHERE 
{
  ?item wdt:P1800 ?value
  # change P1800 to another property        
  SERVICE wikibase:label { bd:serviceParam wikibase:language \"[AUTO_LANGUAGE],en\". }
}
# remove or change limit for more results
LIMIT 10")

(defparameter *getreturn* nil)

(defun getdata (&key (query *query*) (endpoint *wdataq*) (user-agent *user-agent*))
  "Connect to :endpoint and ship the query."
  (let* ((query query)) ;; (quri:url-encode query) dex implicitly encodes query parameters.
    (multiple-value-bind (body status headers uri connection)
        (handler-case
            (dex:request endpoint
                         :method :get
                         :headers '(("User-Agent" . user-agent)
                                    ("accept" . "application/sparql-results+json"))
                         :content '(("format" . "json") ("query" . query))
                         :read-timeout 3)
          (error (c) c))
      (setf *getreturn* body)
      (format t "~&~{~A~^~%~}" (list status headers uri connection))))
  ;; body  
  )

;;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;; test post function
;;;=============================================================================
;; (defun bonk (&key (query *query*) (endpoint *wdataq*) (user-agent *user-agent*))
;;   (multiple-value-list ;; (body status headers uri connection)
;;    (let* ((query query)
;;           (endpoint endpoint)
;;           (user-agent user-agent))
;;     (handler-case
;;         (dex:request endpoint
;;                      :method :post
;;                      :headers '(("User-Agent" . user-agent)
;;                                 ("accept" . "application/sparql-results+json"))
;;                      :content '(("query" . query) ("format" . "json")))
;;       (error (c) c)))))
;;;=============================================================================



;; (defun postdata (&key (query *query*) (endpoint *wdataq*) (user-agent *user-agent*))
;;   "send a wikidata query as a post action to the sparql endpoint."
;;   (multiple-value-list ;; (body status headers uri connection)
;;    (handler-case
;;        (dex:request endpoint
;;                     :method :post
;;                     :headers '(("User-Agent" . *user-agent*)
;;                                ("accept" . "application/sparql-results+json"))
;;                     :content '(("query" . query) ("format" . "json")))
;;      (error (c) c))
;;    (setf *getreturn* body)
;;    (format t "~&~{~A~^~%~}" (list status headers uri connection))))

(defun write-json-to-file (json file)
  (with-open-file (s file :direction :output :if-exists :supersede)
    (write-sequence json s)))

(defun json-test (address)
  (multiple-value-bind (body status headers uri connection)
      (dexador:get address)
    (list body status headers uri connection)))

;; 😀

(defun -main (&optional args)
  (declare (ignorable args))
  (format t "~a~%" "I don't do much yet"))

