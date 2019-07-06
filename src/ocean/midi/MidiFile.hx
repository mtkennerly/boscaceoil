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
package ocean.midi;

import de.polygonal.ds.Iterator;
import ocean.midi.model.MetaItem;
import ocean.midi.model.ChannelItem;
import ocean.midi.model.MessageItem;
import ocean.midi.model.MessageList;
import flash.utils.ByteArray;
import ocean.midi.model.NoteItem;

/**
	 * This class can seralize and unseralize midi file. 
	 * Also provides methods for operating midi header block.
	 * @author Efishocean
	 * @version 1.0.1
	 * @link http://www.tan66.com
	 * @link http://www.tan66.cn
	 */
class MidiFile
{
    public var format(get, set) : Int;
    public var tracks(get, never) : Int;
    public var division(get, set) : Int;

    
    public static inline var DIV_120 : Int = 120;
    
    private static inline var MThd : Int = 0x4D546864;
    private static inline var HDRSIZE : Int = 0x00000006;
    
    /**
		* 16bits
		* 0x0000=sigle;  0x0001=multi syn; 0x0002=multi asyn;
		* Indicates the track format of midi
		*/
    private var _format : Int;
    
    /**
		* 16bits
		* Quantity of exist tracks plus one global track,
		*/
    private var _tracks : Int;
    
    /**
		* 16bits
		* Ticks per minute
		*/
    private var _division : Int;
    
    /**
		* Main track in midi file
		*/
    private var _mainTrack : MidiTrack;
    
    /**
		* track array including main track
		*/
    public var _trackArray : Array<Dynamic>;
    
    /**
		 * Midi track format, 0/1/2 are available.
		 */
    private function get_format() : Int
    {
        return as3hx.Compat.parseInt(_format & 0xFFFF);
    }
    
    /**
		 * @private
		 * @throws InvalidMidiError Shows error message: Midi track format only accept 0,1,2!
		 */
    private function set_format(f : Int) : Int
    {
        if (0 == f || 1 == f || 2 == f)
        {
            _format = f;
        }
        else
        {
            throw new InvalidMidiError("Midi track format only accept 0,1,2!");
        }
        return f;
    }
    
    /**
		 * Property indicates how many tracks in midi file.
		 */
    private function get_tracks() : Int
    {
        return as3hx.Compat.parseInt(_tracks & 0xFFFF);
    }
    
    /**
		 * Division of midi.
		 * @default 120
		 */
    private function get_division() : Int
    {
        return as3hx.Compat.parseInt(_division & 0xFFFF);
    }
    
    /**
		 * @private
		 * division setter
		 */
    private function set_division(d : Int) : Int
    {
        _division = d & 0xFFFF;
        return d;
    }
    
    /**
		* Loads midi file or initialize empty midi file for program.
		* @param file Loaded midi file in raw bytes.
		*/
    public function new(file : ByteArray = null)
    {
        _trackArray = new Array<Dynamic>();
        if (file != null)
        {
            input(file);
        }
        else
        {
            _format = 1;
            _tracks = 0;
            _division = DIV_120;
        }
    }
    
    /**
		* Inputs a fileStream to create message list. Stream will forward.
		* @param fileStream Midi file to loaded as stream.
		* @param separate Tries to separate single track to multi-tracks when 'format' is 0
		* with 'separate' set to true. 
		*/
    public function input(fileStream : ByteArray, separate : Bool = true) : Void
    //check MThd, the midi file header
    {
        
        if (fileStream.readInt() != MThd)
        {
            throw new InvalidMidiError("Midi header tag is incorrect, loads file error!");
        }
        
        //check the size of midi header, that is always 0x00000006 now.
        if (fileStream.readInt() != HDRSIZE)
        {
            throw new InvalidMidiError("Midi header size is incorrect, loads file error!");
        }
        
        //read following infomation
        _format = fileStream.readShort();
        _tracks = fileStream.readShort();
        _division = fileStream.readShort();
        var track : MidiTrack;
        
        //puts every track into track array
        for (i in 0..._tracks)
        {
            //unserialize a track data
            track = new MidiTrack(fileStream);
            _trackArray[i] = track;
        }
        
        //separate channels into diffence tracks when the format is 0.
        if (separate && _format == 0)
        {
            _format = 1;
            //points the main track
            _mainTrack = new MidiTrack();
            var tempArray : Array<Dynamic> = new Array<Dynamic>();
            var channels : Array<Dynamic> = new Array<Dynamic>();
            
            for (item/* AS3HX WARNING could not determine type for var: item exp: EField(EArray(EIdent(_trackArray),EConst(CInt(0))),msgList) type: null */ in _trackArray[0].msgList)
            {
                if (Std.is(item, NoteItem))
                {
                    if (Lambda.indexOf(channels, (try cast(item, NoteItem) catch(e:Dynamic) null).channel) < 0)
                    {
                        _tracks++;
                        //If the channel is not recorded, create a new track for that channel
                        channels.push((try cast(item, NoteItem) catch(e:Dynamic) null).channel);
                        tempArray[(try cast(item, NoteItem) catch(e:Dynamic) null).channel] = new MessageList();
                    }
                    tempArray[(try cast(item, NoteItem) catch(e:Dynamic) null).channel].push(item);
                }
                else if (Std.is(item, ChannelItem))
                {
                    if (Lambda.indexOf(channels, (try cast(item, ChannelItem) catch(e:Dynamic) null).channel) < 0)
                    {
                        _tracks++;
                        //If the channel is not recorded, create a new track for that channel
                        channels.push((try cast(item, ChannelItem) catch(e:Dynamic) null).channel);
                        tempArray[(try cast(item, ChannelItem) catch(e:Dynamic) null).channel] = new MessageList();
                    }
                    tempArray[(try cast(item, ChannelItem) catch(e:Dynamic) null).channel].push(item);
                }
                else
                {
                    _mainTrack.msgList.push(item);
                }
            }
            // set the main track;
            _trackArray[0] = _mainTrack;
            
            i = 0;
            while (i < tempArray.length)
            {
                if (tempArray[i] != null)
                {
                    track = new MidiTrack();
                    track.msgList = tempArray[i];
                    _trackArray.push(track);
                }
                i++;
            }
        }
        else
        {
            _mainTrack = _trackArray[0];
        }
    }
    
