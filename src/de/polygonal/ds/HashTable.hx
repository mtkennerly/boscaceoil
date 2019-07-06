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
import de.polygonal.ds.Iterator;

/**
	 * A hash table using linked overflow for resolving collisions.
	 */
class HashTable
{
    public var size(get, never) : Int;
    public var maxSize(get, never) : Int;

    /**
		 * A simple function for hashing strings.
		 */
    public static function hashString(s : String) : Int
    {
        var hash : Int = 0;
        var i : Int;
        var k : Int = s.length;
        for (i in 0...k)
        {
            hash += as3hx.Compat.parseInt((i + 1) * s.charCodeAt(i));
        }
        return hash;
    }
    
    /**
		 * A simple function for hashing integers.
		 */
    public static function hashInt(i : Int) : Int
    {
        return hashString(Std.string(i));
    }
    
    private var _table : Array<Dynamic>;
    private var _hash : Function;
    
    private var _size : Int;
    private var _divisor : Int;
    private var _count : Int;
    
    /**
		 * Initializes a hash table.
		 * 
		 * @param size The size of the hash table.
		 * @param hash A hashing function.
		 */
    public function new(size : Int, hash : Function = null)
    {
        _count = 0;
        
        _hash = ((hash == null)) ? function(key : Int) : Int
                {
                    return key;
                } : hash;
        _table = new Array<Dynamic>(_size = size);
        
        for (i in 0...size)
        {
            _table[i] = [];
        }
        
        _divisor = as3hx.Compat.parseInt(_size - 1);
    }
    
    /**
		 * Inserts a key/data couple into the table.
		 * 
		 * @param key The key.
		 * @param obj The data associated with the key.
		 */
    public function insert(key : Dynamic, obj : Dynamic) : Void
    {
        _table[_hash(key) & _divisor].push(new HashEntry(key, obj));
        _count++;
    }
    
    /**
		 * Finds the entry that is associated with the given key.
		 * 
		 * @param  key The key to search for.
		 * @return The data associated with the key or null if no matching
		 *         entry was found.
		 */
    public function find(key : Dynamic) : Dynamic
    {
        var list : Array<Dynamic> = _table[_hash(key) & _divisor];
        var k : Int = list.length;
        var entry : HashEntry;
        for (i in 0...k)
        {
            entry = list[i];
            if (entry.key == key)
            {
                return entry.data;
            }
        }
        return null;
    }
    
    /**
		 * Removes an entry based on a given key.
		 * 
		 * @param  key The entry's key.
		 * @return The data associated with the key or null if no matching
		 *         entry was found.
		 */
    public function remove(key : Dynamic) : Dynamic
    {
        var list : Array<Dynamic> = _table[_hash(key) & _divisor];
        var k : Int = list.length;
        for (i in 0...k)
        {
            var entry : HashEntry = list[i];
            if (entry.key == key)
            {
                list.splice(i, 1);
                return entry.data;
            }
        }
        return null;
    }
    
    /**
		 * Checks if a given item exists.
		 * 
		 * @return True if item exists, otherwise false.
		 */
    public function contains(obj : Dynamic) : Bool
    {
        var list : Array<Dynamic>;
        var k : Int = size;
        for (i in 0...k)
        {
            list = _table[i];
            var l : Int = list.length;
            
            for (j in 0...l)
            {
                if (list[j].data == obj)
                {
                    return true;
                }
            }
        }
        return false;
    }
    
    /**
		 * Iterator not supported (yet).
		 */
    public function getIterator() : Iterator
    {
        return new NullIterator();
    }
    
    /**
		 * Clears all elements.
		 */
    public function clear() : Void
    {
        _table = new Array<Dynamic>(_size);
        _count = 0;
    }
    
    /**
		 * The total number of items.
		 */
    private function get_size() : Int
    {
        return _count;
    }
    
    /**
		 * The maximum allowed size of the queue.
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
        var a : Array<Dynamic> = [];
        var list : Array<Dynamic>;
        var k : Int = size;
        for (i in 0...k)
        {
            list = _table[i];
            var l : Int = list.length;
            
            for (j in 0...l)
            {
                a.push(list[j]);
            }
        }
        return a;
    }
    
    /**
		 * Returns a string representing the current object.
		 */
    public function toString() : String
    {
        return "[HashTable, size=" + size + "]";
    }
    
    public function print() : String
    {
        var s : String = "HashTable:\n";
        for (i in 0..._size)
        {
            if (_table[i] != null)
            {
                s += "[" + i + "]" + "\n" + _table[i];
            }
        }
        return s;
    }
}


/**
 * Simple container class for storing a key/data couple.
 */
class HashEntry
{
    public var key : Int;
    
    public var data : Dynamic;
    
    @:allow(de.polygonal.ds)
    private function new(key : Int, data : Dynamic)
    {
        this.key = key;
        this.data = data;
    }
}


