import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.net.*;

class Listclass
{
    public function new()
    {
        for (i in 0...30)
        {
            item.push("");
        }
        clear();
    }
    
    public function clear() : Void
    {
        numitems = 0;
        active = false;
        x = 0;y = 0;
        selection = -1;
    }
    
    public function init(xp : Int, yp : Int) : Void
    {
        x = xp;y = yp;active = true;
        getwidth();
        h = as3hx.Compat.parseInt(numitems * gfx.linesize);
    }
    
    public function close() : Void
    {
        active = false;
    }
    
    public function getwidth() : Void
    {
        w = 0;
        var temp : Int;
        for (i in 0...numitems)
        {
            temp = gfx.len(item[i]);
            if (w < temp)
            {
                w = temp;
            }
        }
        w += 10;
    }
    
    public var item : Array<String> = new Array<String>();
    public var numitems : Int;
    public var active : Bool;
    public var x : Int;public var y : Int;public var w : Int;public var h : Int;
    public var type : Int;
    public var selection : Int;
}

