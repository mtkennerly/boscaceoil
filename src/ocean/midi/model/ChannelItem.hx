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
class ChannelItem extends MessageItem
{
    public var channel(get, set) : Int;
    public var command(get, set) : Int;
    public var data1(get, set) : Int;
    public var data2(get, set) : Dynamic;

    public var _channel : Int;
    public var _command : Int;
    public var _data1 : Int;
    public var _data2 : Dynamic;
    
    public function new()
    {
        super();
    }
    
    private function get_channel() : Int
    {
        return _channel;
    }
    
    private function set_channel(c : Int) : Int
    {
        _channel = c & 0x0F;
        return c;
    }
    
    private function get_command() : Int
    {
        return _command;
    }
    
    private function set_command(c : Int) : Int
    {
        _command = c & 0xF0;
        kind = _command;
        return c;
    }
    
    
    
    private function get_data1() : Int
    {
        return _data1;
    }
    
    private function set_data1(d : Int) : Int
    {
        _data1 = d;
        return d;
    }
    
    private function get_data2() : Dynamic
    {
        return _data2;
    }
    
    private function set_data2(d : Dynamic) : Dynamic
    {
        _data2 = d;
        return d;
    }
    
    override public function clone() : MessageItem
    {
        var item : ChannelItem = new ChannelItem();
        item.kind = this.kind;
        item.timeline = this.timeline;
        item.channel = this.channel;
        item.command = this.command;
        item.data1 = this.data1;
        item.data2 = this.data2;
        return item;
    }
}


