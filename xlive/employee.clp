(defclass PERSON
  "PERSON defclass"
  (is-a USER)
  (slot full-name)
  (slot age)
  (slot eye-color)
  (slot hair-color))

(defclass EMPLOYEE
  "EMPLOYEE defclass"
  (is-a PERSON)
  (slot job-position)
  (slot employer)
  (slot slalary))