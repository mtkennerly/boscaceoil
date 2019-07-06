package co.sparemind.trackermodule;


class XMPatternLine
{
    public var cellOnTrack : Array<XMPatternCell>;
    
    public function new(numtracks : Int)
    {
        cellOnTrack = new Array<XMPatternCell>();
        for (i in 0...numtracks)
        {
            cellOnTrack[i] = new XMPatternCell();
        }
    }
}

