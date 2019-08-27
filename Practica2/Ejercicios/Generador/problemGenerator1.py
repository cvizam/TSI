# -*- coding: utf-8 -*-
"""
Created on Sun May 12 13:06:27 2019

@author: Christian
"""
import sys

###############################################################
# FUNCIONES

posibles_personajes = ['Principe', 'Princesa', 'Bruja', 'Profesor', 'Leonardo']

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

# Lectura del fichero
while True:
   linea = mapa.readline()
   if not linea:
      break
   if linea.strip():
      # Lectura de las línea que contienen información genérica
      if ':' in linea:
         linea = linea.split(':')
         cabecera.append(linea[1])
      # Lectura de datos del problema a generar
      else:
         linea = linea.strip()
         linea = linea.split(" ")
         linea.remove('->')
         # Capturo si las zonas están en vertical y horizontal
         orientacion = linea[0]
         linea.remove(linea[0])
         caminos = []
         # Voy recorriendo línea a línea
         for i in range(len(linea)):
            zona = linea[i]
            obj = ""
            tipo = ""
            elementos = ""
            # Condición para aceptar que una zona tenga varios objetos u personajes
            if zona[0] != 'z':
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
            else:
               zon = zona[0:2]
               caminos.append(zon)
               j = 3
               # Indica que la zona está vacía, ni hay personajes ni objetos
               if zona[3] == ']':
                  zona = zona.strip('[]')
               # La zona no está vacía
               else:
                  if zona[len(zona)-1] == ']':
                     while j != len(zona)-1:
                        obj += zona[j]
                        j += 1
                  else:
                     while j != len(zona):
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

         if orientacion == 'V':
            for y in range(len(caminos)-1):
               rutas.append('(rute '+caminos[y]+' '+caminos[y+1]+' Sur)\n')
               rutas.append('(rute '+caminos[y+1]+' '+caminos[y]+' Norte)\n')
         elif orientacion == 'H':
            for y in range(len(caminos)-1):
               rutas.append('(rute '+caminos[y]+' '+caminos[y+1]+' Este)\n')
               rutas.append('(rute '+caminos[y+1]+' '+caminos[y]+' Oeste)\n')
# ZONAS
zonas = []
for i in range(int(cabecera[2])):
   zonas.append('z'+str((i+1)))

# Escribo la cabecera en el fichero de salida
# PROBLEMA
problema.write('(define (problem {})'.format(cabecera[1]))
# DOMINIO
problema.write('\n(:domain '+cabecera[0]+')')
problema.write('\n(:objects\n\t ')
# PERSONAJES
for i in range(len(personajes)):
   problema.write(personajes[i]+' ')
problema.write('- character\n\t ')
# OBJETOS
for i in range(len(objetos)):
   problema.write(objetos[i]+' ')
problema.write('- item')
# JUGADOR/ES
problema.write('\n\t '+jugador[0]+' - player')
problema.write('\n\t ')
# ZONAS
for i in range(len(zonas)):
   problema.write(zonas[i]+' ')
problema.write('- zone')
# ORIENTACIÓN
problema.write('\n\t Norte Sur Este Oeste - orientation')
problema.write('\n)')
problema.write('\n(:init \n')
# RUTAS
for i in range(len(rutas)):
   problema.write('\t'+rutas[i])
problema.write('\n')
# LOCALIZACIÓN
for i in range(len(loc)):
   problema.write('\t'+loc[i])
# ORIENTACIÓN
problema.write('\t(looking '+jugador[0]+' '+'Sur)')
problema.write('\n')
# MANO VACÍA
problema.write('\n\t(handempty '+jugador[0]+')')
for i in range(len(personajes)):
   problema.write('\n\t(handempty '+personajes[i]+')')

problema.write('\n)')

# OBJETIVO
problema.write('\n(:goal (exists (')
for i in range(len(objetos)):
   problema.write('?i'+str(i)+' ')
problema.write('- item)')
problema.write('\n\t(and ')
for i in range(len(personajes)):
   problema.write('\n\t\t(has '+personajes[i]+' '+'?i'+str(i)+')')
problema.write('\n\t))')
problema.write('\n))')