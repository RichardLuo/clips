(defmodule MAIN
  (export defclass ?ALL)
  (export deftemplate ?ALL))

(defclass MAIN::Event
  "event from pir panel"
  (is-a USER)
  (slot src-address
        (type SYMBOL)
        (default none)))

(defclass MAIN::KeypressEvent
  "MAIN::KeypressEvent"
  (is-a Event)
  (slot on-off-cmd
        (type SYMBOL)
        (default ?NONE)
        (allowed-values on off toggle))
  (slot pressed-times
        (type INTEGER)
        (range 0 100)
        (default ?NONE)))

(defclass MAIN::OpenCloseEvent
  "MAIN::OpenCloseEvent"
  (is-a Event)
  (slot direction
        (type SYMBOL)
        (allowed-values opened closed)
        (default ?NONE)))

(defclass MAIN::OccupancyEvent
  "MAIN::OccupancyEvent, always form PirPanel device"
  (is-a Event)
  (slot pir-status
        (type SYMBOL)
        (allowed-values safe alarm)
        (default ?NONE)))

(defclass MAIN::LuminanceEvent
  "MAIN::LuminanceEvent, to update the luminance of PirPanel"
  (is-a Event)
  (slot luminance
        (type INTEGER)
        (default ?NONE)
        (range 0 1000)))

(defclass MAIN::DeviceOfflineEvent
  "MAIN::DeviceOfflineEvent"
  (is-a Event))

(defrule MAIN::start-event
  "MAIN::start-event"
  (exists (object (is-a Event)))
  =>
  (focus DEVICE BINDING ACTION))

(defrule MAIN::delete-event
  "MAIN::delete-event"
  (declare (salience -10))
  ?event <- (object (is-a Event)
                    (src-address ?addr))
  =>
  (send ?event delete)
  (printout t "deleted a event with src-addr " ?addr crlf))



  