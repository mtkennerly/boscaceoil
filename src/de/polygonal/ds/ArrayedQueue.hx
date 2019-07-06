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
import de.polygonal.ds.ArrayedQueue;

/**
	 * An arrayed queue (circular queue).
	 * <p>A queue is a FIFO structure (First In, First Out).</p>
	 */
class ArrayedQueue implements Collection
{
    public var size(get, never) : Int;
    public var maxSize(get, never) : Int;

    private var _que : Array<Dynamic>;
    private var _size : Int;
    private var _divisor : Int;
    
    private var _count : Int;
    private var _front : Int;
    
    /**
		 * Initializes a queue object to match the given size.
		 * The size must be a power of two to use fast bitwise AND modulo. 
		 * 
		 * @param sizeShift The size exponent. (e.g. size is 1 << sizeShift eq. 2^sizeShift)
		 */
    public function new(sizeShift : Int)
    {
        if (sizeShift < 3)
        {
            sizeShift = 3;
        }
        _size = 1 << sizeShift;
        _divisor = as3hx.Compat.parseInt(_size - 1);
        clear();
    }
    
    /**
		 * Indicates the front item.
		 * 
		 * @return The front item.
		 */
    public function peek() : Dynamic
    {
        return _que[_front];
    }
    
    /**
		 * Enqueues some data.
		 * 
		 * @param  obj The data.
		 * @return True if operation succeeded, otherwise false (queue is full).
		 */
    public function enqueue(obj : Dynamic) : Bool
    {
        if (_size != _count)
        {
            _que[as3hx.Compat.parseInt(_count++ + _front) & _divisor] = obj;
            return true;
        }
        return false;
    }
    
    /**
		 * Dequeues and returns the front item.
		 * 
		 * @return The front item or null if the queue is empty.
		 */
    public function dequeue() : Dynamic
    {
        if (_count > 0)
        {
            var data : Dynamic = _que[_front++];
            if (_front == _size)
            {
                _front = 0;
            }
            _count--;
            return data;
        }
        return null;
    }
    
    /**
		 * Deletes the last dequeued item to free it
		 * for the garbage collector. Use only directly
		 * after calling the dequeue() function.
		 */
    public function dispose() : Void
    {
        if (_front == 0)
        {
            _que[_size - 1] = null;
        }
        else
        {
            _que[_front - 1] = null;
        }
    }
    
    /**
		 * Reads an item relative to the front index.
		 * 
		 * @param i The index of the item.
		 * @return The item at the given relative index.
		 */
    public function getAt(i : Int) : Dynamic
    {
        if (i >= _count)
        {
            return null;
        }
        return _que[as3hx.Compat.parseInt(i + _front) & _divisor];
    }
    
    /**
		 * Writes an item relative to the front index.
		 * 
		 * @param i   The index of the item.
		 * @param obj The data.
		 */
    public function setAt(i : Int, obj : Dynamic) : Void
    {
        if (i >= _count)
        {
            return;
        }
        _que[as3hx.Compat.parseInt(i + _front) & _divisor] = obj;
    }
    
    /**
		 * Checks if a given item exists.
		 * 
		 * @return True if the item is found, otherwise false.
		 */
    public function contains(obj : Dynamic) : Bool
    {
        for (i in 0..._count)
        {
            if (_que[as3hx.Compat.parseInt(i + _front) & _divisor] == obj)
            {
                return true;
            }
        }
        return false;
    }
    
    /**
		 * Clears all elements.
		 */
    public function clear() : Void
    {
        _que = new Array<Dynamic>(_size);
        _front = _count = 0;
    }
    
    /**
		 * Creates a new iterator pointing to the front of the queue.
		 */
    public function getIterator() : Iterator
    {
        return new ArrayedQueueIterator(this);
    }
    
    /**
		 * The total number of items in the queue.
		 */
    private function get_size() : Int
    {
        return _count;
    }
    
    /**
		 * Checks if the queue is empty.
		 */
    public function isEmpty() : Bool
    {
        return _count == 0;
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
        var a : Array<Dynamic> = new Array<Dynamic>(_count);
        for (i in 0..._count)
        {
            a[i] = _que[as3hx.Compat.parseInt(i + _front) & _divisor];
        }
        return a;
    }
    
    /**
		 * Returns a string representing the current object.
		 */
    public function toString() : String
    {
        return "[ArrayedQueue, size=" + size + "]";
    }
    
    /**
		 * Prints out all elements in the queue (for debug/demo purposes).
		 */
    public function dump() : String
    {
        var s : String = "[ArrayedQueue]\n";
        
        s += "\t" + getAt(i) + " -> front\n";
        for (i in 1..._count)
        {
            s += "\t" + getAt(i) + "\n";
        }
        
        return s;
    }
}



class ArrayedQueueIterator implements Iterator
{
    public var data(get, set) : Dynamic;

    private var _que : ArrayedQueue;
    private var _cursor : Int;
    
    @:allow(de.polygonal.ds)
    private function new(que : ArrayedQueue)
    {
        _que = que;
        _cursor = 0;
    }
    
    private function get_data() : Dynamic
    {
        return _que.getAt(_cursor);
    }
    
    private function set_data(obj : Dynamic) : Dynamic
    {
        _que.setAt(_cursor, obj);
        return obj;
    }
    
    public function start() : Void
    {
        _cursor = 0;
    }
    
    public function hasNext() : Bool
    {
        return _cursor < _que.size;
    }
    
    public function next() : Dynamic
    {
        if (_cursor < _que.size)
        {
            return _que.getAt(_cursor++);
        }
        return null;
    }
}