
(defclass COMPLEX (is-a USER) (role concrete)
  (slot real (create-accessor read-write))
  (slot imag (create-accessor read-write)))

(defmethod + ((?a COMPLEX) (?b COMPLEX))
  (make-instance of COMPLEX
                 (real (+ (send ?a get-real)
                          (send ?b get-real)))
                 (imag (+ (send ?a get-imag)
                          (send ?b get-imag)))))

(defmessage-handler COMPLEX magnitude ()
  (sqrt (+ (** ?self:real 2)
           (** ?self:imag 2))))