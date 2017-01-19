(defmodule BINDING
  (import ACTION defclass ?ALL)
  (import DEVICE defclass ?ALL)
  (import DEVICE deftemplate ?ALL)
  (import MAIN defclass ?ALL)
  (import MAIN deftemplate initial-fact))

(defclass BINDING::Binding
  "super class for all concrete binding classes"
  (is-a USER)
  (slot address                         ;address of binding instance itself, nothing to do with device
        (type SYMBOL)
        (default ?NONE))
  (slot enabled
        (type SYMBOL)
        (default ?NONE)
        (visibility public)
        (allowed-values true false))
  (slot status
        (type SYMBOL)
        (visibility public)
        (allowed-values waiting activated fired)
        (default waiting))
  (multislot actions
             (type INSTANCE)
             (visibility public)))

(defmessage-handler BINDING::Binding delete before ()
  (printout t "--> Binding delete before ()" crlf)
  (bind ?len (length$ ?self:actions))
  (if (<= ?len 0)
      then
    (printout t "action list is empty!" crlf)
    (return))
  (printout t "before delete actions, len: " ?len crlf)
  (loop-for-count (?i 1 ?len) do
                  (send  (nth$ ?i ?self:actions) delete)))

; (defmessage-handler BINDING::Binding set-passed ()
;   (printout t "--> BINDING::Binding set-passed()" crlf)
;   (bind ?len (length$ ?self:actions))
;   (if (<= ?len 0)
;       then
;     (printout t "action list is empty!" crlf)
;     (return))
;   (printout t ">> put-passed for actions: " ?len crlf)
;   (loop-for-count (?i 1 ?len) do
;                   (send  (nth$ ?i ?self:actions) put-passed true)))

(defclass BINDING::KeypressBinding
  "BINDING::KeypressBinding"
  (is-a Binding)
  (slot src-address)
  (slot pressed-times
        (type INTEGER)
        (range 0 100)
        (default 1)))

(defrule BINDING::process-keypress-binding
  "process-keypress-binding"
  (object (is-a KeypressEvent)
          (src-address ?address&~none)
          (pressed-times ?times))
  ?binding <- (object (is-a KeypressBinding)
                      (enabled true)
                      (src-address ?address)
                      (pressed-times ?times)
                      (actions $?actions))
  =>
  (send ?binding put-status activated)
  (printout t
            "process-keypress-binding:" crlf
            "   src-address: " ?address crlf
            "   actions: " ?actions crlf))

(defrule BINDING::process-keypress-binding2
  "process-keypress-binding2"
  (object (is-a KeypressEvent)
          (src-address ?address&~none))
  =>
  (printout t "process-keypress-binding2:" crlf
            "   src-address: " ?address crlf))

(defclass BINDING::OpenCloseBinding
  "BINDING::OpenCloseBinding"
  (is-a Binding)
  (slot src-address)
  (slot direction
        (type SYMBOL)
        (default opened)
        (allowed-values opened closed both)))

(defrule BINDING::process-open-close-binding
  "BINDING::process-open-close-binding"
  (object (is-a OpenCloseEvent)
          (src-address ?address&~none)
          (direction ?direction&opened|closed))
  ?binding <- (object (is-a OpenCloseBinding)
                      (enabled true)
                      (src-address ?address)
                      (direction ?dir&both|?direction))
  =>
  (send ?binding put-status activated)
  (printout t "activated OpenCloseBinding src-address: " ?address " binding-dir " ?dir crlf))


(defclass BINDING::PirPanelBinding
  "BINDING::PirPanelBinding"
  (is-a Binding)
  (slot src-address)
  (slot luminance
        (type INTEGER)
        (default 10000)
        (range -200 10000)))

(defrule BINDING::process-pir-binding-left
  "BINDING::process-pir-binding-left"
  ?device <- (object (is-a PirPanel)
                     (address ?dev-uuid)
                     (luminance ?dev-lumi)
                     (occupancy-left alarm))
  ?binding <- (object (is-a PirPanelBinding)
                      (enabled true)
                      (src-address ?dev-uuid)
                      (luminance ?binding-lumi&: (<= ?dev-lumi ?binding-lumi)))
  =>
  (send ?binding put-status activated)
  (printout t "activated a PirPanelBinding of left larm with dev-uuid: " ?dev-uuid
            " device-lumi  " ?dev-lumi
            " binding-lumi " ?binding-lumi crlf))

(defrule BINDING::process-pir-binding-right
  "BINDING::process-pir-binding-right"
  ?device <- (object (is-a PirPanel)
                     (address ?dev-uuid)
                     (luminance ?dev-lumi)
                     (occupancy-right alarm))
  ?binding <- (object (is-a PirPanelBinding)
                      (enabled true)
                      (src-address ?dev-uuid)
                      (luminance ?binding-lumi&: (<= ?dev-lumi ?binding-lumi)))
  =>
  (send ?binding put-status activated)
  (printout t "activated a PirPanelBinding of right larm with dev-uuid: " ?dev-uuid
            " device-lumi  " ?dev-lumi
            " binding-lumi " ?binding-lumi crlf))

(defrule BINDING::debug-pir-binding
  "BINDING::debug-pir-binding"
  ?device <- (object (is-a PirPanel)
                     (address ?dev-uuid)
                     (luminance ?dev-lum)
                     (occupancy-left ?dev-occup-left)
                     (occupancy-right ?dev-occup-right))
  ?binding <- (object (is-a PirPanelBinding)
                      (enabled true)
                      (src-address ?dev-uuid)
                      (luminance ?binding-lum))
  =>
  (printout t
            "debug-pir-binding"
            " dev-uuid: " ?dev-uuid
            " dev-lum " ?dev-lum
            " dev-occupancy-left " ?dev-occup-left
            " dev-occupancy-right " ?dev-occup-right
            " binding-lum " ?binding-lum crlf))

(defrule BINDING::fire-activated-bindings
  "ACTION::fire-bindings"
  ?binding <- (object (is-a BINDING::Binding)
                      (enabled true)
                      (status activated)
                      (address ?address))
  =>
  (printout t "fired an activated binding of address: " ?address crlf)
  (fire-binding ?address)
  (send ?binding put-status waiting))


