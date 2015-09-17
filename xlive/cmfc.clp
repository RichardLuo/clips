
(deftemplate KK
  "template KK"
  (multislot kk))

(defrule test_kk
  "test_kk"
  ?f <- (KK (kk $?kk))
  =>
  (bind ?cnt (cmfc ?kk))
  (retract ?f)
  (printout t "ok, got the cnt " ?cnt crlf))


(defclass People
  "People"
  (is-a USER)
  (multislot address))

(definstances peoples
  ([p1] of People
        (address AAA)))

; (access-people (instance-address [p1]))

; (load "/data/zb/clips/cmfc.clp")



  

