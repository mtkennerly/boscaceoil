package co.sparemind.trackermodule;


class XMPatternCell
{
    public var note : Int = 0;
    public var instrument : Int = 0;
    public var volume : Int = 0;
    public var effect : Int = 0;
    public var effectParam : Int = 0;
    public function new(config : Dynamic = null)
    {
        if (config == null)
        {
            return;
        }
        
        note = config.note;
        instrument = config.instrument;
        volume = config.volume;
        effect = config.effect;
        effectParam = config.effectParam;
    }
    public function isEmpty() : Bool
    {
        return (note == 0 &&
        instrument == 0 &&
        volume == 0 &&
        effect == 0 &&
        effectParam == 0);
    }
}


