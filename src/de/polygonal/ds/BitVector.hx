/**
 * Copyright (c) Michael Baczynski 2007
 * http://lab.polygonal.de/ds/
 *
 * This software is distributed under licence. Use of this software
 * implies agreement with all terms and conditions of the accompanying
 * software licence.
 */
package de.polygonal.ds;


/**
	 * A bitvector.
	 * 
	 * A bitvector is meant to condense bit values (or booleans) into
	 * an array as close as possible so that no space is wasted.
	 */
class BitVector
{
    public var bitCount(get, never) : Int;
    public var cellCount(get, never) : Int;

    private var _bits : Array<Dynamic>;
    private var _arrSize : Int;
    private var _bitSize : Int;
    
    /**
		 * Creates a bitvector with a given number of bits.
		 * Each cell holds a 31-bit signed integer.
		 * 
		 * @param bits The total number of bits.
		 */
    public function new(bits : Int)
    {
        _bits = [];
        _arrSize = 0;
        
        resize(bits);
    }
    
    /**
		 * The total number of bits.
		 */
    private function get_bitCount() : Int
    {
        return as3hx.Compat.parseInt(_arrSize * 31);
    }
    
    /**
		 * The total number of cells.
		 */
    private function get_cellCount() : Int
    {
        return _arrSize;
    }
    
    /**
		 * Gets a bit from a given index.
		 * 
		 * @param index The index of the bit.
		 */
    public function getBit(index : Int) : Int
    {
        var bit : Int = as3hx.Compat.parseInt(index % 31);
        return as3hx.Compat.parseInt((_bits[(index / 31) >> 0] & as3hx.Compat.parseInt(1 << bit)) >> bit);
    }
    
    /**
		 * Sets a bit at a given index.
		 * 
		 * @param index The index of the bit.
		 * @param b     The boolean flag to set.
		 */
    public function setBit(index : Int, b : Bool) : Void
    {
        var cell : Int = as3hx.Compat.parseInt(index / 31);
        var mask : Int = 1 << as3hx.Compat.parseInt(index % 31);
        _bits[cell] = (b) ? (_bits[cell] | mask) : (_bits[cell] & as3hx.Compat.parseInt(~mask));
    }
    
    /**
		 * Resizes the bitvector to an appropriate number of bits.
		 * 
		 * @param size The total number of bits.
		 */
    public function resize(size : Int) : Void
    {
        if (size == _bitSize)
        {
            return;
        }
        _bitSize = size;
        
        //convert the bit-size to integer-size
        if (size % 31 == 0)
        {
            size /= 31;
        }
        else
        {
            size = as3hx.Compat.parseInt((size / 31) + 1);
        }
        
        if (size < _arrSize)
        {
            _bits.splice(size, _bits.length);
            _arrSize = size;
        }
        else
        {
            _bits = _bits.concat(new Array<Dynamic>(size - _arrSize));
            _arrSize = _bits.length;
        }
    }
    
    /**
		 * Resets all bits to 0;
		 */
    public function clear() : Void
    {
        var k : Int = _bits.length;
        for (i in 0...k)
        {
            _bits[i] = 0;
        }
    }
    
    /**
		 * Sets each bit to 1.
		 */
    public function setAll() : Void
    {
        var k : Int = _bits.length;
        for (i in 0...k)
        {
            _bits[i] = as3hx.Compat.INT_MAX;
        }
    }
    
    /**
		 * Returns a string representing the current object.
		 */
    public function toString() : String
    {
        return "[BitVector, size=" + _bitSize + "]";
    }
}


