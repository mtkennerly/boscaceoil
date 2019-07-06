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

import flash.utils.ByteArray;
import ocean.midi.MidiEnum;

/**
	 */
class SysxItem extends MessageItem
{
    public var size(get, never) : Int;
    public var data(get, set) : ByteArray;

    private var _data : ByteArray;
    public function new()
    {
        super();
        this.kind = MidiEnum.SYSTEM_EXCLUSIVE;
        _data = new ByteArray();
    }
    private function get_size() : Int
    {
        if (_data != null)
        {
            return _data.length;
        }
        else
        {
            return 0;
        }
    }
    private function get_data() : ByteArray
    {
        _data.position = 0;
        return _data;
    }
    private function set_data(d : ByteArray) : ByteArray
    {
        _data.position = 0;
        _data.length = 0;
        _data.writeBytes(d);
        return d;
    }
    override public function clone() : MessageItem
    {
        var item : SysxItem = new SysxItem();
        item.timeline = this.timeline;
        item.data = this.data;
        return item;
    }
}
