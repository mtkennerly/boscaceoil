// temporary: ignore the entire contents of this file when building for web
#if targetDesktop
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.utils.*;
import openfl.net.*;
import openfl.filesystem.*;
import org.si.sion.midi.*;
import org.si.sion.events.*;

class Midicontrol
{
    public static var MIDIDRUM_35_Acoustic_Bass_Drum : Int = 35;
    public static var MIDIDRUM_36_Bass_Drum_1 : Int = 36;
    public static var MIDIDRUM_37_Side_Stick : Int = 37;
    public static var MIDIDRUM_38_Acoustic_Snare : Int = 38;
    public static var MIDIDRUM_39_Hand_Clap : Int = 39;
    public static var MIDIDRUM_40_Electric_Snare : Int = 40;
    public static var MIDIDRUM_41_Low_Floor_Tom : Int = 41;
    public static var MIDIDRUM_42_Closed_Hi_Hat : Int = 42;
    public static var MIDIDRUM_43_High_Floor_Tom : Int = 43;
    public static var MIDIDRUM_44_Pedal_Hi_Hat : Int = 44;
    public static var MIDIDRUM_45_Low_Tom : Int = 45;
    public static var MIDIDRUM_46_Open_Hi_Hat : Int = 46;
    public static var MIDIDRUM_47_Low_Mid_Tom : Int = 47;
    public static var MIDIDRUM_48_Hi_Mid_Tom : Int = 48;
    public static var MIDIDRUM_49_Crash_Cymbal_1 : Int = 49;
    public static var MIDIDRUM_50_High_Tom : Int = 50;
    public static var MIDIDRUM_51_Ride_Cymbal_1 : Int = 51;
    public static var MIDIDRUM_52_Chinese_Cymbal : Int = 52;
    public static var MIDIDRUM_53_Ride_Bell : Int = 53;
    public static var MIDIDRUM_54_Tambourine : Int = 54;
    public static var MIDIDRUM_55_Splash_Cymbal : Int = 55;
    public static var MIDIDRUM_56_Cowbell : Int = 56;
    public static var MIDIDRUM_57_Crash_Cymbal_2 : Int = 57;
    public static var MIDIDRUM_58_Vibraslap : Int = 58;
    public static var MIDIDRUM_59_Ride_Cymbal_2 : Int = 59;
    public static var MIDIDRUM_60_Hi_Bongo : Int = 60;
    public static var MIDIDRUM_61_Low_Bongo : Int = 61;
    public static var MIDIDRUM_62_Mute_Hi_Conga : Int = 62;
    public static var MIDIDRUM_63_Open_Hi_Conga : Int = 63;
    public static var MIDIDRUM_64_Low_Conga : Int = 64;
    public static var MIDIDRUM_65_High_Timbale : Int = 65;
    public static var MIDIDRUM_66_Low_Timbale : Int = 66;
    public static var MIDIDRUM_67_High_Agogo : Int = 67;
    public static var MIDIDRUM_68_Low_Agogo : Int = 68;
    public static var MIDIDRUM_69_Cabasa : Int = 69;
    public static var MIDIDRUM_70_Maracas : Int = 70;
    public static var MIDIDRUM_71_Short_Whistle : Int = 71;
    public static var MIDIDRUM_72_Long_Whistle : Int = 72;
    public static var MIDIDRUM_73_Short_Guiro : Int = 73;
    public static var MIDIDRUM_74_Long_Guiro : Int = 74;
    public static var MIDIDRUM_75_Claves : Int = 75;
    public static var MIDIDRUM_76_Hi_Wood_Block : Int = 76;
    public static var MIDIDRUM_77_Low_Wood_Block : Int = 77;
    public static var MIDIDRUM_78_Mute_Cuica : Int = 78;
    public static var MIDIDRUM_79_Open_Cuica : Int = 79;
    public static var MIDIDRUM_80_Mute_Triangle : Int = 80;
    public static var MIDIDRUM_81_Open_Triangle : Int = 81;
    
    public static function openfile() : Void
    {
        Control.stopmusic();
        
        if (!Control.filepath)
        {
            Control.filepath = Control.defaultDirectory;
        }
        file = Control.filepath.resolvePath("");
        file.addEventListener(Event.SELECT, onloadmidi);
        file.browseForOpen("Load .mid File", [midiFilter]);
        
        Control.fixmouseclicks = true;
    }
    
    public static function savemidi() : Void
    {
        Control.stopmusic();
        
        if (!Control.filepath)
        {
            Control.filepath = Control.defaultDirectory;
        }
        file = Control.filepath.resolvePath("*.mid");
        file.addEventListener(Event.SELECT, onsavemidi);
        file.browseForSave("Save .mid File");
        
        Control.fixmouseclicks = true;
    }
    
