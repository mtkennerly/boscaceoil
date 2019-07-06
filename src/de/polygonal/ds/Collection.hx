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
	 * A 'java-style' collection interface.
	 */
interface Collection
{
    
    /**
		 * The total number of items.
		 * 
		 * @return The size.
		 */
    var size(get, never) : Int;

    /**
		 * Searches the collection for a matching item.
		 * 
		 * @return True if the item exists, otherwise false.
		 */
    function contains(obj : Dynamic) : Bool
    ;
    /**
		 * Clears all items.
		 */
    function clear() : Void
    ;
    /**
		 * Initializes an iterator object pointing
		 * to the first item in the collection.
		 *
		 * @return An iterator object.
		 */
    function getIterator() : Iterator
    ;
    
    /**
		 * Checks if the collection is empty.
		 * 
		 * @return True if empty, otherwise false.
		 */
    function isEmpty() : Bool
    ;
    /**
		 * Converts the collection into an array.
		 * 
		 * @return An array.
		 */
    function toArray() : Array<Dynamic>
    ;
}


