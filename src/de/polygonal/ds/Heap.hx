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
import de.polygonal.ds.Collection;
import de.polygonal.ds.Iterator;

import de.polygonal.ds.Heap;

/**
	 * A heap.
	 * 
	 * <p>A heap is a special kind of binary tree in which every node is
	 * greater than all of its children. The implementation is based on an arrayed binary tree.
	 * It can be used as an efficient priority queue.</p>
	 * @see PriorityQueue
	 */
class Heap implements Collection
{
    public var front(get, never) : Dynamic;
    public var size(get, never) : Int;
    public var maxSize(get, never) : Int;

    public var _heap : Array<Dynamic>;
    
    private var _size : Int;
    private var _count : Int;
    private var _compare : Function;
    
    /**
		 * Initializes a new heap.
		 */
    public function new(size : Int, compare : Function = null)
    {
        _heap = new Array<Dynamic>(_size = as3hx.Compat.parseInt(size + 1));
        _count = 0;
        
        if (compare == null)
        {
            _compare = function(a : Int, b : Int) : Int
                    {
                        return as3hx.Compat.parseInt(a - b);
                    };
        }
        else
        {
            _compare = compare;
        }
    }
    
    /**
		 * The heap's front item.
		 */
    private function get_front() : Dynamic
    {
        return _heap[1];
    }
    
    /**
		 * Enqueues some data.
		 * 
		 * @param obj The data.
		 */
    public function enqueue(obj : Dynamic) : Void
    {
        _heap[++_count] = obj;
        walkUp(_count);
    }
    
    /**
		 * Dequeues the front item.
		 */
    public function dequeue() : Void
    {
        if (_count >= 1)
        {
            _heap[1] = _heap[_count];
            ;
            
            walkDown(1);
            _count--;
        }
    }
    
    /**
		 * Checks if a given item exists.
		 * 
		 * @return True if the item is found, otherwise false.
		 */
    public function contains(obj : Dynamic) : Bool
    {
        for (i in 1..._count + 1)
        {
            if (_heap[i] == obj)
            {
                return true;
            }
        }
        return false;
    }
    
    /**
		 * Clears all items.
		 */
    public function clear() : Void
    {
        _heap = new Array<Dynamic>(_size);
        _count = 0;
    }
    
    /**
		 * Returns an iterator object pointing to the front
		 * item.
		 * 
		 * @return An iterator object.
		 */
    public function getIterator() : Iterator
    {
        return new HeapIterator(this);
    }
    
    /**
		 * The total number of items in the heap.
		 */
    private function get_size() : Int
    {
        return _count;
    }
    
    /**
		 * Checks if the heap is empty.
		 */
    public function isEmpty() : Bool
    {
        return false;
    }
    
    /**
		 * The maximum allowed size of the queue.
		 */
    private function get_maxSize() : Int
    {
        return _size;
    }
    
    /**
		 * Converts the heap into an array.
		 * 
		 * @return An array containing all heap values.
		 */
    public function toArray() : Array<Dynamic>
    {
        return _heap.slice(1, _count);
    }
    
    private function walkUp(index : Int) : Void
    {
        var parent : Int = index >> 1;
        var tmp : Dynamic = _heap[index];
        while (parent > 0)
        {
            if (_compare(tmp, _heap[parent]) > 0)
            {
                _heap[index] = _heap[parent];
                index = parent;
                parent >>= 1;
            }
            else
            {
                break;
            }
        }
        _heap[index] = tmp;
    }
    
    private function walkDown(index : Int) : Void
    {
        var child : Int = index << 1;
        
        var tmp : Dynamic = _heap[index];
        var c : Dynamic;
        
        while (child < _count)
        {
            if (child < _count - 1)
            {
                if (_compare(_heap[child], _heap[child + 1]) < 0)
                {
                    child++;
                }
            }
            if (_compare(tmp, _heap[child]) < 0)
            {
                _heap[index] = _heap[child];
                index = child;
                child <<= 1;
            }
            else
            {
                break;
            }
        }
        _heap[index] = tmp;
    }
}



class HeapIterator implements Iterator
{
    public var data(get, set) : Dynamic;

    private var _values : Array<Dynamic>;
    private var _length : Int;
    private var _cursor : Int;
    
    @:allow(de.polygonal.ds)
    private function new(heap : Heap)
    {
        _values = heap.toArray();
        _length = _values.length;
        _cursor = 0;
    }
    
    private function get_data() : Dynamic
    {
        return _values[_cursor];
    }
    
    private function set_data(obj : Dynamic) : Dynamic
    {
        _values[_cursor] = obj;
        return obj;
    }
    
    public function start() : Void
    {
        _cursor = 0;
    }
    
    public function hasNext() : Bool
    {
        return _cursor < _length;
    }
    
    public function next() : Dynamic
    {
        return _values[_cursor++];
    }
}