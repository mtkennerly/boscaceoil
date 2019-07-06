import flash.utils.IDataOutput;
import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.geom.Rectangle;
import org.si.sion.SiONDriver;
import org.si.sion.SiONVoice;
import co.sparemind.trackermodule.XMSong;
import co.sparemind.trackermodule.XMInstrument;
import co.sparemind.trackermodule.XMSample;
import co.sparemind.trackermodule.XMPattern;
import co.sparemind.trackermodule.XMPatternLine;
import co.sparemind.trackermodule.XMPatternCell;

class TrackerModuleXM
{
    public function new()
    {
    }
    
    public var xm : XMSong;
    
    public function loadFromLiveBoscaCeoilModel(desiredSongName : String) : Void
    {
        var boscaInstrument : Instrumentclass;
        
        xm = new XMSong();
        
        xm.songname = desiredSongName;
        xm.defaultBPM = control.bpm;
        xm.defaultTempo = as3hx.Compat.parseInt(control.bpm / 20);
        xm.numChannels = 8;  // bosca has a hard-coded limit  
        xm.numInstruments = control.numinstrument;
        
        var notesByEachInstrumentNumber : Array<Array<Int>> = _notesUsedByEachInstrumentAcrossEntireSong();
        
        // map notes to other notes (mostly for drums)
        var perInstrumentBoscaNoteToXMNoteMap : Array<Array<Int>> = new Array<Array<Int>>();
        i = 0;
        while (i < control.numinstrument)
        {
            boscaInstrument = control.instrument[i];
            var boscaNoteToXMNoteMapForThisInstrument : Array<Int> = _boscaNoteToXMNoteMapForInstrument(boscaInstrument, notesByEachInstrumentNumber[i]);
            perInstrumentBoscaNoteToXMNoteMap[i] = boscaNoteToXMNoteMapForThisInstrument;
            i++;
        }
        
        // pattern arrangement
        var i : Int = 0;
        while (i < control.arrange.lastbar)
        {
            var xmpat : XMPattern = xmPatternFromBoscaBar(i, perInstrumentBoscaNoteToXMNoteMap);
            xm.patterns.push(xmpat);
            xm.patternOrderTable[i] = i;
            xm.numPatterns++;
            xm.songLength++;
            i++;
        }
        
        i = 0;
        while (i < control.numinstrument)
        {
            boscaInstrument = control.instrument[i];
            var xmInstrument : XMInstrument = new XMInstrument();
            var notesUsed : Array<Int> = notesByEachInstrumentNumber[i];
            xmInstrument.name = boscaInstrument.name;
            xmInstrument.volume = as3hx.Compat.parseInt(boscaInstrument.volume / 4);
            var _sw3_ = (boscaInstrument.type);            

            switch (_sw3_)
            {
                case 0:
                    xmInstrument.addSample(_boscaInstrumentToXMSample(boscaInstrument, control._driver));
                default:
                    // XXX: bosca ceoil drumkits are converted lossily to a single XM
                    // instrument, but they could be converted to several instruments.
                    var drumkitNumber : Int = as3hx.Compat.parseInt(boscaInstrument.type - 1);
                    xmInstrument.addSamples(_boscaDrumkitToXMSamples(control.drumkit[drumkitNumber], notesUsed, perInstrumentBoscaNoteToXMNoteMap[i], control._driver));
                    var s : Int = 0;
                    while (s < notesUsed.length)
                    {
                        var sionNote : Int = notesUsed[s];
                        var key : Int = as3hx.Compat.parseInt(perInstrumentBoscaNoteToXMNoteMap[i][sionNote] - 1);  // 0th key is note 1  
                        xmInstrument.keymapAssignments[key] = s;
                        s++;
                    }
                    
                    for (sample/* AS3HX WARNING could not determine type for var: sample exp: EField(EIdent(xmInstrument),samples) type: null */ in xmInstrument.samples)
                    {
                        sample.volume = xmInstrument.volume;
                    }
            }
            
            xm.addInstrument(xmInstrument);
            i++;
        }
    }
    
    public function writeToStream(stream : IDataOutput) : Void
    {
        xm.writeToStream(stream);
    }
    
