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
import de.polygonal.ds.Array2;

/**
	 * A two-dimensonal array built upon a single linear array.
	 */
class Array2 implements Collection
{
    public var width(get, set) : Int;
    public var height(get, set) : Int;
    public var size(get, never) : Int;

    private var _a : Array<Dynamic>;
    private var _w : Int;private var _h : Int;
    
    /**
		 * Initializes a two-dimensional array to match the given width and height.
		 * 
		 * @param w The width  (number of colums).
		 * @param h The height (number of rows).
		 */
    public function new(width : Int, height : Int)
    {
        _a = new Array<Dynamic>((_w = width) * (_h = height));
        fill(null);
    }
    
    /**
		 * Indicates the width (colums).
		 * If a new width is set, the two-dimensional array is resized accordingly.
		 */
    private function get_width() : Int
    {
        return _w;
    }
    
    private function set_width(w : Int) : Int
    {
        resize(w, _h);
        return w;
    }
    
    /**
		 * Indicates the height (rows).
		 * If a new height is set, the two-dimensional array is resized accordingly.
		 */
    private function get_height() : Int
    {
        return _h;
    }
    
    private function set_height(h : Int) : Int
    {
        resize(_w, h);
        return h;
    }
    
    /**
		 * Sets each cells in the two-dimensional array to a given value.
		 * 
		 * @param item The item to be written into each cell.
		 */
    public function fill(item : Dynamic) : Void
    {
        var k : Int = as3hx.Compat.parseInt(_w * _h);
        for (i in 0...k)
        {
            _a[i] = item;
        }
    }
    
    /**
		 * Reads the value at the given x/y index.
		 * No boundary check is performed, so you have to
		 * make sure that the input coordinates do not exceed
		 * the width or height of the two-dimensional array.
		 *
		 * @param x The x index.
		 * @param y The y index.
		 */
    public function get(x : Int, y : Int) : Dynamic
    {
        return _a[y * _w + x];
    }
    
    /**
		 * Writes data into the cell at the given x/y index.
		 * No boundary check is performed, so you have to
		 * make sure that the input coordinates do not exceed
		 * the width or height of the two-dimensional array.
		 *
		 * @param x The x index.
		 * @param y The y index.
		 * @param obj The item to be written into the cell.
		 */
    public function set(x : Int, y : Int, obj : Dynamic) : Void
    {
        _a[y * _w + x] = obj;
    }
    
    /**
		 * Resizes the array to match the given width and height
		 * while preserving existing values.
		 * 
		 * @param w The new width (cols)
		 * @param h The new height (rows)
		 */
    public function resize(w : Int, h : Int) : Void
    {
        if (w <= 0)
        {
            w = 1;
        }
        if (h <= 0)
        {
            h = 1;
        }
        
        var copy : Array<Dynamic> = _a.copy();
        
        as3hx.Compat.setArrayLength(_a, 0);
        as3hx.Compat.setArrayLength(_a, w * h);
        
        var minx : Int = (w < _w) ? w : _w;
        var miny : Int = (h < _h) ? h : _h;
        
        var x : Int;
        var y : Int;
        var t1 : Int;
        var t2 : Int;
        for (y in 0...miny)
        {
            t1 = as3hx.Compat.parseInt(y * w);
            t2 = as3hx.Compat.parseInt(y * _w);
            
            for (x in 0...minx)
            {
                _a[t1 + x] = copy[t2 + x];
            }
        }
        
        _w = w;
        _h = h;
    }
    
    /**
		 * Extracts the row at the given index.
		 * 
		 * @return An array storing the values of the row.
		 */
    public function getRow(y : Int) : Array<Dynamic>
    {
        var offset : Int = as3hx.Compat.parseInt(y * _w);
        return _a.slice(offset, offset + _w);
    }
    
    /**
		 * Extracts the colum at the given index.
		 * 
		 * @return An array storing the values of the column.
		 */
    public function getCol(x : Int) : Array<Dynamic>
    {
        var t : Array<Dynamic> = [];
        for (i in 0..._h)
        {
            t[i] = _a[i * _w + x];
        }
        return t;
    }
    
    /**
		 * Shifts all columns by one column to the left.
		 * Columns are wrapped, so the column at index 0 is
		 * not lost but appended to the rightmost column.
		 */
    public function shiftLeft() : Void
    {
        if (_w == 1)
        {
            return;
        }
        
        var j : Int = as3hx.Compat.parseInt(_w - 1);
        var k : Int;
        for (i in 0..._h)
        {
            k = as3hx.Compat.parseInt(i * _w + j);
            as3hx.Compat.arraySplice(_a, k, 0, [_a.splice(k - j, 1)]);
        }
    }
    
    /**
		 * Shifts all columns by one column to the right.
		 * Columns are wrapped, so the column at the last index is
		 * not lost but appended to the leftmost column.
		 */
    public function shiftRight() : Void
    {
        if (_w == 1)
        {
            return;
        }
        
        var j : Int = as3hx.Compat.parseInt(_w - 1);
        var k : Int;
        for (i in 0..._h)
        {
            k = as3hx.Compat.parseInt(i * _w + j);
            as3hx.Compat.arraySplice(_a, k - j, 0, [_a.splice(k, 1)]);
        }
    }
    
