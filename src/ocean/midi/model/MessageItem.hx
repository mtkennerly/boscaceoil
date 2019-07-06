/**
 * Copyright(C) 2008 Efishocean
 * 
 * This file is part of Midias.
 *
 * Midias is an ActionScript3 midi lib developed by Efishocean.
 * Midias was extracted from my project 'ocean' which purpose to 
 * impletement a commen audio formats libray. 
 * More infos might appear on my blog http://www.tan66.cn 
 * 
 * Midias is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Midias is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

package ocean.midi.model;


/**
	 */
class MessageItem
{
    public var kind(get, set) : Int;
    public var timeline(get, set) : Int;

    public var _timeline : Int;
    public var _kind : Int;
    /**
		 * @default true Means this is an active item while false means to be erased.
		 */
    public var mark : Bool;
    
    public function new()
    {
        mark = true;
    }
    
    private function set_kind(k : Int) : Int
    {
        _kind = k;
        return k;
    }
    
    private function get_kind() : Int
    {
        return _kind;
    }
    
    private function get_timeline() : Int
    {
        return _timeline;
    }
    
    private function set_timeline(t : Int) : Int
    {
        _timeline = t;
        return t;
    }
    
    public function clone() : MessageItem
    {
        var msgItem : MessageItem = new MessageItem();
        msgItem.kind = this.kind;
        msgItem.timeline = this.timeline;
        return msgItem;
    }
}


