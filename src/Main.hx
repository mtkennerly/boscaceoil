/*
 *
   BOSCA CEOIL - Terry Cavanagh 2013 / http://www.distractionware.com

   Available under FreeBSD licence. Have fun!

   This problem uses the SiON Library by Kei Mesuda.

   The SiON Library is

   Copyright 2008-2010 Kei Mesuda (keim) All rights reserved.
   Redistribution and use in source and binary forms,

   with or without modification, are permitted provided that
   the following conditions are met:
   1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
   2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

   THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
   INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
   FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
   THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
   OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
   ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import openfl.media.*;
import openfl.ui.Keyboard;
import bigroom.input.KeyPoll;
import openfl.ui.Mouse;
import openfl.utils.Timer;

#if targetWeb
import openfl.external.ExternalInterface;
#end

class Main extends Sprite
{
    public static var appEventDispatcher : EventDispatcher = new EventDispatcher();

    public static function main() : Void
    {
        new Main();
    }

    public function generickeypoll() : Void
    {
        control.press_up = false;control.press_down = false;control.press_left = false;control.press_right = false;control.press_space = false;control.press_enter = false;if (key.isDown(Keyboard.LEFT) || key.isDown(Keyboard.A))
        {
            control.press_left = true;
        }
        if (key.isDown(Keyboard.RIGHT) || key.isDown(Keyboard.D))
        {
            control.press_right = true;
        }
        if (key.isDown(Keyboard.UP) || key.isDown(Keyboard.W))
        {
            control.press_up = true;
        }
        if (key.isDown(Keyboard.DOWN) || key.isDown(Keyboard.S))
        {
            control.press_down = true;
        }
        if (key.isDown(Keyboard.SPACE))
        {
            control.press_space = true;
        }
        if (key.isDown(Keyboard.ENTER))
        {
            control.press_enter = true;
        }control.keypriority = 0;if (control.keypriority == 3)
        {
            control.press_up = false;control.press_down = false;
        }
        else if (control.keypriority == 4)
        {
            control.press_left = false;control.press_right = false;
        }
        if ((key.isDown(15) || key.isDown(17)) && key.isDown(70) && !control.fullscreentoggleheld)
        {
            //Toggle fullscreen
            control.fullscreentoggleheld = true;if (control.fullscreen)
            {
                control.fullscreen = false;
            }
            else
            {
                control.fullscreen = true;
            }updategraphicsmode();
        }
        if (control.fullscreentoggleheld)
        {
            if (!key.isDown(15) && !key.isDown(17) && !key.isDown(70))
            {
                control.fullscreentoggleheld = false;
            }
        }
        if (control.keyheld)
        {
            if (control.press_space || control.press_right || control.press_left || control.press_enter || control.press_down || control.press_up)
            {
                control.press_space = false;control.press_enter = false;control.press_up = false;control.press_down = false;control.press_left = false;control.press_right = false;
            }
            else
            {
                control.keyheld = false;
            }
        }
        if (control.press_space || control.press_right || control.press_left || control.press_enter || control.press_down || control.press_up)
        {
            //Update screen when there is input.
            gfx.updatebackground = 5;
        }
    }
    public function logic(key : KeyPoll) : Void
    {
        var i : Int;
        var j : Int;
        var k : Int;if (control.arrangescrolldelay > 0)
        {
            control.arrangescrolldelay--;
        }
        if (control.messagedelay > 0)
        {
            control.messagedelay -= 2;if (control.messagedelay < 0)
            {
                control.messagedelay = 0;
            }
        }
        if (control.doubleclickcheck > 0)
        {
            control.doubleclickcheck -= 2;if (control.doubleclickcheck < 0)
            {
                control.doubleclickcheck = 0;
            }
        }
        if (gfx.buttonpress > 0)
        {
            gfx.buttonpress -= 2;if (gfx.buttonpress < 0)
            {
                gfx.buttonpress = 0;
            }
        }
        if (control.minresizecountdown > 0)
        {
            control.minresizecountdown -= 2;if (control.minresizecountdown <= 0)
            {
                control.minresizecountdown = 0;gfx.forceminimumsize();
            }
        }
        if (control.savescreencountdown > 0)
        {
            control.savescreencountdown -= 2;if (control.savescreencountdown <= 0)
            {
                control.savescreencountdown = 0;control.savescreensettings();
            }
        }
        if (control.dragaction == 2)
        {
            control.trashbutton += 2;if (control.trashbutton > 10)
            {
                control.trashbutton = 10;
            }
        }
        else if (control.trashbutton > 0)
        {
            control.trashbutton--;
        }
        if (control.followmode)
        {
            if (control.arrange.currentbar < control.arrange.viewstart)
            {
                control.arrange.viewstart = control.arrange.currentbar;
            }
            if (control.arrange.currentbar > control.arrange.viewstart + 5)
            {
                control.arrange.viewstart = control.arrange.currentbar;
            }
        }
    }
    public function input(key : KeyPoll) : Void
    {
        var i : Int;
        var j : Int;
        var k : Int;generickeypoll();
        if (key.click || key.press || key.rightpress || key.rightclick || key.middlepress || key.middleclick || key.mousewheel != 0)
        {
            //Update screen when you click the mouse
            gfx.updatebackground = 5;
        }
        if (control.fixmouseclicks)
        {
            control.fixmouseclicks = false;key.releaseall();
        }control.cursorx = -1;control.cursory = -1;control.notey = -1;control.instrumentcury = -1;control.arrangecurx = -1;control.arrangecury = -1;control.patterncury = -1;control.timelinecurx = -1;control.list.selection = -1;control.secondlist.selection = -1;if (control.clicklist)
        {
            if (!key.press)
            {
                control.clicklist = false;
            }
        }
        if (control.clicksecondlist)
        {
            if (!key.press)
            {
                control.clicksecondlist = false;
            }
        }
        guiclass.checkinput(key);
        if (guiclass.windowdrag)
        {
            key.click = false;key.press = false;
        }
        if (control.list.active || control.secondlist.active)
        {
            if (control.secondlist.active)
            {
                if (control.mx > control.secondlist.x && control.mx < control.secondlist.x + control.secondlist.w && control.my > control.secondlist.y && control.my < control.secondlist.y + control.secondlist.h)
                {
                    control.secondlist.selection = control.my - control.secondlist.y;control.secondlist.selection = (control.secondlist.selection - (control.secondlist.selection % gfx.linesize)) / gfx.linesize;
                }
            }
            if (control.list.active)
            {
                if (control.mx > control.list.x && control.mx < control.list.x + control.list.w && control.my > control.list.y && control.my < control.list.y + control.list.h)
                {
                    control.list.selection = control.my - control.list.y;control.list.selection = (control.list.selection - (control.list.selection % gfx.linesize)) / gfx.linesize;
                }
            }
        }
        else if (!guiclass.overwindow)
        {
            if (control.mx > 40 && control.mx < gfx.screenwidth - 24)
            {
                if (control.my > gfx.pianorollposition + gfx.linesize && control.my < gfx.pianorollposition + (gfx.linesize * (gfx.patterneditorheight + 1)))
                {
                    control.cursorx = (control.mx - 40);control.cursorx = (control.cursorx - (control.cursorx % control.boxsize)) / control.boxsize;control.cursory = (gfx.screenheight - gfx.linesize) - control.my;control.cursory = 1 + ((control.cursory - (control.cursory % gfx.linesize)) / gfx.linesize);if (control.cursorx >= control.boxcount)
                    {
                        control.cursorx = control.boxcount - 1;
                    }
                    if (control.my >= gfx.screenheight - (gfx.linesize))
                    {
                        control.cursory = -1;
                    }
                }
            }
            else if (control.mx <= 40)
            {
                if (control.my > gfx.pianorollposition + gfx.linesize && control.my < gfx.pianorollposition + (gfx.linesize * (gfx.patterneditorheight + 1)))
                {
                    control.notey = (gfx.screenheight - gfx.linesize) - control.my;control.notey = 1 + ((control.notey - (control.notey % gfx.linesize)) / gfx.linesize);if (control.my >= gfx.screenheight - (gfx.linesize))
                    {
                        control.notey = -1;
                    }
                }
            }
            if (control.my > gfx.linesize && control.my < gfx.pianorollposition + 20)
            {
                if (control.currenttab == control.MENUTAB_ARRANGEMENTS)
                {
                    //Priority: Timeline, Pattern manager, arrangements
                    if (control.mx > gfx.patternmanagerx)
                    {
                        //Pattern Manager
                        control.patterncury = control.my - gfx.linesize - 4;control.patterncury = (control.patterncury - (control.patterncury % gfx.patternheight)) / gfx.patternheight;if (control.patterncury > 6)
                        {
                            control.patterncury = -1;
                        }
                    }
                    else if (control.my >= gfx.pianorollposition + 8 || control.dragaction == 3)
                    {
                        //Timeline
                        control.timelinecurx = control.mx;control.timelinecurx = (control.timelinecurx - (control.timelinecurx % gfx.patternwidth)) / gfx.patternwidth;
                    }
                    //Arrangements
                    else
                    {
                        control.arrangecurx = control.mx;control.arrangecurx = (control.arrangecurx - (control.arrangecurx % gfx.patternwidth)) / gfx.patternwidth;control.arrangecury = (control.my - gfx.linesize);control.arrangecury = (control.arrangecury - (control.arrangecury % gfx.patternheight)) / gfx.patternheight;if (control.arrangecury > 7)
                        {
                            control.arrangecury = 7;
                        }
                    }
                }
                else if (control.currenttab == control.MENUTAB_INSTRUMENTS)
                {
                    if (control.mx < 280)
                    {
                        control.instrumentcury = control.my - gfx.linesize;control.instrumentcury = (control.instrumentcury - (control.instrumentcury % gfx.patternheight)) / gfx.patternheight;if (control.instrumentcury > 6)
                        {
                            control.instrumentcury = -1;
                        }
                    }
                }
            }
        }
        if (control.copykeyheld)
        {
            if (!key.isDown(Keyboard.C) && !key.isDown(Keyboard.V))
            {
                control.copykeyheld = false;
            }
        }
        if (control.timelinecurx > -1)
        {
            if (key.ctrlheld && !control.copykeyheld)
            {
                if (key.isDown(Keyboard.V))
                {
                    gfx.updatebackground = 5;control.copykeyheld = true;control.arrange.paste(control.arrange.viewstart + control.timelinecurx);
                }
            }
        }
        if (key.ctrlheld && !control.copykeyheld)
        {
            if (key.isDown(Keyboard.C))
            {
                control.copykeyheld = true;control.arrange.copy();control.showmessage("PATTERNS COPIED");
            }
        }
        if (control.cursorx > -1 && control.cursory > -1 && control.currentbox > -1 && !control.clicklist)
        {
            if (key.press && control.dragaction == 0)
            {
                //Add note
                if (control.musicbox[control.currentbox].start + control.cursory - 1 == -1)
                {
                    if (key.click)
                    {
                        //Enable/Disable recording filter for this musicbox
                        control.musicbox[control.currentbox].recordfilter = 1 - control.musicbox[control.currentbox].recordfilter;
                    }
                }
                else if (control.musicbox[control.currentbox].start + control.cursory - 1 > -1 && control.musicbox[control.currentbox].start + control.cursory - 1 < control.pianorollsize)
                {
                    control.currentnote = control.pianoroll[control.musicbox[control.currentbox].start + control.cursory - 1];if (control.musicbox[control.currentbox].noteat(control.cursorx, control.currentnote))
                    {
                        control.musicbox[control.currentbox].removenote(control.cursorx, control.currentnote);control.musicbox[control.currentbox].addnote(control.cursorx, control.currentnote, control.notelength);
                    }
                    else
                    {
                        control.musicbox[control.currentbox].addnote(control.cursorx, control.currentnote, control.notelength);
                    }
                }
            }
            if (key.rightpress)
            {
                //Remove any note in this position
                if (control.musicbox[control.currentbox].start + ((gfx.patterneditorheight - 1) - control.cursory) > -1)
                {
                    //OLD
                    //control.currentnote = control.pianoroll[control.musicbox[control.currentbox].start + ((gfx.patterneditorheight - 1) - control.cursory)];if (control.musicbox[control.currentbox].start + control.cursory - 1 > -1)
                    {
                        control.currentnote = control.pianoroll[control.musicbox[control.currentbox].start + control.cursory - 1];
                    }
                    control.musicbox[control.currentbox].removenote(control.cursorx, control.currentnote);
                }
            }
        }
        else
        {
            if (key.click)
            {
                if (control.secondlist.active)
                {
                    if (control.secondlist.selection > -1)
                    {
                        //List selection stuff here
                        if (control.secondlist.type >= control.LIST_MIDI_0_PIANO && control.secondlist.type <= control.LIST_MIDI_15_SOUNDEFFECTS)
                        {
                            control.changeinstrumentvoice(control.secondlist.item[control.secondlist.selection]);control.secondlist.close();control.list.close();
                        }
                    }
                    else
                    {
                        control.secondlist.close();if (control.list.selection == -1)
                        {
                            control.list.close();
                        }
                    }
                    control.clicksecondlist = true;
                }
                if (control.list.active)
                {
                    if (control.list.selection > -1)
                    {
                        //List selection stuff here
                        if (control.list.type == control.LIST_CATEGORY)
                        {
                            control.list.close();control.instrument[control.currentinstrument].category = control.list.item[control.list.selection];control.voicelist.index = control.voicelist.getfirst(control.instrument[control.currentinstrument].category);control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
                        }
                        if (control.list.type == control.LIST_MIDIINSTRUMENT)
                        {
                            control.list.close();control.filllist(control.LIST_MIDIINSTRUMENT);control.list.init(470, (gfx.linesize * 3) + 6);control.midilistselection = control.list.selection;control.secondlist.close();control.filllist(control.LIST_MIDI_0_PIANO + control.list.selection);if (gfx.screenwidth < 800)
                            {
                                control.secondlist.init(580, (gfx.linesize * 3) + 6 + (control.list.selection * gfx.linesize));
                            }
                            else
                            {
                                control.secondlist.init(595, (gfx.linesize * 3) + 6 + (control.list.selection * gfx.linesize));
                            }
                        }
                        if (control.list.type == control.LIST_INSTRUMENT)
                        {
                            if (help.Left(control.list.item[control.list.selection], 2) == "<<")
                            {
                                control.voicelist.pagenum = 0;control.list.close();control.filllist(control.LIST_INSTRUMENT);control.list.init(470, (gfx.linesize * 3) + 6);
                            }
                            else if (help.Left(control.list.item[control.list.selection], 2) == ">>")
                            {
                                control.voicelist.pagenum++;if (control.voicelist.pagenum == 15)
                                {
                                    control.voicelist.pagenum = 0;
                                }control.list.close();control.filllist(control.LIST_INSTRUMENT);control.list.init(470, (gfx.linesize * 3) + 6);
                            }
                            else
                            {
                                control.changeinstrumentvoice(control.list.item[control.list.selection]);control.list.close();
                            }
                        }
                        if (control.list.type == control.LIST_SELECTINSTRUMENT)
                        {
                            control.musicbox[control.currentbox].instr = control.list.selection;control.musicbox[control.currentbox].palette = control.instrument[control.musicbox[control.currentbox].instr].palette;control.list.close();guiclass.changetab(control.currenttab);
                        }
                        if (control.list.type == control.LIST_KEY)
                        {
                            control.changekey(control.list.selection);control.list.close();
                        }
                        if (control.list.type == control.LIST_SCALE)
                        {
                            control.changescale(control.list.selection);control.list.close();
                        }
                        if (control.list.type == control.LIST_BUFFERSIZE)
                        {
                            control.setbuffersize(control.list.selection);control.list.close();
                        }
                        if (control.list.type == control.LIST_EFFECTS)
                        {
                            control.effecttype = control.list.selection;control.updateeffects();control.list.close();
                        }
                        if (control.list.type == control.LIST_MOREEXPORTS)
                        {
                            if (control.list.selection == 0)
                            {
                                #if targetDesktop
                                control.exportxm();
                                #end
                            }
                            else if (control.list.selection == 1)
                            {
                                // TODO: enable for web usage too (it's just text!)
                                #if targetDesktop
                                control.exportmml();
                                #end
                            }control.list.close();
                        }
                        if (control.list.type == control.LIST_EXPORTS)
                        {
                            control.list.close();if (control.list.selection == 0)
                            {
                                control.exportwav();
                            }
                            else if (control.list.selection == 1)
                            {
                                #if targetDesktop
                                midicontrol.savemidi();
                                #end
                            }
                            else if (control.list.selection == 2)
                            {
                                control.filllist(control.LIST_MOREEXPORTS);control.list.init(gfx.screenwidth - 170 - ((gfx.screenwidth - 768) / 4), (gfx.linespacing * 4) - 14);
                            }
                        }
                    }
                    else
                    {
                        control.list.close();
                    }control.clicklist = true;
                }
                else if (control.clicksecondlist)
                {
                    //Clumsy workaround :3
                    control.clicklist = true;
                }
                else if (control.my <= gfx.linesize)
                {
                    //Change tabs
                    #if targetDesktop
                    if (control.mx < (gfx.screenwidth - 40) / 4)
                    {
                        control.changetab(control.MENUTAB_FILE);
                    }
                    else if (control.mx < (2 * (gfx.screenwidth - 40)) / 4)
                    {
                        control.changetab(control.MENUTAB_ARRANGEMENTS);
                        guiclass.helpcondition_set = "changetab_arrangement";
                         //For interactive tutorial
                    }
                    else if (control.mx < (3 * (gfx.screenwidth - 40)) / 4)
                    {
                        control.changetab(control.MENUTAB_INSTRUMENTS);
                        guiclass.helpcondition_set = "changetab_instrument";
                         //For interactive tutorial
                    }
                    else
                    {
                        control.changetab(control.MENUTAB_ADVANCED);
                    }
                    #end

                    #if targetWeb
					if (control.mx < (gfx.screenwidth) / 4) {
						control.changetab(control.MENUTAB_FILE);
					}
                    else if (control.mx < (2 * (gfx.screenwidth)) / 4) {
						control.changetab(control.MENUTAB_ARRANGEMENTS);
					}
                    else if (control.mx < (3 * (gfx.screenwidth)) / 4) {
						control.changetab(control.MENUTAB_INSTRUMENTS);
					}
                    else{
						control.changetab(control.MENUTAB_ADVANCED);
					}
                    #end
                }
                else if (control.my > gfx.linesize && control.my < gfx.pianorollposition + 20)
                {
                    if (control.currenttab == control.MENUTAB_ARRANGEMENTS)
                    {
                        //Arrangements
                        //Timelineif (control.timelinecurx > -1)
                        {
                            j = as3hx.Compat.parseInt(control.arrange.viewstart + control.timelinecurx);
                            if (j > -1)
                            {
                                if (control.doubleclickcheck > 0)
                                {
                                    //Set loop song from this bar
                                    control.arrange.loopstart = j;control.arrange.loopend = control.arrange.lastbar;
                                    if (control.arrange.loopend <= control.arrange.loopstart)
                                    {
                                        control.arrange.loopend = control.arrange.loopstart + 1;
                                    }
                                    control.doubleclickcheck = 0;
                                }
                                else
                                {
                                    control.dragx = j;control.dragaction = 3;control.doubleclickcheck = 25;
                                }
                            }
                        }  //Pattern Manager  if (control.patterncury > -1)
                        {
                            if (control.patterncury == 0 && control.patternmanagerview > 0 && control.numboxes > 0)
                            {
                                control.patternmanagerview--;
                            }
                            else if (control.patterncury == 6 && control.patterncury + control.patternmanagerview < control.numboxes)
                            {
                                control.patternmanagerview++;
                            }
                            else
                            {
                                j = as3hx.Compat.parseInt(control.patternmanagerview + control.patterncury);if (j > -1 && j < control.numboxes)
                                {
                                    control.changemusicbox(j);control.dragaction = 2;control.dragpattern = j;control.dragx = control.mx;control.dragy = control.my;
                                }
                            }
                        }  //Arrangements  if (control.arrangecurx > -1 && control.arrangecury > -1)
                        {
                            if (gfx.arrangementscrollleft == 0 && gfx.arrangementscrollright == 0)
                            {
                                //Change, start drag
                                if (control.dragaction == 0)
                                {
                                    if (control.arrangecurx + control.arrange.viewstart > -1)
                                    {
                                        j = control.arrange.bar[control.arrangecurx + control.arrange.viewstart].channel[control.arrangecury];if (j > -1)
                                        {
                                            control.changemusicbox(j);control.dragaction = 1;control.dragpattern = j;control.dragx = control.mx;control.dragy = control.my;
                                        }
                                    }
                                    //Clicked the control panel
                                    else if (control.arrange.viewstart == -1 && control.arrangecurx == 0)
                                    
                                    /* Not doing this stuff anymore

										if (control.mx < gfx.patternwidth / 2) {

											control.arrange.channelon[control.arrangecury] = true;

										}else {

											control.arrange.channelon[control.arrangecury] = false;

										}*/{
                                        //Set loop to entire song!control.arrange.loopstart = 0;control.arrange.loopend = control.arrange.lastbar;
                                    }
                                }
                            }
                        }
                    }
                    else if (control.currenttab == control.MENUTAB_INSTRUMENTS)
                    {
                        //Instrument Manager
                        if (control.instrumentcury > -1)
                        {
                            if (control.instrumentcury == 0 && control.instrumentmanagerview > 0 && control.numinstrument > 0)
                            {
                                control.instrumentmanagerview--;
                            }
                            else if (control.instrumentcury == 6 && control.instrumentcury + control.instrumentmanagerview < control.numinstrument)
                            {
                                control.instrumentmanagerview++;
                            }
                            else if (control.instrumentcury == 7)
                            {
                                //Add a new one!
                            }
                            else
                            {
                                j = as3hx.Compat.parseInt(control.instrumentcury + control.instrumentmanagerview);if (j < control.numinstrument)
                                {
                                    control.currentinstrument = j;
                                }
                            }
                        }
                        else if (control.my > (gfx.linesize * 2) + 6 && control.my < (gfx.linesize * 3) + 6)
                        {
                            if (control.mx > 280 && control.mx < 460)
                            {
                                control.filllist(control.LIST_CATEGORY);control.list.init(290, (gfx.linesize * 3) + 6);
                            }
                            else if (control.mx >= 460 && control.mx <= 740)
                            {
                                if (control.instrument[control.currentinstrument].category == "MIDI")
                                {
                                    control.voicelist.makesublist(control.instrument[control.currentinstrument].category);control.voicelist.pagenum = 0;control.filllist(control.LIST_MIDIINSTRUMENT);control.list.init(470, (gfx.linesize * 3) + 6);
                                }
                                else
                                {
                                    control.voicelist.makesublist(control.instrument[control.currentinstrument].category);control.filllist(control.LIST_INSTRUMENT);control.list.init(470, (gfx.linesize * 3) + 6);
                                }
                            }
                        }
                    }
                }
                else if (control.notey > -1)
                {
                    //Play a single note
                    if (control.currentbox > -1)
                    {
                        if (control.instrument[control.musicbox[control.currentbox].instr].type == 0)
                        {
                            //Normal instrument
                            j = as3hx.Compat.parseInt(control.musicbox[control.currentbox].start + control.notey - 1);if (j >= 0 && j < 128)
                            {
                                control._driver.noteOn(control.pianoroll[j], control.instrument[control.musicbox[control.currentbox].instr].voice, control.notelength);
                            }
                        }
                        //Drumkit
                        else
                        {
                            j = as3hx.Compat.parseInt(control.musicbox[control.currentbox].start + control.notey - 1);if (j >= 0 && j < 128)
                            {
                                control._driver.noteOn(control.drumkit[control.instrument[control.musicbox[control.currentbox].instr].type - 1].voicenote[j], control.drumkit[control.instrument[control.musicbox[control.currentbox].instr].type - 1].voicelist[j], control.notelength);
                            }
                        }
                    }
                }
            }
            if (key.press && (!control.clicklist && !control.clicksecondlist))
            {
                if (control.currenttab == control.MENUTAB_ARRANGEMENTS)
                {
                    if (control.dragaction == 0 || control.dragaction == 3)
                    {
                        if (control.arrangescrolldelay == 0)
                        {
                            if (gfx.arrangementscrollleft > 0)
                            {
                                control.arrange.viewstart--;if (control.arrange.viewstart < 0)
                                {
                                    control.arrange.viewstart = 0;
                                }control.arrangescrolldelay = 4;
                            }
                            else if (gfx.arrangementscrollright > 0)
                            {
                                control.arrange.viewstart++;if (control.arrange.viewstart > 1000)
                                {
                                    control.arrange.viewstart = 1000;
                                }control.arrangescrolldelay = 4;
                            }
                        }
                    }
                }
                else if (control.currenttab == control.MENUTAB_INSTRUMENTS)
                {
                    if (control.my > gfx.linesize && control.my < gfx.pianorollposition + 20)
                    {
                        if (control.mx >= 280 && control.my > 70 && control.mx < gfx.screenwidth - 50)
                        {
                            i = as3hx.Compat.parseInt(control.mx - 280);j = as3hx.Compat.parseInt(control.my - 80);if (i < 0)
                            {
                                i = 0;
                            }
                            if (i > gfx.screenwidth - 368)
                            {
                                i = as3hx.Compat.parseInt(gfx.screenwidth - 368);
                            }
                            if (j < 0)
                            {
                                j = 0;
                            }
                            if (j > 90)
                            {
                                j = 90;
                            }k = 0;if (control.currentbox > -1)
                            {
                                if (control.musicbox[control.currentbox].recordfilter == 1)
                                {
                                    k = 1;
                                }
                            }
                            if (k == 1)
                            {
                                control.musicbox[control.currentbox].cutoffgraph[control.looptime % control.boxcount] = (i * 128) / (gfx.screenwidth - 368);control.musicbox[control.currentbox].resonancegraph[control.looptime % control.boxcount] = (j * 9) / 90;control.instrument[control.currentinstrument].changefilterto(control.musicbox[control.currentbox].cutoffgraph[control.looptime % control.boxcount], control.musicbox[control.currentbox].resonancegraph[control.looptime % control.boxcount], control.musicbox[control.currentbox].volumegraph[control.looptime % control.boxcount]);if (control.instrument[control.currentinstrument].type > 0)
                                {
                                    control.drumkit[control.instrument[control.currentinstrument].type - 1].updatefilter(control.instrument[control.currentinstrument].cutoff, control.instrument[control.currentinstrument].resonance);
                                }
                            }
                            else
                            {
                                control.instrument[control.currentinstrument].setfilter((i * 128) / (gfx.screenwidth - 368), (j * 9) / 90);control.instrument[control.currentinstrument].updatefilter();if (control.instrument[control.currentinstrument].type > 0)
                                {
                                    control.drumkit[control.instrument[control.currentinstrument].type - 1].updatefilter(control.instrument[control.currentinstrument].cutoff, control.instrument[control.currentinstrument].resonance);
                                }
                            }
                        }
                        else if (control.my > 70 && control.mx >= gfx.screenwidth - 50)
                        {
                            j = as3hx.Compat.parseInt(control.my - 90);if (j < 0)
                            {
                                j = 0;
                            }
                            if (j > 90)
                            {
                                j = 90;
                            }j = as3hx.Compat.parseInt(90 - j);k = 0;if (control.currentbox > -1)
                            {
                                if (control.musicbox[control.currentbox].recordfilter == 1)
                                {
                                    if (control.musicbox[control.currentbox].instr == control.currentinstrument)
                                    {
                                        k = 1;
                                    }
                                }
                            }
                            if (k == 1)
                            {
                                control.musicbox[control.currentbox].volumegraph[control.looptime % control.boxcount] = (j * 256) / 90;control.instrument[control.currentinstrument].changevolumeto((j * 256) / 90);if (control.instrument[control.currentinstrument].type > 0)
                                {
                                    control.drumkit[control.instrument[control.currentinstrument].type - 1].updatevolume((j * 256) / 90);
                                }
                            }
                            else
                            {
                                control.instrument[control.currentinstrument].setvolume((j * 256) / 90);control.instrument[control.currentinstrument].updatefilter();if (control.instrument[control.currentinstrument].type > 0)
                                {
                                    control.drumkit[control.instrument[control.currentinstrument].type - 1].updatevolume((j * 256) / 90);
                                }
                            }
                        }
                    }
                }
            }
            if (key.rightpress)
            {
                if (control.my > gfx.linesize && control.my < gfx.pianorollposition + gfx.linesize)
                {
                    if (control.currenttab == control.MENUTAB_FILE)
                    {
                        //Files
                    }
                    else if (control.currenttab == control.MENUTAB_ARRANGEMENTS)
                    {
                        //Arrangements
                        //Timeline
                        if (key.rightclick)
                        {
                            if (control.timelinecurx > -1)
                            {
                                j = as3hx.Compat.parseInt(control.arrange.viewstart + control.timelinecurx);if (j > -1)
                                {
                                    //Insert blank pattern
                                    control.arrange.deletebar(j);
                                }
                            }
                        }
                        //Pattern Manager
                        //Arrangements
                        if (control.arrangecurx > -1 && control.arrangecury > -1)
                        {
                            //Delete pattern from position
                            control.dragaction = 0;
                            if (control.arrange.bar[control.arrangecurx + control.arrange.viewstart].channel[control.arrangecury] > -1)
                            {
                                control.arrange.removepattern(control.arrangecurx + control.arrange.viewstart, control.arrangecury);
                            }
                        }
                    }
                    else if (control.currenttab == control.MENUTAB_INSTRUMENTS)
                    {
                        //Instruments
                    }
                }
            }
            if (key.middleclick)
            {
                if (control.my > gfx.linesize && control.my < gfx.pianorollposition + gfx.linesize)
                {
                    if (control.currenttab == control.MENUTAB_FILE)
                    {
                        //Files
                    }
                    else if (control.currenttab == control.MENUTAB_ARRANGEMENTS)
                    {
                        //Arrangements
                        //Timeline
                        if (control.timelinecurx > -1)
                        {
                            j = as3hx.Compat.parseInt(control.arrange.viewstart + control.timelinecurx);if (j > -1)
                            {
                                //Insert blank pattern
                                control.arrange.insertbar(j);
                            }
                        }
                        //Pattern Manager
                        //Arrangements
                        if (control.arrangecurx > -1 && control.arrangecury > -1)
                        {
                            //Make variation pattern!
                            j = control.arrange.bar[control.arrangecurx + control.arrange.viewstart].channel[control.arrangecury];if (j > -1)
                            {
                                control.addmusicbox();control.copymusicbox(control.numboxes - 1, j);control.musicbox[control.numboxes - 1].setnotespan();control.patternmanagerview = control.numboxes - 6;control.changemusicbox(control.numboxes - 1);if (control.patternmanagerview < 0)
                                {
                                    control.patternmanagerview = 0;
                                }control.dragaction = 1;control.dragpattern = control.numboxes - 1;control.dragx = control.mx;control.dragy = control.my;
                            }
                        }
                    }
                    else if (control.currenttab == control.MENUTAB_INSTRUMENTS)
                    {
                        //Instruments
                    }
                }
            }
        }
        if (key.hasreleased || key.hasmiddlereleased)
        {
            //Check for click releases: deal with immediately
            key.hasreleased = false;
            key.hasmiddlereleased = false;gfx.updatebackground = 5;  //Update the background on input
            
            if (control.dragaction == 1 || control.dragaction == 2)
            {
                control.dragaction = 0;if (control.arrangecurx > -1 && control.arrangecury > -1)
                {
                    control.arrange.addpattern(control.arrangecurx + control.arrange.viewstart, control.arrangecury, control.dragpattern);
                }
                else if (control.mx > gfx.screenwidth - 120 && control.my > gfx.screenheight - 40)
                {
                    control.deletemusicbox(control.dragpattern);guiclass.changetab(control.currenttab);
                }
            }
            else if (control.dragaction == 3)
            {
                control.dragaction = 0;control.arrange.loopstart = control.dragx;control.arrange.loopend = control.arrange.viewstart + control.timelinecurx + 1;if (control.arrange.loopend <= control.arrange.loopstart)
                {
                    i = control.arrange.loopend;control.arrange.loopend = control.arrange.loopstart + 1;control.arrange.loopstart = i - 1;
                }
                if (control.arrange.currentbar < control.arrange.loopstart)
                {
                    control.arrange.currentbar = control.arrange.loopstart;
                }
                if (control.arrange.currentbar >= control.arrange.loopend)
                {
                    control.arrange.currentbar = control.arrange.loopend - 1;
                }
                if (control.arrange.loopstart < 0)
                {
                    control.arrange.loopstart = 0;
                }
            }
        }
        if (control.my > gfx.pianorollposition)
        {
            if (key.mousewheel < 0)
            {
                control.notelength--;if (control.notelength < 1)
                {
                    control.notelength = 1;
                }key.mousewheel = 0;
            }
            else if (key.mousewheel > 0)
            {
                control.notelength++;key.mousewheel = 0;
            }
        }
        else if (key.mousewheel < 0 || (key.shiftheld && (control.press_down || control.press_left)))
        {
            gfx.zoom--;if (gfx.zoom < 1)
            {
                gfx.zoom = 1;
            }gfx.setzoomlevel(gfx.zoom);key.mousewheel = 0;
        }
        else if (key.mousewheel > 0 || (key.shiftheld && (control.press_up || control.press_right)))
        {
            gfx.zoom++;if (gfx.zoom > 4)
            {
                gfx.zoom = 4;
            }gfx.setzoomlevel(gfx.zoom);key.mousewheel = 0;
        }
        if (control.keydelay <= 0)
        {
            if (control.currentbox > -1)
            {
                if (!key.shiftheld)
                {
                    if (control.press_down)
                    {
                        control.musicbox[control.currentbox].start--;if (control.musicbox[control.currentbox].start < -1)
                        {
                            control.musicbox[control.currentbox].start = -1;
                        }control.keydelay = 2;
                    }
                    else if (control.press_up)
                    {
                        control.musicbox[control.currentbox].start++;if (control.musicbox[control.currentbox].start > control.pianorollsize - gfx.notesonscreen)
                        {
                            control.musicbox[control.currentbox].start = control.pianorollsize - gfx.notesonscreen;
                        }
                        if (control.instrument[control.musicbox[control.currentbox].instr].type > 0)
                        {
                            //Also check for drumkit ranges
                            if (control.musicbox[control.currentbox].start > control.drumkit[control.instrument[control.musicbox[control.currentbox].instr].type - 1].size - 12)
                            {
                                control.musicbox[control.currentbox].start = control.drumkit[control.instrument[control.musicbox[control.currentbox].instr].type - 1].size - 12;
                            }
                            if (control.musicbox[control.currentbox].start < 0)
                            {
                                control.musicbox[control.currentbox].start = 0;
                            }
                        }control.keydelay = 2;
                    }
                }
                else if (control.press_down || control.press_left)
                {
                    control.notelength--;if (control.notelength < 1)
                    {
                        control.notelength = 1;
                    }control.keydelay = 2;
                }
                else if (control.press_up || control.press_right)
                {
                    control.notelength++;control.keydelay = 2;
                }
            }
            if (!key.shiftheld)
            {
                if (control.press_left)
                {
                    control.arrange.viewstart--;if (control.arrange.viewstart < 0)
                    {
                        control.arrange.viewstart = 0;
                    }control.keydelay = 2;
                }
                else if (control.press_right)
                {
                    control.arrange.viewstart++;if (control.arrange.viewstart > 1000)
                    {
                        control.arrange.viewstart = 1000;
                    }control.keydelay = 2;
                }
            }
        }
        else
        {
            control.keydelay--;
        }
        if (control.currentbox > -1)
        {
            if (!control.press_down && control.musicbox[control.currentbox].start == -1)
            {
                control.musicbox[control.currentbox].start = 0;
            }
        }
        if (!control.keyheld)
        {
            if (control.press_space || control.press_enter)
            {
                if (!control.musicplaying)
                {
                    control.startmusic();
                }
                else
                {
                    control.stopmusic();
                }control.keyheld = true;
            }
        }  //Hardcoding some interactive tutorial stuff here  if (guiclass.helpcondition_check != "nothing")
        {
            if (guiclass.helpcondition_check == guiclass.helpcondition_set)
            {
                if (guiclass.helpcondition_check == "changetab_arrangement")
                {
                    guiclass.changewindow("help6");control.changetab(control.currenttab);control.clicklist = true;
                }
                else if (guiclass.helpcondition_check == "addnew_pattern")
                {
                    guiclass.changewindow("help7");control.changetab(control.currenttab);control.clicklist = true;
                }
                else if (guiclass.helpcondition_check == "addnew_instrument")
                {
                    guiclass.changewindow("help15");control.changetab(control.currenttab);control.clicklist = true;
                }
                else if (guiclass.helpcondition_check == "changetab_instrument")
                {
                    guiclass.changewindow("help14");control.changetab(control.currenttab);control.clicklist = true;
                }
            }guiclass.helpcondition_set = "nothing";
        }

        #if targetDesktop
        if (key.isDown(Keyboard.ESCAPE))
        {
            Sys.exit(0);
        }
        #end
    }
    public function render(key : KeyPoll) : Void
    {
        var i : Int;
        var j : Int;
        var k : Int;if (gfx.updatebackground > 0)
        {
            gfx.changeframerate(30);
            //Background
            gfx.fillrect(0, 0, gfx.screenwidth, gfx.screenheight, 1);
            
            //Tabs
            #if targetDesktop
            j = as3hx.Compat.parseInt((gfx.screenwidth - 40) / 4);
            #end
            #if targetWeb
            j = (gfx.screenwidth) / 4;
            #end
            if (control.currenttab == control.MENUTAB_HELP)
            {
                gfx.fillrect(0, 0, j, gfx.linesize, 5);gfx.print(14, 0, "HELP", (control.currenttab == control.MENUTAB_HELP) ? 0 : 2, false, true);
            }
            else if (control.currenttab == control.MENUTAB_CREDITS || control.currenttab == control.MENUTAB_GITHUB)
            {
                gfx.fillrect(0, 0, j, gfx.linesize, 5);gfx.print(14, 0, "CREDITS", ((control.currenttab == control.MENUTAB_CREDITS || control.currenttab == control.MENUTAB_GITHUB)) ? 0 : 2, false, true);
            }
            else
            {
                gfx.fillrect(control.currenttab * j, 0, j, gfx.linesize, 5);gfx.print(14, 0, "FILE", (control.currenttab == control.MENUTAB_FILE) ? 0 : 2, false, true);
            }
            gfx.print(j + 14, 0, "ARRANGEMENT", (control.currenttab == control.MENUTAB_ARRANGEMENTS) ? 0 : 2, false, true);
            gfx.print((j * 2) + 14, 0, "INSTRUMENT", (control.currenttab == control.MENUTAB_INSTRUMENTS) ? 0 : 2, false, true);
            gfx.print((j * 3) + 14, 0, "ADVANCED", (control.currenttab == control.MENUTAB_ADVANCED) ? 0 : 2, false, true);
            #if targetDesktop
                gfx.fillrect(j * 4, 0, 42, 20, 3);
                gfx.drawicon((j * 4) + 12, 1, (control.fullscreen) ? 5 : 4);
            #end

            if (control.nowexporting)
            {
                gfx.updatebackground = 5;gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, gfx.screenheight - (gfx.pianorollposition + gfx.linesize), 14);if (control.arrange.currentbar % 2 == 0)
                {
                    guiclass.tx = as3hx.Compat.parseInt(gfx.screenwidth / 64) + 1;i = -1;
                    while (i < guiclass.tx)
                    {
                        gfx.fillrect((i * 64) + help.slowsine, gfx.pianorollposition + gfx.linesize, 32, gfx.screenheight - (gfx.pianorollposition + gfx.linesize), 1);
                        i++;
                    }
                }
                else
                {
                    guiclass.tx = as3hx.Compat.parseInt(gfx.screenheight - (gfx.pianorollposition + gfx.linesize) / 64) + 1;i = 0;
                    while (i < guiclass.tx)
                    {
                        gfx.fillrect(0, gfx.pianorollposition + gfx.linesize + (i * 64) + help.slowsine, gfx.screenwidth, 32, 1);
                        i++;
                    }
                    if (help.slowsine >= 32)
                    {
                        gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, help.slowsine - 32, 1);
                    }
                }
                if (help.slowsine < 32)
                {
                    gfx.print(gfx.screenwidthmid - (gfx.len("NOW EXPORTING AS WAV, PLEASE WAIT") / 2), (gfx.pianorollposition + gfx.linesize) + (gfx.screenheight - gfx.hig("WAV") - (gfx.pianorollposition + gfx.linesize)) / 2, "NOW EXPORTING AS WAV, PLEASE WAIT", 0, false, true);
                }
            }
            else if (control.currentbox > -1)
            {
                gfx.drawpatterneditor();
            }
            else
            {
                gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, gfx.screenheight - gfx.pianorollposition, 14);
            }  //Draw menu area  gfx.fillrect(0, gfx.linesize, gfx.screenwidth, gfx.linesize * 10, 5);j = 0;
            while (j < gfx.linesize * 10)
            {
                if (j % 4 == 0)
                {
                    gfx.fillrect(0, gfx.linesize + j, gfx.screenwidth, 2, 1);
                }
                j++;
            }var _sw0_ = (control.currenttab);            

            switch (_sw0_)
            {case control.MENUTAB_FILE:guiclass.tx = (gfx.screenwidth - 768) / 4;gfx.fillrect(guiclass.tx, gfx.linesize, 408, gfx.linesize * 10, 5);gfx.fillrect(gfx.screenwidth - guiclass.tx - 408 + 24, gfx.linesize, 408, gfx.linesize * 10, 5);case control.MENUTAB_CREDITS:guiclass.tx = (gfx.screenwidth - 768) / 4;gfx.fillrect(guiclass.tx, gfx.linesize, 408, gfx.linesize * 10, 5);gfx.fillrect(gfx.screenwidth - guiclass.tx - 408 + 24, gfx.linesize, 408, gfx.linesize * 10, 5);case control.MENUTAB_GITHUB:guiclass.tx = (gfx.screenwidth - 768) / 4;gfx.fillrect(guiclass.tx, gfx.linesize, 408, gfx.linesize * 10, 5);gfx.fillrect(gfx.screenwidth - guiclass.tx - 408 + 24, gfx.linesize, 408, gfx.linesize * 10, 5);case control.MENUTAB_HELP:guiclass.tx = (gfx.screenwidth - 768) / 2;gfx.fillrect(guiclass.tx, gfx.linesize, 768, gfx.linesize * 10, 5);case control.MENUTAB_ARRANGEMENTS:gfx.drawarrangementeditor();gfx.drawtimeline();gfx.drawpatternmanager();case control.MENUTAB_INSTRUMENTS:gfx.drawinstrumentlist();gfx.drawinstrument();case control.MENUTAB_ADVANCED:guiclass.tx = (gfx.screenwidth - 768) / 4;gfx.fillrect(guiclass.tx, gfx.linesize, 408, gfx.linesize * 10, 5);gfx.fillrect(gfx.screenwidth - guiclass.tx - 408 + 24, gfx.linesize, 408, gfx.linesize * 10, 5);
            }  //Cache bitmap at this point  gfx.updatebackground--;if (gfx.updatebackground == 0)
            {
                gfx.settrect(gfx.backbuffer.rect.x, gfx.backbuffer.rect.y, gfx.backbuffer.rect.width, gfx.backbuffer.rect.height);gfx.backbuffercache.copyPixels(gfx.backbuffer, gfx.trect, gfx.tl);
            }
        }
        else
        {
            if (!control.musicplaying)
            {
                gfx.changeframerate(15);
            }  //If there's no music playing, drop the framerate!    //Draw from cache  gfx.settrect(gfx.backbuffercache.rect.x, gfx.backbuffercache.rect.y, gfx.backbuffercache.rect.width, gfx.backbuffercache.rect.height);gfx.backbuffer.copyPixels(gfx.backbuffercache, gfx.trect, gfx.tl);
        }
        if (control.currenttab == control.MENUTAB_ARRANGEMENTS)
        {
            gfx.drawarrangementcursor();if (control.mx > gfx.patternmanagerx - 108)
            {
                gfx.drawpatternmanager();
            }gfx.drawtimeline_cursor();gfx.drawpatternmanager_cursor();
        }
        if (!control.nowexporting)
        {
            if (control.currentbox > -1)
            {
                gfx.drawpatterneditor_cursor();
            }
        }guiclass.drawbuttons();if (control.messagedelay > 0)
        {
            i = (control.messagedelay > 10) ? 10 : control.messagedelay;gfx.fillrect(0, gfx.screenheight - (i * 2), gfx.screenwidth, 20, 16);gfx.print(gfx.screenwidthmid - (gfx.len(control.message) / 2), gfx.screenheight - (i * 2), control.message, 0, false, true);
        }  //Draw pop up lists over all that  gfx.drawlist();  //Draw mouse dragging stuff over everything  if (control.dragaction == 1 || control.dragaction == 2)
        {
            if (Math.abs(control.mx - control.dragx) > 4 || Math.abs(control.my - control.dragy) > 4)
            {
                gfx.drawmusicbox(control.mx, control.my, control.dragpattern);
            }
        }gfx.render();
    }
    
    public function new()
    {
        super();
        control.versionnumber = "v2.1 unstable";  // Version number displayed beside logo  
        control.version = 3;  // Version number used by file  
        control.ctrl = "Ctrl";  //Set this to Cmd on Mac so that the tutorial is correct  
        
        #if targetDesktop
        appEventDispatcher.addEventListener("INVOKE", onInvokeEvent);
        appEventDispatcher.dispatchEvent(new Event("INVOKE"));
        #end
        
        key = new KeyPoll(stage);
        control.init();
        
        //Working towards resolution independence!
        gfx.init(stage);
        
        #if targetDesktop
        stage.addEventListener(Event.RESIZE, handleResize);
        #end
        
        var tempbmp : Bitmap;
        tempbmp = new ImIcons();
        gfx.buffer = tempbmp.bitmapData;
        gfx.makeiconarray();
        tempbmp = new ImLogo0();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        tempbmp = new ImLogo1();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        tempbmp = new ImLogo2();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        tempbmp = new ImLogo3();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        tempbmp = new ImLogo4();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        tempbmp = new ImLogo5();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        tempbmp = new ImLogo6();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        tempbmp = new ImLogo7();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        
        tempbmp = new ImTutorialimage0();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        tempbmp = new ImTutorialimage1();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        tempbmp = new ImTutorialimage2();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        tempbmp = new ImTutorialimage3();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        tempbmp = new ImTutorialimage4();
        gfx.buffer = tempbmp.bitmapData;
        gfx.addimage();
        gfx.buffer = new BitmapData(1, 1, false, 0x000000);
        
        control.changetab(control.MENUTAB_FILE);
        
        control.voicelist.fixlengths();
        stage.fullScreenSourceRect = null;
        addChild(gfx.screen);
        
        control.loadscreensettings();
        control.loadfilesettings();
        updategraphicsmode();
        
        gfx.changescalemode(gfx.scalemode);
        
        if (guiclass.firstrun)
        {
            guiclass.changewindow("firstrun");
            control.changetab(control.currenttab);
            control.clicklist = true;
        }
    }
    
    private function handleResize(e : Event) : Void
    // adjust the gui to fit the new device resolution
    {
        
        var tempwidth : Int;
        var tempheight : Int;
        if (e != null)
        {
            e.preventDefault();
            tempwidth = e.target.stageWidth;
            tempheight = e.target.stageHeight;
        }
        else
        {
            tempwidth = gfx.windowwidth;
            tempheight = gfx.windowheight;
        }
        
        control.savescreencountdown = 30;  //Half a second after a resize, save the settings  
        control.minresizecountdown = 5;  //Force a minimum screensize  
        gfx.changewindowsize(tempwidth, tempheight);
        
        gfx.patternmanagerx = gfx.screenwidth - 116;
        gfx.patterneditorheight = (gfx.windowheight - (gfx.pianorollposition - (gfx.linesize + 2))) / 12;
        gfx.notesonscreen = ((gfx.screenheight - gfx.pianorollposition - gfx.linesize) / gfx.linesize) + 1;
        gfx.tf_1.width = gfx.windowwidth;
        gfx.updateboxsize();
        
        guiclass.changetab(control.currenttab);
        
        var temp : BitmapData = new BitmapData(gfx.windowwidth, gfx.windowheight, false, 0x000000);
        gfx.updatebackground = 5;
        gfx.backbuffercache = new BitmapData(gfx.windowwidth, gfx.windowheight, false, 0x000000);
        temp.copyPixels(gfx.backbuffer, gfx.backbuffer.rect, gfx.tl);
        gfx.backbuffer = temp;
        //gfx.screen.bitmapData.dispose();
        gfx.screen.bitmapData = gfx.backbuffer;
        if (gfx.scalemode == 1)
        {
            gfx.screen.scaleX = 1.5;
            gfx.screen.scaleY = 1.5;
        }
        else
        {
            gfx.screen.scaleX = 1;
            gfx.screen.scaleY = 1;
        }
    }
    
    private function _startMainLoop() : Void
    {
        #if targetDesktop
        appEventDispatcher.addEventListener(Event.ACTIVATE, __activate__);
        appEventDispatcher.addEventListener(Event.DEACTIVATE, __deactivate__);
        #end
        #if targetWeb
        addEventListener(Event.DEACTIVATE, __activate__);
        addEventListener(Event.ACTIVATE, __deactivate__);
        #end
        
        _timer.addEventListener(TimerEvent.TIMER, mainloop);
        _timer.start();
    }
    
    private function __activate__(__DOLLAR__event : Event) : Void
    {
        gfx.changeframerate(30);
    }
    
    private function __deactivate__(__DOLLAR__event : Event) : Void
    {
        gfx.changeframerate(1);
    }
    
    #if targetWeb
    private function _startMainLoopWeb() : Void
    {
        // Expose some functions to external JS
        ExternalInterface.addCallback("getCeolString", control.getCeolString);
        ExternalInterface.addCallback("invokeCeolWeb", control.invokeCeolWeb);
        ExternalInterface.addCallback("newSong", control.newsong);
        ExternalInterface.addCallback("exportWav", control.exportwav);

        control.invokeCeolWeb(ExternalInterface.call("Bosca._getStartupCeol"));

        _startMainLoop();
    }
    #end
    
    public function _input() : Void
    {
        if (gfx.scalemode == 1)
        {
            control.mx = mouseX / 1.5;
            control.my = mouseY / 1.5;
        }
        else
        {
            control.mx = mouseX;
            control.my = mouseY;
        }
        
        input(key);
    }
    
    public function _logic() : Void
    {
        logic(key);
        help.updateglow();
        if (control.forceresize)
        {
            control.forceresize = false;
            handleResize(null);
        }
    }
    
    public function _render() : Void
    {
        gfx.backbuffer.lock();
        render(key);
    }
    
    public function mainloop(e : TimerEvent) : Void
    {
        _current = Math.round(haxe.Timer.stamp() * 1000);
        if (_last < 0)
        {
            _last = _current;
        }
        _delta += _current - _last;
        _last = _current;
        if (_delta >= _rate)
        {
            _delta %= _skip;
            while (_delta >= _rate)
            {
                _delta -= _rate;
                _input();
                _logic();
                if (key.hasclicked)
                {
                    key.click = false;
                }
                if (key.hasrightclicked)
                {
                    key.rightclick = false;
                }
                if (key.hasmiddleclicked)
                {
                    key.middleclick = false;
                }
            }
            _render();
            
            e.updateAfterEvent();
        }
    }
    
    public function updategraphicsmode() : Void
    {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        
        if (control.fullscreen)
        {
            stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
        }
        else
        {
            stage.displayState = StageDisplayState.NORMAL;
        }
        
        control.savescreensettings();
    }
    
    #if targetDesktop
    public function onInvokeEvent(event : Event) : Void
    {
        if (event.arguments.length > 0)
        {
            if (event.currentDirectory != null)
            {
                // set file directory to current directory
                
                control.filepath = event.currentDirectory;
            }
            if (control.startup == 0)
            {
                //Loading a song at startup, wait until the sound is initilised
                
                control.invokefile = event.arguments[0];
            }
            //Program is up and running, just load now
            else
            {
                
                control.invokeceol(event.arguments[0]);
            }
        }
    }
    #end
    
    public var key : KeyPoll;
    
    // Timer information (a shout out to ChevyRay for the implementation)
    public static inline var TARGET_FPS : Float = 30;  // the fixed-FPS we want the control to run at  
    private var _rate : Float = 1000 / TARGET_FPS;  // how long (in seconds) each frame is  
    private var _skip : Float = _rate * 10;  // this tells us to allow a maximum of 10 frame skips  
    private var _last : Float = -1;
    private var _current : Float = 0;
    private var _delta : Float = 0;
    private var _timer : Timer = new Timer(4);
    
    //Embedded resources:
    @:meta(Embed(source="graphics/icons.png"))

    private var im_icons : Class<Dynamic>;
    @:meta(Embed(source="graphics/logo_blue.png"))

    private var im_logo0 : Class<Dynamic>;
    @:meta(Embed(source="graphics/logo_purple.png"))

    private var im_logo1 : Class<Dynamic>;
    @:meta(Embed(source="graphics/logo_red.png"))

    private var im_logo2 : Class<Dynamic>;
    @:meta(Embed(source="graphics/logo_orange.png"))

    private var im_logo3 : Class<Dynamic>;
    @:meta(Embed(source="graphics/logo_green.png"))

    private var im_logo4 : Class<Dynamic>;
    @:meta(Embed(source="graphics/logo_cyan.png"))

    private var im_logo5 : Class<Dynamic>;
    @:meta(Embed(source="graphics/logo_gray.png"))

    private var im_logo6 : Class<Dynamic>;
    @:meta(Embed(source="graphics/logo_shadow.png"))

    private var im_logo7 : Class<Dynamic>;
    
    @:meta(Embed(source="graphics/tutorial_longnote.png"))

    private var im_tutorialimage0 : Class<Dynamic>;
    @:meta(Embed(source="graphics/tutorial_drag.png"))

    private var im_tutorialimage1 : Class<Dynamic>;
    @:meta(Embed(source="graphics/tutorial_timelinedrag.png"))

    private var im_tutorialimage2 : Class<Dynamic>;
    @:meta(Embed(source="graphics/tutorial_patterndrag.png"))

    private var im_tutorialimage3 : Class<Dynamic>;
    @:meta(Embed(source="graphics/tutorial_secret.png"))

    private var im_tutorialimage4 : Class<Dynamic>;
}
