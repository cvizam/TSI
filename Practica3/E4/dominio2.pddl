(define (domain dominio2)


(:requirements
  :typing
  :fluents
  :derived-predicates
  :negative-preconditions
  :universal-preconditions
  :disjuntive-preconditions
  :conditional-effects
  :htn-expansion

  ; Requisitos adicionales para el manejo del tiempo
  :durative-actions
  :metatags
 )

(:types aircraft person city - object)
(:constants slow fast - object)
(:predicates (at ?x - (either person aircraft) ?c - city)
             (in ?p - person ?a - aircraft)
             (different ?x ?y) (igual ?x ?y)
             (hay-fuel ?a ?c1 ?c2)
             (hay-fuel-slow ?a ?c1 ?c2)
             (hay-fuel-fast ?a ?c1 ?c2)
             (destino ?p - person ?c - city)
             (slow-duration ?a - aircraft ?c1 - city ?c2 - city)
             (fast-duration ?a - aircraft ?c1 - city ?c2 - city)
             )
(:functions (fuel ?a - aircraft)
            (distance ?c1 - city ?c2 - city)
            (slow-speed ?a - aircraft)
            (fast-speed ?a - aircraft)
            (slow-burn ?a - aircraft)
            (fast-burn ?a - aircraft)
            (capacity ?a - aircraft)
            (refuel-rate ?a - aircraft)
            (total-fuel-used ?a - aircraft)
            (boarding-time)
            (debarking-time)
            (fuel-limit ?a - aircraft)
            (capacidad-pasajeros ?a - aircraft)
            (pasajeros ?a - aircraft)
            (duration-limit ?a - aircraft)
            (total-duration-used ?a - aircraft)
            )

;; el consecuente "vacio" se representa como "()" y significa "siempre verdad"
(:derived
  (igual ?x ?x) ())

(:derived 
  (different ?x ?y) (not (igual ?x ?y)))



;; este literal derivado se utiliza para deducir, a partir de la información en el estado actual, 
;; si hay fuel suficiente para que el avión ?a vuele de la ciudad ?c1 a la ?c2
;; el antecedente de este literal derivado comprueba si el fuel actual de ?a es mayor que 1. 
;; En este caso es una forma de describir que no hay restricciones de fuel. Pueden introducirse una
;; restricción más copleja  si en lugar de 1 se representa una expresión más elaborada (esto es objeto de
;; los siguientes ejercicios).
(:derived 
  
  (hay-fuel ?a - aircraft ?c1 - city ?c2 - city)
  (> (fuel ?a) 1))

;; literal utilizado para deducir si hay fuel suficiente para volar de la ciudad ?c1 a la ?c2
;; a velocidad lenta
(:derived

  (hay-fuel-slow ?a - aircraft ?c1 - city ?c2 - city)
  (> (fuel ?a) (* (distance ?c1 ?c2) (slow-burn ?a))))

;; literal utilizado para deducir si hay fuel suficiente para volar de la ciudad ?c1 a la ?c2
;; a velocidad rapida
(:derived
  
  (hay-fuel-fast ?a - aircraft ?c1 - city ?c2 - city)
  (> (fuel ?a) (* (distance ?c1 ?c2) (fast-burn ?a))))

;; literal utilizado para deducir si si es posible volar de la ciudad ?c1 a la ?c2 
;; a velocidad lenta sin superar el limite de duración del avion
(:derived
  
  (slow-duration ?a - aircraft ?c1 - city ?c2 - city)
  (> (duration-limit ?a) (+ (/ (distance ?c1 ?c2) (slow-speed ?a)) (total-duration-used ?a))))

;; literal utilizado para deducir si si es posible volar de la ciudad ?c1 a la ?c2 
;; a velocidad rapida sin superar el limite de duración del avion
  (:derived
  
  (fast-duration ?a - aircraft ?c1 - city ?c2 - city)
  (> (duration-limit ?a) (+ (/ (distance ?c1 ?c2) (fast-speed ?a)) (total-duration-used ?a))))

  

(:task transport-person
	:parameters (?p - person ?c - city)
	
  (:method Case1 ; si la persona esta en la ciudad no se hace nada
	 :precondition (at ?p ?c)
	 :tasks ()
   )
	 
   
   (:method Case2 ;si no esta en la ciudad destino, pero avion y persona estan en la misma ciudad
	  :precondition (and (at ?p - person ?c1 - city)
			                 (at ?a - aircraft ?c1 - city)
                       (not (destino ?p - person ?c1 - city)))
				     
	  :tasks ( 
	  	      (board-persons)
		        (mover-avion ?a ?c1 ?c)
		        (debark-persons))
	)


   (:method Case3 ;si no esta en la ciudad destino, y avion y persona estan no están en la misma ciudad
    :precondition (and (at ?p - person ?c1 - city)
                       (at ?a - aircraft ?c2 - city)
                       (not (destino ?p - person ?c1 - city)))
             
    :tasks ( 
            (mover-avion ?a ?c2 ?c1)
            (board-persons)
            (mover-avion ?a ?c1 ?c)
            (debark-persons))
    )

   (:method Case4 ;si ya estan montados los pasajeros pero no estan en la ciudad destino
    :precondition (and (in ?p - person ?a - aircraft)
                       (at ?a - aircraft ?c1 - city)
                       (not (destino ?p - person ?c1 - city)))
             
    :tasks ( 
            (mover-avion ?a ?c1 ?c)
            (debark-persons)
            (board-persons))
    )
)

(:task mover-avion
 :parameters (?a - aircraft ?c1 - city ?c2 -city)
 
 (:method fuel-suficiente-fast;si hay fuel suficiente para viajar rapido
  :precondition (and (hay-fuel-fast ?a ?c1 ?c2)
                (> (fuel-limit ?a)(+ (total-fuel-used ?a) (* (distance ?c1 ?c2) (fast-burn ?a))))
                (fast-duration ?a ?c1 ?c2))
  :tasks (
          (zoom ?a ?c1 ?c2)
         )
  )
 (:method fuel-insuficiente-fast;si no hay fuel suficiente para viajar rapido pero se puede repostar
  :precondition (and (not (hay-fuel-fast ?a ?c1 ?c2))
                (> (fuel-limit ?a)(+ (total-fuel-used ?a) (* (distance ?c1 ?c2) (fast-burn ?a))))
                (fast-duration ?a ?c1 ?c2))
  :tasks (
          (refuel ?a ?c1)
          (zoom ?a ?c1 ?c2)
         )
  )
 (:method fuel-suficiente-slow;si hay fuel suficiente para viajar lento
  :precondition (and (hay-fuel-slow ?a ?c1 ?c2)
                (> (fuel-limit ?a)(+ (total-fuel-used ?a) (* (distance ?c1 ?c2) (slow-burn ?a))))
                (slow-duration ?a ?c1 ?c2))
  :tasks (
          (fly ?a ?c1 ?c2)
         )
  )
 (:method fuel-insuficiente-slow;si no hay fuel suficiente para viajar lento pero se puede repostar
  :precondition (and (not (hay-fuel-slow ?a ?c1 ?c2))
                (> (fuel-limit ?a)(+ (total-fuel-used ?a) (* (distance ?c1 ?c2) (slow-burn ?a))))
                (fast-duration ?a ?c1 ?c2))
  :tasks (
          (refuel ?a ?c1)
          (fly ?a ?c1 ?c2)
         )
  )
  )
 
(:import "Primitivas-ZenoTravel.pddl") 


)
