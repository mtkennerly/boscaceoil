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

package ocean.midi.controller;

import haxe.Constraints.Function;
import de.polygonal.ds.DLinkedList;
import de.polygonal.ds.DListIterator;
import flash.events.Event;
import flash.events.EventDispatcher;
import ocean.midi.model.MetaItem;
import ocean.midi.model.NoteItem;
import ocean.midi.model.MessageItem;
import ocean.midi.model.MessageList;
import ocean.midi.MidiEnum;
import ocean.midi.InvalidMidiError;
import ocean.midi.event.MvcEvent;
import ocean.midi.controller.History;

/**
	* TrackEditor class controlls one track specified by the setter 'activeMsgList'
	*
	* Each track utilies a single messageListEditor instance,
	* cause it provides undo and redo method just on one certain file.
	*
	* Some methods invoke the execute method,
	* which stores the references of changed items into two array, the 'after' and 'before'.
	*
	* The methods execute, undo and redo will invoke update subsequence.
	* During update processing, updateA and updateB refer to the provided arrA and arrB,
	* and have their marks of items swtiched,
	* then sent an "update" event to notify the relative views to redraw these items.
	*
	* This means each time when updating occurs,
	* some old items may be deactivated, and some new items may be created and pushed into current list.
	* The relative views should redraw these special old items and new items
	* @author EfishOcean 2007-8-7 22:51
	* @version 0.1
	*/
class TrackEditor extends EventDispatcher
{
    public var activeMsgList(get, set) : MessageList;
    private var _history(get, never) : Int;

    //
    private var _activeMsgList : MessageList;
    private var _globalHistory : History;
    private var _stack : DLinkedList;
    private var _itr : DListIterator;
    public var pending : Array<Dynamic>;
    
    /**
		* Edits midi track
		* @param messageList Midi event messages.
		* @see ocean.midi.model.MessageList
		*/
    public function new(messageList : MessageList = null)
    {
        super();
        
        if (messageList != null)
        {
            _activeMsgList = messageList;
        }
        else
        {
            _activeMsgList = new MessageList();
        }
        _globalHistory = History.getHistory();
        _stack = _globalHistory.stack;
        
        _itr = _globalHistory.iterator;
    }
    
    /**
		 * The activeMsgList
		 */
    private function set_activeMsgList(msgList : MessageList) : MessageList
    {
        if (msgList != null)
        {
            _activeMsgList = msgList;
        }
        else
        {
            throw new InvalidMidiError("set midi message list error, midi track is invalid");
        }
        dispatchEvent(new MvcEvent(MvcEvent.APPLY_TRACK));
        return msgList;
    }
    
    /**
		 * The active message List in editing.
		 */
    private function get_activeMsgList() : MessageList
    {
        return _activeMsgList;
    }
    
    private function get__history() : Int
    {
        return _globalHistory.size;
    }
    
    /**
		* Clones items from list, and form a new messageList
		* @param	list Active message list.
		* @return	the new messageList.
		* @see ocean.midi.model.MessageList
		*/
    public function copy(list : MessageList) : MessageList
    {
        var msgList : MessageList = new MessageList();
        //find the min time
        var min : Int = 0;
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(list) type: MessageList */ in list)
        {
            if (item.mark)
            {
                min = (min < item.timeline) ? min : item.timeline;
                // clone item
                msgList.push(item.clone());
            }
        }
        