    private static function onsavemidi(e : Event) : Void
    {
        file = try cast(e.currentTarget, File) catch(e:Dynamic) null;
        
        if (!Control.fileHasExtension(file, "mid"))
        {
            Control.addExtensionToFile(file, "mid");
        }
        
        convertceoltomidi();
        
        tempbytes = new ByteArray();
        tempbytes = clone(midiexporter.midifile.output());
        
        stream = new FileStream();
        stream.open(file, FileMode.WRITE);
        stream.writeBytes(tempbytes, 0, tempbytes.length);
        stream.close();
        
        Control.fixmouseclicks = true;
        Control.showmessage("SONG EXPORTED AS MIDI");
        Control.savefilesettings();
    }
    
    private static function onloadmidi(e : Event) : Void
    {
        mididata = new ByteArray();
        file = try cast(e.currentTarget, File) catch(e:Dynamic) null;
        
        stream = new FileStream();
        stream.open(file, FileMode.READ);
        stream.readBytes(mididata);
        stream.close();
        
        tempbytes = new ByteArray();
        tempbytes = clone(mididata);
        midiexporter = new Midiexporter();
        midiexporter.midifile.input(tempbytes);
        
        smfData.loadBytes(mididata);
        
        var track : SMFTrack;
        var event : SMFEvent;
        
        clearnotes();
        resetinstruments();
        
        //trace(smfData.toString());
        
        var trackn : Int = 0;
        while (trackn < smfData.numTracks)
        {
            //trace("Reading track " + String(trackn) + ": " + String(smfData.tracks[trackn].sequence.length));
            for (event/* AS3HX WARNING could not determine type for var: event exp: EField(EArray(EField(EIdent(smfData),tracks),EIdent(trackn)),sequence) type: null */ in smfData.tracks[trackn].sequence)
            {
                //trace("msg: " + String(event.time) + ": " + event.toString());
                var _sw1_ = (event.type & 0xf0);                

                switch (_sw1_)
                {
                    case SMFEvent.NOTE_ON:
                        if (event.velocity == 0)
                        {
                            //This is *actually* a note off event in disguise
                            changenotelength(event.time, event.note, event.channel);
                        }
                        else
                        {
                            addnote(event.time, event.note, event.channel);
                            if (event.velocity > channelvolume[event.channel])
                            {
                                channelvolume[event.channel] = event.velocity;
                            }
                        }
                    case SMFEvent.NOTE_OFF:
                        changenotelength(event.time, event.note, event.channel);
                    case SMFEvent.PROGRAM_CHANGE:
                        channelinstrument[event.channel] = event.value;
                }
            }
            trackn++;
        }
        
        //channelinstrument[9] = 142;
        channelinstrument[9] = Control.voicelist.getvoice("Simple Drumkit");
        
        convertmiditoceol();
        
        Control.arrange.currentbar = 0;Control.arrange.viewstart = 0;
        Control.changemusicbox(0);
        
        /*
			Control._driver.setBeatCallbackInterval(1);
			Control._driver.setTimerInterruption(1, null);
          Control._driver.play(smfData, false);
			*/
        
        Control.showmessage("MIDI IMPORTED");
        Control.fixmouseclicks = true;
        Control.savefilesettings();
    }
    
    public static function clone(source : Dynamic) : Dynamic
    {
        var myBA : ByteArray = new ByteArray();
        myBA.writeObject(source);
        myBA.position = 0;
        return (myBA.readObject());
    }
    
    public static function resetinstruments() : Void
    {
        if (channelinstrument.length == 0)
        {
            for (i in 0...16)
            {
                channelinstrument.push(-1);
                channelvolume.push(0);
            }
        }
        else
        {
            for (i in 0...16)
            {
                channelinstrument[i] = -1;
                channelvolume[i] = 0;
            }
        }
    }
    
    public static function clearnotes() : Void
    {
        unmatchednotes = new Array<Rectangle>();
        midinotes = new Array<Rectangle>();
    }
    
    public static function addnote(time : Int, note : Int, instr : Int) : Void
    {
        unmatchednotes.push(new Rectangle(time, note, 0, instr));
    }
    
