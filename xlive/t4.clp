(clear)
(watch focus)
(watch facts)
(watch rules)
(watch instances)

(load "/zb/clips/main.clp")
(load "/zb/clips/device.clp")
(load "/zb/clips/action.clp")
(load "/zb/clips/binding.clp")

(definstances devices
  (plug1 of DEVICE::SmartPlug
         (address SSS)
         (on-off-status off))
  (pir1 of DEVICE::PirPanel
        (address PPP)
        (status available)
        (luminance 80)
        (pir-status safe)))

(definstances bindings
  ([act1] of ACTION::Action
          (address PPP)
          (method set-on-off)
          (on-off-cmd on))
  ([act2] of ACTION::Action
          (address PPP)
          (method set-alert-level)
          (alert-level 10))

  ([ocb1] of BINDING::PirPanelBinding
          (address binding-001)
          (src-address PPP)
          (luminance 30)
          (pir-status alarm)
          (actions [act1] [act2])))

(definstances events
  (evt1 of MAIN::OccupancyEvent
        (src-address PPP)
        (pir-status alarm))
  (evt2 of MAIN::LuminanceEvent
        (src-address PPP)
        (luminance 8))
  )

(reset)
(agenda *)
