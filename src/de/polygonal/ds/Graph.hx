/**
 * Copyright (c) Michael Baczynski 2007
 * http://lab.polygonal.de/ds/
 *
 * This software is distributed under licence. Use of this software
 * implies agreement with all terms and conditions of the accompanying
 * software licence.
 */
package de.polygonal.ds;

import haxe.Constraints.Function;
import de.polygonal.ds.GraphNode;

/**
	 * A linked uni-directional weighted graph structure.
	 * <p>The Graph class manages all graph nodes. Each graph node has
	 * a linked list of arcs, pointing to different nodes.</p>
	 */
class Graph
{
    public var size(get, never) : Int;
    public var maxSize(get, never) : Int;

    /**
	 	 * An array containing all graph nodes.
	 	 */
    public var nodes : Array<Dynamic>;
    
    private var _nodeCount : Int;
    private var _maxSize : Int;
    
    /**
		 * Constructs an empty graph.
		 * 
		 * @param size The total number of nodes allowed.
		 */
    public function new(size : Int)
    {
        nodes = new Array<Dynamic>(_maxSize = size);
        _nodeCount = 0;
    }
    
    /**
		 * Performs a depth-first traversal on the given node.
		 * 
		 * @param node    The starting graph node.
		 * @param process A function to apply to each traversed node.
		 */
    public function depthFirst(node : GraphNode, process : Function) : Void
    {
        if (node == null)
        {
            return;
        }
        
        process(node);
        node.marked = true;
        
        var k : Int = node.numArcs;
        var t : GraphNode;
        for (i in 0...k)
        {
            t = node.arcs[i].node;
            if (!t.marked)
            {
                depthFirst(t, process);
            }
        }
    }
    
    /**
		 * Performs a breadth-first traversal on the given node.
		 * 
		 * @param node    The starting graph node.
		 * @param process A function to apply to each traversed node.
		 */
    public function breadthFirst(node : GraphNode, process : Function) : Void
    {
        if (node == null)
        {
            return;
        }
        
        var que : Array<Dynamic> = [];
        que.push(node);
        node.marked = true;
        
        var c : Int = 1;
        
        var t : GraphNode;
        var u : GraphNode;
        while (c > 0)
        {
            process(t = que[0]);
            
            var arcs : Array<Dynamic> = t.arcs;
            var k : Int = t.numArcs;
            for (i in 0...k)
            {
                u = arcs[i].node;
                if (!u.marked)
                {
                    u.marked = true;
                    que.push(u);
                    c++;
                }
            }
            que.shift();
            c--;
        }
    }
    
    /**
		 * Adds a node at a given index to the graph.
		 * 
		 * @param obj The data to store in the node.
		 * @param i   The index the node is stored at.
		 * @return True if successful, otherwise false.
		 */
    public function addNode(obj : Dynamic, i : Int) : Bool
    {
        if (nodes[i] != null)
        {
            return false;
        }
        
        nodes[i] = new GraphNode(obj);
        _nodeCount++;
        return true;
    }
    
    /**
		 * Removes a node from the graph at a given index.
		 * 
		 * @param index Index of the node to remove
		 * @return True if successful, otherwise false.
		 */
    public function removeNode(i : Int) : Bool
    {
        var node : GraphNode = nodes[i];
        if (node == null)
        {
            return false;
        }
        
        var arc : GraphArc;
        for (j in 0..._maxSize)
        {
            var t : GraphNode = nodes[j];
            if (t != null && t.getArc(node))
            {
                removeArc(j, i);
            }
        }
        
        nodes[i] = null;
        _nodeCount--;
        return true;
    }
    
    /**
		 * Finds an arc pointing to the node
		 * at the 'from' index to the node at the 'to' index.
		 * 
		 * @param from The originating graph node index.
		 * @param to   The ending graph node index.
		 * @return A GraphArc object or null if it doesn't exist.
		 */
    public function getArc(from : Int, to : Int) : GraphArc
    {
        var node0 : GraphNode = nodes[from];
        var node1 : GraphNode = nodes[to];
        if (node0 != null && node1 != null)
        {
            return node0.getArc(node1);
        }
        return null;
    }
    
    /**
		 * Adds an arc pointing to the node located at the
		 * 'from' index to the node at the 'to' index.
		 * 
		 * @param from   The originating graph node index.
		 * @param to     The ending graph node index.
		 * @param weight The arc's weight
		 *
		 * @return True if an arc was added, otherwise false.
		 */
    public function addArc(from : Int, to : Int, weight : Int = 1) : Bool
    {
        var node0 : GraphNode = nodes[from];
        var node1 : GraphNode = nodes[to];
        
        if (node0 != null && node1 != null)
        {
            if (node0.getArc(node1))
            {
                return false;
            }
            
            node0.addArc(node1, weight);
            return true;
        }
        return false;
    }
    
    /**
		 * Removes an arc pointing to the node located at the
		 * 'from' index to the node at the 'to' index.
		 * 
		 * @param from The originating graph node index.
		 * @param to   The ending graph node index.
		 * 
		 * @return True if an arc was removed, otherwise false.
		 */
    public function removeArc(from : Int, to : Int) : Bool
    {
        var node0 : GraphNode = nodes[from];
        var node1 : GraphNode = nodes[to];
        
        if (node0 != null && node1 != null)
        {
            node0.removeArc(node1);
            return true;
        }
        return false;
    }
    
    /**
		 * Clears the markers on all nodes in the graph
		 * so the breadth-first and depth-first traversal
		 * algorithms can 'see' the nodes.
		 */
    public function clearMarks() : Void
    {
        for (i in 0..._maxSize)
        {
            var node : GraphNode = nodes[i];
            if (node != null)
            {
                node.marked = false;
            }
        }
    }
    
    /**
		 * The number of nodes in the graph.
		 */
    private function get_size() : Int
    {
        return _nodeCount;
    }
    
    /**
		 * The maximum number of nodes the
		 * graph can store.
		 */
    private function get_maxSize() : Int
    {
        return _maxSize;
    }
    
    /**
		 * Clears every node in the graph.
		 */
    public function clear() : Void
    {
        nodes = new Array<Dynamic>(_maxSize);
        _nodeCount = 0;
    }
}
