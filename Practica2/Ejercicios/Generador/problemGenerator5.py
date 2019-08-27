# -*- coding: utf-8 -*-
"""
Created on Sun May 12 13:06:27 2019

@author: Christian
"""
import sys
import string as st

###############################################################
# FUNCIONES

posibles_personajes = ['Principe', 'Princesa', 'Bruja', 'Profesor', 'Leonardo']

def definePuntuacion(puntuaciones,personajes,objetos):
   for i in range(len(personajes)):
      pr = personajes[i]
      personaje = ""
      x = 0
      while x < len(personajes[i])-1:
         personaje += pr[x]
         x += 1

      for j in range(len(objetos)):
         ob = objetos[j]
         objeto = ""
         y = 0
         while y < len(objetos[j])-1:
            objeto += ob[y]
            y += 1

         if personaje == 'leonardo' and objeto == 'oscar':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 10)\n')
         elif personaje == 'leonardo' and objeto == 'rosa':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 1)\n')
         elif personaje == 'leonardo' and objeto == 'manzana':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 3)\n')
         elif personaje == 'leonardo' and objeto == 'algoritmo':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 4)\n')
         elif personaje == 'leonardo' and objeto == 'oro':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 5)\n')

         elif personaje == 'princesa' and objeto == 'oscar':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 5)\n')
         elif personaje == 'princesa' and objeto == 'rosa':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 10)\n')
         elif personaje == 'princesa' and objeto == 'manzana':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 1)\n')
         elif personaje == 'princesa' and objeto == 'algoritmo':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 3)\n')
         elif personaje == 'princesa' and objeto == 'oro':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 4)\n')

         elif personaje == 'bruja' and objeto == 'oscar':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 4)\n')
         elif personaje == 'bruja' and objeto == 'rosa':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 5)\n')
         elif personaje == 'bruja' and objeto == 'manzana':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 10)\n')
         elif personaje == 'bruja' and objeto == 'algoritmo':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 1)\n')
         elif personaje == 'bruja' and objeto == 'oro':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 3)\n')

         elif personaje == 'profesor' and objeto == 'oscar':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 3)\n')
         elif personaje == 'profesor' and objeto == 'rosa':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 4)\n')
         elif personaje == 'profesor' and objeto == 'manzana':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 5)\n')
         elif personaje == 'profesor' and objeto == 'algoritmo':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 10)\n')
         elif personaje == 'profesor' and objeto == 'oro':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 1)\n')

         elif personaje == 'principe' and objeto == 'oscar':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 1)\n')
         elif personaje == 'principe' and objeto == 'rosa':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 3)\n')
         elif personaje == 'principe' and objeto == 'manzana':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 4)\n')
         elif personaje == 'principe' and objeto == 'algoritmo':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 5)\n')
         elif personaje == 'principe' and objeto == 'oro':
            puntuaciones.append('(= (points '+personajes[i]+' '+objetos[j]+') 10)\n')

###############################################################
# PROGRAMA PRINCIPAL

# Lectura de argumentos
if len(sys.argv) == 3:
   arg1 = sys.argv[1]
   arg2 = sys.argv[2]

# Apertura de ficheros
mapa = open(arg1)
problema = open(arg2,"w")

cabecera = []
datos = []
loc = []
rutas = []
objetos = []
personajes = []
jugador = []
distancias = []
superficies = []
surfaces = []
puntuaciones = []
bolsillo = []

