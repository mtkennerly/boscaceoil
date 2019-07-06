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

import openfl.utils.ByteArray;
import ocean.midi.MidiEnum;

/**
	 * 
	 */
class MetaItem extends MessageItem
{
    public var text(get, set) : ByteArray;
    public var type(get, set) : Int;
    public var metaName(get, never) : String;
    public var size(get, never) : Int;

    public var _text : ByteArray;
    public var _type : Int;
    
    public function new()
    {
        super();
        //defaulte meta item is a end of track
        _text = new ByteArray();
        _type = MidiEnum.END_OF_TRK;
        this.kind = MidiEnum.META;
    }
    private function get_text() : ByteArray
    {
        _text.position = 0;
        return _text;
    }
    
    private function set_text(t : ByteArray) : ByteArray
    {
        _text.position = 0;
        _text.length = 0;
        _text.writeBytes(t);
        return t;
    }
    
    private function get_type() : Int
    {
        return _type;
    }
    
    private function set_type(t : Int) : Int
    {
        _type = t;
        return t;
    }
    private function get_metaName() : String
    {
        return MidiEnum.getMessageName(type);
    }
    private function get_size() : Int
    {
        if (_text != null)
        {
            return _text.length;
        }
        else
        {
            return 0;
        }
    }
    
    override public function clone() : MessageItem
    {
        var item : MetaItem = new MetaItem();
        item.kind = this.kind;
        item.timeline = this.timeline;
        item.text = this.text;
        item.type = this.type;
        return item;
    }
}


