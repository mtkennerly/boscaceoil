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
import de.polygonal.ds.Array3;

/**
	 * A three-dimensonal array build upon a single linear array.
	 */
class Array3 implements Collection
{
    public var width(get, set) : Int;
    public var height(get, set) : Int;
    public var depth(get, set) : Int;
    public var size(get, never) : Int;

    private var _a : Array<Dynamic>;
    private var _w : Int;private var _h : Int;private var _d : Int;
    
    /**
		 * Initializes a three-dimensional array to match the given width, height and depth.
		 * 
		 * width  - The width (number of columns).
		 * height - The height (number of rows).
		 * depth  - The depth (number of layers).
		 */
    public function new(w : Int, h : Int, d : Int)
    {
        _a = new Array<Dynamic>((_w = w) * (_h = h) * (_d = d));
    }
    
    /**
		 * Indicates the width (columns).
		 * If a new width is set, the structure is resized accordingly.
		 */
    private function get_width() : Int
    {
        return _w;
    }
    
    private function set_width(w : Int) : Int
    {
        resize(w, _h, _d);
        return w;
    }
    
    /**
		 * Indicates the height (rows).
		 * If a new height is set, the structure is resized accordingly.
		 */
    private function get_height() : Int
    {
        return _h;
    }
    
    private function set_height(h : Int) : Int
    {
        resize(_w, h, _d);
        return h;
    }
    
    /**
		 * Indicates the depth (layers).
		 * If a new depth is set, the structure is resized accordingly.
		 */
    private function get_depth() : Int
    {
        return _d;
    }
    
    private function set_depth(d : Int) : Int
    {
        resize(_w, _h, d);
        return d;
    }
    
    /**
		 * Sets each cell in the three-dimensional array to a given value.
		 * 
		 * @param obj The data.
		 */
    public function fill(obj : Dynamic) : Void
    {
        var k : Int = size;
        for (i in 0...k)
        {
            _a[i] = obj;
        }
    }
    
    /**
		 * Reads the data at the given x/y/z index.
		 * No boundary check is performed, so you have to
		 * make sure the x, y and z index does not exceed the
		 * width, height or depth of the structure.
		 *
		 * @param x The x index.
		 * @param y The y index.
		 * @param z The z index.
		 */
    public function get(x : Int, y : Int, z : Int) : Dynamic
    {
        return _a[(z * _w * _h) + (y * _w) + x];
    }
    
    /**
		 * Writes data into the cell at the given x/y/z index.
		 * No boundary check is performed, so you have to
		 * make sure the x, y and z index does not exceed the
		 * width, height or depth of the structure.
		 * 
		 * @param x   The x index.
		 * @param y   The y index.
		 * @param z   The z index.
		 * @param obj The data to store.
		 */
    public function set(x : Int, y : Int, z : Int, obj : Dynamic) : Void
    {
        _a[(z * _w * _h) + (y * _w) + x] = obj;
    }
    
    /**
		 * Resizes the array to match the given width, height and depth
		 * while preserving existing values.
		 * 
		 * @param w The new width (columns)
		 * @param h The new height (rows)
		 * @param d The new depth (layers)
		 */
    public function resize(w : Int, h : Int, d : Int) : Void
    {
        var tmp : Array<Dynamic> = _a.copy();
        
        as3hx.Compat.setArrayLength(_a, 0);
        as3hx.Compat.setArrayLength(_a, w * h * d);
        
        if (_a.length == 0)
        {
            return;
        }
        
        var xMin : Int = (w < _w) ? w : _w;
        var yMin : Int = (h < _h) ? h : _h;
        var zMin : Int = (d < _d) ? d : _d;
        
        var x : Int;
        var y : Int;
        var z : Int;
        var t1 : Int;
        var t2 : Int;
        var t3 : Int;
        var t4 : Int;
        
        for (z in 0...zMin)
        {
            t1 = as3hx.Compat.parseInt(z * w * h);
            t2 = as3hx.Compat.parseInt(z * _w * _h);
            
            for (y in 0...yMin)
            {
                t3 = as3hx.Compat.parseInt(y * w);
                t4 = as3hx.Compat.parseInt(y * _w);
                
                for (x in 0...xMin)
                {
                    _a[t1 + t3 + x] = tmp[t2 + t4 + x];
                }
            }
        }
        
        _w = w;
        _h = h;
        _d = d;
    }
    
    /**
		 * Checks if a given item exists.
		 * 
		 * @return True if the item is found, otherwise false.
		 */
    public function contains(obj : Dynamic) : Bool
    {
        var k : Int = size;
        for (i in 0...k)
        {
            if (_a[i] == obj)
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
        _a = new Array<Dynamic>(size);
    }
    
    /**
		 * Initializes an iterator object pointing to the
		 * first item (0, 0) in the first layer.
		 */
    public function getIterator() : Iterator
    {
        return new Array3Iterator(this);
    }
    
    /**
		 * The total number of cells.
		 */
    private function get_size() : Int
    {
        return as3hx.Compat.parseInt(_w * _h * _d);
    }
    
    /**
		 * Checks if the 3d array is empty.
		 */
    public function isEmpty() : Bool
    {
        return false;
    }
    
    
    /**
		 * Converts the structure into an array.
		 * 
		 * @return An array.
		 */
    public function toArray() : Array<Dynamic>
    {
        var a : Array<Dynamic> = _a.copy();
        
        var k : Int = size;
        if (a.length > k)
        {
            as3hx.Compat.setArrayLength(a, k);
        }
        return a;
    }
    
    /**
		 * Returns a string representing the current object.
		 */
    public function toString() : String
    {
        return "[Array3, size=" + size + "]";
    }
}



class Array3Iterator implements Iterator
{
    public var data(get, set) : Dynamic;

    private var _values : Array<Dynamic>;
    private var _length : Int;
    private var _cursor : Int;
    
    @:allow(de.polygonal.ds)
    private function new(a3 : Array3)
    {
        _values = a3.toArray();
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