# LECTURA DE FICHERO
while True:
   linea = mapa.readline()
   if not linea:
      break
   if linea.strip():
      # Lectura de las línea que contienen información genérica
      if ':' in linea:
         if linea[0] == 'b':
            t = str(linea).rfind('[')+1
            aux = ""
            while linea[t] != ']':
               aux += linea[t]
               t += 1
            aux = aux.split(' ')
            for i in range(len(aux)):
               tm = aux[i].split(':')
               bolsillo.append('\t(= (magic_pocket_size '+tm[0]+') '+tm[1]+')\n')
         elif str(linea).find('puntos_totales') >= 0:
            temp = linea.split(':')
            puntos_totales = temp[1]
         else:
            linea = linea.split(':')
            cabecera.append(linea[1])
      # Lectura de datos del problema a generar
      else:
         linea = linea.strip()
         linea = linea.split("=")
         # Capturo si las zonas están en vertical y horizontal
         linea[0] = linea[0]
         temp = linea[0].split('->')
         orientacion = temp[0]
         temp[1] = temp[1].strip()
         linea[0] = temp[1]
         caminos = []
         dist = []
         superf = []
         # Voy recorriendo línea a línea
         for i in range(len(linea)):
            zona = linea[i]
            obj = ""
            tipo = ""
            elementos = ""
            sup = ""
            if str(zona).isdigit() == True:
               dist.append(zona)
            # Condición para aceptar que una zona tenga varios objetos u personajes
            elif zona[0] != 'z' and str(zona[0]).isdigit() == False:
               j = 0
               while zona[j] != ']':
                     obj += zona[j]
                     j += 1
               elementos = obj.split('-')
               obj = elementos[0]
               tipo = elementos[1]
               if tipo in posibles_personajes:
                  personajes.append(obj)
                  loc.append('(location '+obj+' '+zon+')\n')
               elif tipo == 'Player':
                  jugador.append(obj)
                  loc.append('(location '+obj+' '+zon+')\n')
               else:
                  objetos.append(obj)
                  loc.append('(location '+obj+' '+zon+')\n')
            # Condición para aceptar las zonas que sólo tienen un objeto u personaje
            elif zona[0] == 'z' and str(zona[0]).isdigit() == False:
               zon = zona[0:2]
               caminos.append(zon)
               j = 3
               # Indica que la zona está vacía, ni hay personajes ni objetos
               if zona[3] == ']':
                  zona = zona.strip('[]')
                  j = 5
                  while j < len(zona):
                     sup += zona[j]
                     j += 1
                  superf.append(sup)
                  surfaces.append(sup)
               # La zona no está vacía
               else:
                  while zona[j] != ']':
                     obj += zona[j]
                     j += 1

                  zona = zona.strip('[]')
                  copia = str(zona)
                  pos = copia.rfind('[')
                  pos += 1
                  while pos < len(zona):
                     sup += zona[pos]
                     pos += 1
                  superf.append(sup)
                  surfaces.append(sup)

                  numero = str(obj).count(" ")
                  if numero >= 1:
                     obj = obj.split(" ")
                     for h in range(numero+1):
                        elementos = obj[h].split('-')
                        elem = elementos[0]
                        tipo = elementos[1]

                        if tipo in posibles_personajes:
                           personajes.append(elem)
                           loc.append('(location '+elem+' '+zon+')\n')
                        elif tipo == 'Player':
                           jugador.append(elem)
                           loc.append('(location '+elem+' '+zon+')\n')
                        else:
                           o = str(elem)
                           if o.find("bikini") >= 0:
                              elem = "Bikini"
                           elif o.find("zapatillas") >= 0:
                              elem = "Zapatillas"
                           objetos.append(elem)
                           loc.append('(location '+elem+' '+zon+')\n')
                  else:
                     elementos = obj.split('-')
                     obj = elementos[0]
                     tipo = elementos[1]
                     if tipo in posibles_personajes:
                        personajes.append(obj)
                        loc.append('(location '+obj+' '+zon+')\n')
                     elif tipo == 'Player':
                        jugador.append(obj)
                        loc.append('(location '+obj+' '+zon+')\n')
                     else:
                        o = str(obj)
                        if o.find("bikini") >= 0:
                           obj = "Bikini"
                        elif o.find("zapatillas") >= 0:
                           obj = "Zapatillas"
                        objetos.append(obj)
                        loc.append('(location '+obj+' '+zon+')\n')

         if orientacion[0] == 'V':
            for y in range(len(caminos)-1):
               rutas.append('(rute '+caminos[y]+' '+caminos[y+1]+' Sur)\n')
               rutas.append('(rute '+caminos[y+1]+' '+caminos[y]+' Norte)\n')
               distancias.append('(= (distance '+caminos[y]+' '+caminos[y+1]+') '+dist[y]+')\n')
               distancias.append('(= (distance '+caminos[y+1]+' '+caminos[y]+') '+dist[y]+')\n')
               superficies.append('(surface '+caminos[y]+' '+superf[y]+')\n')
               superficies.append('(surface '+caminos[len(caminos)-1]+' '+superf[len(caminos)-1]+')\n')

         elif orientacion[0] == 'H':
            for y in range(len(caminos)-1):
               rutas.append('(rute '+caminos[y]+' '+caminos[y+1]+' Este)\n')
               rutas.append('(rute '+caminos[y+1]+' '+caminos[y]+' Oeste)\n')
               distancias.append('(= (distance '+caminos[y]+' '+caminos[y+1]+') '+dist[y]+')\n')
               distancias.append('(= (distance '+caminos[y+1]+' '+caminos[y]+') '+dist[y]+')\n')
               superficies.append('(surface '+caminos[y]+' '+superf[y]+')\n')
               superficies.append('(surface '+caminos[len(caminos)-1]+' '+superf[len(caminos)-1]+')\n')

