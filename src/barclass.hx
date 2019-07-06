import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.net.*;

class Barclass
{
    public function new()
    {
        for (i in 0...8)
        {
            channel.push(-1);
        }
        clear();
    }
    
    public function clear() : Void
    {
        for (i in 0...8)
        {
            channel[i] = -1;
        }
    }
    
    public var channel : Array<Int> = new Array<Int>();
}

