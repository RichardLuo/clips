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
        (default -1)
        (range -1 1000)
        (create-accessor read-write))
  (slot pir-status
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
        (create-accessor read-write)))

(defrule DEVICE::update-occupancy
  "update-occupancy"
  ?event <- (object (is-a OccupancyEvent)
                    (src-address ?address&~none)
                    (pir-status ?new-status))
  ?device <- (object (is-a PirPanel)
                     (address ?address)
                     (pir-status ?old-status&~?new-status))
  =>
  (send ?event delete)
  (send ?device put-pir-status ?new-status)
  (printout t "updated occupancy to: " ?new-status
            " src-address: " ?address crlf))

(defrule DEVICE::update-luminance
  "update-luminance"
  ?event <- (object (is-a LuminanceEvent)
                    (src-address ?address&~none)
                    (luminance ?new-lum))
  ?device <- (object (is-a PirPanel)
                     (address ?address)
                     (luminance ?old-lum&~?new-lum))
  =>
  (send ?event delete)
  (send ?device put-luminance ?new-lum)
  (printout t "updated lum to: " ?new-lum " src-address: " ?address crlf))

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