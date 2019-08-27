package practica_busqueda;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.Vector2d;
import tools.pathfinder.Node;
import tools.pathfinder.newPathFinder;

import javax.swing.*;
import javax.swing.plaf.nimbus.State;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Vector;

public class Agent extends AbstractPlayer {
    //Objeto de clase Pathfinder
    private newPathFinder pf;
    private Vector2d fescala;
    private ArrayList<Node> path  = new ArrayList<>();
    private Vector2d ultimaPos;
    Boolean nuevoPath = false;

    public Agent(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
        //Creamos una lista de IDs de obstaculos
        ArrayList<Integer> tiposObs = new ArrayList();
        tiposObs.add(0); //<- Muros
        tiposObs.add(7); //<- Piedras

        //Se inicializa el objeto del pathfinder con las ids de los obstaculos
        pf = new newPathFinder(tiposObs);
        pf.VERBOSE = false; // <- activa o desactiva el modo la impresion del log

        //Se lanza el algoritmo de pathfinding para poder ser usado en la funcion aCT
        pf.run(stateObs);

        //Calculamos el factor de escala entre mundos
        fescala = new Vector2d(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length , stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);

        //Ultima posicion del avatar
        ultimaPos = new Vector2d(stateObs.getAvatarPosition().x / fescala.x, stateObs.getAvatarPosition().y / fescala.y);
    }

    public ArrayList<Node> mejorCamino(StateObservation stateObs, Vector2d Avatar)
    {
        ArrayList<Node> camino  = new ArrayList<>();
        ArrayList<Observation>[] posiciones = stateObs.getResourcesPositions(stateObs.getAvatarPosition());
        Vector2d gema;
        gema = posiciones[0].get(0).position;
        gema.x = gema.x / fescala.x;
        gema.y = gema.y / fescala.y;

        for(int i=1; i<posiciones[0].size();i++){
            camino = pf.getPathaux(Avatar,gema);
            if(camino == null){
                gema = posiciones[0].get(i).position;
                gema.x = gema.x / fescala.x;
                gema.y = gema.y / fescala.y;
            }
            else{
                nuevoPath = false;
                return camino;
            }
        }
        return camino;
    }

    public void bloqueaNPC(StateObservation stateObs){
        ArrayList<Observation>[] npcs = stateObs.getNPCPositions(stateObs.getAvatarPosition());
        Vector2d npc;
        Vector2d npc2;

        for(int i=0; i<npcs[0].size();i++) {
            npc = npcs[0].get(i).position;
            npc.x = npc.x / fescala.x;
            npc.y = npc.y / fescala.y;

            if (!pf.grid[(int) npc.x][(int) npc.y-1].isEmpty())
                pf.grid[(int) npc.x][(int) npc.y-1].get(0).itype = 7;
            if (!pf.grid[(int) npc.x+1][(int) npc.y].isEmpty())
                pf.grid[(int) npc.x+1][(int) npc.y].get(0).itype = 7;
            if (!pf.grid[(int) npc.x][(int) npc.y+1].isEmpty())
                pf.grid[(int) npc.x][(int) npc.y+1].get(0).itype = 7;
            if (!pf.grid[(int) npc.x-1][(int) npc.y].isEmpty())
                pf.grid[(int) npc.x-1][(int) npc.y].get(0).itype = 7;
            if(!pf.grid[(int) npc.x-1][(int) npc.y-1].isEmpty())
                pf.grid[(int) npc.x-1][(int) npc.y-1].get(0).itype = 7;
            if(!pf.grid[(int) npc.x+1][(int) npc.y-1].isEmpty())
                pf.grid[(int) npc.x+1][(int) npc.y-1].get(0).itype = 7;
            if(!pf.grid[(int) npc.x+1][(int) npc.y+1].isEmpty())
                pf.grid[(int) npc.x+1][(int) npc.y+1].get(0).itype = 7;
            if(!pf.grid[(int) npc.x-1][(int) npc.y+1].isEmpty())
                pf.grid[(int) npc.x-1][(int) npc.y+1].get(0).itype = 7;
        }

        for(int i=0; i<npcs[1].size();i++) {
            npc2 = npcs[1].get(i).position;
            npc2.x = npc2.x / fescala.x;
            npc2.y = npc2.y / fescala.y;

            if (!pf.grid[(int) npc2.x][(int) npc2.y - 1].isEmpty())
                pf.grid[(int) npc2.x][(int) npc2.y - 1].get(0).itype = 7;
            if (!pf.grid[(int) npc2.x + 1][(int) npc2.y].isEmpty())
                pf.grid[(int) npc2.x + 1][(int) npc2.y].get(0).itype = 7;
            if (!pf.grid[(int) npc2.x][(int) npc2.y + 1].isEmpty())
                pf.grid[(int) npc2.x][(int) npc2.y + 1].get(0).itype = 7;
            if (!pf.grid[(int) npc2.x - 1][(int) npc2.y].isEmpty())
                pf.grid[(int) npc2.x - 1][(int) npc2.y].get(0).itype = 7;
            if(!pf.grid[(int) npc2.x-1][(int) npc2.y-1].isEmpty())
                pf.grid[(int) npc2.x-1][(int) npc2.y-1].get(0).itype = 7;
            if(!pf.grid[(int) npc2.x+1][(int) npc2.y-1].isEmpty())
                pf.grid[(int) npc2.x+1][(int) npc2.y-1].get(0).itype = 7;
            if(!pf.grid[(int) npc2.x+1][(int) npc2.y+1].isEmpty())
                pf.grid[(int) npc2.x+1][(int) npc2.y+1].get(0).itype = 7;
            if(!pf.grid[(int) npc2.x-1][(int) npc2.y+1].isEmpty())
                pf.grid[(int) npc2.x-1][(int) npc2.y+1].get(0).itype = 7;
        }
    }

