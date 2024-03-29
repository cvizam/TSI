(define (problem BELKAN)
    (:domain Ejercicio6)
    (:objects 
        Princesa Principe Bruja Profesor Leonardo - character
        Oscar Manzana Rosa Algoritmo Oro Bikini Zapatillas - item
        Hacker - player
        ElonMusk - player
        z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12 z13 z14 z15 z16 z17 z18 z19 z20 z21 z22 z23 z24 z25 - zone
        Norte Sur Este Oeste - orientation
        Bosque Agua Precipicio Arena Piedra - type
    )
    (:init
        ; Conexiones entre zonas y su orientación
        (rute z1 z3 Este)
        (rute z1 z2 Sur)
        (rute z2 z1 Norte)
        (rute z2 z4 Este)
        (rute z2 z11 Sur)
        (rute z3 z1 Oeste)
        (rute z3 z4 Sur)
        (rute z3 z5 Este)
        (rute z4 z3 Norte)
        (rute z4 z2 Oeste)
        (rute z5 z3 Oeste)
        (rute z5 z7 Este)
        (rute z5 z6 Sur)
        (rute z6 z5 Norte)
        (rute z6 z15 Sur)
        (rute z7 z5 Oeste)
        (rute z7 z9 Este)
        (rute z7 z8 Sur)
        (rute z8 z7 Norte)
        (rute z8 z10 Este)
        (rute z8 z17 Sur)
        (rute z9 z7 Oeste)
        (rute z9 z10 Sur)
        (rute z10 z9 Norte)
        (rute z10 z8 Oeste)
        (rute z10 z19 Sur)
        (rute z11 z2 Norte)
        (rute z11 z13 Este)
        (rute z11 z12 Sur)
        (rute z12 z11 Norte)
        (rute z12 z14 Este)
        (rute z12 z21 Sur)
        (rute z13 z11 Oeste)
        (rute z13 z15 Este)
        (rute z14 z12 Oeste)
        (rute z14 z23 Sur)
        (rute z15 z6 Norte)
        (rute z15 z13 Oeste)
        (rute z15 z16 Sur)
        (rute z16 z15 Norte)
        (rute z16 z18 Este)
        (rute z16 z25 Sur)
        (rute z17 z8 Norte)
        (rute z17 z19 Este)
        (rute z18 z16 Oeste)
        (rute z18 z20 Este)
        (rute z19 z10 Norte)
        (rute z19 z17 Oeste)
        (rute z20 z18 Oeste)
        (rute z21 z12 Norte)
        (rute z21 z23 Este)
        (rute z22 z25 Oeste)
        (rute z22 z24 Este)
        (rute z23 z21 Oeste)
        (rute z23 z25 Este)
        (rute z24 z22 Oeste)
        (rute z25 z23 Oeste)
        (rute z25 z22 Este)

        ; Distancia entre las zonas
        (= (distance z1 z3) 1)
        (= (distance z1 z2) 2)
        (= (distance z2 z1) 2)
        (= (distance z2 z4) 3)
        (= (distance z2 z11) 4)
        (= (distance z3 z1) 1)
        (= (distance z3 z4) 5)
        (= (distance z3 z5) 1)
        (= (distance z4 z3) 5)
        (= (distance z4 z2) 3)
        (= (distance z5 z3) 1)
        (= (distance z5 z7) 2)
        (= (distance z5 z6) 3)
        (= (distance z6 z5) 3)
        (= (distance z6 z15) 4)
        (= (distance z7 z5) 2)
        (= (distance z7 z9) 5)
        (= (distance z7 z8) 1)
        (= (distance z8 z7) 1)
        (= (distance z8 z10) 2)
        (= (distance z8 z17) 3)
        (= (distance z9 z7) 5)
        (= (distance z9 z10) 4)
        (= (distance z10 z9) 4)
        (= (distance z10 z8) 2)
        (= (distance z10 z19) 5)
        (= (distance z11 z2) 4)
        (= (distance z11 z13) 1)
        (= (distance z11 z12) 2)
        (= (distance z12 z11) 2)
        (= (distance z12 z14) 3)
        (= (distance z12 z21) 4)
        (= (distance z13 z11) 1)
        (= (distance z13 z15) 5)
        (= (distance z14 z12) 3)
        (= (distance z14 z23) 1)
        (= (distance z15 z6) 4)
        (= (distance z15 z13) 5)
        (= (distance z15 z16) 2)
        (= (distance z15 z17) 1)
        (= (distance z16 z15) 2)
        (= (distance z16 z18) 3)
        (= (distance z16 z25) 4)
        (= (distance z17 z8) 3)
        (= (distance z17 z19) 5)
        (= (distance z17 z15) 1)
        (= (distance z18 z16) 3)
        (= (distance z18 z20) 1)
        (= (distance z19 z10) 5)
        (= (distance z19 z17) 5)
        (= (distance z19 z20) 2)
        (= (distance z20 z18) 1)
        (= (distance z20 z19) 2)
        (= (distance z21 z12) 4)
        (= (distance z21 z23) 2)
        (= (distance z22 z25) 3)
        (= (distance z22 z24) 4)
        (= (distance z23 z21) 2)
        (= (distance z23 z25) 5)
        (= (distance z23 z14) 1)
        (= (distance z24 z22) 4)
        (= (distance z25 z23) 5)
        (= (distance z25 z22) 3)
        (= (distance z25 z16) 4)

        ; Inicializo a 0 la distancia total a minimizar
        (= (total_distance) 0)
    
        ; Superficie de las zonas
        (surface z1 Arena)
        (surface z2 Piedra)
        (surface z3 Arena)
        (surface z4 Piedra)
        (surface z5 Arena)
        (surface z6 Piedra)
        (surface z7 Arena)
        (surface z8 Piedra)
        (surface z9 Precipicio)
        (surface z10 Bosque)
        (surface z11 Arena)
        (surface z12 Piedra)
        (surface z13 Arena)
        (surface z14 Piedra)
        (surface z15 Arena)
        (surface z16 Piedra)
        (surface z17 Bosque)
        (surface z18 Arena)
        (surface z19 Bosque)
        (surface z20 Piedra)
        (surface z21 Arena)
        (surface z22 Agua)
        (surface z23 Arena)
        (surface z24 Precipicio)
        (surface z25 Agua)

        ; Puntos por entregar 'X' objeto a 'Y' personaje
        (= (points Leonardo Oscar) 10)
        (= (points Leonardo Rosa) 1)
        (= (points Leonardo Manzana) 3)
        (= (points Leonardo Algoritmo) 4)
        (= (points Leonardo Oro) 5)
        (= (points Princesa Oscar) 5)
        (= (points Princesa Rosa) 10)
        (= (points Princesa Manzana) 1)
        (= (points Princesa Algoritmo) 3)
        (= (points Princesa Oro) 4)
        (= (points Bruja Oscar) 4)
        (= (points Bruja Rosa) 5)
        (= (points Bruja Manzana) 10)
        (= (points Bruja Algoritmo) 1)
        (= (points Bruja Oro) 3)
        (= (points Profesor Oscar) 3)
        (= (points Profesor Rosa) 4)
        (= (points Profesor Manzana) 5)
        (= (points Profesor Algoritmo) 10)
        (= (points Profesor Oro) 1)
        (= (points Principe Oscar) 1)
        (= (points Principe Rosa) 3)
        (= (points Principe Manzana) 4)
        (= (points Principe Algoritmo) 5)
        (= (points Principe Oro) 10)

        ; Inicializo los puntos totales a 0
        (= (total_points) 0)


        ;Localización y orientación del jugador
        (location Hacker z1)
        (looking Hacker Sur)
        (location ElonMusk z15)
        (looking ElonMusk Sur)

        ; Localización de los personajes
        (location Princesa z4)
        (location Principe z18)
        (location Bruja z7)
        (location Profesor z10)
        (location Leonardo z11)

        ; Localización de los objetos
        (location Manzana z12)
        (location Oscar z16)
        (location Rosa z17)
        (location Oro z22)
        (location Algoritmo z6)
        (location Manzana z9)
        (location Oscar z8)
        (location Rosa z21)
        (location Oro z13)
        (location Algoritmo z2)
        (location Bikini z19)
        (location Zapatillas z14)
        (location Bikini z5)
        (location Zapatillas z15)

        ; Por defecto, no tienen ningún objeto ni jugador ni personajes
        (handempty Hacker)
        (handempty ElonMusk)
        (handempty Principe)
        (handempty Princesa)
        (handempty Bruja)
        (handempty Profesor)
        (handempty Leonardo)

        ; Inicializo la mochila del jugador a vacía
        (bagempty Hacker)
        (bagempty ElonMusk)

        ; Indico cuales son las superficies por las que se puede ir sin problemas
        (allow Piedra)
        (allow Arena)

        ; Indico los objetos necesarios para ir por dichas superficies
        (necessary Agua Bikini)
        (necessary Bosque Zapatillas)

        ; Inicializo el bolsillo mágico de los personajes a 0
        (= (magic_pocket Leonardo) 0)
        (= (magic_pocket Princesa) 0)
        (= (magic_pocket Bruja) 0)
        (= (magic_pocket Profesor) 0)
        (= (magic_pocket Principe) 0)

        ; Indico el tamaño máximo del bolsillo mágico de los personajes
        (= (magic_pocket_size Leonardo) 2)
        (= (magic_pocket_size Princesa) 2)
        (= (magic_pocket_size Bruja) 2)
        (= (magic_pocket_size Profesor) 2)
        (= (magic_pocket_size Principe) 1)

        (= (player_points Hacker) 0)
        (= (player_points ElonMusk) 0)
    )
    
    (:goal 
         (and (>= (total_points) 70) (>= (player_points Hacker) 20) (>= (player_points ElonMusk) 35))
    )
  (:metric minimize (total_distance))
)
