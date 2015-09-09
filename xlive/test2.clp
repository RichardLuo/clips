
(clear)

; (watch focus)
; (watch facts)
; (watch rules)
; (watch agenda)

(load "/data/zb/clips/main.clp")

(load "/data/zb/clips/device.clp")
(load "/data/zb/clips/binding.clp")

(make-instance pir1 of DEVICE::PirPanel
               (address AAA)
               (status available)
               (pir-status safe))

(make-instance plug1 of DEVICE::SmartPlug
               (address plug-addr1)
               (on-off-status off))

(make-instance kb1 of BINDING::Keypress
               (src-address AAA)
               (dev-address plug-addr1))

(set-current-module MAIN)
(assert (Event (address AAA)
               (keypressed yes)))



(agenda)