    public static function changenotelength(time : Int, note : Int, instr : Int) : Void
    //Find the first note of that pitch and instrument BEFORE given time.
    {
        
        var timedist : Int = -1;
        var currenttimedist : Int = 0;
        var matchingnote : Int = -1;
        var i : Int = 0;
        while (i < unmatchednotes.length)
        {
            if (unmatchednotes[i].y == note && unmatchednotes[i].height == instr)
            {
                currenttimedist = as3hx.Compat.parseInt(time - unmatchednotes[i].x);
                if (currenttimedist >= 0)
                {
                    if (timedist == -1)
                    {
                        timedist = currenttimedist;
                        matchingnote = i;
                    }
                    else if (currenttimedist < timedist)
                    {
                        timedist = currenttimedist;
                        matchingnote = i;
                    }
                }
            }
            i++;
        }
        
        if (matchingnote != -1)
        {
            unmatchednotes[matchingnote].width = -1;
            midinotes.push(new Rectangle(unmatchednotes[matchingnote].x, 
                    unmatchednotes[matchingnote].y, 
                    time, 
                    unmatchednotes[matchingnote].height));
            
            //Swap matching note with last note, and pop it off
            if (matchingnote != unmatchednotes.length - 1)
            {
                var swp : Int;
                
                swp = unmatchednotes[matchingnote].x;
                unmatchednotes[matchingnote].x = unmatchednotes[unmatchednotes.length - 1].x;
                unmatchednotes[unmatchednotes.length - 1].x = swp;
                
                swp = unmatchednotes[matchingnote].y;
                unmatchednotes[matchingnote].y = unmatchednotes[unmatchednotes.length - 1].y;
                unmatchednotes[unmatchednotes.length - 1].y = swp;
                
                swp = unmatchednotes[matchingnote].width;
                unmatchednotes[matchingnote].width = unmatchednotes[unmatchednotes.length - 1].width;
                unmatchednotes[unmatchednotes.length - 1].width = swp;
                
                swp = unmatchednotes[matchingnote].height;
                unmatchednotes[matchingnote].height = unmatchednotes[unmatchednotes.length - 1].height;
                unmatchednotes[unmatchednotes.length - 1].height = swp;
            }
        }
        
        if (unmatchednotes.length > 0)
        {
            if (unmatchednotes[unmatchednotes.length - 1].width == -1)
            {
                unmatchednotes.pop();
            }
        }
    }
    
    public static function getsonglength() : Int
    {
        return as3hx.Compat.parseInt(smfData.measures);
    }
    
    public static function reversechannelinstrument(t : Int) : Int
    //Given instrument number t, return first channel using it.
    {
        
        for (i in 0...16)
        {
            if (channelinstrument[i] == t)
            {
                return i;
            }
        }
        return -1;
    }
    
    public static function gettopbox(currentpattern : Int, chan : Int) : Int
    //return the first musicbox to either match instrument or be empty
    {
        
        if (chan == 9)
        {
            //Drums, put it on the last row
            if (Control.arrange.bar[currentpattern].channel[7] == -1)
            {
                return 7;
            }
            else if (reversechannelinstrument(channelinstrument[Control.musicbox[Control.arrange.bar[currentpattern].channel[7]].instr]) == reversechannelinstrument(channelinstrument[chan]))
            {
                return 7;
            }
        }
        
        
        for (i in 0...8)
        {
            if (Control.arrange.bar[currentpattern].channel[i] == -1)
            {
                return i;
            }
            else if (channelinstrument[chan] != -1)
            {
                if (reversechannelinstrument(channelinstrument[Control.musicbox[Control.arrange.bar[currentpattern].channel[i]].instr]) == reversechannelinstrument(channelinstrument[chan]))
                {
                    return i;
                }
            }
        }
        return -1;
    }
    
    public static function getmusicbox(currentpattern : Int, chan : Int) : Int
    //Find (or create a new) music box at the position we're placing the note.
    {
        
        var top : Int = gettopbox(currentpattern, chan);
        
        if (top > -1)
        {
            if (Control.arrange.bar[currentpattern].channel[top] == -1)
            {
                Control.currentinstrument = chan;
                if (channelinstrument[chan] > -1)
                {
                    Control.voicelist.index = channelinstrument[chan];
                    Control.changeinstrumentvoice(Control.voicelist.name[Control.voicelist.index]);
                }
                else
                {
                    Control.voicelist.index = 0;
                    Control.changeinstrumentvoice(Control.voicelist.name[Control.voicelist.index]);
                }
                Control.addmusicbox();
                Control.arrange.addpattern(currentpattern, top, Control.numboxes - 1);
                return as3hx.Compat.parseInt(Control.numboxes - 1);
            }
            else
            {
                return Control.arrange.bar[currentpattern].channel[top];
            }
        }
        
        return -1;
    }
    
    public static function addnotetoceol(currentpattern : Int, time : Int, pitch : Int, notelength : Int, chan : Int) : Void
    //Control.musicbox[currentpattern + (instr * numpatterns)].addnote(time, pitch, notelength);
    {
        
        currentpattern = getmusicbox(currentpattern, chan);
        if (currentpattern > -1)
        {
            Control.musicbox[currentpattern].addnote(time, pitch, notelength);
        }
    }
    
    public static function replaceontimeline(_old : Int, _new : Int) : Void
    {
        for (i in 0...numpatterns)
        {
            for (j in 0...8)
            {
                if (Control.arrange.bar[i].channel[j] == _old)
                {
                    Control.arrange.bar[i].channel[j] = _new;
                }
            }
        }
    }
    
