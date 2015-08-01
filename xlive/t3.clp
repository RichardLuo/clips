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

  ([ocb1] of BINDING::OpenCloseBinding
          (address binding-001)
          (src-address PPP)
          (direction opened)
          (actions [act1] [act2]))

  ([act3] of ACTION::Action
          (address PPP)
          (method set-on-off)
          (on-off-cmd on))

  ([act4] of ACTION::Action
          (address PPP)
          (method set-alert-level)
          (alert-level 10))

  ([act5] of ACTION::Action
          (address SSS)
          (method set-on-off)
          (on-off-cmd on))

  ([ocb2] of BINDING::KeypressBinding
          (address binding-002)
          (src-address PPP)
          (actions [act5] [act4]))

  ([ppb1] of BINDING::PirPanelBinding
          (address binding-003)
          (src-address PPP)
          (pir-status alarm)
          (actions [act1] [act2] [act3] [act4])))

(definstances events
  (evt1 of MAIN::KeypressEvent
        (src-address PPP))
  (evt2 of MAIN::OpenCloseEvent
        (src-address PPP)
        (direction opened))
  (evt3 of MAIN::OccupancyEvent
        (src-address PPP)
        (pir-status alarm))
  )

(reset)
(agenda *)
