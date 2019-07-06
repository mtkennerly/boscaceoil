package de.polygonal.ds;

import flash.utils.Dictionary;
import de.polygonal.ds.Collection;
import de.polygonal.ds.Iterator;
import de.polygonal.ds.HashMap;

class HashMap implements Collection
{
    public var size(get, never) : Int;

    private var _keyMap : Dictionary;
    private var _objMap : Dictionary;
    private var _size : Int;
    
    /**
		 * Initializes a hash map, which maps
		 * keys to values. It cannot contain duplicate keys so
		 * each key can map to at most one value.
		 */
    public function new()
    {
        _keyMap = new Dictionary(true);
        _objMap = new Dictionary(true);
        _size = 0;
    }
    
    /**
		 * Inserts a key/data couple into the table.
		 * 
		 * @param key The key.
		 * @param obj The data associated with the key.
		 */
    public function insert(key : Dynamic, obj : Dynamic) : Bool
    {
        if (Reflect.field(_keyMap, Std.string(key)) != null)
        {
            return false;
        }
        ++_size;
        Reflect.setField(_objMap, Std.string(obj), key);
        Reflect.setField(_keyMap, Std.string(key), obj);
        return true;
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
        return Reflect.field(_keyMap, Std.string(key)) || null;
    }
    
    /**
		 * Finds the key that maps the given value.
		 * 
		 * @param  val The value which maps the sought-after key.
		 * @return The key mapping the given value or null if no matching
		 *         key was found.
		 */
    public function findKey(val : Dynamic) : Dynamic
    {
        return Reflect.field(_objMap, Std.string(val)) || null;
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
        var obj : Dynamic = Reflect.field(_keyMap, Std.string(key));
        
        if (obj != null)
        {
            --_size;
            _keyMap.remove(key);
            _objMap.remove(obj);
            return obj;
        }
        return null;
    }
    
    /**
		 * Checks if a key maps the given value.
		 * 
		 * @return True if value exists, otherwise false.
		 */
    public function contains(obj : Dynamic) : Bool
    {
        return (Reflect.field(_objMap, Std.string(obj)) != null) ? true : false;
    }
    
    /**
		 * Checks if a mapping exists for the given key.
		 * 
		 * @return True if key exists, otherwise false.
		 */
    public function containsKey(key : Dynamic) : Bool
    {
        return (Reflect.field(_keyMap, Std.string(key)) != null) ? true : false;
    }
    
    /**
		 * Creates an interator for traversing the values.
		 */
    public function getIterator() : Iterator
    {
        return new HashMapValueIterator(this);
    }
    
    /**
		 * Creates an interator for traversing the keys.
		 */
    public function getKeyIterator() : Iterator
    {
        return new HashMapKeyIterator(this);
    }
    
    /**
		 * Clears all elements.
		 */
    public function clear() : Void
    {
        _keyMap = new Dictionary(true);
        _objMap = new Dictionary(true);
        _size = 0;
    }
    
    /**
		 * The total number of items.
		 */
    private function get_size() : Int
    {
        return _size;
    }
    
    /**
		 * Checks if the map is empty.
		 * 
		 * @return True if empty, otherwise false.
		 */
    public function isEmpty() : Bool
    {
        return _size == 0;
    }
    
    /**
		 * Writes all values into an array.
		 * 
		 * @return An array.
		 */
    public function toArray() : Array<Dynamic>
    {
        var a : Array<Dynamic> = new Array<Dynamic>(_size);
        var j : Int = 0;
        for (i/* AS3HX WARNING could not determine type for var: i exp: EIdent(_keyMap) type: Dictionary */ in _keyMap)
        {
            a[j++] = i;
        }
        return a;
    }
    
    /**
		 * Writes all keys into an array.
		 * 
		 * @return An array.
		 */
    public function getKeySet() : Array<Dynamic>
    {
        var a : Array<Dynamic> = new Array<Dynamic>(_size);
        var j : Int = 0;
        for (i/* AS3HX WARNING could not determine type for var: i exp: EIdent(_objMap) type: Dictionary */ in _objMap)
        {
            a[j++] = i;
        }
        return a;
    }
    
    /**
		 * Returns a string representing the current object.
		 */
    public function toString() : String
    {
        return "[HashMap, size=" + size + "]";
    }
    
    /**
		 * Prints all elements (for debug/demo purposes only).
		 */
    public function dump() : String
    {
        var s : String = "HashMap:\n";
        for (i/* AS3HX WARNING could not determine type for var: i exp: EIdent(_objMap) type: Dictionary */ in _objMap)
        {
            s += "[key: " + i + " val:" + _keyMap[i] + "]\n";
        }
        return s;
    }
}



class HashMapValueIterator implements Iterator
{
    public var data(get, set) : Dynamic;

    private var _h : HashMap;
    private var _values : Array<Dynamic>;
    private var _cursor : Int;
    private var _size : Int;
    
    @:allow(de.polygonal.ds)
    private function new(h : HashMap)
    {
        _h = h;
        _values = h.toArray();
        _cursor = 0;
        _size = _h.size;
    }
    
    private function get_data() : Dynamic
    {
        return _values[_cursor];
    }
    
    private function set_data(obj : Dynamic) : Dynamic
    {
        var key : Dynamic = _h.findKey(_values[_cursor]);
        _h.remove(key);
        _h.insert(key, obj);
        return obj;
    }
    
    public function start() : Void
    {
        _cursor = 0;
    }
    
    public function hasNext() : Bool
    {
        return _cursor < _size;
    }
    
    public function next() : Dynamic
    {
        return _values[_cursor++];
    }
}

class HashMapKeyIterator implements Iterator
{
    public var data(get, set) : Dynamic;

    private var _h : HashMap;
    private var _keys : Array<Dynamic>;
    private var _cursor : Int;
    private var _size : Int;
    
    @:allow(de.polygonal.ds)
    private function new(h : HashMap)
    {
        _h = h;
        _keys = h.getKeySet();
        _cursor = 0;
        _size = _h.size;
    }
    
    private function get_data() : Dynamic
    {
        return _keys[_cursor];
    }
    
    private function set_data(obj : Dynamic) : Dynamic
    {
        var key : Dynamic = _keys[_cursor];
        var val : Dynamic = _h.find(key);
        _h.remove(key);
        _h.insert(obj, val);
        return obj;
    }
    
    public function start() : Void
    {
        _cursor = 0;
    }
    
    public function hasNext() : Bool
    {
        return _cursor < _size;
    }
    
    public function next() : Dynamic
    {
        return _keys[_cursor++];
    }
}