/**
 * Copyright (c) Michael Baczynski 2007
 * http://lab.polygonal.de/ds/
 *
 * This software is distributed under licence. Use of this software
 * implies agreement with all terms and conditions of the accompanying
 * software licence.
 */
package de.polygonal.ds;

import de.polygonal.ds.DListNode;
import de.polygonal.ds.DLinkedList;

/**
	 * A list iterator.
	 */
class DListIterator implements Iterator
{
    public var data(get, set) : Dynamic;

    /**
		 * The node the iterator is pointing to.
		 */
    public var node : DListNode;
    
    /**
		 * The list of the iterator is referenced.
		 */
    public var list : DLinkedList;
    
    /**
		 * Initializes a new DListIterator instance pointing to a given node.
		 * Usually created by invoking SLinkedList.getIterator().
		 * 
		 * @param list The linked list the iterator should use.
		 * @param node The iterator's initial node.
		 */
    public function new(list : DLinkedList, node : DListNode = null)
    {
        this.list = list;
        this.node = node;
    }
    
    /**
		 * Moves the iterator to the start of the list.
		 */
    public function start() : Void
    {
        node = list.head;
    }
    
    /**
		 * Returns the current node's data while
		 * moving the iterator forward by one position.
		 */
    public function next() : Dynamic
    {
        if (hasNext())
        {
            var obj : Dynamic = node.data;
            node = node.next;
            return obj;
        }
        return null;
    }
    
    /**
		 * Checks if the next node exists.
		 */
    public function hasNext() : Bool
    {
        return cast(node, Bool);
    }
    
    /**
		 * Read/writes the current node's data.
		 * 
		 * @return The data.
		 */
    private function get_data() : Dynamic
    {
        if (node != null)
        {
            return node.data;
        }
        return null;
    }
    
    private function set_data(obj : Dynamic) : Dynamic
    {
        node.data = obj;
        return obj;
    }
    
    /**
		 * Moves the iterator to the end of the list.
		 */
    public function end() : Void
    {
        node = list.tail;
    }
    
    /**
		 * Moves the iterator to the next node.
		 */
    public function forth() : Void
    {
        if (node != null)
        {
            node = node.next;
        }
    }
    
    /**
		 * Moves the iterator to the previous node.
		 */
    public function back() : Void
    {
        if (node != null)
        {
            node = node.prev;
        }
    }
    
    /**
		 * Checks if the current referenced node is valid.
		 * 
		 * @return True if the node exists, otherwise false.
		 */
    public function valid() : Bool
    {
        return cast(node, Bool);
    }
    
    /**
		 * Removes the node the iterator is
		 * pointing to.
		 */
    public function remove() : Void
    {
        list.remove(this);
    }
    
    /**
		 * Returns a string representing the current object.
		 */
    public function toString() : String
    {
        return "{DListIterator, data=" + ((node != null) ? node.data : "null") + "}";
    }
}
