/**
 * Copyright (c) Michael Baczynski 2007
 * http://lab.polygonal.de/ds/
 *
 * This software is distributed under licence. Use of this software
 * implies agreement with all terms and conditions of the accompanying
 * software licence.
 */
package de.polygonal.ds;

import openfl.utils.Dictionary;
import de.polygonal.ds.Collection;
import de.polygonal.ds.Iterator;
import de.polygonal.ds.PriorityQueue;

/**
	 * A priority queue.
	 * 
	 * <p>The priority queue is based on the heap structure and
	 * manages prioritized data.</p>
	 */
class PriorityQueue implements Collection
{
    public var front(get, never) : Prioritizable;
    public var size(get, never) : Int;
    public var maxSize(get, never) : Int;

    private var _heap : Array<Dynamic>;
    private var _size : Int;
    private var _count : Int;
    private var _posLookup : Dictionary;
    
    /**
		 * Initializes a priority queue with a given size.
		 * 
		 * @param size The size of the priority queue.
		 */
    public function new(size : Int)
    {
        _heap = new Array<Dynamic>(_size = as3hx.Compat.parseInt(size + 1));
        _posLookup = new Dictionary(true);
        _count = 0;
    }
    
    /**
		 * The priority queue's front item.
		 */
    private function get_front() : Prioritizable
    {
        return _heap[1];
    }
    
    /**
		 * Enqueues a prioritized object.
		 * 
		 * @param obj The prioritized data.
		 */
    public function enqueue(obj : Prioritizable) : Void
    {
        _count++;
        _heap[_count] = obj;
        Reflect.setField(_posLookup, Std.string(obj), _count);
        walkUp(_count);
    }
    
    /**
		 * Dequeues the front item, which is the item
		 * with the highest priority.
		 */
    public function dequeue() : Void
    {
        if (_count >= 1)
        {
            _posLookup.remove(null);
            
            _heap[1] = _heap[_count];
            walkDown(1);
            ;
            _count--;
        }
    }
    
    /**
		 * Reprioritizes an item.
		 * 
		 * @param obj         The object whose priority is changed.
		 * @param newPriority The new priority.
		 * @return True if the repriorization succeeded, otherwise false.
		 */
    public function reprioritize(obj : Prioritizable, newPriority : Int) : Bool
    {
        if (Reflect.field(_posLookup, Std.string(obj)) == null)
        {
            return false;
        }
        
        var oldPriority : Int = obj.priority;
        
        //App.tr("old priority=", obj.priority);
        
        obj.priority = newPriority;
        
        //App.tr("new priority=", obj.priority);
        
        var pos : Int = Reflect.field(_posLookup, Std.string(obj));
        
        //App.tr("current pos=", pos);
        
        //App.tr("now ", newPriority > p ? "Walkup" : "WalkDown");
        
        (newPriority > oldPriority) ? walkUp(pos) : walkDown(pos);
        
        return true;
    }
    
    /**
		 * Removes an item.
		 * 
		 * @param obj The object to remove.
		 * @return True if removal succeeded, otherwise false.
		 */
    public function remove(obj : Prioritizable) : Bool
    {
        if (Reflect.field(_posLookup, Std.string(obj)) == null)
        {
            return false;
        }
        
        var pos : Int = Reflect.field(_posLookup, Std.string(obj));
        _posLookup.remove(obj);
        
        _heap[pos] = _heap[_count];
        ;
        
        walkDown(pos);
        _count--;
        
        return true;
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
        _posLookup = new Dictionary(true);
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
        return new PriorityQueueIterator(this);
    }
    
    /**
		 * The total number of items in the priority queue.
		 */
    private function get_size() : Int
    {
        return _count;
    }
    
    /**
		 * Checks if the priority queue is empty.
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
		 * Converts the priority queue into an array.
		 * 
		 * @return An array containing all values.
		 */
    public function toArray() : Array<Dynamic>
    {
        return _heap.slice(1, _count);
    }
    
    private function walkUp(index : Int) : Void
    {
        var parent : Int = index >> 1;
        var parentObj : Prioritizable;
        
        var tmp : Prioritizable = _heap[index];
        var p : Int = tmp.priority;
        
        while (parent > 0)
        {
            parentObj = _heap[parent];
            
            if (p - parentObj.priority > 0)
            {
                _heap[index] = parentObj;
                Reflect.setField(_posLookup, Std.string(parentObj), index);
                
                index = parent;
                parent >>= 1;
            }
            else
            {
                break;
            }
        }
        
        _heap[index] = tmp;
        Reflect.setField(_posLookup, Std.string(tmp), index);
    }
    
    private function walkDown(index : Int) : Void
    {
        var child : Int = index << 1;
        var childObj : Prioritizable;
        
        var tmp : Prioritizable = _heap[index];
        var p : Int = tmp.priority;
        
        while (child < _count)
        {
            if (child < _count - 1)
            {
                if (_heap[child].priority - _heap[child + 1].priority < 0)
                {
                    child++;
                }
            }
            
            childObj = _heap[child];
            
            if (p - childObj.priority < 0)
            {
                _heap[index] = childObj;
                Reflect.setField(_posLookup, Std.string(childObj), child);
                
                index = child;
                child <<= 1;
            }
            else
            {
                break;
            }
        }
        _heap[index] = tmp;
        Reflect.setField(_posLookup, Std.string(tmp), index);
    }
}



class PriorityQueueIterator implements Iterator
{
    public var data(get, set) : Dynamic;

    private var _values : Array<Dynamic>;
    private var _length : Int;
    private var _cursor : Int;
    
    @:allow(de.polygonal.ds)
    private function new(pq : PriorityQueue)
    {
        _values = pq.toArray();
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