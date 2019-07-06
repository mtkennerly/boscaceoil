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

import openfl.utils.Dictionary;

/**
	 * MidiEnum class
	 */
class MidiEnum
{
    /**
		* Channel message
		*/
    public static inline var NOTE_OFF : Int = 0x80;  //	????  
    public static inline var NOTE_ON : Int = 0x90;  //	????  
    public static inline var POLY_PRESSURE : Int = 0xA0;  //	???????(??)  
    public static inline var CONTROL_CHANGE : Int = 0xB0;  //	??????  
    public static inline var PROGRAM_CHANGE : Int = 0xC0;  //	??(??)??  
    public static inline var CHANNEL_PRESSURE : Int = 0xD0;  //	?????  
    public static inline var PITCH_BEND : Int = 0xE0;  //	??  
    /**
		* Meta message
		*/
    public static inline var META : Int = 0xFF;  //	Meta tag  
    public static inline var SEQ_NUM : Int = 0x00;  //  Sequence number  
    public static inline var TEXT : Int = 0x01;  //  Text  
    public static inline var COPY_RIGHT : Int = 0x02;  //  Copyright notice  
    public static inline var SEQ_TRK_NAME : Int = 0x03;  //  Sequence or track name  
    public static inline var INSTRUMENT_NAME : Int = 0x04;  //  Instrument name  
    public static inline var LYRIC_TXT : Int = 0x05;  //  Lyric text  
    public static inline var MARKER_TXT : Int = 0x06;  //  Marker text  
    public static inline var CUE_POINT : Int = 0x07;  //  Cue point  
    public static inline var PROGRAM_NAME : Int = 0x08;  //  Program name  
    public static inline var DEVICE_NAME : Int = 0x09;  //  Device name  
    public static inline var CHANNEL_PREFIX : Int = 0x20;  //  MIDI channel prefix assignment  
    public static inline var END_OF_TRK : Int = 0x2F;  //  End of track  
    public static inline var SET_TEMPO : Int = 0x51;  //  1/4 Tempo setting  
    public static inline var SMPTE_OFFSET : Int = 0x54;  //  SMPTE offset  
    public static inline var TIME_SIGN : Int = 0x58;  //  Time signature  
    public static inline var KEY_SIGN : Int = 0x59;  //  Key signature  
    public static inline var SEQ_SPEC : Int = 0x7F;  //  Sequencer specific event  
    /**
		* System Real Time Message----
		*/
    public static inline var TIMING_CLOCK : Int = 0xF8;  //  ????  
    public static inline var RESERVED_0xF9 : Int = 0xF9;  //	??  
    public static inline var SYS_START : Int = 0xFA;  //	?????????(????????????????)  
    public static inline var SYS_CONTINUE : Int = 0xFB;  //	???????????????  
    public static inline var SYS_STOP : Int = 0xFC;  //	??????  
    public static inline var RESERVED_0xFD : Int = 0xFD;  //	??  
    public static inline var ACTIVE_SENDING : Int = 0xFE;  //	??????  
    //public static const	SYS_RESET:int  			=	0xFF;		//	????
    /**
		* System message
		*/
    public static inline var SYSTEM_EXCLUSIVE : Int = 0xF0;  //	???????,????????  
    public static inline var MIDI_TIME_CODE : Int = 0xF1;  //	midi???  
    public static inline var SONG_POSITION : Int = 0xF2;  //	????  
    public static inline var SONG_SELECT : Int = 0xF3;  //	??  
    public static inline var RESERVED_0xF4 : Int = 0xF4;  //	??  
    public static inline var RESERVED_0xF5 : Int = 0xF5;  //	??  
    public static inline var TUNE_REQUEST : Int = 0xF6;  //	??  
    public static inline var END_OF_SYS_EX : Int = 0xF7;  //	??????????  
    
    public static inline var NOTE : Int = 0x00;  // zero can be presents the note kind  
    
    private static var _message : Dictionary<Int, String> = new Dictionary(true);
    
    //Initialize the static block
    
    /**
		* Initializes the static dictionary.
		*/
    public function new()
    {
        null;
    }
    
    /**
		 * @param n message value.
		 * @return message name. 
		 */
    public static function getMessageName(n : Int) : String
    {
        return _message[n];
    }
    private static var MidiEnum_static_initializer = {
        {
            _message[NOTE_OFF] = "NOTE_OFF";
            _message[NOTE_ON] = "NOTE_ON";
            _message[POLY_PRESSURE] = "POLY_PRESSURE";
            _message[CONTROL_CHANGE] = "CONTROL_CHANGE";
            _message[PROGRAM_CHANGE] = "PROGRAM_CHANGE";
            _message[CHANNEL_PRESSURE] = "CHANNEL_PRESSURE";
            _message[PITCH_BEND] = "PITCH_BEND";
            
            _message[META] = "META";
            _message[SEQ_NUM] = "SEQ_NUM";
            _message[TEXT] = "TEXT";
            _message[COPY_RIGHT] = "COPY_RIGHT";
            _message[SEQ_TRK_NAME] = "SEQ_TRK_NAME";
            _message[INSTRUMENT_NAME] = "INSTRUMENT_NAME";
            _message[LYRIC_TXT] = "LYRIC_TXT";
            _message[MARKER_TXT] = "MARKER_TXT";
            _message[CUE_POINT] = "CUE_POINT";
            _message[PROGRAM_NAME] = "PROGRAM_NAME";
            _message[DEVICE_NAME] = "DEVICE_NAME";
            _message[CHANNEL_PREFIX] = "CHANNEL_PREFIX";
            _message[END_OF_TRK] = "END_OF_TRK";
            _message[SET_TEMPO] = "SET_TEMPO";
            _message[SMPTE_OFFSET] = "SMPTE_OFFSET";
            _message[TIME_SIGN] = "TIME_SIGN";
            _message[KEY_SIGN] = "KEY_SIGN";
            _message[SEQ_SPEC] = "SEQ_SPEC";
            
            _message[TIMING_CLOCK] = "TIMING_CLOCK";
            _message[RESERVED_0xF9] = "RESERVED_0xF9";
            _message[SYS_START] = "SYS_START";
            _message[SYS_CONTINUE] = "SYS_CONTINUE";
            _message[SYS_STOP] = "SYS_STOP";
            _message[RESERVED_0xFD] = "RESERVED_0xFD";
            _message[ACTIVE_SENDING] = "ACTIVE_SENDING";
            //_message[SYS_RESET]="SYS_RESET";
            
            _message[SYSTEM_EXCLUSIVE] = "SYSTEM_EXCLUSIVE";
            _message[MIDI_TIME_CODE] = "MIDI_TIME_CODE";
            _message[SONG_POSITION] = "SONG_POSITION";
            _message[SONG_SELECT] = "SONG_SELECT";
            _message[RESERVED_0xF4] = "RESERVED_0xF4";
            _message[RESERVED_0xF5] = "RESERVED_0xF5";
            _message[TUNE_REQUEST] = "TUNE_REQUEST";
            _message[END_OF_SYS_EX] = "END_OF_SYS_EX";
            
            _message[NOTE] = "NOTE";
        };
        true;
    }

}