    public static function musicboxmatch(a : Int, b : Int) : Bool
    {
        if (Control.musicbox[a].numnotes == Control.musicbox[b].numnotes)
        {
            if (Control.musicbox[a].instr == Control.musicbox[b].instr)
            {
                var i : Int = 0;
                while (i < Control.musicbox[a].numnotes)
                {
                    if (Control.musicbox[a].notes[i].x != Control.musicbox[b].notes[i].x)
                    {
                        return false;
                    }
                    i++;
                }
                return true;
            }
        }
        return false;
    }
    
    public static function convertmiditoceol() : Void
    {
        Control.newsong();
        Control.numboxes = 0;
        Control.bpm = (smfData.bpm - (smfData.bpm % 5));
        if (Control.bpm <= 10)
        {
            Control.bpm = 120;
        }
        Control._driver.bpm = Control.bpm;
        Control._driver.play(null, false);
        //for (var tst:int = 0; tst < 16; tst++) {
        //     trace("channel " + String(tst) + " uses instrument " + String(channelinstrument[tst]) + " at volume " + String(channelvolume[tst]));
        //}
        
        resolution = smfData.resolution;
        signature = smfData.signature_d;
        numnotes = smfData.signature_d * smfData.signature_n;
        if (signature == 0 || numnotes == 0)
        {
            signature = 4;
            numnotes = 16;
        }
        if (numnotes > 16)
        {
            Control.doublesize = true;
        }
        
        var boxsize : Int = resolution;
        numpatterns = getsonglength();
        Control.numboxes = 0;
        Control.arrange.bar[0].channel[0] = -1;
        
        Control.numinstrument = 16;
        for (j in 0...16)
        {
            Control.currentinstrument = j;
            Control.voicelist.index = 132;  //Set to chiptune noise if not used  
            Control.changeinstrumentvoice(Control.voicelist.name[Control.voicelist.index]);
            
            if (channelinstrument[j] > -1)
            {
                Control.voicelist.index = channelinstrument[j];
                Control.changeinstrumentvoice(Control.voicelist.name[Control.voicelist.index]);
                
                Control.instrument[Control.currentinstrument].setvolume((channelvolume[j] * 256) / 128);
                Control.instrument[Control.currentinstrument].updatefilter();
                if (Control.instrument[Control.currentinstrument].type > 0)
                {
                    Control.drumkit[Control.instrument[Control.currentinstrument].type - 1].updatevolume((channelvolume[j] * 256) / 128);
                }
            }
        }
        
        var i : Int;
        var note : Int;
        var notelength : Int;
        var currentpattern : Int;
        
        i = 0;
        while (i < midinotes.length)
        {
            //Drums
            if (as3hx.Compat.parseInt(midinotes[i].height) == 9)
            {
                //x = time
                //y = note
                //w = length
                //h = instrument
                note = as3hx.Compat.parseInt((midinotes[i].x * numnotes) / boxsize);
                notelength = as3hx.Compat.parseInt((((midinotes[i].width - midinotes[i].x - 1) * numnotes) / boxsize) + 1);
                currentpattern = as3hx.Compat.parseInt((midinotes[i].x - (midinotes[i].x % boxsize)) / boxsize);
                
                var drumnote : Int = 0;
                
                //0 "Bass Drum 1"
                //1 "Bass Drum 2"
                //2 "Bass Drum 3"
                //3 "Snare Drum"
                //4 "Snare Drum 2"
                //5 "Open Hi-Hat"
                //6 "Closed Hi-Hat"
                //7 "Crash Cymbal"
                var _sw2_ = (midinotes[i].y);                

                switch (_sw2_)
                {
                    case MIDIDRUM_35_Acoustic_Bass_Drum:drumnote = 0;
                    case MIDIDRUM_36_Bass_Drum_1:drumnote = 1;
                    case MIDIDRUM_37_Side_Stick:drumnote = 3;
                    case MIDIDRUM_38_Acoustic_Snare:drumnote = 3;
                    case MIDIDRUM_39_Hand_Clap:drumnote = 1;
                    case MIDIDRUM_40_Electric_Snare:drumnote = 4;
                    case MIDIDRUM_41_Low_Floor_Tom:drumnote = 1;
                    case MIDIDRUM_42_Closed_Hi_Hat:drumnote = 6;
                    case MIDIDRUM_43_High_Floor_Tom:drumnote = 2;
                    case MIDIDRUM_44_Pedal_Hi_Hat:drumnote = 5;
                    case MIDIDRUM_45_Low_Tom:drumnote = 1;
                    case MIDIDRUM_46_Open_Hi_Hat:drumnote = 5;
                    case MIDIDRUM_47_Low_Mid_Tom:drumnote = 1;
                    case MIDIDRUM_48_Hi_Mid_Tom:drumnote = 2;
                    case MIDIDRUM_49_Crash_Cymbal_1:drumnote = 7;
                    case MIDIDRUM_50_High_Tom:drumnote = 2;
                    case MIDIDRUM_51_Ride_Cymbal_1:drumnote = 7;
                    case MIDIDRUM_52_Chinese_Cymbal:drumnote = 7;
                    case MIDIDRUM_53_Ride_Bell:drumnote = 5;
                    case MIDIDRUM_54_Tambourine:drumnote = 5;
                    case MIDIDRUM_55_Splash_Cymbal:drumnote = 7;
                    case MIDIDRUM_56_Cowbell:drumnote = 7;
                    case MIDIDRUM_57_Crash_Cymbal_2:drumnote = 7;
                    case MIDIDRUM_58_Vibraslap:drumnote = 5;
                    case MIDIDRUM_59_Ride_Cymbal_2:drumnote = 7;
                    case MIDIDRUM_60_Hi_Bongo:drumnote = 4;
                    case MIDIDRUM_61_Low_Bongo:drumnote = 3;
                    case MIDIDRUM_62_Mute_Hi_Conga:drumnote = 4;
                    case MIDIDRUM_63_Open_Hi_Conga:drumnote = 5;
                    case MIDIDRUM_64_Low_Conga:drumnote = 2;
                    case MIDIDRUM_65_High_Timbale:drumnote = 4;
                    case MIDIDRUM_66_Low_Timbale:drumnote = 3;
                    case MIDIDRUM_67_High_Agogo:drumnote = 4;
                    case MIDIDRUM_68_Low_Agogo:drumnote = 3;
                    case MIDIDRUM_69_Cabasa:drumnote = 5;
                    case MIDIDRUM_70_Maracas:drumnote = 7;
                    case MIDIDRUM_71_Short_Whistle:drumnote = 7;
                    case MIDIDRUM_72_Long_Whistle:drumnote = 7;
                    case MIDIDRUM_73_Short_Guiro:drumnote = 3;
                    case MIDIDRUM_74_Long_Guiro:drumnote = 4;
                    case MIDIDRUM_75_Claves:drumnote = 6;
                    case MIDIDRUM_76_Hi_Wood_Block:drumnote = 4;
                    case MIDIDRUM_77_Low_Wood_Block:drumnote = 3;
                    case MIDIDRUM_78_Mute_Cuica:drumnote = 2;
                    case MIDIDRUM_79_Open_Cuica:drumnote = 4;
                    case MIDIDRUM_80_Mute_Triangle:drumnote = 5;
                    case MIDIDRUM_81_Open_Triangle:drumnote = 7;
                }
                
                addnotetoceol(currentpattern, note - (numnotes * currentpattern), drumnote, notelength, midinotes[i].height);
            }
            //x = time
            else
            {
                
                //y = note
                //w = length
                //h = instrument
                note = as3hx.Compat.parseInt((midinotes[i].x * numnotes) / boxsize);
                notelength = as3hx.Compat.parseInt((((midinotes[i].width - midinotes[i].x - 1) * numnotes) / boxsize) + 1);
                currentpattern = as3hx.Compat.parseInt((midinotes[i].x - (midinotes[i].x % boxsize)) / boxsize);
                
                addnotetoceol(currentpattern, note - (numnotes * currentpattern), midinotes[i].y, notelength, midinotes[i].height);
            }
            i++;
        }
        
        //Optimising stage: Check for duplicate patterns and remove unused ones.
        i = 0;
        while (i < Control.numboxes)
        {
            var currenthash : Int = Control.musicbox[i].hash;
            if (currenthash != -1)
            {
                j = as3hx.Compat.parseInt(i + 1);
                while (j < Control.numboxes)
                {
                    if (Control.musicbox[j].hash == currenthash)
                    {
                        //Probably a match! Let's compare and remove if so
                        if (musicboxmatch(i, j))
                        {
                            replaceontimeline(j, i);
                            Control.musicbox[j].hash = -1;
                        }
                    }
                    j++;
                }
            }
            i++;
        }
        
        //Delete unused boxes
        i = Control.numboxes;
        while (i >= 0)
        {
            if (i < Control.numboxes)
            {
                if (Control.musicbox[i].hash == -1)
                {
                    Control.deletemusicbox(i);
                }
            }
            i--;
        }
        
        Control.arrange.loopstart = 0;
        Control.arrange.loopend = Control.arrange.lastbar;
        if (Control.arrange.loopend <= Control.arrange.loopstart)
        {
            Control.arrange.loopend = Control.arrange.loopstart + 1;
        }
    }
    
