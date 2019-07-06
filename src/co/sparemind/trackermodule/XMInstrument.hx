package co.sparemind.trackermodule;

import flash.utils.ByteArray;
import flash.utils.Endian;


class XMInstrument
{
    public var name(get, set) : String;

    
    
    
    private var _name : ByteArray;
    public var volume : Int = 40;
    public var samples : Array<XMSample> = new Array<XMSample>();
    public var keymapAssignments : Array<Int> = [
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        ];
    
    public function new()
    {
        _name = new ByteArray();
        _name.endian = Endian.LITTLE_ENDIAN;
        this.name = "                      ";
    }
    
    public function addSample(sample : XMSample) : Void
    {
        samples.push(sample);
    }
    
    /**
		 * XM only seems to support 16 samples per instrument
		 * so this silently discards any past that.
		 */
    public function addSamples(extraSamples : Array<XMSample>) : Void
    {
        samples = samples.concat(extraSamples).slice(0, 16);
    }
    
    private function get_name() : String
    {
        return Std.string(_name);
    }
    private function set_name(unpadded : String) : String
    {
        _name.clear();
        _name.writeMultiByte(unpadded.substring(0, 22), "us-ascii");
        for (i in _name.length...22)
        {
            _name.writeByte(0x20);
        }
        return unpadded;
    }
}



