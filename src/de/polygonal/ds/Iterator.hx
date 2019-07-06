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
	 * A 'java-style' iterator interface.
	 */
interface Iterator
{
    
    /**
		 * Grants access to the current item being
		 * referenced by the iterator. This provides
		 * a quick way to read or write the current data.
		 */
    var data(get, set) : Dynamic;

    /**
		 * Retrieves the current item and moves
		 * the iterator to the next item in the sequence.
		 */
    function next() : Dynamic
    ;
    /**
		 * Checks if the next item exists.
		 * 
		 * @return True if a next item exists, otherwise false.
		 */
    function hasNext() : Bool
    ;
    /**
		 * Moves the iterator to the first item
		 * in the sequence.
		 */
    function start() : Void
    ;
}


