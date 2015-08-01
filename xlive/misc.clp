

(defrule pir-smart-lighting
  "bindings for pir's smart lighting control"
  (object (is-a PirPanel)
          (pir-status ?pir&alarm)
          (status AVAILABLE)
          (address ?address))
  =>
  (printout t "PirPanel of address " ?address " left: " ?left " right:" ?right crlf))

(defclass CONDITION
  "PirSmartBinding, the most complext one"
  (is-a USER)
  (slot pressed-button
        (type symbol)
        (default none))
  (slot min-luminance
        (type INTEGER)
        (default -1))
  (slot pir-status
        (type SYMBOL)
        (default none)))


(deftemplate pir-binding
  (slot address (type INTEGER))
  (multislot actions (type SYMBOL)))


(deftemplate ConditionDescription
  "Binding of pir"
  (slot pir-panel)
  (slot luminance)
  (slot motion-detect))