    /**
		* Outputs a new byte array, presents a valid midi file.
		* @return Midi file data in raw bytes
		*/
    public function output() : ByteArray
    {
        var file : ByteArray = new ByteArray();
        
        // write midi header
        file.writeInt(MThd);
        
        // write midi header size
        file.writeInt(HDRSIZE);
        
        //write following midi infos.
        file.writeShort(_format);
        file.writeShort(_tracks);
        file.writeShort(_division);
        
        //serialize every tracks.
        for (i in 0..._tracks)
        {
            _trackArray[i].serialize(file);
        }
        
        //get a new bytearray contents the midi file data
        return file;
    }
    
    /**
		* Get a reference of specific track
		* @param num Indicates the track number
		* @return MidiTrack
		* @see MidiTrack
		*/
    public function track(num : Int) : MidiTrack
    {
        if (num >= _tracks)
        {
            return null;
        }
        else
        {
            return _trackArray[num];
        }
    }
    
    /**
		* Add a track to the midi
		* @param track track to be added.
		* @return how many tracks in this midi
		* @see MidiTrack
		*/
    public function addTrack(track : MidiTrack = null) : Int
    {
        if (null == track)
        {
            return addTrack(new MidiTrack());
        }
        else
        {
            _tracks++;
            return _trackArray.push(track);
        }
    }
    
    /**
		* Delete a track from midi identify by the track no..
		* @param t Indicates whick tracks to be erased.
		* @return Reference of the deleted track.
		* @see MidiTrack
		*/
    public function deleteTrack(t : Int) : MidiTrack
    {
        if (t <= 0)
        {
            //track[0] refers to the main track
            throw new InvalidMidiError("Invalid track number. Can't delete main track.");
        }
        else if (t >= _tracks)
        {
            throw new InvalidMidiError("Invalid track number. There isn't this track");
        }
        //track[t] refers to the t'th track.
        else
        {
            
            _tracks--;
            return _trackArray.splice(t, 1)[0];
        }
    }
    
    /**
		* Sets a track refering to a MidiTrack instance by track num
		* @param t Indicats track number
		* @param track A MidiTrack instance
		* @see MidiTrack
		* @throws InvalidMidiError
		* <p>"Invalid track number. There isn't this track." if appointed track number is overflow.
		* "Should n't set a null midiTrack." when designated midi track is null.</P>
		*/
    public function setTrack(t : Int, track : MidiTrack) : Void
    {
        if (t >= _tracks || t < 0)
        {
            throw new InvalidMidiError("Invalid track number. There isn't this track");
        }
        else if (track == null)
        {
            throw new InvalidMidiError("Should n't set a null midiTrack");
        }
        //track[t] refers to the t'th track.
        else
        {
            
            _trackArray[t] = track;
        }
    }
    
    /**
		* Swaps two track's position
		* @param t1 first track
		* @param t2 second track
		* @throws InvalidMidiError
		* <p>when given track numbers is logical fault.</p>
		*/
    public function swapTrack(t1 : Int, t2 : Int) : Void
    {
        if (t1 <= 0 || t2 <= 0)
        {
            //track[0] refers to the main track
            throw new InvalidMidiError("Invalid track number. Can't swap main track.");
        }
        else if (t1 >= _tracks || t2 >= _tracks)
        {
            throw new InvalidMidiError("Invalid track number. There isn't this track");
        }
        else
        {
            var temp : MidiTrack = _trackArray[t1];
            _trackArray[t1] = _trackArray[t2];
            _trackArray[t2] = temp;
            temp = null;
        }
    }
    
    /**
		* Inserts track after special position.
		* @param t Indicates track number
		* @param track A MidiTrack instance to insert. Creates empty track when this param is null by default.
		* @return The amount of tracks after operation.
		* @throws InvalidMidiError
		* <p>when given track number slops over.</p>
		* @see MidiTrack
		*/
    public function insertTrack(t : Int, track : MidiTrack = null) : Int
    {
        if (t >= _tracks || t < 0)
        {
            throw new InvalidMidiError("Invalid inserting position number.");
        }
        if (null == track)
        {
            return insertTrack(t, new MidiTrack());
        }
        else
        {
            _tracks++;
            as3hx.Compat.arraySplice(_trackArray, t, 0, [track]);
            return _tracks;
        }
    }
    
    /**
		* Disposes the midifile.
		*/
    public function dispose() : Void
    {
        var i : Int = 0;
        while (i < _trackArray.length)
        {
            _trackArray[i].dispose();
            i++;
        }
        _tracks = 0;
        _division = 0;
        _trackArray = new Array<Dynamic>();
    }
}


