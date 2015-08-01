(deftemplate PirEvent
  "event from pir panel"
  (slot address
        (type SYMBOL)
        (default none))
  (slot pir-status
        (type SYMBOL)
        (allowed-values safe alarm none)
        (default none))
  (slot luminance
        (type INTEGER)
        (default -1))
  (slot keypress
        (type SYMBOL)
        (allowed-values yes no)
        (default no)))

(defrule check-pir-event
  "check the whether event is valid"
  ?event <- (PirEvent (address ?address&~none)
                      (pir-status ?status&safe|alarm))
  ?pir-panel <- (object (is-a PirPanel)
                        (address ?event-addr)
                        (pir-status ?pir-status&~?status))
  =>
  (retract ?event)
  (printout t "PirPanel of address " ?address " pir-status: " ?status crlf)
  (send ?pir-panel put-pir-status ?status))

