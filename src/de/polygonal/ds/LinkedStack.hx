/**
 * Copyright (c) Michael Baczynski 2007
 * http://lab.polygonal.de/ds/
 *
 * This software is distributed under licence. Use of this software
 * implies agreement with all terms and conditions of the accompanying
 * software licence.
 */
package de.polygonal.ds;

import de.polygonal.ds.DLinkedList;

/**
	 * A linked stack.
	 * <p>A stack is a LIFO structure (Last In, First Out)</p>.
	 */
class LinkedStack
{
    public var size(get, never) : Int;

    private var _list : DLinkedList;
    
    /**
		 * Initializes a linked stack.
		 * You can pass an existing doubly linked list
		 * to provide stack-like access.
		 * 
		 * @param list An existing list to use as a stack.
		 */
    public function new(list : DLinkedList = null)
    {
        if (list == null)
        {
            _list = new DLinkedList();
        }
        else
        {
            _list = list;
        }
    }
    
    /**
		 * The total number of items in the stack.
		 */
    private function get_size() : Int
    {
        return _list.size;
    }
    
    /**
		 * Indicates the top item.
		 *
		 * @return The top item.
		 */
    public function peek() : Dynamic
    {
        if (_list.size > 0)
        {
            return _list.tail.data;
        }
        else
        {
            return null;
        }
    }
    
    /**
		 * Pushes data onto the stack.
		 * 
		 * @param obj The data to insert.
		 */
    public function push(obj : Dynamic) : Void
    {
        _list.append(obj);
    }
    
    /**
		 * Pops data from the stack.
		 * 
		 * @return The top item.
		 */
    public function pop() : Void
    {
        _list.removeTail();
    }
    
    /**
		 * Returns a string representing the current object.
		 */
    public function toString() : String
    {
        return "[LinkedStack > " + _list + "]";
    }
    
    /**
		 * Prints out all elements in the stack (for debug/demo purposes).
		 */
    public function dump() : String
    {
        return "LinkedStack:\n" + _list.dump();
    }
}
