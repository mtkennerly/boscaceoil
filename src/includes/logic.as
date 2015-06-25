﻿public function logic(key:KeyPoll):void {
	var i:int, j:int, k:int;
	
	if (control.messagedelay > 0) control.messagedelay--;
  if (control.doubleclickcheck > 0) control.doubleclickcheck--;
	if (gfx.buttonpress > 0) gfx.buttonpress--;
	
	if (control.minresizecountdown > 0) {
		control.minresizecountdown--;
		if (control.minresizecountdown == 0) {
			gfx.forceminimumsize();
		}
	}
	
	if (control.savescreencountdown > 0) {
		control.savescreencountdown--;
		if (control.savescreencountdown <= 0) control.savescreensettings();
	}
	
	if (control.dragaction == 2) {
		control.trashbutton++;
		if (control.trashbutton > 10) control.trashbutton = 10;
	}else {
		if (control.trashbutton > 0) control.trashbutton--;
	}
	
	if (control.followmode) {
		if (control.arrange.currentbar < control.arrange.viewstart) {
			control.arrange.viewstart = control.arrange.currentbar;
		}
		if (control.arrange.currentbar > control.arrange.viewstart+5) {
			control.arrange.viewstart = control.arrange.currentbar;
		}
	}
}
