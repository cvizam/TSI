package tools.pathfinder;

import core.game.Observation;
import core.game.StateObservation;
import ontology.Types;
import tools.Vector2d;

import java.util.ArrayList;

/**
 * Created by dperez on 14/01/16.
 */
public class newPathFinder {

    public newAStar astar;
    public StateObservation state;

    public boolean VERBOSE = false;

    //All types are obstacles except the ones included in this array
    public ArrayList<Integer> obstacleItypes;

    public ArrayList<Observation> grid[][];


    private static int[] x_arrNeig = null;
    private static int[] y_arrNeig = null;

    public newPathFinder(ArrayList<Integer> obstacleItypes)
    {
        this.obstacleItypes = obstacleItypes;
    }

    public void run(StateObservation stateObs)
    {
        this.state = stateObs;
        this.grid = stateObs.getObservationGrid();
        this.astar = new newAStar(this);

        init();
        runAll();

        if(VERBOSE)
        {
            for(Integer pathId : astar.pathCache.keySet())
            {
                ArrayList<Node> nodes = astar.pathCache.get(pathId);
                astar.printPath(pathId, nodes);
            }
        }
    }

    private void init()
    {
        if(x_arrNeig == null)
        {
            //TODO: This is a bit of a hack, it wouldn't work with other (new) action sets.
            ArrayList<Types.ACTIONS> actions = this.state.getAvailableActions();
            if(actions.size() == 3)
            {
                //left, right
                x_arrNeig = new int[]{-1, 1};
                y_arrNeig = new int[]{0,  0};
            }else
            {
                //up, down, left, right
                x_arrNeig = new int[]{0,    0,    -1,    1};
                y_arrNeig = new int[]{-1,   1,     0,    0};
            }
        }
    }

    private void runAll()
    {
        for(int i = 0; i < grid.length; ++i)
        {
            for(int j = 0; j < grid[i].length; ++j)
            {
                boolean obstacleCell = isObstacle(i,j);
                if(!obstacleCell)
                {
                    if(VERBOSE) System.out.println("Running from (" + i +  "," + j + ")");
                    runAll(i,j);
                }

            }
        }
    }

    public ArrayList<Node> getPath(Vector2d start, Vector2d end)
    {
        return astar.getPath(new Node(start), new Node(end));
    }

    // Modificación del método getPath para conseguir un camino de forma más directa
    // sin considerar el árbol generado anteriormente, ubicado en caché.
    public ArrayList<Node> getPathaux(Vector2d start, Vector2d end)
    {
        return astar._findPath(new Node(start), new Node(end));
    }

    private void runAll(int i, int j) {
        Node start = new Node(new Vector2d(i,j));
        Node goal = null; //To get all routes.

        astar.findPath(start, goal);
    }


    // Modificación del método isObstacle original, para que descarte nodos que posean NPCS.
    private boolean isObstacle(int row, int col)
    {
        Vector2d fescala = new Vector2d(state.getWorldDimension().width / state.getObservationGrid().length , state.getWorldDimension().height / state.getObservationGrid()[0].length);
        Vector2d npc;
        Vector2d npc2;
        ArrayList<Observation>[] npcs = state.getNPCPositions(state.getAvatarPosition());

        if(row<0 || row>=grid.length) return true;
        if(col<0 || col>=grid[row].length) return true;

        for(Observation obs : grid[row][col])
        {
            if(obstacleItypes.contains(obs.itype))
                return true;

            for(int i=0; i<npcs[0].size();i++) {
                npc = npcs[0].get(i).position;
                npc.x = npc.x / fescala.x;
                npc.y = npc.y / fescala.y;

                if (obs.position.x == npc.x && obs.position.y == npc.y)
                    return true;
                else if (obs.position.x == npc.x && obs.position.y - 1 == npc.y)
                    return true;
                else if (obs.position.x + 1 == npc.x && obs.position.y == npc.y)
                    return true;
                else if (obs.position.x == npc.x && obs.position.y + 1 == npc.y)
                    return true;
                else if (obs.position.x - 1 == npc.x && obs.position.y == npc.y)
                    return true;
                else if (obs.position.x - 1 == npc.x && obs.position.y - 1 == npc.y)
                    return true;
                else if (obs.position.x + 1 == npc.x && obs.position.y - 1 == npc.y)
                    return true;
                else if (obs.position.x + 1 == npc.x && obs.position.y + 1 == npc.y)
                    return true;
                else if (obs.position.x - 1 == npc.x && obs.position.y + 1 == npc.y)
                    return true;
            }

            for(int j=0; j<npcs[1].size();j++) {
                npc2 = npcs[1].get(j).position;
                npc2.x = npc2.x / fescala.x;
                npc2.y = npc2.y / fescala.y;

                if (obs.position.x == npc2.x && obs.position.y == npc2.y)
                    return true;
                else if (obs.position.x == npc2.x && obs.position.y - 1 == npc2.y)
                    return true;
                else if (obs.position.x + 1 == npc2.x && obs.position.y == npc2.y)
                    return true;
                else if (obs.position.x == npc2.x && obs.position.y + 1 == npc2.y)
                    return true;
                else if (obs.position.x - 1 == npc2.x && obs.position.y == npc2.y)
                    return true;
                else if (obs.position.x - 1 == npc2.x && obs.position.y - 1 == npc2.y)
                    return true;
                else if (obs.position.x + 1 == npc2.x && obs.position.y - 1 == npc2.y)
                    return true;
                else if (obs.position.x + 1 == npc2.x && obs.position.y + 1 == npc2.y)
                    return true;
                else if (obs.position.x - 1 == npc2.x && obs.position.y + 1 == npc2.y)
                    return true;
            }
        }

        return false;

    }

    public ArrayList<Node> getNeighbours(Node node) {
        ArrayList<Node> neighbours = new ArrayList<Node>();
        int x = (int) (node.position.x);
        int y = (int) (node.position.y);

        for(int i = 0; i < x_arrNeig.length; ++i)
        {
            if(!isObstacle(x+x_arrNeig[i], y+y_arrNeig[i]))
            {
                neighbours.add(new Node(new Vector2d(x+x_arrNeig[i], y+y_arrNeig[i])));
            }
        }

        return neighbours;
    }


}