zonas = []
for i in range(int(cabecera[2])):
   zonas.append('z'+str((i+1)))

surf = set(surfaces)
surfaces = list(surf)

definePuntuacion(puntuaciones,personajes,objetos)

# Escribo la cabecera en el fichero de salida
problema.write('(define (problem {})'.format(cabecera[1]))
# DOMINIO
problema.write('\n(:domain '+cabecera[0]+')')
# PERSONAJES
problema.write('\n(:objects\n\t ')
for i in range(len(personajes)):
   problema.write(personajes[i]+' ')
problema.write('- character\n\t ')
objetos.append('Bikini')
objetos.append('Zapatillas')
obb = set(objetos)
objetos = list(obb)
# OBJETOS
for i in range(len(objetos)):
   problema.write(objetos[i]+' ')
problema.write('- item')
# JUGADOR/ES
problema.write('\n\t '+jugador[0]+' - player')
problema.write('\n\t ')
for i in range(len(zonas)):
   problema.write(zonas[i]+' ')
problema.write('- zone')
# ORIENTACIONES
problema.write('\n\t Norte Sur Este Oeste - orientation\n\t ')
surfaces.append('Bosque')
surfaces.append('Agua')
srf = set(surfaces)
surfaces = list(srf)
# SUPERFICIES
for i in range(len(surfaces)):
   problema.write(surfaces[i]+' ')
problema.write('- type')
problema.write(')\n')
problema.write('\n(:init \n')
# RUTAS
for i in range(len(rutas)):
   problema.write('\t'+rutas[i])
problema.write('\n')
# DISTANCIAS
for i in range(len(distancias)):
   problema.write('\t'+distancias[i])
problema.write('\n\t(= (total_distance) 0)\n')   
problema.write('\n')
superficies2 = set(superficies)
superficies = list(superficies2)
# SUPERFICIES
for i in range(len(superficies)):
   problema.write('\t'+superficies[i])
problema.write('\n')
# PUNTUACIONES
for i in range(len(puntuaciones)):
   problema.write('\t'+puntuaciones[i])
problema.write('\n\t(= (total_points) 0)\n') 
problema.write('\n')
# LOCALIZACIONES
for i in range(len(loc)):
   problema.write('\t'+loc[i])
problema.write('\t(looking '+jugador[0]+' '+'Sur)')
problema.write('\n')
# MANO VACÍA
problema.write('\n\t(handempty '+jugador[0]+')')
for i in range(len(personajes)):
   problema.write('\n\t(handempty '+personajes[i]+')')
problema.write('\n')

# MOCHILA VACÍA
for i in range(len(jugador)):
   problema.write('\t(bagempty '+jugador[i]+')\n')
problema.write('\n')
for i in range(len(surfaces)):
   if surfaces[i] == 'Piedra' or surfaces[i] == 'Arena':
      problema.write('\t(allow '+surfaces[i]+')\n')
problema.write('\n')
for i in range(len(objetos)):
   o = str(objetos[i])
   if o.find("Bikini") >= 0:
      problema.write('\t(necessary Agua '+objetos[i]+')\n')
   if o.find("Zapatillas") >= 0:
      problema.write('\t(necessary Bosque '+objetos[i]+')\n')
problema.write('\n')
# BOLSILLO MÁGICO
for i in range(len(personajes)):
   problema.write('\t(= (magic_pocket '+personajes[i]+') 0)\n')
problema.write('\n')
for i in range(len(bolsillo)):
   problema.write(bolsillo[i])
problema.write('\n')
problema.write('\n)')    
problema.write('\n(:goal ')
problema.write('\n\t(and (>= (total_points) '+puntos_totales+'))')
problema.write('\n\t)')
problema.write('\n(:metric minimize (total_distance))')
problema.write('\n)')