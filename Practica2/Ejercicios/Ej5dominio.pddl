;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Christian Vigil Zamora
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain Ejercicio5)
  (:requirements :strips :typing :fluents)
  ; Representación de los objetos
  (:types zone orientation locatable type - object
  		person item - locatable
  		player character - person)

  ; Predicados
  (:predicates 
  		   (rute ?z1 - zone ?z2 - zone ?o - orientation)
	       (location ?l - locatable ?z - zone)
	       (looking ?p - player ?o - orientation)
	       (has ?p - person ?i - item)
	       (handempty ?p - person)
	       (surface ?z - zone ?t - type)
	       (bag ?pl - player ?i - item)
	       (bagempty ?pl - player)
	       (necessary ?t - type ?i - item)
	       (allow ?t - type)
  )

  ; Funciones
  (:functions
  	(distance ?x ?y - zone)
  	(total_distance)
  	(points ?c - character ?i - item)
  	(total_points)
  	(magic_pocket ?c - character)
  	(magic_pocket_size ?c - character)
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
  		 :parameters (?pl - player  ?z1 - zone ?z2 - zone ?o - orientation ?t - type ?i - item)
  		 :precondition (and (location ?pl ?z1) (looking ?pl ?o) (rute ?z1 ?z2 ?o)
  		 					(surface ?z2 ?t) (or (allow ?t) (and (necessary ?t ?i) (or (has ?pl ?i) (bag ?pl ?i)))))
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
 
  ; Acción entregar un objeto
  (:action give
	     :parameters (?pl - player ?c - character ?i - item ?z - zone)
	     :precondition (and (location ?pl ?z) (location ?c ?z)
	     					(has ?pl ?i) (not (has ?pl Zapatillas)) (not (has ?pl Bikini)) (< (magic_pocket ?c) (magic_pocket_size ?c)))
	     :effect
	     (and (not (has ?pl ?i)) (has ?c ?i) (handempty ?pl) (increase (total_points) (points ?c ?i)) (increase (magic_pocket ?c) 1))
	)

  ; Acción guardar un objeto en la mochila
  (:action put
	     :parameters (?pl - player ?i - item)
	     :precondition (and (has ?pl ?i) (bagempty ?pl))
	     :effect
	     (and (not (has ?pl ?i)) (bag ?pl ?i) (not (bagempty ?pl)) (handempty ?pl))
	)

  ; Acción sacar un objeto de la mochila
  (:action take
	     :parameters (?pl - player ?i - item)
	     :precondition (and (bag ?pl ?i) (handempty ?pl))
	     :effect
	     (and (not (bag ?pl ?i)) (has ?pl ?i) (not (handempty ?pl)) (bagempty ?pl))
	)

  )
