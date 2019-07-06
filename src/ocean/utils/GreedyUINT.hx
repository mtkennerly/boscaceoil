/**
* ...
*/

package ocean.utils;

import flash.errors.Error;
import flash.utils.ByteArray;
import flash.errors.EOFError;

class GreedyUINT
{
    public var value(get, set) : Int;
    public var rawBytes(get, set) : ByteArray;
    public var length(get, never) : Int;

    //*	MEMBERS//////////////////////////////////////////////////////
    
    private var _rawBytes : ByteArray;
    //*	PROPERTIES///////////////////////////////////////////////////
    
    /**
		* The value of GreedyUINT as uint.
		*/
    private function get_value() : Int
    {
        _rawBytes.position = 0;
        if (0 == _rawBytes.length)
        {
            throw new Error("value is not defined");
        }
        
        var n : Int;
        // value = (128^e)*b1+(128^e-1)*b2+....(128^0)*bn;
        var e : Int = as3hx.Compat.parseInt(_rawBytes.length - 1);
        while (e >= 0)
        {
            n += as3hx.Compat.parseInt(_rawBytes.readByte() & 0x7F) << as3hx.Compat.parseInt(7 * e);
            e--;
        }
        if (n == Infinity || n == -Infinity)
        {
            throw new Error("value is beyond uint infinity");
        }
        return n;
    }
    
    /**
		* Set the value of GreedyUINT with uint.
		* @param	n
		* @return
		*/
    private function set_value(n : Int) : Int
    {
        _rawBytes.position = 0;
        var e : Int;
        var t : Int;
        var temp : Array<Dynamic> = new Array<Dynamic>();
        // bytes =[ n/(128^e)%128 | 0x80 , n/(128^e-1)%128 | 0x80 , ... n/(128^0)%128 ];
        if (0 != n)
        {
            e = 0;
t = n >> as3hx.Compat.parseInt(7 * e);
            while (t >= 1 && e < 5)
            
            //变长整数最后一个字节高bit位为0。其他字节高bit位为1，低七位是余数对128求模{
                
                // tips:If the divisor is a power of 2, the modulo (%) operation can be done with:
                //	modulus = numerator & (divisor - 1);
                temp[e] = (e != 0) ? (t & as3hx.Compat.parseInt(128 - 1) | 0x80) : n & as3hx.Compat.parseInt(128 - 1);  //temp[e] = e?( t%128 | 0x80 ): n%128;  
                
                // 余数为整数除以128的e次方
                t = n >> as3hx.Compat.parseInt(7 * (++e));
            }
        }
        else
        {
            temp[0] = 0;
        }
        _rawBytes.length = e = temp.length;
        while (e > 0)
        {
            _rawBytes.writeByte(temp[e - 1]);
            e--;
        }
        return n;
    }
    
    /**
		* RawBytes value in ByteArray format
		*/
    private function get_rawBytes() : ByteArray
    {
        _rawBytes.position = 0;
        return _rawBytes;
    }
    /**
		* set property rawBytes with input byteArray, this method will not effect the position of the coming byteArray.
		* @param	raw
		* @return
		*/
    private function set_rawBytes(raw : ByteArray) : ByteArray
    {
        _rawBytes.position = 0;
        _rawBytes.length = 0;
        if (check(raw))
        {
            _rawBytes.writeBytes(raw);
            _rawBytes.position = 0;
        }
        else
        {
            throw new Error("input byteArrary is not a valid GreedyUINT");
        }
        return raw;
    }
    //*	METHODS//////////////////////////////////////////////////////
    
    /**
		* GreedyUINT is length flexible unsigned int type. 
		* When value a greedy uint, the high bit of the last byte is 0, other byte's high bit is 1. 
		* Each 7 bits equals the remainder moded by 128. 
		* <p><code>bytes = [ n/(128<sup>p</sup>)%128 | 0x80 , 
		* n/(128<sup>p-1</sup>)%128 | 0x80 , ... n/(128<sup>0</sup>)%128 ];</code></p>
		* @param	raw bytes to convert into greedy uint, if null creates a 0. 
		* @author Efishocean
		* @version 1.0.0
		* fixed the byteArray position to zero in every function's first line 2007-7-25 11:58
		*/
    public function new(raw : ByteArray = null)
    {
        _rawBytes = new ByteArray();
        if (null == raw)
        {
            _rawBytes[0] = 0;
        }
        else if (check(raw))
        {
            _rawBytes.writeBytes(raw);
        }
        else
        {
            throw new Error("input byteArrary is not a valid GreedyUINT");
        }
    }
    
    /**
		* Checks if the input raw datas are valid greedyUINT
		* @param	raw bytes
		* @return valid or not.
		* @ 2007-7-18 23:08
		*/
    public function check(raw : ByteArray) : Bool
    {
        if (null == raw)
        {
            return false;
        }
        var len : Int = raw.length;
        //变长只处理小于4294967295的数，这个范围内可以用小于5个字节的变长表示
        if (len > 5 || len <= 0)
        {
            return false;
        }
        //变长整数最后一字节8bit位为零
        if ((raw[len - 1] & 0x80) != 0x00)
        {
            return false;
        }
        //前面字节的8bit位为'1'
        else
        {
            var i : Int = 0;
            while (i < len - 1)
            {
                if ((raw[i] & 0x80) != 0x80)
                {
                    return false;
                }
                i++;
            }
        }
        return true;
    }
    
    /**
		* Copies greedy uint from stream obay the valid format. this method will push the position of stream forward.
		* @param raw bytes stream
		* @see #GreedyUINT()
		*/
    public function stream(raw : ByteArray) : Void
    {
        _rawBytes.position = 0;
        _rawBytes.length = 0;
        var temp : Int;
        
        do
        
        //从流中读出一字节{
            
            try
            {
                temp = raw.readByte();
            }
            catch (e : EOFError)
            {
                throw new Error("End of File Error! Not enough bytes to read.");
            }  //写入字节  
            
            _rawBytes.writeByte(temp);
        }
        while (((temp & 0x80) != 0x00 && _rawBytes.length <= 5));
        if (_rawBytes.length == 6)
        {
            throw new Error("can't deal with uint value beyond 4294967295. This stream is not countable .");
        }
    }
    
    /**
		* The length of greedy uint in bytes
		*/
    private function get_length() : Int
    {
        return rawBytes.length;
    }
}