    public static function convertceoltomidi() : Void
    //Export the song currently loaded as a midi.
    {
        
        //midifile = new MidiFile();
        /*
			trace("num tracks:" + midifile.tracks);
			for (var sel:int = 0 ; sel < midifile.tracks ; sel++) {
				trace("track " + String(sel + 1) + ", data:" + String(midifile.track(sel).trackChannel) + ", channel:" + String(midifile.track(sel).trackChannel));
				for (var i:int = 0 ; i < midifile.track(sel).msgList.length ; i++) {
					if (midifile.track(sel).msgList[i] is ChannelItem) {
						trace(i, "command: " + String(midifile.track(sel).msgList[i]._command) + ", data1:" + String(midifile.track(sel).msgList[i]._data1));
					}
					var index:uint = i+1;
					var time:uint = midifile.track(sel).msgList[i].timeline;
					var len:uint = midifile.track(sel).msgList[i] is NoteItem? midifile.track(sel).msgList[i].duration : null;
					var channel:uint = midifile.track(sel).msgList[i] is NoteItem?midifile.track(sel).msgList[i].channel+1 : midifile.track(sel).trackChannel+1;
					var type:String = MidiEnum.getMessageName(midifile.track(sel).msgList[i].kind);
					var param:String = midifile.track(sel).msgList[i] is NoteItem? midifile.track(sel).msgList[i].pitchName : "else";
					var value:uint = midifile.track(sel).msgList[i] is NoteItem? midifile.track(sel).msgList[i].velocity : null;
					trace("index:" + String(index) + ", time:" + String(time) + ", len:+" + String(len) + ", channel:" + String(channel) + ", event:" + String(type) + ", param:" + String(param) + ", value:" + String(value));
				}				
			}
			*/
        midiexporter = new Midiexporter();
        
        midiexporter.nexttrack();
        midiexporter.writetimesig();
        midiexporter.writetempo(Control.bpm);
        
        midiexporter.nexttrack();
        
        //Write all the instruments to each channel.
        //In MIDI, channel 9 is special.
        var j : Int = 0;
        while (j < Control.numinstrument)
        {
            midiexporter.writeinstrument(instrumentconverttomidi(Control.instrument[j].index), j);
            j++;
        }
        
        //Cover the entire song
        Control.arrange.loopstart = 0;
        Control.arrange.loopend = Control.arrange.lastbar;
        if (Control.arrange.loopend <= Control.arrange.loopstart)
        {
            Control.arrange.loopend = Control.arrange.loopstart + 1;
        }
        
        /*
			These are the same patch numbers as defined in the original version of GS. 
			Drum bank is accessed by setting cc#0 (Bank Select MSB) to 120 and cc#32 (Bank 
			Select LSB) to 0 and PC (Program Change) to select drum kit.	
			1 	Standard Kit 	The only kit specified by General MIDI Level 1
			 * */
        
        //Write notes
        j = 0;
        while (j < Control.arrange.lastbar)
        {
            for (i in 0...8)
            {
                if (Control.arrange.bar[j].channel[i] != -1)
                {
                    var t : Int = Control.arrange.bar[j].channel[i];
                    //Do normal instruments first
                    if (Control.instrument[Control.musicbox[Control.arrange.bar[j].channel[i]].instr].type == 0)
                    {
                        var k : Int = 0;
                        while (k < Control.musicbox[t].numnotes)
                        {
                            midiexporter.writenote(Control.musicbox[t].instr, 
                                    Control.musicbox[t].notes[k].x, 
                                    ((j * Control.boxcount) + Control.musicbox[t].notes[k].width) * 30, 
                                    Control.musicbox[t].notes[k].y * 30, 255
                    );
                            k++;
                        }
                    }
                }
            }
            j++;
        }
        
        midiexporter.nexttrack();
        midiexporter.writeinstrument(0, 9);
        //Drumkits
        j = 0;
        while (j < Control.arrange.lastbar)
        {
            for (i in 0...8)
            {
                if (Control.arrange.bar[j].channel[i] != -1)
                {
                    t = Control.arrange.bar[j].channel[i];
                    var drumkit : Int = Control.musicbox[Control.arrange.bar[j].channel[i]].instr;
                    //Now do drum kits
                    if (help.Left(Control.voicelist.voice[Control.instrument[drumkit].index], 7) == "drumkit")
                    {
                        k = 0;
                        while (k < Control.musicbox[t].numnotes)
                        {
                            midiexporter.writenote(9, 
                                    convertdrumtonote(Control.musicbox[t].notes[k].x, Control.instrument[drumkit].index), 
                                    ((j * Control.boxcount) + Control.musicbox[t].notes[k].width) * 30, 
                                    Control.musicbox[t].notes[k].y * 30, 255
                    );
                            k++;
                        }
                    }
                }
            }
            j++;
        }
    }
    
