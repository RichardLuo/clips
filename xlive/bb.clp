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
  ([act4] of ACTION::Action
          (address PPP)
          (method set-alert-level)
          (alert-level 10))

  ([act5] of ACTION::Action
          (address SSS)
          (method set-on-off)
          (on-off-cmd on))

  ([ocb2] of BINDING::KeypressBinding
          (src-address PPP)
          (actions (instance-address [act5]) (instance-address [act4])))
  )

(definstances events
  (evt1 of MAIN::KeypressEvent
        (src-address PPP))
  (evt2 of MAIN::OpenCloseEvent
        (src-address PPP)
        (direction opened))
  )

(reset)
(agenda *)
