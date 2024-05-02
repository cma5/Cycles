import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;

/**
 * A simple undirected and unweighted graph implementation.
 * 
 * @param <SimpleVector> The type that would be used as vertex.
 */
public class Graph<SimpleVector> {
    final private HashMap<SimpleVector, Set<SimpleVector>> adjacencyList;
    
    /**
     * Create new Graph object.
     */
    public Graph() {
        this.adjacencyList = new HashMap<>();
    }

    public void printGraph(){
        println(this.adjacencyList);
    }

    /**
     * Add new vertex to the graph.
     * 
     * @param v The vertex object. 
     */
    public boolean addVertex(SimpleVector v) {
        if (this.adjacencyList.containsKey(v)) {
            //println("Vertex already exists.");
            return false;
        }
        this.adjacencyList.put(v, new HashSet<SimpleVector>());
        return true;
    }
    
    /**
     * Remove the vertex v from the graph.
     * 
     * @param v The vertex that will be removed.
     */
    public boolean removeVertex(SimpleVector v) {
        if (!this.adjacencyList.containsKey(v)) {
            //println("Vertex doesn't exist.");
            return false;
        }
        
        this.adjacencyList.remove(v);
        
        for (SimpleVector u: this.getAllVertices()) {
            this.adjacencyList.get(u).remove(v);
        }
        return true;
    }
    
    /**
     * Add new edge between vertex. Adding new edge from u to v will
     * automatically add new edge from v to u since the graph is undirected.
     * 
     * @param v Start vertex.
     * @param u Destination vertex.
     * 
     * if there are no keyes, or the edge already exists, we return false
     */
    public boolean addEdge(SimpleVector v, SimpleVector u) {
        if (v.equals(u)){
            return false;
        }

        if (!this.adjacencyList.containsKey(v) || !this.adjacencyList.containsKey(u)) {
            return false;
        }
        
        if (!this.adjacencyList.get(v).add(u) || !this.adjacencyList.get(u).add(v)){
            return false;
        }

        return true;
    }
    
    /**
     * Remove the edge between vertex. Removing the edge from u to v will 
     * automatically remove the edge from v to u since the graph is undirected.
     * 
     * @param v Start vertex.
     * @param u Destination vertex.
     */
    public boolean removeEdge(SimpleVector v, SimpleVector u) {
        if (!this.adjacencyList.containsKey(v) || !this.adjacencyList.containsKey(u)) {
            return false;
        }
        
        this.adjacencyList.get(v).remove(u);
        this.adjacencyList.get(u).remove(v);
        return true;
    }
    
    /**
     * Check adjacency between 2 vertices in the graph.
     * 
     * @param v Start vertex.
     * @param u Destination vertex.
     * @return <tt>true</tt> if the vertex v and u are connected.
     */
    public boolean isAdjacent(SimpleVector v, SimpleVector u) {
        return this.adjacencyList.get(v).contains(u);
    }
    
    /**
     * Get connected vertices of a vertex.
     * 
     * @param v The vertex.
     * @return An iterable for connected vertices.
     */
    public Iterable<SimpleVector> getNeighbors(SimpleVector v) {
        return this.adjacencyList.get(v);
    }
    
    /**
     * Get all vertices in the graph.
     * 
     * @return An Iterable for all vertices in the graph.
     */
    public Iterable<SimpleVector> getAllVertices() {
        return this.adjacencyList.keySet();
    }

    public void clear(){
        this.adjacencyList.clear();
    }

    /**
     * Get all simple cycles in the graph.
     * 
     * This is an implementation of the following concept: https://en.wikipedia.org/wiki/Cycle_(graph_theory)
     */

    public List<List<SimpleVector>> findAllSimpleCycles() {
        List<List<SimpleVector>> cycles = new ArrayList<>();
        HashMap<SimpleVector, Set<SimpleVector>> visitedInCycle = new HashMap<>();

        for (SimpleVector vertex : getAllVertices()) {
            List<SimpleVector> path = new ArrayList<>();
            findSimpleCyclesDFS(vertex, vertex, new HashSet<>(), path, cycles, visitedInCycle);
        }

        return cycles;
    }

    private void findSimpleCyclesDFS(SimpleVector start, SimpleVector current, Set<SimpleVector> visited,
            List<SimpleVector> path, List<List<SimpleVector>> cycles, HashMap<SimpleVector, Set<SimpleVector>> visitedInCycle) {
        visited.add(current);
        path.add(current);

        for (SimpleVector neighbor : getNeighbors(current)) {
            if (neighbor.equals(start) && path.size() > 2) {
                // Found a cycle
                boolean isNewCycle = isNewCycle(path, visitedInCycle);
                if (isNewCycle) {
                    cycles.add(new ArrayList<>(path));
                    addToVisitedInCycle(path, visitedInCycle);
                }
            } else if (!visited.contains(neighbor)) {
                findSimpleCyclesDFS(start, neighbor, visited, path, cycles, visitedInCycle);
            }
        }

        // Backtrack
        visited.remove(current);
        path.remove(path.size() - 1);
    }

    private boolean isNewCycle(List<SimpleVector> path, HashMap<SimpleVector, Set<SimpleVector>> visitedInCycle) {
        Set<SimpleVector> cycleSet = new HashSet<>(path);
        for (Set<SimpleVector> visitedSet : visitedInCycle.values()) {
            if (visitedSet.equals(cycleSet)) {
                return false; // This cycle already exists
            }
        }
        return true; // This is a new cycle
    }

    private void addToVisitedInCycle(List<SimpleVector> path, HashMap<SimpleVector, Set<SimpleVector>> visitedInCycle) {
        Set<SimpleVector> cycleSet = new HashSet<>(path);
        visitedInCycle.put(path.get(0), cycleSet);
    }
}
