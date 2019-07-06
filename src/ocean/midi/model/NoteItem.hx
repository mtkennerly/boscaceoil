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
class NoteItem extends MessageItem
{
    public var channel(get, set) : Int;
    public var pitch(get, set) : Int;
    public var pitchName(get, never) : String;
    public var duration(get, set) : Int;
    public var velocity(get, set) : Int;

    private var _pitch : Int;
    private var _velocity : Int;
    private var _duration : Int;
    private var _channel : Int;
    private static var _pitchName : Array<Dynamic> = ["C", "Db", "D", "Eb", "E", "F", "F#", "G", "G#", "A", "Bb", "B"];
    
    public function new(c : Int = 0, p : Int = 67, v : Int = 127, d : Int = 120, t : Int = 0)
    {
        super();
        _channel = c & 0x0F;
        _pitch = p & 0x7F;
        _velocity = v & 0x7F;
        _duration = d;
        
        _timeline = t;
    }
    
    private function get_channel() : Int
    {
        return _channel;
    }
    
    private function set_channel(c : Int) : Int
    {
        _channel = c;
        return c;
    }
    
    private function get_pitch() : Int
    {
        return _pitch;
    }
    
    private function get_pitchName() : String
    {
        var level : Int = as3hx.Compat.parseInt(_pitch / 12 >> 0);
        var str : String = _pitchName[_pitch % 12] + ((level != 0) ? level : "");
        return str;
    }
    
    private function set_pitch(p : Int) : Int
    {
        _pitch = p;
        return p;
    }
    
    private function get_duration() : Int
    {
        return _duration;
    }
    
    private function set_duration(d : Int) : Int
    {
        _duration = d;
        return d;
    }
    
    private function get_velocity() : Int
    {
        return _velocity;
    }
    
    private function set_velocity(v : Int) : Int
    {
        _velocity = v;
        return v;
    }
    
    override public function clone() : MessageItem
    {
        var item : NoteItem = new NoteItem();
        item.kind = this.kind;
        item.timeline = this.timeline;
        item.channel = this.channel;
        item.duration = this.duration;
        item.pitch = this.pitch;
        item.velocity = this.velocity;
        return item;
    }
}