    /**
		 * Shifts all rows up by one row.
		 * Rows are wrapped, so the first row is
		 * not lost but appended to bottommost row.
		 */
    public function shiftUp() : Void
    {
        if (_h == 1)
        {
            return;
        }
        
        _a = _a.concat(_a.slice(0, _w));
        _a.splice(0, _w);
    }
    
    /**
		 * Shifts all rows down by one row.
		 * Rows are wrapped, so the last row is
		 * not lost but appended to the topmost row.
		 */
    public function shiftDown() : Void
    {
        if (_h == 1)
        {
            return;
        }
        
        var offset : Int = as3hx.Compat.parseInt((_h - 1) * _w);
        _a = _a.slice(offset, offset + _w).concat(_a);
        _a.splice(_h * _w, _w);
    }
    
    /**
		 * Appends an array as a new row.
		 * If the given array is longer or shorter than the current width,
		 * it is truncated or widened to match the current dimensions.
		 *
		 * @param a The array to insert.
		 */
    public function appendRow(a : Array<Dynamic>) : Void
    {
        as3hx.Compat.setArrayLength(a, _w);
        _a = _a.concat(a);
        _h++;
    }
    
    /**
		 * Prepends an array as a new row.
		 * If the given array is longer or shorter than the current width,
		 * it is truncated or widened to match the current dimensions.
		 * 
		 * @param a The array to insert.
		 */
    public function prependRow(a : Array<Dynamic>) : Void
    {
        as3hx.Compat.setArrayLength(a, _w);
        _a = a.concat(_a);
        _h++;
    }
    
    /**
		 * Appends an array as a new column.
		 * If the given array is longer or shorter than the current height,
		 * it is truncated or widened to match the current dimensions.
		 * 
		 * @param a The array to insert.
		 */
    public function appendCol(a : Array<Dynamic>) : Void
    {
        as3hx.Compat.setArrayLength(a, _h);
        for (y in 0..._h)
        {
            as3hx.Compat.arraySplice(_a, y * _w + _w + y, 0, [a[y]]);
        }
        _w++;
    }
    
    /**
		 * Prepends an array as a new column.
		 * If the given array is longer or shorter than the current height,
		 * it is truncated or widened to match the current dimensions.
		 * 
		 * @param a - The array to insert.
		 */
    public function prependCol(a : Array<Dynamic>) : Void
    {
        as3hx.Compat.setArrayLength(a, _h);
        for (y in 0..._h)
        {
            as3hx.Compat.arraySplice(_a, y * _w + y, 0, [a[y]]);
        }
        _w++;
    }
    
    /**
		 * Flips rows with cols and vice versa.
		 * This is equivalent of rotating the array about 180 degrees.
		 */
    public function transpose() : Void
    {
        var a : Array<Dynamic> = _a.copy();
        for (y in 0..._h)
        {
            for (x in 0..._w)
            {
                _a[x * _w + y] = a[y * _w + x];
            }
        }
    }
    
    /**
		 * Checks if a given item exists.
		 * 
		 * @return True if the specified item is found, otherwise false.
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
		 * Initializes an iterator object
		 * pointing to the first value (0, 0).
		 */
    public function getIterator() : Iterator
    {
        return new Array2Iterator(this);
    }
    
    /**
		 * The total number of cells.
		 */
    private function get_size() : Int
    {
        return as3hx.Compat.parseInt(_w * _h);
    }
    
    /**
		 * Checks if the 2d array is empty.
		 */
    public function isEmpty() : Bool
    {
        return false;
    }
    
    /**
		 * Converts the structure into an array.
		 * 
		 * @return An array storing the data of this structure.
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
        return "[Array2, width=" + width + ", height=" + height + "]";
    }
    
    /**
		 * Prints all elements (for debug/demo purposes only).
		 */
    public function dump() : String
    {
        var s : String = "Array2\n{";
        var offset : Int;
        var value : Dynamic;
        for (y in 0..._h)
        {
            s += "\n" + "\t";
            offset = as3hx.Compat.parseInt(y * _w);
            for (x in 0..._w)
            {
                value = _a[offset + x];
                s += "[" + ((value != null) ? value : "?") + "]";
            }
        }
        s += "\n}";
        return s;
    }
}



class Array2Iterator implements Iterator
{
    public var data(get, set) : Dynamic;

    private var _a2 : Array2;
    private var _xCursor : Int;
    private var _yCursor : Int;
    
    @:allow(de.polygonal.ds)
    private function new(a2 : Array2)
    {
        _a2 = a2;
        _xCursor = _yCursor = 0;
    }
    
    private function get_data() : Dynamic
    {
        return _a2.get(_xCursor, _yCursor);
    }
    
    private function set_data(obj : Dynamic) : Dynamic
    {
        _a2.set(_xCursor, _yCursor, obj);
        return obj;
    }
    
    public function start() : Void
    {
        _xCursor = _yCursor = 0;
    }
    
    public function hasNext() : Bool
    {
        return (_yCursor * _a2.width + _xCursor < _a2.size);
    }
    
    public function next() : Dynamic
    {
        var item : Dynamic = data;
        
        if (++_xCursor == _a2.width)
        {
            _yCursor++;
            _xCursor = 0;
        }
        
        return item;
    }
}