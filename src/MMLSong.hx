import flash.utils.IDataOutput;
import flash.geom.Rectangle;

class MMLSong
{
    private var instrumentDefinitions : Array<String>;
    private var mmlToUseInstrument : Array<String>;
    private var noteDivisions : Int = 4;
    private var bpm : Int = 120;
    private var lengthOfPattern : Int = 16;
    private var monophonicTracksForBoscaTrack : Array<Array<String>>;
    
    public function new()
    {
    }
    
    public function loadFromLiveBoscaCeoilModel() : Void
    {
        noteDivisions = control.barcount;
        bpm = control.bpm;
        lengthOfPattern = control.boxcount;
        
        var emptyBarMML : String = "\n// empty bar\n" + StringUtil.repeat("  r   ", lengthOfPattern) + "\n";
        var bar : Int;
        var patternNum : Int;
        var numberOfPatterns : Int = control.numboxes;
        
        instrumentDefinitions = new Array<String>();
        mmlToUseInstrument = new Array<String>();
        var i : Int = 0;
        while (i < control.numinstrument)
        {
            var boscaInstrument : Instrumentclass = control.instrument[i];
            if (boscaInstrument.type == 0)
            {
                //regular instrument, not a drumkit
                instrumentDefinitions[i] = _boscaInstrumentToMML(boscaInstrument, i);
                mmlToUseInstrument[i] = _boscaInstrumentToMMLUse(boscaInstrument, i);
            }
            else
            {
                instrumentDefinitions[i] = "#OPN@" + i + " { //drum kit placeholder\n" +
                        "4,6,\n" +
                        "31,15, 0, 9, 1, 0, 0,15, 0, 0\n" +
                        "31,20, 5,14, 5, 3, 0, 4, 0, 0\n" +
                        "31,10, 9, 9, 1, 0, 0,10, 0, 0\n" +
                        "31,22, 5,14, 5, 0, 1, 7, 0, 0};\n";
                mmlToUseInstrument[i] = _boscaInstrumentToMMLUse(boscaInstrument, i);
            }
            i++;
        }
        
        var monophonicTracksForBoscaPattern : Array<Array<String>> = new Array<Array<String>>();
        monophonicTracksForBoscaTrack = new Array<Array<String>>();
        for (track in 0...8)
        {
            var maxMonoTracksForBoscaTrack : Int = 0;
            bar = 0;
            while (bar < control.arrange.lastbar)
            {
                patternNum = control.arrange.bar[bar].channel[track];
                
                if (patternNum < 0)
                {
                    {bar++;
                        continue;
                    }
                }
                var monoTracksForBar : Array<String> = _mmlTracksForBoscaPattern(patternNum, control.musicbox);
                maxMonoTracksForBoscaTrack = Math.max(maxMonoTracksForBoscaTrack, monoTracksForBar.length);
                
                monophonicTracksForBoscaPattern[patternNum] = monoTracksForBar;
                bar++;
            }
            
            var outTracks : Array<String> = new Array<String>();
            for (monoTrackNo in 0...maxMonoTracksForBoscaTrack)
            {
                var outTrack : String = "\n";
                bar = 0;
                while (bar < control.arrange.lastbar)
                {
                    patternNum = control.arrange.bar[bar].channel[track];
                    if (patternNum < 0)
                    {
                        outTrack += emptyBarMML;
                        {bar++;
                            continue;
                        }
                    }
                    
                    monoTracksForBar = monophonicTracksForBoscaPattern[patternNum];
                    if (Lambda.has(monoTracksForBar, monoTrackNo))
                    {
                        outTrack += ("\n// pattern " + patternNum + "\n");
                        outTrack += monoTracksForBar[monoTrackNo];
                    }
                    else
                    {
                        outTrack += emptyBarMML;
                    }
                    bar++;
                }
                outTracks.push(outTrack);
            }
            monophonicTracksForBoscaTrack[track] = outTracks;
        }
    }
    