    public function _notesUsedByEachInstrumentAcrossEntireSong() : Array<Array<Int>>
    {
        var seenNotePerInstrument : Array<Dynamic> = [];
        var i : Int;
        var n : Int;
        
        // start with a clear 2d array
        i = 0;
        while (i < control.numinstrument)
        {
            seenNotePerInstrument[i] = [];
            i++;
        }
        
        // build a 2d sparse boolean array of notes used
        i = 0;
        while (i < control.numboxes)
        {
            var box : Musicphraseclass = control.musicbox[i];
            var instrumentNum : Int = box.instr;
            
            n = 0;
            while (n < box.numnotes)
            {
                var noteNum : Int = box.notes[n].x;
                seenNotePerInstrument[instrumentNum][noteNum] = true;
                n++;
            }
            i++;
        }
        
        // map the sparse boolean array into a list of list of ints
        var notesUsedByEachInstrument : Array<Array<Int>> = new Array<Array<Int>>();
        i = 0;
        while (i < seenNotePerInstrument.length)
        {
            var notesUsedByThisInstrument : Array<Int> = new Array<Int>();
            n = 0;
            while (n < seenNotePerInstrument[i].length)
            {
                if (seenNotePerInstrument[i][n] != null)
                {
                    notesUsedByThisInstrument.push(n);
                }
                n++;
            }
            notesUsedByEachInstrument.push(notesUsedByThisInstrument);
            i++;
        }
        
        return notesUsedByEachInstrument;
    }
    
    private function xmPatternFromBoscaBar(barNum : Int, instrumentNoteMap : Array<Array<Int>>) : XMPattern
    {
        var numtracks : Int = 8;
        var numrows : Int = control.boxcount;
        var pattern : XMPattern = new XMPattern(numrows);
        var rows : Array<XMPatternLine> = pattern.rows;
        // 	var lineAllNotesOff = [];
        // 	for (var i:uint = 0; i < numtracks; i++) {
        // 		lineAllNotesOff.push({
        // 			note: 97,
        // 			instrument: 0,
        // 			volume: 0,
        // 			effect: 0,
        // 			effectParam: 0
        // 		});
        // 	}
        // 	rows.push(lineAllNotesOff.slice(0));
        for (rowToBlank in 0...numrows)
        {
            rows[rowToBlank] = new XMPatternLine(numtracks);
        }
        // ----------
        for (i in 0...numtracks)
        {
            var whichbox : Int = control.arrange.bar[barNum].channel[i];
            if (whichbox < 0)
            {
                continue;
            }
            var box : Musicphraseclass = control.musicbox[whichbox];
            
            var notes : Array<Rectangle> = box.notes;
            var j : Int = 0;
            while (j < box.numnotes)
            {
                var boscaNote : Rectangle = notes[j];
                var timerelativetostartofbar : Int = boscaNote.width;  // yes, it's called width. whatever.  
                var notelength : Int = boscaNote.y;
                var xmnote : XMPatternCell = boscaBoxNoteToXMNote(box, j, instrumentNoteMap);
                
                // find a clear place to write
                var targetTrack : Int = i;
                while (rows[timerelativetostartofbar].cellOnTrack[targetTrack].note > 0)
                {
                    // track is busy (eg drum hits at once, chords)
                    targetTrack++;
                    if (!(targetTrack < numtracks))
                    {
                        // too much going on, just ignore this note
                        {j++;
                            continue;
                        }
                    }
                }
                
                rows[timerelativetostartofbar].cellOnTrack[targetTrack] = xmnote;
                var endrow : Int = as3hx.Compat.parseInt(timerelativetostartofbar + notelength);
                if (endrow >= numrows)
                {
                    {j++;
                        continue;
                    }
                }
                if (rows[endrow].cellOnTrack[targetTrack].note > 0)
                {
                    {j++;
                        continue;
                    }
                }  // someone else is already starting to play  
                rows[endrow].cellOnTrack[targetTrack] = new XMPatternCell({
                            note : 97,
                            instrument : 0,
                            volume : 0,
                            effect : 0,
                            effectParam : 0
                        });
                j++;
            }
        }
        return pattern;
    }
    
    private function boscaBoxNoteToXMNote(box : Musicphraseclass, notenum : Int, noteMapping : Array<Array<Int>>) : XMPatternCell
    {
        var sionNoteNum : Int = box.notes[notenum].x;
        var xmNoteNum : Int = noteMapping[box.instr][sionNoteNum];
        return new XMPatternCell(
        {
            note : xmNoteNum,
            instrument : box.instr + 1,
            volume : 0,
            effect : 0,
            effectParam : 0
        });
    }
    
    private function _boscaNoteToXMNoteMapForInstrument(boscaInstrument : Instrumentclass, usefulNotes : Array<Int>) : Array<Int>
    {
        if (boscaInstrument.type > 0)
        {
            return _boscaDrumkitToXMNoteMap(usefulNotes);
        }
        
        return _boscaNoteToXMNoteMapLinear();
    }
    
    private function _boscaNoteToXMNoteMapLinear() : Array<Int>
    {
        var map : Array<Int> = new Array<Int>();
        for (scionNote in 0...127)
        {
            var maybeXMNote : Int = as3hx.Compat.parseInt(scionNote + 13);
            var xmNote : Int;
            if (maybeXMNote < 1)
            {
                // too low for XM
                map[scionNote] = 0;
                continue;
            }
            if (maybeXMNote > 96)
            {
                // too high for XM
                map[scionNote] = 0;
                continue;
            }
            map[scionNote] = maybeXMNote;
        }
        return map;
    }
    
