(:task board-persons
  :parameters()

  (:method recursive
    :precondition (and  (at ?p ?c)
                        (at ?a ?c)
                        (< (pasajeros ?a) (capacidad-pasajeros ?a))
                        (not (destino ?p ?c)))
    :tasks ( (board ?p ?a ?c)
             (board-persons))
  )
  (:method caso-base
    :precondition ()
    :tasks ()
  )
)

(:durative-action board
 :parameters (?p - person ?a - aircraft ?c - city)
 :duration (= ?duration (boarding-time))
 :condition (and  (at ?p ?c)
                  (at ?a ?c)
                  (< (pasajeros ?a) (capacidad-pasajeros ?a)))
 :effect (and  (not (at ?p ?c))
               (in ?p ?a)
               (increase (pasajeros ?a) 1))
)

(:task debark-persons
  :parameters()

  (:method recursive
    :precondition (and (in ?p ?a)
                       (at ?a ?c)
                       (destino ?p ?c))
    :tasks ( (debark ?p ?a ?c)
             (debark-persons))
  )
  (:method caso-base
    :precondition ()
    :tasks ()
  )
)

(:durative-action debark
 :parameters (?p - person ?a - aircraft ?c - city)
 :duration (= ?duration (debarking-time))
 :condition (and (in ?p ?a)
                 (at ?a ?c))
 :effect (and  (not (in ?p ?a))
               (at ?p ?c)
               (decrease (pasajeros ?a) 1))
)

(:durative-action fly 
 :parameters (?a - aircraft ?c1 ?c2 - city)
 :duration (= ?duration (/ (distance ?c1 ?c2) (slow-speed ?a)))
 :condition (and  (at ?a ?c1)
                  (>= (fuel ?a) 
                         (* (distance ?c1 ?c2) (slow-burn ?a))))
 :effect (and  (not (at ?a ?c1))
               (at ?a ?c2)
              (increase (total-fuel-used ?a)
                         (* (distance ?c1 ?c2) (slow-burn ?a)))
              (decrease (fuel ?a) 
                         (* (distance ?c1 ?c2) (slow-burn ?a)))
              (increase (total-duration-used ?a)
                         (/ (distance ?c1 ?c2) (slow-speed ?a)))))
                                  
(:durative-action zoom
 :parameters (?a - aircraft ?c1 ?c2 - city)
 :duration (= ?duration (/ (distance ?c1 ?c2) (fast-speed ?a)))
 :condition (and  (at ?a ?c1)
                  (>= (fuel ?a) 
                         (* (distance ?c1 ?c2) (fast-burn ?a))))
 :effect (and (not (at ?a ?c1))
               (at ?a ?c2)
               (increase (total-fuel-used ?a)
                         (* (distance ?c1 ?c2) (fast-burn ?a)))
              (decrease (fuel ?a) 
                         (* (distance ?c1 ?c2) (fast-burn ?a)))
              (increase (total-duration-used ?a)
                         (/ (distance ?c1 ?c2) (fast-speed ?a)))))

(:durative-action refuel
 :parameters (?a - aircraft ?c - city)
 :duration (= ?duration (/ (- (capacity ?a) (fuel ?a)) (refuel-rate ?a)))
 :condition (and  (> (capacity ?a) (fuel ?a))
                 (at ?a ?c))
 :effect (assign (fuel ?a) (capacity ?a)))