    public function writeToStream(stream : IDataOutput) : Void
    {
        var out : String = "";
        out += "/** Music Macro Language (MML) exported from Bosca Ceoil */\n";
        for (def in instrumentDefinitions)
        {
            out += def;
            out += "\n";
        }
        
        for (monoTracks in monophonicTracksForBoscaTrack)
        {
            if (monoTracks.length == 0)
            {
                continue;
            }  // don't bother printing entirely empty tracks  
            
            out += StringUtil.substitute("\n\n// === Bosca Ceoil track with up to {0} notes played at a time\n", monoTracks.length);
            
            for (monoTrack in monoTracks)
            {
                out +="\n// ---- track\n";
                
                // XXX: I thought note length would be something like (lengthOfPattern / noteDivisions) but I clearly misunderstand
                out += StringUtil.substitute("\nt{0} l{1} // timing (tempo and note length)\n", bpm, 16);
                
                out += monoTrack;
                out += ";\n";
            }
        }
        stream.writeMultiByte(out, "utf-8");
    }
    
    private function _mmlTracksForBoscaPattern(patternNum : Int, patternDefinitions : Array<Musicphraseclass>) : Array<String>
    {
        var tracks : Array<String> = new Array<String>();
        
        var pattern : Musicphraseclass = patternDefinitions[patternNum];
        var octave : Int = -1;
        
        for (place in 0...lengthOfPattern)
        {
            var notesInThisSlot : Array<String> = new Array<String>();
            var n : Int = 0;
            while (n < pattern.numnotes)
            {
                var note : Rectangle = pattern.notes[n];
                var noteStartingAt : Int = note.width;
                var sionNoteNum : Int = note.x;
                var noteLength : Int = note.y;
                var noteEndingAt : Int = as3hx.Compat.parseInt(noteStartingAt + noteLength - 1);
                
                var isNotePlaying : Bool = (noteStartingAt <= place) && (place <= noteEndingAt);
                
                if (!isNotePlaying)
                {
                    {n++;
                        continue;
                    }
                }
                
                var newOctave : Int = _octaveFromSiONNoteNumber(sionNoteNum);
                var mmlOctave : String = _mmlTransitionFromOctaveToOctave(octave, newOctave);
                var mmlNoteName : String = _mmlNoteNameFromSiONNoteNumber(sionNoteNum);
                var mmlSlur : String = ((noteEndingAt > place)) ? "& " : "  ";
                
                octave = newOctave;
                
                notesInThisSlot.push(mmlOctave + mmlNoteName + mmlSlur);
                n++;
            }
            while (notesInThisSlot.length > tracks.length)
            {
                var emptyTrackSoFar : String = StringUtil.repeat(emptyNoteMML, place);
                tracks.push(mmlToUseInstrument[pattern.instr] + "\n" + emptyTrackSoFar);
            }
            var emptyNoteMML : String = "  r   ";
            
            var track : Int = 0;
            while (track < tracks.length)
            {
                var noteMML : String;
                if (Lambda.has(notesInThisSlot, track))
                {
                    noteMML = notesInThisSlot[track];
                }
                else
                {
                    noteMML = emptyNoteMML;
                }
                tracks[track] += noteMML;
                track++;
            }
        }
        
        return tracks;
    }
    
    /**
		 * XXX: Duplicated from TrackerModuleXM (consider factoring out)
		 */
    private function _mmlNoteNameFromSiONNoteNumber(noteNum : Int) : String
    {
        var noteNames : Array<String> = ["c ", "c+", "d ", "d+", "e ", "f ", "f+", "g ", "g+", "a ", "a+", "b "];
        
        var noteName : String = noteNames[noteNum % 12];
        return noteName;
    }
    
    /**
		 * XXX: Duplicated from TrackerModuleXM (consider factoring out)
		 */
    private function _octaveFromSiONNoteNumber(noteNum : Int) : Int
    {
        var octave : Int = as3hx.Compat.parseInt(noteNum / 12);
        return octave;
    }
    
    private function _mmlTransitionFromOctaveToOctave(oldOctave : Int, newOctave : Int) : String
    {
        if (oldOctave == newOctave)
        {
            return "  ";
        }
        if ((oldOctave + 1) == newOctave)
        {
            return "< ";
        }
        if ((oldOctave - 1) == newOctave)
        {
            return "> ";
        }
        return "o" + newOctave;
    }
    
    private function _boscaInstrumentToMML(instrument : Instrumentclass, channel : Int) : String
    {
        return StringUtil.substitute("// instrument \"{0}\"\n{1}\n", instrument.name, instrument.voice.getMML(channel));
    }
    
    private function _boscaInstrumentToMMLUse(instrument : Instrumentclass, channel : Int) : String
    {
        return StringUtil.substitute("%6@{0} v{1} @f{2},{3}", channel, as3hx.Compat.parseInt(instrument.volume / 16), instrument.cutoff, instrument.resonance);
    }
}
