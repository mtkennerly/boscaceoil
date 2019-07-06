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
        Control.press_up = false;Control.press_down = false;Control.press_left = false;Control.press_right = false;Control.press_space = false;Control.press_enter = false;if (key.isDown(Keyboard.LEFT) || key.isDown(Keyboard.A))
        {
            Control.press_left = true;
        }
        if (key.isDown(Keyboard.RIGHT) || key.isDown(Keyboard.D))
        {
            Control.press_right = true;
        }
        if (key.isDown(Keyboard.UP) || key.isDown(Keyboard.W))
        {
            Control.press_up = true;
        }
        if (key.isDown(Keyboard.DOWN) || key.isDown(Keyboard.S))
        {
            Control.press_down = true;
        }
        if (key.isDown(Keyboard.SPACE))
        {
            Control.press_space = true;
        }
        if (key.isDown(Keyboard.ENTER))
        {
            Control.press_enter = true;
        }Control.keypriority = 0;if (Control.keypriority == 3)
        {
            Control.press_up = false;Control.press_down = false;
        }
        else if (Control.keypriority == 4)
        {
            Control.press_left = false;Control.press_right = false;
        }
        if ((key.isDown(15) || key.isDown(17)) && key.isDown(70) && !Control.fullscreentoggleheld)
        {
            //Toggle fullscreen
            Control.fullscreentoggleheld = true;if (Control.fullscreen)
            {
                Control.fullscreen = false;
            }
            else
            {
                Control.fullscreen = true;
            }updategraphicsmode();
        }
        if (Control.fullscreentoggleheld)
        {
            if (!key.isDown(15) && !key.isDown(17) && !key.isDown(70))
            {
                Control.fullscreentoggleheld = false;
            }
        }
        if (Control.keyheld)
        {
            if (Control.press_space || Control.press_right || Control.press_left || Control.press_enter || Control.press_down || Control.press_up)
            {
                Control.press_space = false;Control.press_enter = false;Control.press_up = false;Control.press_down = false;Control.press_left = false;Control.press_right = false;
            }
            else
            {
                Control.keyheld = false;
            }
        }
        if (Control.press_space || Control.press_right || Control.press_left || Control.press_enter || Control.press_down || Control.press_up)
        {
            //Update screen when there is input.
            Gfx.updatebackground = 5;
        }
    }
    public function logic(key : KeyPoll) : Void
    {
        var i : Int;
        var j : Int;
        var k : Int;if (Control.arrangescrolldelay > 0)
        {
            Control.arrangescrolldelay--;
        }
        if (Control.messagedelay > 0)
        {
            Control.messagedelay -= 2;if (Control.messagedelay < 0)
            {
                Control.messagedelay = 0;
            }
        }
        if (Control.doubleclickcheck > 0)
        {
            Control.doubleclickcheck -= 2;if (Control.doubleclickcheck < 0)
            {
                Control.doubleclickcheck = 0;
            }
        }
        if (Gfx.buttonpress > 0)
        {
            Gfx.buttonpress -= 2;if (Gfx.buttonpress < 0)
            {
                Gfx.buttonpress = 0;
            }
        }
        if (Control.minresizecountdown > 0)
        {
            Control.minresizecountdown -= 2;if (Control.minresizecountdown <= 0)
            {
                Control.minresizecountdown = 0;Gfx.forceminimumsize();
            }
        }
        if (Control.savescreencountdown > 0)
        {
            Control.savescreencountdown -= 2;if (Control.savescreencountdown <= 0)
            {
                Control.savescreencountdown = 0;Control.savescreensettings();
            }
        }
        if (Control.dragaction == 2)
        {
            Control.trashbutton += 2;if (Control.trashbutton > 10)
            {
                Control.trashbutton = 10;
            }
        }
        else if (Control.trashbutton > 0)
        {
            Control.trashbutton--;
        }
        if (Control.followmode)
        {
            if (Control.arrange.currentbar < Control.arrange.viewstart)
            {
                Control.arrange.viewstart = Control.arrange.currentbar;
            }
            if (Control.arrange.currentbar > Control.arrange.viewstart + 5)
            {
                Control.arrange.viewstart = Control.arrange.currentbar;
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
            Gfx.updatebackground = 5;
        }
        if (Control.fixmouseclicks)
        {
            Control.fixmouseclicks = false;key.releaseall();
        }Control.cursorx = -1;Control.cursory = -1;Control.notey = -1;Control.instrumentcury = -1;Control.arrangecurx = -1;Control.arrangecury = -1;Control.patterncury = -1;Control.timelinecurx = -1;Control.list.selection = -1;Control.secondlist.selection = -1;if (Control.clicklist)
        {
            if (!key.press)
            {
                Control.clicklist = false;
            }
        }
        if (Control.clicksecondlist)
        {
            if (!key.press)
            {
                Control.clicksecondlist = false;
            }
        }
        Guiclass.checkinput(key);
        if (Guiclass.windowdrag)
        {
            key.click = false;key.press = false;
        }
        if (Control.list.active || Control.secondlist.active)
        {
            if (Control.secondlist.active)
            {
                if (Control.mx > Control.secondlist.x && Control.mx < Control.secondlist.x + Control.secondlist.w && Control.my > Control.secondlist.y && Control.my < Control.secondlist.y + Control.secondlist.h)
                {
                    Control.secondlist.selection = Control.my - Control.secondlist.y;Control.secondlist.selection = (Control.secondlist.selection - (Control.secondlist.selection % Gfx.linesize)) / Gfx.linesize;
                }
            }
            if (Control.list.active)
            {
                if (Control.mx > Control.list.x && Control.mx < Control.list.x + Control.list.w && Control.my > Control.list.y && Control.my < Control.list.y + Control.list.h)
                {
                    Control.list.selection = Control.my - Control.list.y;Control.list.selection = (Control.list.selection - (Control.list.selection % Gfx.linesize)) / Gfx.linesize;
                }
            }
        }
        else if (!Guiclass.overwindow)
        {
            if (Control.mx > 40 && Control.mx < Gfx.screenwidth - 24)
            {
                if (Control.my > Gfx.pianorollposition + Gfx.linesize && Control.my < Gfx.pianorollposition + (Gfx.linesize * (Gfx.patterneditorheight + 1)))
                {
                    Control.cursorx = (Control.mx - 40);Control.cursorx = (Control.cursorx - (Control.cursorx % Control.boxsize)) / Control.boxsize;Control.cursory = (Gfx.screenheight - Gfx.linesize) - Control.my;Control.cursory = 1 + ((Control.cursory - (Control.cursory % Gfx.linesize)) / Gfx.linesize);if (Control.cursorx >= Control.boxcount)
                    {
                        Control.cursorx = Control.boxcount - 1;
                    }
                    if (Control.my >= Gfx.screenheight - (Gfx.linesize))
                    {
                        Control.cursory = -1;
                    }
                }
            }
            else if (Control.mx <= 40)
            {
                if (Control.my > Gfx.pianorollposition + Gfx.linesize && Control.my < Gfx.pianorollposition + (Gfx.linesize * (Gfx.patterneditorheight + 1)))
                {
                    Control.notey = (Gfx.screenheight - Gfx.linesize) - Control.my;Control.notey = 1 + ((Control.notey - (Control.notey % Gfx.linesize)) / Gfx.linesize);if (Control.my >= Gfx.screenheight - (Gfx.linesize))
                    {
                        Control.notey = -1;
                    }
                }
            }
            if (Control.my > Gfx.linesize && Control.my < Gfx.pianorollposition + 20)
            {
                if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS)
                {
                    //Priority: Timeline, Pattern manager, arrangements
                    if (Control.mx > Gfx.patternmanagerx)
                    {
                        //Pattern Manager
                        Control.patterncury = Control.my - Gfx.linesize - 4;Control.patterncury = (Control.patterncury - (Control.patterncury % Gfx.patternheight)) / Gfx.patternheight;if (Control.patterncury > 6)
                        {
                            Control.patterncury = -1;
                        }
                    }
                    else if (Control.my >= Gfx.pianorollposition + 8 || Control.dragaction == 3)
                    {
                        //Timeline
                        Control.timelinecurx = Control.mx;Control.timelinecurx = (Control.timelinecurx - (Control.timelinecurx % Gfx.patternwidth)) / Gfx.patternwidth;
                    }
                    //Arrangements
                    else
                    {
                        Control.arrangecurx = Control.mx;Control.arrangecurx = (Control.arrangecurx - (Control.arrangecurx % Gfx.patternwidth)) / Gfx.patternwidth;Control.arrangecury = (Control.my - Gfx.linesize);Control.arrangecury = (Control.arrangecury - (Control.arrangecury % Gfx.patternheight)) / Gfx.patternheight;if (Control.arrangecury > 7)
                        {
                            Control.arrangecury = 7;
                        }
                    }
                }
                else if (Control.currenttab == Control.MENUTAB_INSTRUMENTS)
                {
                    if (Control.mx < 280)
                    {
                        Control.instrumentcury = Control.my - Gfx.linesize;Control.instrumentcury = (Control.instrumentcury - (Control.instrumentcury % Gfx.patternheight)) / Gfx.patternheight;if (Control.instrumentcury > 6)
                        {
                            Control.instrumentcury = -1;
                        }
                    }
                }
            }
        }
        if (Control.copykeyheld)
        {
            if (!key.isDown(Keyboard.C) && !key.isDown(Keyboard.V))
            {
                Control.copykeyheld = false;
            }
        }
        if (Control.timelinecurx > -1)
        {
            if (key.ctrlheld && !Control.copykeyheld)
            {
                if (key.isDown(Keyboard.V))
                {
                    Gfx.updatebackground = 5;Control.copykeyheld = true;Control.arrange.paste(Control.arrange.viewstart + Control.timelinecurx);
                }
            }
        }
        if (key.ctrlheld && !Control.copykeyheld)
        {
            if (key.isDown(Keyboard.C))
            {
                Control.copykeyheld = true;Control.arrange.copy();Control.showmessage("PATTERNS COPIED");
            }
        }
        if (Control.cursorx > -1 && Control.cursory > -1 && Control.currentbox > -1 && !Control.clicklist)
        {
            if (key.press && Control.dragaction == 0)
            {
                //Add note
                if (Control.musicbox[Control.currentbox].start + Control.cursory - 1 == -1)
                {
                    if (key.click)
                    {
                        //Enable/Disable recording filter for this musicbox
                        Control.musicbox[Control.currentbox].recordfilter = 1 - Control.musicbox[Control.currentbox].recordfilter;
                    }
                }
                else if (Control.musicbox[Control.currentbox].start + Control.cursory - 1 > -1 && Control.musicbox[Control.currentbox].start + Control.cursory - 1 < Control.pianorollsize)
                {
                    Control.currentnote = Control.pianoroll[Control.musicbox[Control.currentbox].start + Control.cursory - 1];if (Control.musicbox[Control.currentbox].noteat(Control.cursorx, Control.currentnote))
                    {
                        Control.musicbox[Control.currentbox].removenote(Control.cursorx, Control.currentnote);Control.musicbox[Control.currentbox].addnote(Control.cursorx, Control.currentnote, Control.notelength);
                    }
                    else
                    {
                        Control.musicbox[Control.currentbox].addnote(Control.cursorx, Control.currentnote, Control.notelength);
                    }
                }
            }
            if (key.rightpress)
            {
                //Remove any note in this position
                if (Control.musicbox[Control.currentbox].start + ((Gfx.patterneditorheight - 1) - Control.cursory) > -1)
                {
                    //OLD
                    //Control.currentnote = Control.pianoroll[Control.musicbox[Control.currentbox].start + ((Gfx.patterneditorheight - 1) - Control.cursory)];if (Control.musicbox[Control.currentbox].start + Control.cursory - 1 > -1)
                    {
                        Control.currentnote = Control.pianoroll[Control.musicbox[Control.currentbox].start + Control.cursory - 1];
                    }
                    Control.musicbox[Control.currentbox].removenote(Control.cursorx, Control.currentnote);
                }
            }
        }
        else
        {
            if (key.click)
            {
                if (Control.secondlist.active)
                {
                    if (Control.secondlist.selection > -1)
                    {
                        //List selection stuff here
                        if (Control.secondlist.type >= Control.LIST_MIDI_0_PIANO && Control.secondlist.type <= Control.LIST_MIDI_15_SOUNDEFFECTS)
                        {
                            Control.changeinstrumentvoice(Control.secondlist.item[Control.secondlist.selection]);Control.secondlist.close();Control.list.close();
                        }
                    }
                    else
                    {
                        Control.secondlist.close();if (Control.list.selection == -1)
                        {
                            Control.list.close();
                        }
                    }
                    Control.clicksecondlist = true;
                }
                if (Control.list.active)
                {
                    if (Control.list.selection > -1)
                    {
                        //List selection stuff here
                        if (Control.list.type == Control.LIST_CATEGORY)
                        {
                            Control.list.close();Control.instrument[Control.currentinstrument].category = Control.list.item[Control.list.selection];Control.voicelist.index = Control.voicelist.getfirst(Control.instrument[Control.currentinstrument].category);Control.changeinstrumentvoice(Control.voicelist.name[Control.voicelist.index]);
                        }
                        if (Control.list.type == Control.LIST_MIDIINSTRUMENT)
                        {
                            Control.list.close();Control.filllist(Control.LIST_MIDIINSTRUMENT);Control.list.init(470, (Gfx.linesize * 3) + 6);Control.midilistselection = Control.list.selection;Control.secondlist.close();Control.filllist(Control.LIST_MIDI_0_PIANO + Control.list.selection);if (Gfx.screenwidth < 800)
                            {
                                Control.secondlist.init(580, (Gfx.linesize * 3) + 6 + (Control.list.selection * Gfx.linesize));
                            }
                            else
                            {
                                Control.secondlist.init(595, (Gfx.linesize * 3) + 6 + (Control.list.selection * Gfx.linesize));
                            }
                        }
                        if (Control.list.type == Control.LIST_INSTRUMENT)
                        {
                            if (help.Left(Control.list.item[Control.list.selection], 2) == "<<")
                            {
                                Control.voicelist.pagenum = 0;Control.list.close();Control.filllist(Control.LIST_INSTRUMENT);Control.list.init(470, (Gfx.linesize * 3) + 6);
                            }
                            else if (help.Left(Control.list.item[Control.list.selection], 2) == ">>")
                            {
                                Control.voicelist.pagenum++;if (Control.voicelist.pagenum == 15)
                                {
                                    Control.voicelist.pagenum = 0;
                                }Control.list.close();Control.filllist(Control.LIST_INSTRUMENT);Control.list.init(470, (Gfx.linesize * 3) + 6);
                            }
                            else
                            {
                                Control.changeinstrumentvoice(Control.list.item[Control.list.selection]);Control.list.close();
                            }
                        }
                        if (Control.list.type == Control.LIST_SELECTINSTRUMENT)
                        {
                            Control.musicbox[Control.currentbox].instr = Control.list.selection;Control.musicbox[Control.currentbox].palette = Control.instrument[Control.musicbox[Control.currentbox].instr].palette;Control.list.close();Guiclass.changetab(Control.currenttab);
                        }
                        if (Control.list.type == Control.LIST_KEY)
                        {
                            Control.changekey(Control.list.selection);Control.list.close();
                        }
                        if (Control.list.type == Control.LIST_SCALE)
                        {
                            Control.changescale(Control.list.selection);Control.list.close();
                        }
                        if (Control.list.type == Control.LIST_BUFFERSIZE)
                        {
                            Control.setbuffersize(Control.list.selection);Control.list.close();
                        }
                        if (Control.list.type == Control.LIST_EFFECTS)
                        {
                            Control.effecttype = Control.list.selection;Control.updateeffects();Control.list.close();
                        }
                        if (Control.list.type == Control.LIST_MOREEXPORTS)
                        {
                            if (Control.list.selection == 0)
                            {
                                #if targetDesktop
                                Control.exportxm();
                                #end
                            }
                            else if (Control.list.selection == 1)
                            {
                                // TODO: enable for web usage too (it's just text!)
                                #if targetDesktop
                                Control.exportmml();
                                #end
                            }Control.list.close();
                        }
                        if (Control.list.type == Control.LIST_EXPORTS)
                        {
                            Control.list.close();if (Control.list.selection == 0)
                            {
                                Control.exportwav();
                            }
                            else if (Control.list.selection == 1)
                            {
                                #if targetDesktop
                                Midicontrol.savemidi();
                                #end
                            }
                            else if (Control.list.selection == 2)
                            {
                                Control.filllist(Control.LIST_MOREEXPORTS);Control.list.init(Gfx.screenwidth - 170 - ((Gfx.screenwidth - 768) / 4), (Gfx.linespacing * 4) - 14);
                            }
                        }
                    }
                    else
                    {
                        Control.list.close();
                    }Control.clicklist = true;
                }
                else if (Control.clicksecondlist)
                {
                    //Clumsy workaround :3
                    Control.clicklist = true;
                }
                else if (Control.my <= Gfx.linesize)
                {
                    //Change tabs
                    #if targetDesktop
                    if (Control.mx < (Gfx.screenwidth - 40) / 4)
                    {
                        Control.changetab(Control.MENUTAB_FILE);
                    }
                    else if (Control.mx < (2 * (Gfx.screenwidth - 40)) / 4)
                    {
                        Control.changetab(Control.MENUTAB_ARRANGEMENTS);
                        Guiclass.helpcondition_set = "changetab_arrangement";
                         //For interactive tutorial
                    }
                    else if (Control.mx < (3 * (Gfx.screenwidth - 40)) / 4)
                    {
                        Control.changetab(Control.MENUTAB_INSTRUMENTS);
                        Guiclass.helpcondition_set = "changetab_instrument";
                         //For interactive tutorial
                    }
                    else
                    {
                        Control.changetab(Control.MENUTAB_ADVANCED);
                    }
                    #end

                    #if targetWeb
					if (Control.mx < (Gfx.screenwidth) / 4) {
						Control.changetab(Control.MENUTAB_FILE);
					}
                    else if (Control.mx < (2 * (Gfx.screenwidth)) / 4) {
						Control.changetab(Control.MENUTAB_ARRANGEMENTS);
					}
                    else if (Control.mx < (3 * (Gfx.screenwidth)) / 4) {
						Control.changetab(Control.MENUTAB_INSTRUMENTS);
					}
                    else{
						Control.changetab(Control.MENUTAB_ADVANCED);
					}
                    #end
                }
                else if (Control.my > Gfx.linesize && Control.my < Gfx.pianorollposition + 20)
                {
                    if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS)
                    {
                        //Arrangements
                        //Timelineif (Control.timelinecurx > -1)
                        {
                            j = as3hx.Compat.parseInt(Control.arrange.viewstart + Control.timelinecurx);
                            if (j > -1)
                            {
                                if (Control.doubleclickcheck > 0)
                                {
                                    //Set loop song from this bar
                                    Control.arrange.loopstart = j;Control.arrange.loopend = Control.arrange.lastbar;
                                    if (Control.arrange.loopend <= Control.arrange.loopstart)
                                    {
                                        Control.arrange.loopend = Control.arrange.loopstart + 1;
                                    }
                                    Control.doubleclickcheck = 0;
                                }
                                else
                                {
                                    Control.dragx = j;Control.dragaction = 3;Control.doubleclickcheck = 25;
                                }
                            }
                        }  //Pattern Manager  if (Control.patterncury > -1)
                        {
                            if (Control.patterncury == 0 && Control.patternmanagerview > 0 && Control.numboxes > 0)
                            {
                                Control.patternmanagerview--;
                            }
                            else if (Control.patterncury == 6 && Control.patterncury + Control.patternmanagerview < Control.numboxes)
                            {
                                Control.patternmanagerview++;
                            }
                            else
                            {
                                j = as3hx.Compat.parseInt(Control.patternmanagerview + Control.patterncury);if (j > -1 && j < Control.numboxes)
                                {
                                    Control.changemusicbox(j);Control.dragaction = 2;Control.dragpattern = j;Control.dragx = Control.mx;Control.dragy = Control.my;
                                }
                            }
                        }  //Arrangements  if (Control.arrangecurx > -1 && Control.arrangecury > -1)
                        {
                            if (Gfx.arrangementscrollleft == 0 && Gfx.arrangementscrollright == 0)
                            {
                                //Change, start drag
                                if (Control.dragaction == 0)
                                {
                                    if (Control.arrangecurx + Control.arrange.viewstart > -1)
                                    {
                                        j = Control.arrange.bar[Control.arrangecurx + Control.arrange.viewstart].channel[Control.arrangecury];if (j > -1)
                                        {
                                            Control.changemusicbox(j);Control.dragaction = 1;Control.dragpattern = j;Control.dragx = Control.mx;Control.dragy = Control.my;
                                        }
                                    }
                                    //Clicked the control panel
                                    else if (Control.arrange.viewstart == -1 && Control.arrangecurx == 0)
                                    
                                    /* Not doing this stuff anymore

										if (Control.mx < Gfx.patternwidth / 2) {

											Control.arrange.channelon[Control.arrangecury] = true;

										}else {

											Control.arrange.channelon[Control.arrangecury] = false;

										}*/{
                                        //Set loop to entire song!
                                        Control.arrange.loopstart = 0;
                                        Control.arrange.loopend = Control.arrange.lastbar;
                                    }
                                }
                            }
                        }
                    }
                    else if (Control.currenttab == Control.MENUTAB_INSTRUMENTS)
                    {
                        //Instrument Manager
                        if (Control.instrumentcury > -1)
                        {
                            if (Control.instrumentcury == 0 && Control.instrumentmanagerview > 0 && Control.numinstrument > 0)
                            {
                                Control.instrumentmanagerview--;
                            }
                            else if (Control.instrumentcury == 6 && Control.instrumentcury + Control.instrumentmanagerview < Control.numinstrument)
                            {
                                Control.instrumentmanagerview++;
                            }
                            else if (Control.instrumentcury == 7)
                            {
                                //Add a new one!
                            }
                            else
                            {
                                j = as3hx.Compat.parseInt(Control.instrumentcury + Control.instrumentmanagerview);if (j < Control.numinstrument)
                                {
                                    Control.currentinstrument = j;
                                }
                            }
                        }
                        else if (Control.my > (Gfx.linesize * 2) + 6 && Control.my < (Gfx.linesize * 3) + 6)
                        {
                            if (Control.mx > 280 && Control.mx < 460)
                            {
                                Control.filllist(Control.LIST_CATEGORY);Control.list.init(290, (Gfx.linesize * 3) + 6);
                            }
                            else if (Control.mx >= 460 && Control.mx <= 740)
                            {
                                if (Control.instrument[Control.currentinstrument].category == "MIDI")
                                {
                                    Control.voicelist.makesublist(Control.instrument[Control.currentinstrument].category);Control.voicelist.pagenum = 0;Control.filllist(Control.LIST_MIDIINSTRUMENT);Control.list.init(470, (Gfx.linesize * 3) + 6);
                                }
                                else
                                {
                                    Control.voicelist.makesublist(Control.instrument[Control.currentinstrument].category);Control.filllist(Control.LIST_INSTRUMENT);Control.list.init(470, (Gfx.linesize * 3) + 6);
                                }
                            }
                        }
                    }
                }
                else if (Control.notey > -1)
                {
                    //Play a single note
                    if (Control.currentbox > -1)
                    {
                        if (Control.instrument[Control.musicbox[Control.currentbox].instr].type == 0)
                        {
                            //Normal instrument
                            j = as3hx.Compat.parseInt(Control.musicbox[Control.currentbox].start + Control.notey - 1);if (j >= 0 && j < 128)
                            {
                                Control._driver.noteOn(Control.pianoroll[j], Control.instrument[Control.musicbox[Control.currentbox].instr].voice, Control.notelength);
                            }
                        }
                        //Drumkit
                        else
                        {
                            j = as3hx.Compat.parseInt(Control.musicbox[Control.currentbox].start + Control.notey - 1);if (j >= 0 && j < 128)
                            {
                                Control._driver.noteOn(Control.drumkit[Control.instrument[Control.musicbox[Control.currentbox].instr].type - 1].voicenote[j], Control.drumkit[Control.instrument[Control.musicbox[Control.currentbox].instr].type - 1].voicelist[j], Control.notelength);
                            }
                        }
                    }
                }
            }
            if (key.press && (!Control.clicklist && !Control.clicksecondlist))
            {
                if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS)
                {
                    if (Control.dragaction == 0 || Control.dragaction == 3)
                    {
                        if (Control.arrangescrolldelay == 0)
                        {
                            if (Gfx.arrangementscrollleft > 0)
                            {
                                Control.arrange.viewstart--;if (Control.arrange.viewstart < 0)
                                {
                                    Control.arrange.viewstart = 0;
                                }Control.arrangescrolldelay = 4;
                            }
                            else if (Gfx.arrangementscrollright > 0)
                            {
                                Control.arrange.viewstart++;if (Control.arrange.viewstart > 1000)
                                {
                                    Control.arrange.viewstart = 1000;
                                }Control.arrangescrolldelay = 4;
                            }
                        }
                    }
                }
                else if (Control.currenttab == Control.MENUTAB_INSTRUMENTS)
                {
                    if (Control.my > Gfx.linesize && Control.my < Gfx.pianorollposition + 20)
                    {
                        if (Control.mx >= 280 && Control.my > 70 && Control.mx < Gfx.screenwidth - 50)
                        {
                            i = as3hx.Compat.parseInt(Control.mx - 280);j = as3hx.Compat.parseInt(Control.my - 80);if (i < 0)
                            {
                                i = 0;
                            }
                            if (i > Gfx.screenwidth - 368)
                            {
                                i = as3hx.Compat.parseInt(Gfx.screenwidth - 368);
                            }
                            if (j < 0)
                            {
                                j = 0;
                            }
                            if (j > 90)
                            {
                                j = 90;
                            }k = 0;if (Control.currentbox > -1)
                            {
                                if (Control.musicbox[Control.currentbox].recordfilter == 1)
                                {
                                    k = 1;
                                }
                            }
                            if (k == 1)
                            {
                                Control.musicbox[Control.currentbox].cutoffgraph[Control.looptime % Control.boxcount] = (i * 128) / (Gfx.screenwidth - 368);Control.musicbox[Control.currentbox].resonancegraph[Control.looptime % Control.boxcount] = (j * 9) / 90;Control.instrument[Control.currentinstrument].changefilterto(Control.musicbox[Control.currentbox].cutoffgraph[Control.looptime % Control.boxcount], Control.musicbox[Control.currentbox].resonancegraph[Control.looptime % Control.boxcount], Control.musicbox[Control.currentbox].volumegraph[Control.looptime % Control.boxcount]);if (Control.instrument[Control.currentinstrument].type > 0)
                                {
                                    Control.drumkit[Control.instrument[Control.currentinstrument].type - 1].updatefilter(Control.instrument[Control.currentinstrument].cutoff, Control.instrument[Control.currentinstrument].resonance);
                                }
                            }
                            else
                            {
                                Control.instrument[Control.currentinstrument].setfilter((i * 128) / (Gfx.screenwidth - 368), (j * 9) / 90);Control.instrument[Control.currentinstrument].updatefilter();if (Control.instrument[Control.currentinstrument].type > 0)
                                {
                                    Control.drumkit[Control.instrument[Control.currentinstrument].type - 1].updatefilter(Control.instrument[Control.currentinstrument].cutoff, Control.instrument[Control.currentinstrument].resonance);
                                }
                            }
                        }
                        else if (Control.my > 70 && Control.mx >= Gfx.screenwidth - 50)
                        {
                            j = as3hx.Compat.parseInt(Control.my - 90);if (j < 0)
                            {
                                j = 0;
                            }
                            if (j > 90)
                            {
                                j = 90;
                            }j = as3hx.Compat.parseInt(90 - j);k = 0;if (Control.currentbox > -1)
                            {
                                if (Control.musicbox[Control.currentbox].recordfilter == 1)
                                {
                                    if (Control.musicbox[Control.currentbox].instr == Control.currentinstrument)
                                    {
                                        k = 1;
                                    }
                                }
                            }
                            if (k == 1)
                            {
                                Control.musicbox[Control.currentbox].volumegraph[Control.looptime % Control.boxcount] = (j * 256) / 90;Control.instrument[Control.currentinstrument].changevolumeto((j * 256) / 90);if (Control.instrument[Control.currentinstrument].type > 0)
                                {
                                    Control.drumkit[Control.instrument[Control.currentinstrument].type - 1].updatevolume((j * 256) / 90);
                                }
                            }
                            else
                            {
                                Control.instrument[Control.currentinstrument].setvolume((j * 256) / 90);Control.instrument[Control.currentinstrument].updatefilter();if (Control.instrument[Control.currentinstrument].type > 0)
                                {
                                    Control.drumkit[Control.instrument[Control.currentinstrument].type - 1].updatevolume((j * 256) / 90);
                                }
                            }
                        }
                    }
                }
            }
            if (key.rightpress)
            {
                if (Control.my > Gfx.linesize && Control.my < Gfx.pianorollposition + Gfx.linesize)
                {
                    if (Control.currenttab == Control.MENUTAB_FILE)
                    {
                        //Files
                    }
                    else if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS)
                    {
                        //Arrangements
                        //Timeline
                        if (key.rightclick)
                        {
                            if (Control.timelinecurx > -1)
                            {
                                j = as3hx.Compat.parseInt(Control.arrange.viewstart + Control.timelinecurx);if (j > -1)
                                {
                                    //Insert blank pattern
                                    Control.arrange.deletebar(j);
                                }
                            }
                        }
                        //Pattern Manager
                        //Arrangements
                        if (Control.arrangecurx > -1 && Control.arrangecury > -1)
                        {
                            //Delete pattern from position
                            Control.dragaction = 0;
                            if (Control.arrange.bar[Control.arrangecurx + Control.arrange.viewstart].channel[Control.arrangecury] > -1)
                            {
                                Control.arrange.removepattern(Control.arrangecurx + Control.arrange.viewstart, Control.arrangecury);
                            }
                        }
                    }
                    else if (Control.currenttab == Control.MENUTAB_INSTRUMENTS)
                    {
                        //Instruments
                    }
                }
            }
            if (key.middleclick)
            {
                if (Control.my > Gfx.linesize && Control.my < Gfx.pianorollposition + Gfx.linesize)
                {
                    if (Control.currenttab == Control.MENUTAB_FILE)
                    {
                        //Files
                    }
                    else if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS)
                    {
                        //Arrangements
                        //Timeline
                        if (Control.timelinecurx > -1)
                        {
                            j = as3hx.Compat.parseInt(Control.arrange.viewstart + Control.timelinecurx);if (j > -1)
                            {
                                //Insert blank pattern
                                Control.arrange.insertbar(j);
                            }
                        }
                        //Pattern Manager
                        //Arrangements
                        if (Control.arrangecurx > -1 && Control.arrangecury > -1)
                        {
                            //Make variation pattern!
                            j = Control.arrange.bar[Control.arrangecurx + Control.arrange.viewstart].channel[Control.arrangecury];if (j > -1)
                            {
                                Control.addmusicbox();Control.copymusicbox(Control.numboxes - 1, j);Control.musicbox[Control.numboxes - 1].setnotespan();Control.patternmanagerview = Control.numboxes - 6;Control.changemusicbox(Control.numboxes - 1);if (Control.patternmanagerview < 0)
                                {
                                    Control.patternmanagerview = 0;
                                }Control.dragaction = 1;Control.dragpattern = Control.numboxes - 1;Control.dragx = Control.mx;Control.dragy = Control.my;
                            }
                        }
                    }
                    else if (Control.currenttab == Control.MENUTAB_INSTRUMENTS)
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
            key.hasmiddlereleased = false;Gfx.updatebackground = 5;  //Update the background on input
            
            if (Control.dragaction == 1 || Control.dragaction == 2)
            {
                Control.dragaction = 0;if (Control.arrangecurx > -1 && Control.arrangecury > -1)
                {
                    Control.arrange.addpattern(Control.arrangecurx + Control.arrange.viewstart, Control.arrangecury, Control.dragpattern);
                }
                else if (Control.mx > Gfx.screenwidth - 120 && Control.my > Gfx.screenheight - 40)
                {
                    Control.deletemusicbox(Control.dragpattern);Guiclass.changetab(Control.currenttab);
                }
            }
            else if (Control.dragaction == 3)
            {
                Control.dragaction = 0;Control.arrange.loopstart = Control.dragx;Control.arrange.loopend = Control.arrange.viewstart + Control.timelinecurx + 1;if (Control.arrange.loopend <= Control.arrange.loopstart)
                {
                    i = Control.arrange.loopend;Control.arrange.loopend = Control.arrange.loopstart + 1;Control.arrange.loopstart = i - 1;
                }
                if (Control.arrange.currentbar < Control.arrange.loopstart)
                {
                    Control.arrange.currentbar = Control.arrange.loopstart;
                }
                if (Control.arrange.currentbar >= Control.arrange.loopend)
                {
                    Control.arrange.currentbar = Control.arrange.loopend - 1;
                }
                if (Control.arrange.loopstart < 0)
                {
                    Control.arrange.loopstart = 0;
                }
            }
        }
        if (Control.my > Gfx.pianorollposition)
        {
            if (key.mousewheel < 0)
            {
                Control.notelength--;if (Control.notelength < 1)
                {
                    Control.notelength = 1;
                }key.mousewheel = 0;
            }
            else if (key.mousewheel > 0)
            {
                Control.notelength++;key.mousewheel = 0;
            }
        }
        else if (key.mousewheel < 0 || (key.shiftheld && (Control.press_down || Control.press_left)))
        {
            Gfx.zoom--;if (Gfx.zoom < 1)
            {
                Gfx.zoom = 1;
            }gfx.setzoomlevel(Gfx.zoom);key.mousewheel = 0;
        }
        else if (key.mousewheel > 0 || (key.shiftheld && (Control.press_up || Control.press_right)))
        {
            Gfx.zoom++;if (Gfx.zoom > 4)
            {
                Gfx.zoom = 4;
            }gfx.setzoomlevel(Gfx.zoom);key.mousewheel = 0;
        }
        if (Control.keydelay <= 0)
        {
            if (Control.currentbox > -1)
            {
                if (!key.shiftheld)
                {
                    if (Control.press_down)
                    {
                        Control.musicbox[Control.currentbox].start--;if (Control.musicbox[Control.currentbox].start < -1)
                        {
                            Control.musicbox[Control.currentbox].start = -1;
                        }Control.keydelay = 2;
                    }
                    else if (Control.press_up)
                    {
                        Control.musicbox[Control.currentbox].start++;if (Control.musicbox[Control.currentbox].start > Control.pianorollsize - Gfx.notesonscreen)
                        {
                            Control.musicbox[Control.currentbox].start = Control.pianorollsize - Gfx.notesonscreen;
                        }
                        if (Control.instrument[Control.musicbox[Control.currentbox].instr].type > 0)
                        {
                            //Also check for drumkit ranges
                            if (Control.musicbox[Control.currentbox].start > Control.drumkit[Control.instrument[Control.musicbox[Control.currentbox].instr].type - 1].size - 12)
                            {
                                Control.musicbox[Control.currentbox].start = Control.drumkit[Control.instrument[Control.musicbox[Control.currentbox].instr].type - 1].size - 12;
                            }
                            if (Control.musicbox[Control.currentbox].start < 0)
                            {
                                Control.musicbox[Control.currentbox].start = 0;
                            }
                        }Control.keydelay = 2;
                    }
                }
                else if (Control.press_down || Control.press_left)
                {
                    Control.notelength--;if (Control.notelength < 1)
                    {
                        Control.notelength = 1;
                    }Control.keydelay = 2;
                }
                else if (Control.press_up || Control.press_right)
                {
                    Control.notelength++;Control.keydelay = 2;
                }
            }
            if (!key.shiftheld)
            {
                if (Control.press_left)
                {
                    Control.arrange.viewstart--;if (Control.arrange.viewstart < 0)
                    {
                        Control.arrange.viewstart = 0;
                    }Control.keydelay = 2;
                }
                else if (Control.press_right)
                {
                    Control.arrange.viewstart++;if (Control.arrange.viewstart > 1000)
                    {
                        Control.arrange.viewstart = 1000;
                    }Control.keydelay = 2;
                }
            }
        }
        else
        {
            Control.keydelay--;
        }
        if (Control.currentbox > -1)
        {
            if (!Control.press_down && Control.musicbox[Control.currentbox].start == -1)
            {
                Control.musicbox[Control.currentbox].start = 0;
            }
        }
        if (!Control.keyheld)
        {
            if (Control.press_space || Control.press_enter)
            {
                if (!Control.musicplaying)
                {
                    Control.startmusic();
                }
                else
                {
                    Control.stopmusic();
                }Control.keyheld = true;
            }
        }  //Hardcoding some interactive tutorial stuff here  if (Guiclass.helpcondition_check != "nothing")
        {
            if (Guiclass.helpcondition_check == Guiclass.helpcondition_set)
            {
                if (Guiclass.helpcondition_check == "changetab_arrangement")
                {
                    Guiclass.changewindow("help6");Control.changetab(Control.currenttab);Control.clicklist = true;
                }
                else if (Guiclass.helpcondition_check == "addnew_pattern")
                {
                    Guiclass.changewindow("help7");Control.changetab(Control.currenttab);Control.clicklist = true;
                }
                else if (Guiclass.helpcondition_check == "addnew_instrument")
                {
                    Guiclass.changewindow("help15");Control.changetab(Control.currenttab);Control.clicklist = true;
                }
                else if (Guiclass.helpcondition_check == "changetab_instrument")
                {
                    Guiclass.changewindow("help14");Control.changetab(Control.currenttab);Control.clicklist = true;
                }
            }Guiclass.helpcondition_set = "nothing";
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
        var k : Int;if (Gfx.updatebackground > 0)
        {
            Gfx.changeframerate(30);
            //Background
            Gfx.fillrect(0, 0, Gfx.screenwidth, Gfx.screenheight, 1);
            
            //Tabs
            #if targetDesktop
            j = as3hx.Compat.parseInt((Gfx.screenwidth - 40) / 4);
            #end
            #if targetWeb
            j = (Gfx.screenwidth) / 4;
            #end
            if (Control.currenttab == Control.MENUTAB_HELP)
            {
                Gfx.fillrect(0, 0, j, Gfx.linesize, 5);Gfx.print(14, 0, "HELP", (Control.currenttab == Control.MENUTAB_HELP) ? 0 : 2, false, true);
            }
            else if (Control.currenttab == Control.MENUTAB_CREDITS || Control.currenttab == Control.MENUTAB_GITHUB)
            {
                Gfx.fillrect(0, 0, j, Gfx.linesize, 5);Gfx.print(14, 0, "CREDITS", ((Control.currenttab == Control.MENUTAB_CREDITS || Control.currenttab == Control.MENUTAB_GITHUB)) ? 0 : 2, false, true);
            }
            else
            {
                Gfx.fillrect(Control.currenttab * j, 0, j, Gfx.linesize, 5);Gfx.print(14, 0, "FILE", (Control.currenttab == Control.MENUTAB_FILE) ? 0 : 2, false, true);
            }
            Gfx.print(j + 14, 0, "ARRANGEMENT", (Control.currenttab == Control.MENUTAB_ARRANGEMENTS) ? 0 : 2, false, true);
            Gfx.print((j * 2) + 14, 0, "INSTRUMENT", (Control.currenttab == Control.MENUTAB_INSTRUMENTS) ? 0 : 2, false, true);
            Gfx.print((j * 3) + 14, 0, "ADVANCED", (Control.currenttab == Control.MENUTAB_ADVANCED) ? 0 : 2, false, true);
            #if targetDesktop
                Gfx.fillrect(j * 4, 0, 42, 20, 3);
                Gfx.drawicon((j * 4) + 12, 1, (Control.fullscreen) ? 5 : 4);
            #end

            if (Control.nowexporting)
            {
                Gfx.updatebackground = 5;Gfx.fillrect(0, Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth, Gfx.screenheight - (Gfx.pianorollposition + Gfx.linesize), 14);if (Control.arrange.currentbar % 2 == 0)
                {
                    Guiclass.tx = as3hx.Compat.parseInt(Gfx.screenwidth / 64) + 1;i = -1;
                    while (i < Guiclass.tx)
                    {
                        Gfx.fillrect((i * 64) + help.slowsine, Gfx.pianorollposition + Gfx.linesize, 32, Gfx.screenheight - (Gfx.pianorollposition + Gfx.linesize), 1);
                        i++;
                    }
                }
                else
                {
                    Guiclass.tx = as3hx.Compat.parseInt(Gfx.screenheight - (Gfx.pianorollposition + Gfx.linesize) / 64) + 1;i = 0;
                    while (i < Guiclass.tx)
                    {
                        Gfx.fillrect(0, Gfx.pianorollposition + Gfx.linesize + (i * 64) + help.slowsine, Gfx.screenwidth, 32, 1);
                        i++;
                    }
                    if (help.slowsine >= 32)
                    {
                        Gfx.fillrect(0, Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth, help.slowsine - 32, 1);
                    }
                }
                if (help.slowsine < 32)
                {
                    Gfx.print(Gfx.screenwidthmid - (Gfx.len("NOW EXPORTING AS WAV, PLEASE WAIT") / 2), (Gfx.pianorollposition + Gfx.linesize) + (Gfx.screenheight - Gfx.hig("WAV") - (Gfx.pianorollposition + Gfx.linesize)) / 2, "NOW EXPORTING AS WAV, PLEASE WAIT", 0, false, true);
                }
            }
            else if (Control.currentbox > -1)
            {
                Gfx.drawpatterneditor();
            }
            else
            {
                Gfx.fillrect(0, Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth, Gfx.screenheight - Gfx.pianorollposition, 14);
            }  //Draw menu area  Gfx.fillrect(0, Gfx.linesize, Gfx.screenwidth, Gfx.linesize * 10, 5);j = 0;
            while (j < Gfx.linesize * 10)
            {
                if (j % 4 == 0)
                {
                    Gfx.fillrect(0, Gfx.linesize + j, Gfx.screenwidth, 2, 1);
                }
                j++;
            }var _sw0_ = (Control.currenttab);            

            switch (_sw0_)
            {case Control.MENUTAB_FILE:Guiclass.tx = (Gfx.screenwidth - 768) / 4;Gfx.fillrect(Guiclass.tx, Gfx.linesize, 408, Gfx.linesize * 10, 5);Gfx.fillrect(Gfx.screenwidth - Guiclass.tx - 408 + 24, Gfx.linesize, 408, Gfx.linesize * 10, 5);case Control.MENUTAB_CREDITS:Guiclass.tx = (Gfx.screenwidth - 768) / 4;Gfx.fillrect(Guiclass.tx, Gfx.linesize, 408, Gfx.linesize * 10, 5);Gfx.fillrect(Gfx.screenwidth - Guiclass.tx - 408 + 24, Gfx.linesize, 408, Gfx.linesize * 10, 5);case Control.MENUTAB_GITHUB:Guiclass.tx = (Gfx.screenwidth - 768) / 4;Gfx.fillrect(Guiclass.tx, Gfx.linesize, 408, Gfx.linesize * 10, 5);Gfx.fillrect(Gfx.screenwidth - Guiclass.tx - 408 + 24, Gfx.linesize, 408, Gfx.linesize * 10, 5);case Control.MENUTAB_HELP:Guiclass.tx = (Gfx.screenwidth - 768) / 2;Gfx.fillrect(Guiclass.tx, Gfx.linesize, 768, Gfx.linesize * 10, 5);case Control.MENUTAB_ARRANGEMENTS:gfx.drawarrangementeditor();Gfx.drawtimeline();Gfx.drawpatternmanager();case Control.MENUTAB_INSTRUMENTS:gfx.drawinstrumentlist();Gfx.drawinstrument();case Control.MENUTAB_ADVANCED:Guiclass.tx = (Gfx.screenwidth - 768) / 4;Gfx.fillrect(Guiclass.tx, Gfx.linesize, 408, Gfx.linesize * 10, 5);Gfx.fillrect(Gfx.screenwidth - Guiclass.tx - 408 + 24, Gfx.linesize, 408, Gfx.linesize * 10, 5);
            }  //Cache bitmap at this point  Gfx.updatebackground--;if (Gfx.updatebackground == 0)
            {
                Gfx.settrect(Gfx.backbuffer.rect.x, Gfx.backbuffer.rect.y, Gfx.backbuffer.rect.width, Gfx.backbuffer.rect.height);Gfx.backbuffercache.copyPixels(Gfx.backbuffer, Gfx.trect, Gfx.tl);
            }
        }
        else
        {
            if (!Control.musicplaying)
            {
                Gfx.changeframerate(15);
            }  //If there's no music playing, drop the framerate!    //Draw from cache  Gfx.settrect(Gfx.backbuffercache.rect.x, Gfx.backbuffercache.rect.y, Gfx.backbuffercache.rect.width, Gfx.backbuffercache.rect.height);Gfx.backbuffer.copyPixels(Gfx.backbuffercache, Gfx.trect, Gfx.tl);
        }
        if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS)
        {
            Gfx.drawarrangementcursor();if (Control.mx > Gfx.patternmanagerx - 108)
            {
                Gfx.drawpatternmanager();
            }gfx.drawtimeline_cursor();Gfx.drawpatternmanager_cursor();
        }
        if (!Control.nowexporting)
        {
            if (Control.currentbox > -1)
            {
                Gfx.drawpatterneditor_cursor();
            }
        }Guiclass.drawbuttons();if (Control.messagedelay > 0)
        {
            i = (Control.messagedelay > 10) ? 10 : Control.messagedelay;Gfx.fillrect(0, Gfx.screenheight - (i * 2), Gfx.screenwidth, 20, 16);Gfx.print(Gfx.screenwidthmid - (Gfx.len(Control.message) / 2), Gfx.screenheight - (i * 2), Control.message, 0, false, true);
        }  //Draw pop up lists over all that  Gfx.drawlist();  //Draw mouse dragging stuff over everything  if (Control.dragaction == 1 || Control.dragaction == 2)
        {
            if (Math.abs(Control.mx - Control.dragx) > 4 || Math.abs(Control.my - Control.dragy) > 4)
            {
                Gfx.drawmusicbox(Control.mx, Control.my, Control.dragpattern);
            }
        }gfx.render();
    }
    
    public function new()
    {
        super();
        Control.versionnumber = "v2.1 unstable";  // Version number displayed beside logo  
        Control.version = 3;  // Version number used by file  
        Control.ctrl = "Ctrl";  //Set this to Cmd on Mac so that the tutorial is correct  
        
        #if targetDesktop
        appEventDispatcher.addEventListener("INVOKE", onInvokeEvent);
        appEventDispatcher.dispatchEvent(new Event("INVOKE"));
        #end
        
        key = new KeyPoll(stage);
        Control.init();
        
        //Working towards resolution independence!
        Gfx.init(stage);
        
        #if targetDesktop
        stage.addEventListener(Event.RESIZE, handleResize);
        #end
        
        var tempbmp : Bitmap;
        tempbmp = new ImIcons();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.makeiconarray();
        tempbmp = new ImLogo0();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        tempbmp = new ImLogo1();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        tempbmp = new ImLogo2();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        tempbmp = new ImLogo3();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        tempbmp = new ImLogo4();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        tempbmp = new ImLogo5();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        tempbmp = new ImLogo6();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        tempbmp = new ImLogo7();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        
        tempbmp = new ImTutorialimage0();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        tempbmp = new ImTutorialimage1();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        tempbmp = new ImTutorialimage2();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        tempbmp = new ImTutorialimage3();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        tempbmp = new ImTutorialimage4();
        Gfx.buffer = tempbmp.bitmapData;
        Gfx.addimage();
        Gfx.buffer = new BitmapData(1, 1, false, 0x000000);
        
        Control.changetab(Control.MENUTAB_FILE);
        
        Control.voicelist.fixlengths();
        stage.fullScreenSourceRect = null;
        addChild(Gfx.screen);
        
        Control.loadscreensettings();
        Control.loadfilesettings();
        updategraphicsmode();
        
        Gfx.changescalemode(Gfx.scalemode);
        
        if (Guiclass.firstrun)
        {
            Guiclass.changewindow("firstrun");
            Control.changetab(Control.currenttab);
            Control.clicklist = true;
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
            tempwidth = Gfx.windowwidth;
            tempheight = Gfx.windowheight;
        }
        
        Control.savescreencountdown = 30;  //Half a second after a resize, save the settings  
        Control.minresizecountdown = 5;  //Force a minimum screensize  
        Gfx.changewindowsize(tempwidth, tempheight);
        
        Gfx.patternmanagerx = Gfx.screenwidth - 116;
        Gfx.patterneditorheight = (Gfx.windowheight - (Gfx.pianorollposition - (Gfx.linesize + 2))) / 12;
        Gfx.notesonscreen = ((Gfx.screenheight - Gfx.pianorollposition - Gfx.linesize) / Gfx.linesize) + 1;
        Gfx.tf_1.width = Gfx.windowwidth;
        Gfx.updateboxsize();
        
        Guiclass.changetab(Control.currenttab);
        
        var temp : BitmapData = new BitmapData(Gfx.windowwidth, Gfx.windowheight, false, 0x000000);
        Gfx.updatebackground = 5;
        Gfx.backbuffercache = new BitmapData(Gfx.windowwidth, Gfx.windowheight, false, 0x000000);
        temp.copyPixels(Gfx.backbuffer, Gfx.backbuffer.rect, Gfx.tl);
        Gfx.backbuffer = temp;
        //gfx.screen.bitmapData.dispose();
        Gfx.screen.bitmapData = Gfx.backbuffer;
        if (Gfx.scalemode == 1)
        {
            Gfx.screen.scaleX = 1.5;
            Gfx.screen.scaleY = 1.5;
        }
        else
        {
            Gfx.screen.scaleX = 1;
            Gfx.screen.scaleY = 1;
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
        Gfx.changeframerate(30);
    }
    
    private function __deactivate__(__DOLLAR__event : Event) : Void
    {
        Gfx.changeframerate(1);
    }
    
    #if targetWeb
    private function _startMainLoopWeb() : Void
    {
        // Expose some functions to external JS
        ExternalInterface.addCallback("getCeolString", Control.getCeolString);
        ExternalInterface.addCallback("invokeCeolWeb", Control.invokeCeolWeb);
        ExternalInterface.addCallback("newSong", Control.newsong);
        ExternalInterface.addCallback("exportWav", Control.exportwav);

        Control.invokeCeolWeb(ExternalInterface.call("Bosca._getStartupCeol"));

        _startMainLoop();
    }
    #end
    
    public function _input() : Void
    {
        if (Gfx.scalemode == 1)
        {
            Control.mx = mouseX / 1.5;
            Control.my = mouseY / 1.5;
        }
        else
        {
            Control.mx = mouseX;
            Control.my = mouseY;
        }
        
        input(key);
    }
    
    public function _logic() : Void
    {
        logic(key);
        help.updateglow();
        if (Control.forceresize)
        {
            Control.forceresize = false;
            handleResize(null);
        }
    }
    
    public function _render() : Void
    {
        Gfx.backbuffer.lock();
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
        
        if (Control.fullscreen)
        {
            stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
        }
        else
        {
            stage.displayState = StageDisplayState.NORMAL;
        }
        
        Control.savescreensettings();
    }
    
    #if targetDesktop
    public function onInvokeEvent(event : Event) : Void
    {
        if (event.arguments.length > 0)
        {
            if (event.currentDirectory != null)
            {
                // set file directory to current directory
                
                Control.filepath = event.currentDirectory;
            }
            if (Control.startup == 0)
            {
                //Loading a song at startup, wait until the sound is initilised
                
                Control.invokefile = event.arguments[0];
            }
            //Program is up and running, just load now
            else
            {
                
                Control.invokeceol(event.arguments[0]);
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