    @Override
    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
        // Actualizamos el sensor y el mapa del PathFinder.
        pf.state = stateObs.copy();
        pf.grid = stateObs.getObservationGrid().clone();

        //Obtenemos la posicion del avatar
        Vector2d avatar =  new Vector2d(stateObs.getAvatarPosition().x / fescala.x, stateObs.getAvatarPosition().y / fescala.y);
        System.out.println("Posicion del avatar: " + avatar.toString());
        //System.out.println("Ultima posicion: " + ultimaPos);
        //System.out.println("Ultima accion: " + ultimaaccion);

        // Bloqueamos las casillas que rodean a los NPCS
        bloqueaNPC(stateObs);

        //actualizamos el plan de ruta
        if(((avatar.x != ultimaPos.x) || (avatar.y != ultimaPos.y)) && path != null && !path.isEmpty()){
            path.remove(0);
        }

        //Calculamos el numero de gemas que lleva encima
        int nGemas = 0;
        if(stateObs.getAvatarResources().isEmpty() != true){
            nGemas = stateObs.getAvatarResources().get(6);
        }
        //Si no hay un plan de ruta calculado...
        if(path.isEmpty() || nuevoPath){
            //Si ya tiene todas las gemas se calcula uno al portal mas cercano. Si no se calcula a la gema mas cercana
            if(nGemas >= 9){
                Vector2d portal;

                //Se crea una lista de observaciones de portales, ordenada por cercania al avatar
                ArrayList<Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());

                //Se seleccionan el portal mas cercano
                portal = posiciones[0].get(0).position;

                //Se le aplica el factor de escala para que las coordenas de pixel coincidan con las coordenadas del grig
                portal.x = portal.x / fescala.x;
                portal.y = portal.y / fescala.y;

                //Calculamos un camino desde la posicion del avatar a la posicion del portal
                path = pf.getPathaux(avatar, portal);
            }
            else{

                // Calculamos un camino desde la posición del avatar a la posición de la gema
                path = mejorCamino(stateObs,avatar);

            }
        }

        if(path != null){
            Types.ACTIONS siguienteaccion;
            Node siguientePos = path.get(0);

            //Se determina el siguiente movimiento a partir de la posicion del avatar
            if(siguientePos.position.x != avatar.x){
                if (siguientePos.position.x > avatar.x) {
                    siguienteaccion = Types.ACTIONS.ACTION_RIGHT;
                }else{
                    siguienteaccion = Types.ACTIONS.ACTION_LEFT;
                }
            }else{
                if(siguientePos.position.y > avatar.y){
                    siguienteaccion = Types.ACTIONS.ACTION_DOWN;
                }else{
                    siguienteaccion = Types.ACTIONS.ACTION_UP;
                }
            }

            // Comprobamos si la siguiente posición del plan contiene una piedra, si se da el caso, calculamos un plan nuevo
            if(!stateObs.getObservationGrid()[(int)siguientePos.position.x][(int)siguientePos.position.y].isEmpty() && stateObs.getObservationGrid()[(int)siguientePos.position.x][(int)siguientePos.position.y].get(0).itype == 7)
            {
                nuevoPath = true;
            }

            //Se actualiza la ultima posicion del avatar
            ultimaPos = avatar;

            //Se devuelve la accion deseada
            return siguienteaccion;
        }
        else{
            //Salida por defecto
            return Types.ACTIONS.ACTION_NIL;
        }

    }



    private void simularacciones(StateObservation stateObs){
        //Obtenemos la lista de acciones disponible
        ArrayList<Types.ACTIONS> acciones = stateObs.getAvailableActions();

        //Guardamos la informacion sobre el estado inicial
        StateObservation viejoEstado = stateObs;

        for(Types.ACTIONS accion:acciones){
            //avanzamos el estado tras aplicarle una accion
            viejoEstado.advance(accion);

            //viejoEstado.somethingsomething(parametros);  <- Hacemos lo que queramos con el estado avanzado

            //Restauramos el estado para avanzarlo con otra de las acciones disponibles.
            viejoEstado = stateObs;
        }
    }
}
