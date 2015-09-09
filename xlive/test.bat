
(clear)
(watch facts)
(watch rules)
(watch agenda)
(load "/data/zb/clips/devices.clp")
(load "/data/zb/clips/rules.clp")
(make-instance pir1 of PirPanel
 (status available)
 (pir-status safe))

(make-instance pir1 of DEV::PirPanel
               (address JJJ)
               (status available)
               (pir-status safe))

(assert (PirEvent (address JJJ)
                  (pir-status alarm)
                  (luminance 100)))

(agenda)
