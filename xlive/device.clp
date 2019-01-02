(defmodule DEVICE
  (export defclass ?ALL)
  (export deftemplate ?ALL)
  (import MAIN defclass ?ALL)
  (import MAIN deftemplate initial-fact))

(defclass Device
  "Base Device class"
  (is-a USER)
  (slot address
        (type SYMBOL)
        (default none))
  (slot status
        (type SYMBOL)
        (default offline)
        (allowed-values offline online available))
  (slot dname
        (type SYMBOL)
        (default none))
  (slot alert-level
        (type INTEGER)
        (range 0 100)
        (default 0)))

(defclass OnOffDevice
  "OnOffDevice, abstract logic device"
  (is-a Device)
  (slot on-off-status
        (type SYMBOL)
        (allowed-values on off)
        (default off)))

(defclass SmartPlug
  "SmartPlug, a logic device"
  (is-a OnOffDevice))

(defclass LightSocket
  "LightSocket, a logic device"
  (is-a OnOffDevice))

(defclass PirPanel
  "PirPanel, a logic device"
  (is-a Device)
  (slot luminance
        (type INTEGER)
        (default -200)
        (range -200 10000)
        (create-accessor read-write))
  (slot temperature
        (type INTEGER)
        (default -100)
        (range -100 200)
        (create-accessor read-write))
  (slot occupancy-left
        (type SYMBOL)
        (default safe)
        (allowed-values safe alarm)
        (create-accessor read-write))
  (slot occupancy-right
        (type SYMBOL)
        (default safe)
        (allowed-values safe alarm)
        (create-accessor read-write)))

(defclass DoorContact
  "DoorContact, a logic device"
  (is-a Device)
  (slot door-status
        (type SYMBOL)
        (default closed)        
        (allowed-values opened closed)
        (create-accessor read-write))
  (slot temperature
        (type INTEGER)
        (default -100)
        (create-accessor read-write)))

(defclass WindowCovering
  "WindowCovering, a logic device"
  (is-a Device)
  (slot percent-status
        (type INTEGER)
        (range 0 100)
        (default 0)
        (create-accessor read-write)))

(defclass SmartKnob
  "SmartKnob, a logic device"
  (is-a Device)
  (slot last-knob-angle
        (type INTEGER)
        (default 0)
        (create-accessor read-write)))

(defrule DEVICE::print-occupancy
  "print-occupancy"
  ?event <- (object (is-a OccupancyEvent)
                    (src-address ?address&~none)
                    (occupancy-left ?left)
                    (occupancy-right ?right))
  =>
  (printout t "got occupancy from " ?address
            " occupancy-left " ?left
            " occupancy-right " ?right crlf))

(defrule DEVICE::update-occupancy-left
  "update-occupancy-left"
  ?event <- (object (is-a OccupancyEvent)
                    (src-address ?address&~none)
                    (occupancy-left ?new-left&alarm|safe))
  ?device <- (object (is-a PirPanel)
                     (address ?address)
                     (luminance ?lumi)
                     (occupancy-left ?old-left&~?new-left))
  =>
  (send ?device put-occupancy-left ?new-left)
  (printout t "updated occupancy-left from " ?old-left  " to " ?new-left
            " dev-lum: " ?lumi " src-uuid: " ?address crlf))

(defrule DEVICE::update-occupancy-right
  "update-occupancy-right"
  ?event <- (object (is-a OccupancyEvent)
                    (src-address ?address&~none)
                    (occupancy-right ?new-right&alarm|safe))
  ?device <- (object (is-a PirPanel)
                     (address ?address)
                     (luminance ?lumi)
                     (occupancy-right ?old-right&~?new-right))
  =>
  (send ?device put-occupancy-right ?new-right)
  (printout t "updated occupancy-right from " ?old-right  " to " ?new-right
            " dev-lum: " ?lumi " src-uuid: " ?address crlf))

(defrule DEVICE::update-luminance
  "update-luminance"
  ?event <- (object (is-a LuminanceEvent)
                    (src-address ?address&~none)
                    (luminance ?new-lum))
  ?device <- (object (is-a PirPanel)
                     (address ?address)
                     (luminance ?old-lum&~?new-lum))
  =>
  (send ?device put-luminance ?new-lum)
  (printout t
            "updated pirs luminance from " ?old-lum
            " to " ?new-lum ", pirs uuid:" ?address crlf))

(defrule DEVICE::process-device-offline
  "DEVICE::process-device-offline"
  ?event <- (object (is-a MAIN::DeviceOfflineEvent)
                    (src-address ?address))
  ?device <- (object (is-a Device)
                     (address ?address)
                     (status ?status&~offline))
  =>
  (send ?device delete)
  (printout t "device of " ?address " offline, deleted" crlf))