    private function _boscaDrumkitToXMNoteMap(necessaryNotes : Array<Int>) : Array<Int>
    {
        var map : Array<Int> = new Array<Int>();
        var startAt : Int = 49;  // 1 = low C, 49 = middle C, 96 = highest B  
        var scionNote : Int;
        var offset : Int;
        
        // start with a clear map for the unused notes
        for (scionNote in 0...128)
        {
            map[scionNote] = 0;
        }
        
        // fill up the used notes in the middle where sampling doesn't change
        // much
        offset = 0;
        while (offset < necessaryNotes.length)
        {
            var necessaryNote : Int = necessaryNotes[offset];
            var xmNote : Int = as3hx.Compat.parseInt(startAt + offset);
            map[necessaryNote] = xmNote;
            offset++;
        }
        
        return map;
    }
    
    // bosca drumkits can be much larger than a single XM instrument
    // and an XM instrument can only have one "relative note" setting all
    // samples.
    //
    private function _boscaDrumkitToXMSamples(drumkit : Drumkitclass, whichDrumNumbers : Array<Int>, noteMapping : Array<Int>, driver : SiONDriver) : Array<XMSample>
    {
        var samples : Array<XMSample> = new Array<XMSample>();
        var di : Int = 0;
        while (di < whichDrumNumbers.length)
        {
            var d : Int = whichDrumNumbers[di];
            var voice : SiONVoice = drumkit.voicelist[d];
            var samplename : String = drumkit.voicename[d];
            var sionNoteNum : Int = drumkit.voicenote[d];
            var xmNoteNum : Int = noteMapping[sionNoteNum];
            
            var compensationNeeded : Int = 0;  //49 - xmNoteNum;  
            
            var xmsample : XMSample = new XMSample();
            xmsample.relativeNoteNumber = 0;
            xmsample.name = voice.name;
            xmsample.volume = 0x40;
            xmsample.bitsPerSample = 16;
            xmsample.data = _playSiONNoteTo16BitDeltaSamples(sionNoteNum + compensationNeeded, voice, 32, driver);
            
            samples.push(xmsample);
            di++;
        }
        return samples;
    }
    
    private function _boscaInstrumentToXMSample(instrument : Instrumentclass, driver : SiONDriver) : XMSample
    {
        var voice : SiONVoice = instrument.voice;
        var xmsample : XMSample = new XMSample();
        xmsample.relativeNoteNumber = 3;
        xmsample.name = voice.name;
        xmsample.volume = 0x40;
        xmsample.bitsPerSample = 16;
        
        // consider voice.preferableNote
        var c5 : Int = 60;
        
        xmsample.data = _playSiONNoteTo16BitDeltaSamples(c5, voice, 16, driver);
        trace(xmsample);
        return xmsample;
    }
    
    private function _playSiONNoteTo16BitDeltaSamples(note : Int, voice : SiONVoice, length : Float, driver : SiONDriver) : ByteArray
    {
        var deltasamples : ByteArray = new ByteArray();
        deltasamples.endian = Endian.LITTLE_ENDIAN;
        
        // XXX: Interferes with regular playback. Find a more reliable way.
        // driver.renderQueue() might work
        driver.stop();
        
        var renderBuffer : Array<Float> = new Array<Float>();
        // XXX: only works for %6 (FM synth) voices.
        // theoretically voice.moduleType is 6 for FM and switchable
        var mml : String = voice.getMML(voice.channelNum) + " %6," + voice.channelNum + "@" + voice.toneNum + " " + _mmlNoteFromSiONNoteNumber(note);  // theoretically, command 'n60' plays note 60  
        trace(mml);
        driver.render(mml, renderBuffer, 1);
        
        // delta encoding algorithm that module formats like XM use
        var previousSample : Int = 0;
        var i : Int;
        while (i < renderBuffer.length)
        {
            var thisSample : Int = as3hx.Compat.parseInt(renderBuffer[i] * 32767);  // signed float to 16-bit signed int  
            var sampleDelta : Int = as3hx.Compat.parseInt(thisSample - previousSample);
            deltasamples.writeShort(sampleDelta);
            previousSample = thisSample;
            i++;
        }
        driver.play();
        
        return deltasamples;
    }
    
    /**
		 *
		 * I'm sure there's a better way to do this (eg maybe there's an MML
		 * command for "play note number").
		 */
    private function _mmlNoteFromSiONNoteNumber(noteNum : Int) : String
    {
        var noteNames : Array<String> = ["c", "c+", "d", "d+", "e", "f", "f+", "g", "g+", "a", "a+", "b"];
        
        var octave : Int = as3hx.Compat.parseInt(noteNum / 12);
        var noteName : String = noteNames[noteNum % 12];
        return "o" + octave + noteName;
    }
}


