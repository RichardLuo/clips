(defmodule ACTION
  (export defclass ?ALL)
  (import DEVICE defclass ?ALL)
  (import DEVICE deftemplate ?ALL)
  (import MAIN defclass ?ALL)
  (import MAIN deftemplate initial-fact))


(defclass ACTION::Action
  "ACTION::Action"
  (is-a USER)
  (slot passed                          ;used for control process
        (type SYMBOL)
        (allowed-values true false)
        (default false))
  (slot address
        (type SYMBOL)
        (default ?NONE))
  (slot method
        (type SYMBOL)
        (allowed-values set-on-off set-alert-level set-wc-current-lift-percent)
        (default ?NONE))
  (slot on-off-cmd
        (type SYMBOL)
        (allowed-values on off toggle none)
        (default none))
  (slot alert-level
        (type INTEGER)
        (range -1 100)
        (default -1))
  (slot wc-current-lift-percent
        (type INTEGER)
        (range 0 100)
        (default 0)))

