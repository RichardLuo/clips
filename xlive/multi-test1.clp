; (defrule ABC
;   ?card <- (object (is-a Card)
;                    (CardNumber ?card.CardNumber))
;    (test (starts-with ?card.CardNumber "AT2")) 
; => 
;    (make-instance [cardinfo] of CardInfo)
;    (slot-insert$ ?card InfoList (+ 1 (length$ (send ?card get-InfoList))) 
;                  (instance-address [cardinfo])))


(defclass Bar
  ""
  (is-a USER)
  (slot index
        (type INTEGER)
        (default 0)))

(defclass Action
  ""
  (is-a USER)
  (slot device)
  (multislot request))
;;; set-on-off address onoff



(defclass Foo
  ""
  (is-a USER)
  (multislot bars))


(deftemplate Inc
  ""
  (slot number
        (type INTEGER)
        (default 0)))

(defrule AddFooInstance
  ""
  ?inc <- (Inc (number ?n&: (> ?n 0)))
  ?foo <- (object (is-a Foo))
  =>
  (bind ?bar (make-instance (gensym) of Bar (index ?n)))
  (slot-insert$ ?foo bars (+ 1 (length$ (send ?foo get-bars)))
                (instance-address ?bar))
  (retract ?inc)
  (assert (Inc (number (- ?n 1))))
  (printout t "================ n: " ?n crlf))


(make-instance foo of Foo)
(assert (Inc (number 10)))