    public static function convertdrumtonote(note : Int, drumkit : Int) : Int
    //Takes a drum beat from Control.createdrumkit()'s list and converts it
    {
        
        //to a drum beat from the General Midi list (http://www.midi.org/techspecs/gm1sound.php)
        var i : Int;
        var voicename : String = "";
        if (Control.voicelist.name[drumkit] == "Simple Drumkit")
        {
            voicename = Control.drumkit[0].voicename[note];
            
            if (voicename == "Bass Drum 1")
            {
                return MIDIDRUM_35_Acoustic_Bass_Drum;
            }
            if (voicename == "Bass Drum 2")
            {
                return MIDIDRUM_36_Bass_Drum_1;
            }
            if (voicename == "Bass Drum 3")
            {
                return MIDIDRUM_66_Low_Timbale;
            }
            if (voicename == "Snare Drum")
            {
                return MIDIDRUM_38_Acoustic_Snare;
            }
            if (voicename == "Snare Drum 2")
            {
                return MIDIDRUM_40_Electric_Snare;
            }
            if (voicename == "Open Hi-Hat")
            {
                return MIDIDRUM_46_Open_Hi_Hat;
            }
            if (voicename == "Closed Hi-Hat")
            {
                return MIDIDRUM_42_Closed_Hi_Hat;
            }
            if (voicename == "Crash Cymbal")
            {
                return MIDIDRUM_49_Crash_Cymbal_1;
            }
        }
        else if (Control.voicelist.name[drumkit] == "SiON Drumkit")
        {
            voicename = Control.drumkit[1].voicename[note];
            
            if (voicename == "Bass Drum 2")
            {
                return MIDIDRUM_35_Acoustic_Bass_Drum;
            }
            if (voicename == "Bass Drum 3 o1f")
            {
                return MIDIDRUM_36_Bass_Drum_1;
            }
            if (voicename == "RUFINA BD o2c")
            {
                return MIDIDRUM_35_Acoustic_Bass_Drum;
            }
            if (voicename == "B.D.(-vBend)")
            {
                return MIDIDRUM_35_Acoustic_Bass_Drum;
            }
            if (voicename == "BD808_2(-vBend)")
            {
                return MIDIDRUM_36_Bass_Drum_1;
            }
            if (voicename == "Cho cho 3 (o2e)")
            {
                return MIDIDRUM_72_Long_Whistle;
            }
            if (voicename == "Cow-Bell 1")
            {
                return MIDIDRUM_56_Cowbell;
            }
            if (voicename == "Crash Cymbal (noise)")
            {
                return MIDIDRUM_49_Crash_Cymbal_1;
            }
            if (voicename == "Crash Noise")
            {
                return MIDIDRUM_57_Crash_Cymbal_2;
            }
            if (voicename == "Crash Noise Short")
            {
                return MIDIDRUM_51_Ride_Cymbal_1;
            }
            if (voicename == "ETHNIC Percus.0")
            {
                return MIDIDRUM_40_Electric_Snare;
            }
            if (voicename == "ETHNIC Percus.1")
            {
                return MIDIDRUM_40_Electric_Snare;
            }
            if (voicename == "Heavy BD.")
            {
                return MIDIDRUM_35_Acoustic_Bass_Drum;
            }
            if (voicename == "Heavy BD2")
            {
                return MIDIDRUM_36_Bass_Drum_1;
            }
            if (voicename == "Heavy SD1")
            {
                return MIDIDRUM_38_Acoustic_Snare;
            }
            if (voicename == "Hi-Hat close 5_")
            {
                return MIDIDRUM_42_Closed_Hi_Hat;
            }
            if (voicename == "Hi-Hat close 4")
            {
                return MIDIDRUM_42_Closed_Hi_Hat;
            }
            if (voicename == "Hi-Hat close 5")
            {
                return MIDIDRUM_42_Closed_Hi_Hat;
            }
            if (voicename == "Hi-Hat Close 6 -808-")
            {
                return MIDIDRUM_42_Closed_Hi_Hat;
            }
            if (voicename == "Hi-hat #7 Metal o3-6")
            {
                return MIDIDRUM_42_Closed_Hi_Hat;
            }
            if (voicename == "Hi-Hat Close #8 o4")
            {
                return MIDIDRUM_42_Closed_Hi_Hat;
            }
            if (voicename == "Hi-hat Open o4e-g+")
            {
                return MIDIDRUM_46_Open_Hi_Hat;
            }
            if (voicename == "Open-hat2 Metal o4c-")
            {
                return MIDIDRUM_46_Open_Hi_Hat;
            }
            if (voicename == "Open-hat3 Metal")
            {
                return MIDIDRUM_46_Open_Hi_Hat;
            }
            if (voicename == "Hi-Hat Open #4 o4f")
            {
                return MIDIDRUM_46_Open_Hi_Hat;
            }
            if (voicename == "Metal ride o4c or o5c")
            {
                return MIDIDRUM_51_Ride_Cymbal_1;
            }
            if (voicename == "Rim Shot #1 o3c")
            {
                return MIDIDRUM_59_Ride_Cymbal_2;
            }
            if (voicename == "Snare Drum Light")
            {
                return MIDIDRUM_38_Acoustic_Snare;
            }
            if (voicename == "Snare Drum Lighter")
            {
                return MIDIDRUM_38_Acoustic_Snare;
            }
            if (voicename == "Snare Drum 808 o2-o3")
            {
                return MIDIDRUM_38_Acoustic_Snare;
            }
            if (voicename == "Snare4 -808type- o2")
            {
                return MIDIDRUM_38_Acoustic_Snare;
            }
            if (voicename == "Snare5 o1-2(Franger)")
            {
                return MIDIDRUM_38_Acoustic_Snare;
            }
            if (voicename == "Tom (old)")
            {
                return MIDIDRUM_45_Low_Tom;
            }
            if (voicename == "Synth tom 2 algo 3")
            {
                return MIDIDRUM_47_Low_Mid_Tom;
            }
            if (voicename == "Synth (Noisy) Tom #3")
            {
                return MIDIDRUM_48_Hi_Mid_Tom;
            }
            if (voicename == "Synth Tom #3")
            {
                return MIDIDRUM_50_High_Tom;
            }
            if (voicename == "Synth -DX7- Tom #4")
            {
                return MIDIDRUM_76_Hi_Wood_Block;
            }
            if (voicename == "Triangle 1 o5c")
            {
                return MIDIDRUM_81_Open_Triangle;
            }
        }
        else if (Control.voicelist.name[drumkit] == "Midi Drumkit")
        {
            //This one's easy: we already have the mapping saved.
            trace(note, Control.drumkit[2].midivoice[note]);
            if (Control.drumkit[2].midivoice[note] >= 35 && Control.drumkit[2].midivoice[note] <= 81)
            {
                return Control.drumkit[2].midivoice[note];
            }
            //There are a handful of notes in the SiON midi drumkit that aren't standard:
            //Map them to something similar in the standard set:
            voicename = Control.drumkit[2].voicename[note];
            if (voicename == "Seq Click H")
            {
                return MIDIDRUM_42_Closed_Hi_Hat;
            }
            if (voicename == "Brush Tap")
            {
                return MIDIDRUM_55_Splash_Cymbal;
            }
            if (voicename == "Brush Swirl")
            {
                return MIDIDRUM_59_Ride_Cymbal_2;
            }
            if (voicename == "Brush Slap")
            {
                return MIDIDRUM_49_Crash_Cymbal_1;
            }
            if (voicename == "Brush Tap Swirl")
            {
                return MIDIDRUM_49_Crash_Cymbal_1;
            }
            if (voicename == "Snare Roll")
            {
                return MIDIDRUM_38_Acoustic_Snare;
            }
            if (voicename == "Castanet")
            {
                return MIDIDRUM_35_Acoustic_Bass_Drum;
            }
            if (voicename == "Snare L")
            {
                return MIDIDRUM_40_Electric_Snare;
            }
            if (voicename == "Sticks")
            {
                return MIDIDRUM_37_Side_Stick;
            }
            if (voicename == "Bass Drum L")
            {
                return MIDIDRUM_36_Bass_Drum_1;
            }
            if (voicename == "Open Rim Shot")
            {
                return MIDIDRUM_46_Open_Hi_Hat;
            }
            if (voicename == "Shaker")
            {
                return MIDIDRUM_70_Maracas;
            }
            if (voicename == "Jingle Bells")
            {
                return MIDIDRUM_81_Open_Triangle;
            }
            if (voicename == "Bell Tree")
            {
                return MIDIDRUM_74_Long_Guiro;
            }
        }
        
        //If in doubt just return sum bass \:D/
        return 35;
    }
    
    public static function instrumentconverttomidi(t : Int) : Int
    //Converts Bosca Ceoil instrument to a similar Midi one.
    {
        
        return Control.voicelist.midimap[t];
    }
    
    #if targetDesktop
    public static var file : File;public static var stream : FileStream;
    #end
    
    public static var mididata : ByteArray;
    public static var resolution : Float;
    public static var signature : Float;
    public static var numnotes : Int;
    public static var numpatterns : Int;
    
    public static var midiFilter : FileFilter = new FileFilter("Standard MIDI File", "*.mid;*.midi;");
    
    public static var unmatchednotes : Array<Rectangle> = new Array<Rectangle>();
    public static var midinotes : Array<Rectangle> = new Array<Rectangle>();
    public static var channelinstrument : Array<Int> = new Array<Int>();
    public static var channelvolume : Array<Int> = new Array<Int>();
    public static var smfData : SMFData = new SMFData();
    
    //Stuff for exporting
    public static var tempbytes : ByteArray;
    public static var midiexporter : Midiexporter;

    public function new()
    {
    }
}

#end