        //fix each item's timeline, however the 1st item's timeline should be zero.
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(msgList) type: MessageList */ in msgList)
        {
            item.timeline -= min;
        }
        return msgList;
    }
    
    /**
		* Cuts some items from 'list' , and return a new messageList
		* @param	list Active message list.
		* @return	Reference of active message list.
		* @see ocean.midi.model.MessageList
		*/
    public function cut(list : MessageList) : MessageList
    {
        var msgList : MessageList = copy(list);
        erase(list);
        return msgList;
    }
    
    
    /**
		* Apply filter on message list. An example filter is defined in pan method as closure fucntion.
		* @param	selected All items in selected list should be selected note-item's reference
		* @param	filter Function that can modify the items in eventlist.
		* 			A proper filter should like the following: 
		* <listing version="3.0">function tuneFilter( msg:EventItem , [args] ):void{;}</listing>
		* @param	...args More arguments.
		* 			<p>WARNING! if the filter is modifying the timeline of item, it should pass the
		* 			_end-of-track item as arguments and fix it.</p>
		* @see ocean.midi.model.MessageList
		*/
    public function applyFilter(selected : MessageList, filter : Function, args : Array<Dynamic> = null) : Void
    {
        var after : Array<Dynamic> = new Array<Dynamic>();
        var temp : MessageItem;
        var item : MessageItem;
        
        //use selfFeedBackSecurity is because:
        //if the 'filter' callback invokes selected as args, will also cause problems.
        //for example: filter descrease the length of selected, item may point at undefined position.
        var selfFeedbackSecurity : Array<Dynamic> = new Array<Dynamic>();
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(selected) type: MessageList */ in selected)
        {
            temp = item.clone();
            // abandon old items
            item.mark = false;
            after.push(item);
            selfFeedbackSecurity.push(temp);
        }
        
        //don't use for each here, because selected is part of _activeMsgList.
        var i : Int = selfFeedbackSecurity.length;
        while (i > 0)
        {
            temp = selfFeedbackSecurity[i - 1];
            // add new items
            filter(temp, args);
            _activeMsgList.push(temp);
            after.push(temp);
            i--;
        }
        execute(after);
    }
    
    
    /**
		* Pans a block of selected items.  
		* @param	list @see ocean.midi.model.MessageList
		* @param	v Vertical panning pitch.
		* @param	h Horizontal panning timeline.
		*/
    public function pan(list : MessageList, v : Int = 0, h : Int = 0) : Void
    {
        if (v != 0 || h != 0)
        {
            var filter : Function = function(item : MessageItem, args : Array<Dynamic>) : Void
            //pan the timeline
            {
                
                if ((item.timeline + args[1]) < 0)
                {
                    item.timeline = 0;
                }
                else
                {
                    item.timeline += args[1];
                }
                if (Std.is(item, NoteItem))
                
                //max key is G#10{
                    
                    if (((try cast(item, NoteItem) catch(e:Dynamic) null).pitch + args[0]) > 0x7F)
                    {
                        (try cast(item, NoteItem) catch(e:Dynamic) null).pitch = 0x7F;
                    }
                    //min key is C
                    else if (((try cast(item, NoteItem) catch(e:Dynamic) null).pitch + args[0]) < 0x00)
                    {
                        (try cast(item, NoteItem) catch(e:Dynamic) null).pitch = 0x00;
                    }
                    //pan the pitch
                    else
                    {
                        
                        (try cast(item, NoteItem) catch(e:Dynamic) null).pitch += args[0];
                    }
                }
            }
            this.applyFilter(list, filter, v, h);
        }
    }
    
    
    /**
		* Inserts a message to the track. Don't alter following messages's deltatime
		* @param	atTime Time position to insert .
		* @param	item @see ocean.midi.model.MessageItem 
		*/
    public function insertMessage(atTime : Int, item : MessageItem) : Void
    {
        var after : Array<Dynamic> = new Array<Dynamic>();
        var temp : MessageItem;
        
        temp = item.clone();
        temp.timeline = atTime;
        temp.mark = true;
        after.push(temp);
        
        // temp list, later concat to _activeMsgList
        var tempList : MessageList = new MessageList();
        tempList.push(temp);
        
        //maxtimeline+maxduration - atTime indecates slide
        var slide : Int = ((Std.is(temp, NoteItem))) ? (try cast(temp, NoteItem) catch(e:Dynamic) null).duration : 0;
        
        // fixed the _end-of-track item
        ////_end.timeline += slide;
        
        if (Std.is(temp, NoteItem))
        
        //slide old, and form a abandoned array{
            
            for (it/* AS3HX WARNING could not determine type for var: it exp: EIdent(_activeMsgList) type: MessageList */ in _activeMsgList)
            
            // _end is always not in undo-redo stack{
                
                if (it.mark)
                {
                    if (it.timeline >= atTime)
                    
                    // slide cloned item{
                        
                        temp = it.clone();
                        temp.timeline += slide;
                        
                        // new item
                        temp.mark = true;
                        
                        //old item
                        it.mark = false;
                        
                        // add new item
                        tempList.push(temp);
                        
                        // record added item
                        after.push(temp);
                        
                        // record abandoned item
                        after.push(it);
                    }
                }
            }
        }
        //add new items
        for (_it/* AS3HX WARNING could not determine type for var: _it exp: EIdent(tempList) type: MessageList */ in tempList)
        {
            _activeMsgList.push(_it);
        }
        
        execute(after);
    }
    /**
		 * paste a message to the track. alter the following message's deltatime. Erase it if collision detected.
		 * @param	atTime Time position to paste.
		 * @param	item @see ocean.midi.model.MessageItem 
		 */
    public function pasteMessage(atTime : Int, item : MessageItem) : Void
    {
        var after : Array<Dynamic> = new Array<Dynamic>();
        var temp : MessageItem;
        temp = item.clone();
        temp.timeline = atTime;
        temp.mark = true;
        after.push(temp);
        
        //note's time line between new item's duration is abandoned.
        if (Std.is(temp, NoteItem))
        {
            for (it/* AS3HX WARNING could not determine type for var: it exp: EIdent(_activeMsgList) type: MessageList */ in _activeMsgList)
            {
                if (it.kind == MidiEnum.NOTE && it.timeline >= atTime && it.timeline < (atTime + (try cast(temp, NoteItem) catch(e:Dynamic) null).duration))
                {
                    it.mark = false;
                    after.push(it);
                }
            }
        }
        //add new item
        _activeMsgList.push(temp);
        
        execute(after);
    }
    
    /**
		 * Merge a message to the track. alter the following message's deltatime. make it stable.		
		 * @param	atTime Time position to insert .
		 * @param	item @see ocean.midi.model.MessageItem 
		 */
    public function mergeMessage(atTime : Int, item : MessageItem) : Void
    {
        var after : Array<Dynamic> = new Array<Dynamic>();
        var temp : MessageItem;
        temp = item.clone();
        temp.timeline = atTime;
        temp.mark = true;
        _activeMsgList.push(temp);
        after.push(temp);
        execute(after);
    }
    
    /**
		 * Erases a message, specified by index in messageList
		 * @param item to be erased.
		 * @return the erased item
		 */
    public function eraseMessage(item : MessageItem) : Void
    {
        var after : Array<Dynamic> = new Array<Dynamic>();
        item.mark = false;
        after.push(item);
        execute(after);
    }
    
    /**
		* Insert a track fragment into the track at special time.
		* @param	atTime postion to insert.
		* @param list to be inserted.
		* @see ocean.midi.model.MessageList
		*/
    public function insert(atTime : Int, list : MessageList) : Void
    {
        var after : Array<Dynamic> = new Array<Dynamic>();
        var slide : Int = 0;
        var temp : MessageItem;
        var tempList : MessageList = new MessageList();
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(list) type: MessageList */ in list)
        {
            if (item.mark)
            
            // clone an item{
                
                temp = item.clone();
                
                // fix timeline of lst
                temp.timeline += atTime;
                
                if (Std.is(item, NoteItem))
                
                // max timeline in list{
                    
                    slide = ((slide > (temp.timeline + (try cast(temp, NoteItem) catch(e:Dynamic) null).duration))) ? slide : (temp.timeline + (try cast(temp, NoteItem) catch(e:Dynamic) null).duration);
                }
                
                // new item
                temp.mark = true;
                
                // add new item
                tempList.push(temp);
                
                // record action
                after.push(temp);
            }
        }
        
        //maxtimeline+maxduration - atTime indecates slide
        slide -= atTime;
        
        //slide old, and form a abandoned array
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(_activeMsgList) type: MessageList */ in _activeMsgList)
        {
            if (item.mark)
            {
                if (item.timeline >= atTime)
                
                // slide cloned item{
                    
                    temp = item.clone();
                    temp.timeline += slide;
                    
                    // new item
                    temp.mark = true;
                    
                    //old item
                    item.mark = false;
                    
                    // add new item
                    tempList.push(temp);
                    
                    // record added item
                    after.push(temp);
                    
                    // record abandoned item
                    after.push(item);
                }
            }
        }
        
        //add new items
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(tempList) type: MessageList */ in tempList)
        {
            _activeMsgList.push(item);
        }
        
        execute(after);
    }
    
    /**
		* Replaces a list of items where the timeline is map the range of list
		* @param	atTime position to be replaced with new.
		* @param	list to be replaced
		* @see ocean.midi.model.MessageList
		*/
    public function paste(atTime : Int, list : MessageList) : Void
    {
        var after : Array<Dynamic> = new Array<Dynamic>();
        var max : Int = 0;
        var temp : MessageItem;
        var tempList : MessageList = new MessageList();
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(list) type: MessageList */ in list)
        {
            if (item.mark)
            
            // clone an item{
                
                temp = item.clone();
                
                // fix timeline
                temp.timeline += atTime;
                
                if (item.kind == MidiEnum.NOTE)
                
                // max timeline in list{
                    
                    max = ((max > (temp.timeline + (try cast(temp, NoteItem) catch(e:Dynamic) null).duration))) ? max : (temp.timeline + (try cast(temp, NoteItem) catch(e:Dynamic) null).duration);
                }
                else
                {
                    max = (max > temp.timeline) ? max : temp.timeline;
                }
                
                //new item
                temp.mark = true;
                
                // add new item to tempList
                tempList.push(temp);
                
                // record action
                after.push(temp);
            }
        }
        
        //form a abandoned array
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(_activeMsgList) type: MessageList */ in _activeMsgList)
        {
            if (item.mark)
            {
                if (item.kind == MidiEnum.NOTE && item.timeline >= atTime && item.timeline < max)
                
                //old item{
                    
                    item.mark = false;
                    
                    // record action
                    after.push(item);
                }
            }
        }
        // add new items
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(tempList) type: MessageList */ in tempList)
        {
            _activeMsgList.push(item);
        }
        
        execute(after);
    }
    
    /**
		* Merge activeMsgList with new list.
		* @param	atTime position to push
		* @param	list to merge.
		* @see ocean.midi.model.MessageList
		*/
    public function merge(atTime : Int, list : MessageList) : Void
    {
        var max : Int = 0;
        var after : Array<Dynamic> = new Array<Dynamic>();
        var temp : MessageItem;
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(list) type: MessageList */ in list)
        {
            if (item.mark)
            
            // clone an item{
                
                temp = item.clone();
                
                //fix timeline
                temp.timeline += atTime;
                
                if (item.kind == MidiEnum.NOTE)
                
                // max timeline in list{
                    
                    max = ((max > (temp.timeline + (try cast(temp, NoteItem) catch(e:Dynamic) null).duration))) ? max : (temp.timeline + (try cast(temp, NoteItem) catch(e:Dynamic) null).duration);
                }
                else
                {
                    max = (max > temp.timeline) ? max : temp.timeline;
                }
                
                //new item
                item.mark = true;
                
                //add item
                _activeMsgList.push(temp);
                
                //record into stack
                after.push(temp);
            }
        }
        
        execute(after);
    }
    
    /**
		* Erases a list of datas from the activeMsgList.
		* @param	list item references selected from activeMsgList.
		* @see ocean.midi.model.MessageList
		* @see #activeMsgList()
		*/
    public function erase(list : MessageList) : Void
    {
        var after : Array<Dynamic> = new Array<Dynamic>();
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(list) type: MessageList */ in list)
        {
            if (item.mark)
            
            //new item{
                
                item.mark = false;
                after.push(item);
            }
        }
        execute(after);
    }
    
    
    /**
		* Notifies views and puts change status in undoredo stack
		* @param	after array carries marked items after operation.
		* @see #undo()
		* @see #redo()
		*/
    private function execute(after : Array<Dynamic>) : Void
    //send events and update views
    {
        
        update(after);
        
        //push the array of current changed-session on the top of undo stack
        _stack.insertAfter(_itr, after);
        _itr.forth();
        
        //cut the stack at current point, next states are abondoned
        _stack.tail = _itr.node;
        _stack.tail.next = null;
        
        //iterator points the tail. acts like a stack
        _itr.end();
        
        //stack is full, shift the bottom
        if (_stack.size > _history + 1)
        {
            _stack.head.next.unlink();
        }
    }
    
    /**
		* Undo last operation.
		* @see #redo()
		*/
    public function undo() : Void
    {
        if (_itr.node != _stack.head)
        
        //switch state of cached session **{
            
            for (item/* AS3HX WARNING could not determine type for var: item exp: EField(EIdent(_itr),data) type: null */ in _itr.data)
            {
                item.mark = !item.mark;
            }
            //update the views to redraw
            update(_itr.data);
            //move iterator back
            _itr.back();
        }
    }
    
    /**
		* Redo last undo-ed operation.
		* @see #undo()
		*/
    public function redo() : Void
    {
        if (_itr.node != _stack.tail)
        
        //move iterator forth{
            
            _itr.forth();
            //switch state of cached session **
            for (item/* AS3HX WARNING could not determine type for var: item exp: EField(EIdent(_itr),data) type: null */ in _itr.data)
            {
                item.mark = !item.mark;
            }
            //update the views to redraw
            update(_itr.data);
        }
    }
    
    /**
		* Dispatches update event to views
		* @param	arr Marks of items in arr will be utilized to redraw views.
		* @see #execute()
		* @see ocean.midi.model.MessageItem#mark
		*/
    private function update(arr : Array<Dynamic>) : Void
    {
        pending = arr;
        dispatchEvent(new MvcEvent(MvcEvent.UPDATE_VIEW));
    }
}


