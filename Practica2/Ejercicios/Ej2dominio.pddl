;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Christian Vigil Zamora
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain Ejercicio2)
  (:requirements :strips :typing :fluents)
  ; Representación de los objetos
  (:types zone orientation locatable - object
  		person item - locatable
  		player character - person)

  ; Predicados
  (:predicates 
  		   (rute ?z1 - zone ?z2 - zone ?o - orientation)
	       (location ?l - locatable ?z - zone)
	       (looking ?pl - player ?o - orientation)
	       (has ?p - person ?i - item)
	       (handempty ?p - person)
  )

  ; Funciones
  (:functions
  	(distance ?x ?y - zone)
  	(total_distance)
  )

  ; Acción girar a la izquierda 
  (:action turn-left
  		 :parameters (?pl - player ?o - orientation)
  		 :precondition (and (looking ?pl ?o))
	  		 :effect (and (when (and (looking ?pl Norte))(and (looking ?pl Oeste)
	  		 					(not (looking ?pl Norte))))
	  		 			  (when (and (looking ?pl Sur))(and (looking ?pl Este)
	  		 					(not (looking ?pl Sur))))
	  		 			  (when (and (looking ?pl Este))(and (looking ?pl Norte)
	  		 					(not (looking ?pl Este))))
	  		 			  (when (and (looking ?pl Oeste))(and (looking ?pl Sur)
	  		 					(not (looking ?pl Oeste))))
	  		 		  )
  )

  ; Acción girar a la derecha
  (:action turn-right
  		 :parameters (?pl - player ?o - orientation)
  		 :precondition (and (looking ?pl ?o))
	  		 :effect (and (when (and (looking ?pl Norte))(and (looking ?pl Este)
	  		 					(not (looking ?pl Norte))))
	  		 			  (when (and (looking ?pl Sur))(and (looking ?pl Oeste)
	  		 					(not (looking ?pl Sur))))
	  		 			  (when (and (looking ?pl Este))(and (looking ?pl Sur)
	  		 					(not (looking ?pl Este))))
	  		 			  (when (and (looking ?pl Oeste))(and (looking ?pl Norte)
	  		 					(not (looking ?pl Oeste))))
	  		 		  )
  )

  ; Acción ir de una zona a otra
  (:action go
  		 :parameters (?pl - player  ?z1 - zone ?z2 - zone ?o - orientation)
  		 :precondition (and (location ?pl ?z1) (looking ?pl ?o) (rute ?z1 ?z2 ?o))
  		 :effect (and (not (location ?pl ?z1)) (location ?pl ?z2) (increase (total_distance) (distance ?z1 ?z2)))
  	)

  ; Acción coger un objeto
  (:action pick-up
	     :parameters (?pl - player ?z - zone ?i - item)
	     :precondition (and (location ?pl ?z) (location ?i ?z) 
							(handempty ?pl))
	     :effect
	     (and (not (handempty ?pl)) (has ?pl ?i) 
	     					(not (location ?i ?z)))
	)

  ; Acción dejar un objeto
  (:action put-down
	     :parameters (?pl - player ?z - zone ?i - item)
	     :precondition (and (has ?pl ?i) (location ?pl ?z))
	     :effect
	     (and (not (has ?pl ?i)) (location ?i ?z) (handempty ?pl))
	)
 
  ; Acción entregar un objeto a un personaje
  (:action give
	     :parameters (?pl - player ?c - character ?i - item ?z - zone)
	     :precondition (and (location ?pl ?z) (location ?c ?z)
	     					(has ?pl ?i) (handempty ?c))
	     :effect
	     (and (not (has ?pl ?i)) (has ?c ?i) (handempty ?pl) (not (handempty ?c)))
	)
  )
