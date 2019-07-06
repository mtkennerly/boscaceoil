  /**
 * Copyright (c) Michael Baczynski 2007
 * http://lab.polygonal.de/ds/
 *
 * This software is distributed under licence. Use of this software
 * implies agreement with all terms and conditions of the accompanying
 * software licence.
 */  
package de.polygonal.ds;

import de.polygonal.ds.Collection;
import de.polygonal.ds.Iterator;
import de.polygonal.ds.ArrayedStack;

/**
	* An arrayed stack.
	* <p>A stack is a LIFO structure (Last In, First Out).</p>
	*/
class ArrayedStack implements Collection
{
    public var size(get, never) : Int;
    public var maxSize(get, never) : Int;

    private var _stack : Array<Dynamic>;
    private var _size : Int;
    private var _top : Int;
    
    /**
		 * Initializes a stack to match the given size.
		 * 
		 * @param size The total number of elements the stack can store.
		 */
    public function new(size : Int)
    {
        _size = size;
        clear();
    }
    
    /**
		 * Indicates the top item.
		 *
		 * @return The top item.
		 */
    public function peek() : Dynamic
    {
        return _stack[_top - 1];
    }
    
    /**
		 * Pushes data onto the stack.
		 * 
		 * @param obj The data.
		 */
    public function push(obj : Dynamic) : Bool
    {
        if (_size != _top)
        {
            _stack[_top++] = obj;
            return true;
        }
        return false;
    }
    
    /**
		 * Pops data from the stack.
		 * 
		 * @return The top item.
		 */
    public function pop() : Void
    {
        if (_top > 0)
        {
            _top--;
        }
    }
    
    /**
		 * Reads an item at a given index.
		 * 
		 * @param i The index.
		 * @return The item at the given index.
		 */
    public function getAt(i : Int) : Dynamic
    {
        if (i >= _top)
        {
            return null;
        }
        return _stack[i];
    }
    
    /**
		 * Writes an item at a given index.
		 * 
		 * @param i   The index.
		 * @param obj The data.
		 */
    public function setAt(i : Int, obj : Dynamic) : Void
    {
        if (i >= _top)
        {
            return;
        }
        _stack[i] = obj;
    }
    
    /**
		 * Checks if a given item exists.
		 * 
		 * @return True if the item is found, otherwise false.
		 */
    public function contains(obj : Dynamic) : Bool
    {
        for (i in 0..._top)
        {
            if (_stack[i] == obj)
            {
                return true;
            }
        }
        return false;
    }
    
    /**
		 * Clears the stack.
		 */
    public function clear() : Void
    {
        _stack = new Array<Dynamic>(_size);
        _top = 0;
    }
    
    /**
		 * Creates a new iterator pointing to the top item.
		 */
    public function getIterator() : Iterator
    {
        return new ArrayedStackIterator(this);
    }
    
    /**
		 * The total number of items in the stack.
		 */
    private function get_size() : Int
    {
        return _top;
    }
    
    /**
		 * Checks if the stack is empty.
		 */
    public function isEmpty() : Bool
    {
        return _size == 0;
    }
    
    /**
		 * The maximum allowed size.
		 */
    private function get_maxSize() : Int
    {
        return _size;
    }
    
    /**
		 * Converts the structure into an array.
		 * 
		 * @return An array.
		 */
    public function toArray() : Array<Dynamic>
    {
        return _stack.copy();
    }
    
    /**
		 * Returns a string representing the current object.
		 */
    public function toString() : String
    {
        return "[ArrayedStack, size= " + _top + "]";
    }
    
    /**
		 * Prints out all elements in the queue (for debug/demo purposes).
		 */
    public function dump() : String
    {
        var s : String = "[ArrayedStack]";
        if (_top == 0)
        {
            return s;
        }
        
        var k : Int = as3hx.Compat.parseInt(_top - 1);
        s += "\n\t" + _stack[k--] + " -> front\n";
        var i : Int = k;
        while (i >= 0)
        {
            s += "\t" + _stack[i] + "\n";
            i--;
        }
        return s;
    }
}



class ArrayedStackIterator implements Iterator
{
    public var data(get, set) : Dynamic;

    private var _stack : ArrayedStack;
    private var _cursor : Int;
    
    @:allow(de.polygonal.ds)
    private function new(stack : ArrayedStack)
    {
        _stack = stack;
        start();
    }
    
    private function get_data() : Dynamic
    {
        return _stack.getAt(_cursor);
    }
    
    private function set_data(obj : Dynamic) : Dynamic
    {
        _stack.setAt(_cursor, obj);
        return obj;
    }
    
    public function start() : Void
    {
        _cursor = as3hx.Compat.parseInt(_stack.size - 1);
    }
    
    public function hasNext() : Bool
    {
        return _cursor >= 0;
    }
    
    public function next() : Dynamic
    {
        if (_cursor >= 0)
        {
            return _stack.getAt(_cursor--);
        }
        return null;
    }
}