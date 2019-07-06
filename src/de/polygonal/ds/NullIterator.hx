/**
 * Copyright (c) Michael Baczynski 2007
 * http://lab.polygonal.de/ds/
 *
 * This software is distributed under licence. Use of this software
 * implies agreement with all terms and conditions of the accompanying
 * software licence.
 */
package de.polygonal.ds;

import de.polygonal.ds.Iterator;

/**
	 * An do-nothing iterator for structures that don't support iterators.
	 */
class NullIterator implements Iterator
{
    public var data(get, set) : Dynamic;

    public function start() : Void
    {
    }
    
    public function next() : Dynamic
    {
        return null;
    }
    
    public function hasNext() : Bool
    {
        return false;
    }
    
    private function get_data() : Dynamic
    {
        return null;
    }
    
    private function set_data(obj : Dynamic) : Dynamic
    {
        return obj;
    }

    public function new()
    {
    }
}


