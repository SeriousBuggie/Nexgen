/***************************************************************************************************
 *
 *  NSC. Nexgen Server Controller by Zeropoint.
 *
 *  $CLASS        NexgenRCPClientConfig
 *  $VERSION      1.06 (8-3-2008 22:13)
 *  $AUTHOR       Daan 'Defrost' Scheerens  initial version
 *  $CONTACT      d.scheerens@gmail.com
 *  $DESCRIPTION  Nexgen client settings control panel page.
 *
 **************************************************************************************************/
class NexgenRCPClientConfig extends NexgenPanel;

var UWindowCheckbox enableNexgenHUDInp;
var UWindowCheckbox useMsgFlashEffectInp;
var UWindowCheckbox showPlayerLocationInp;
var UWindowCheckbox playPMSoundInp;
var UWindowCheckbox autoSSNormalGameInp;
var UWindowCheckbox autoSSMatchInp;
var UWindowComboControl chatAreaLinesInp;
var NexgenHSliderControl chatAreaFontInp;
var UWindowComboControl chatAreaColorInp;
var UWindowComboControl otherAreaLinesInp;
var NexgenHSliderControl otherAreaFontInp;
var UWindowComboControl otherAreaColorInp;

/***************************************************************************************************
 *
 *  $DESCRIPTION  Creates the contents of the panel.
 *  $OVERRIDE
 *
 **************************************************************************************************/
function setContent() {
	local NexgenContentPanel p;
	local int index;	
	
	// Create layout & add components.
	setAcceptsFocus();
	createPanelRootRegion(); //createWindowRootRegion();
	splitRegionV(196, defaultComponentDist);
	
	// Keybindings.
    addSubPanel(class'NexgenCPKeyBind');
	
	// User Interface settings.
	splitRegionH(192, defaultComponentDist);
	p = addContentPanel();
	p.splitRegionH(16);
	p.addLabel(client.lng.UISettingsTxt, true, TA_Center);
	p.divideRegionH(9);
	enableNexgenHUDInp = p.addCheckBox(TA_Left, client.lng.enableMsgHUDTxt);
	p.splitRegionV(32, defaultComponentDist, , true);
	p.splitRegionV(96, defaultComponentDist, , true);
	p.splitRegionV(64, defaultComponentDist, , true);
	p.splitRegionV(32, defaultComponentDist, , true);
	p.splitRegionV(96, defaultComponentDist, , true);
	p.splitRegionV(64, defaultComponentDist, , true);
	useMsgFlashEffectInp = p.addCheckBox(TA_Left, client.lng.msgFlashEffectTxt);
	showPlayerLocationInp = p.addCheckBox(TA_Left, client.lng.showPlayerLocationTxt);
	p.addLabel("Chat messages line count");
	chatAreaLinesInp = p.addListCombo();
	p.addLabel("Chat messages font size");
	chatAreaFontInp = p.addHSlider();
	p.addLabel("Chat messages default font color");
	chatAreaColorInp = p.addListCombo();
	p.addLabel("Other messages line count");
	otherAreaLinesInp = p.addListCombo();
	p.addLabel("Other messages font size");
	otherAreaFontInp = p.addHSlider();
	p.addLabel("Other messages default font color");
	otherAreaColorInp = p.addListCombo();
	
	// Other stuff.
	splitRegionH(80, defaultComponentDist);
	p = addContentPanel();
	p.splitRegionH(16);
	p.addLabel(client.lng.miscSettingsTxt, true, TA_Center);
	p.divideRegionH(3);
	playPMSoundInp = p.addCheckBox(TA_Left, client.lng.pmSoundTxt);
	autoSSNormalGameInp = p.addCheckBox(TA_Left, client.lng.autoSSNormalGameTxt);
	autoSSMatchInp = p.addCheckBox(TA_Left, client.lng.autoSSMatchTxt);
	
	// Configure components.
	enableNexgenHUDInp.register(self);
	chatAreaLinesInp.register(self);
	chatAreaFontInp.register(self);
	chatAreaColorInp.register(self);
	otherAreaLinesInp.register(self);
	otherAreaFontInp.register(self);
	otherAreaColorInp.register(self);
	useMsgFlashEffectInp.register(self);
	showPlayerLocationInp.register(self);
	playPMSoundInp.register(self);
	autoSSNormalGameInp.register(self);
	autoSSMatchInp.register(self);

	enableNexgenHUDInp.bChecked = client.gc.get(client.SSTR_UseNexgenHUD, "true") ~= "true";
	useMsgFlashEffectInp.bChecked = client.gc.get(client.SSTR_FlashMessages, "false") ~= "true";
	showPlayerLocationInp.bChecked = client.gc.get(client.SSTR_ShowPlayerLocation, "true") ~= "true";
	playPMSoundInp.bChecked = client.gc.get(client.SSTR_PlayPMSound, "true") ~= "true";
	autoSSNormalGameInp.bChecked = client.gc.get(client.SSTR_AutoSSNormalGame, "false") ~= "true";
	autoSSMatchInp.bChecked = client.gc.get(client.SSTR_AutoSSMatch, "true") ~= "true";
	
	loadNumOfLines(3, 8, chatAreaLinesInp);
	loadNumOfLines(0, 8, otherAreaLinesInp);
	loadFontColors(chatAreaColorInp);
	loadFontColors(otherAreaColorInp);

	chatAreaFontInp.SetRange(1, 7, 1);
	otherAreaFontInp.SetRange(1, 7, 1);
	
	chatAreaFontInp.SetValue(2);
	otherAreaFontInp.SetValue(1);
}

function loadNumOfLines(byte start, byte end, UWindowComboControl comboList) {
	local int i;
	
	for(i=start; i<=end; i++) {
		comboList.addItem(string(i));
	}
} 

function loadFontColors(UWindowComboControl comboList) {
	comboList.addItem("Red");
	comboList.addItem("Blue");
	comboList.addItem("Green");
	comboList.addItem("Yellow");
	comboList.addItem("White");
	comboList.addItem("Black");
	comboList.addItem("Pink");
	comboList.addItem("Cyan");
	comboList.addItem("Metal");
	comboList.addItem("Orange");
} 

/***************************************************************************************************
 *
 *  $DESCRIPTION  Notifies the dialog of an event (caused by user interaction with the interface).
 *  $PARAM        control    The control object where the event was triggered.
 *  $PARAM        eventType  Identifier for the type of event that has occurred.
 *  $REQUIRE      control != none
 *  $OVERRIDE
 *
 **************************************************************************************************/
function notify(UWindowDialogControl control, byte eventType) {
	super.notify(control, eventType);
	
	// Toggle Nexgen HUD on/off.
	if (control == enableNexgenHUDInp && eventType == DE_Click) {
		// Save setting.
		client.gc.set(client.SSTR_UseNexgenHUD, string(enableNexgenHUDInp.bChecked));
		client.gc.saveConfig();
		
		// Apply setting.
		client.setNexgenMessageHUD(enableNexgenHUDInp.bChecked);
	}
	
	// Message HUD line count change
	if (control == chatAreaLinesInp && eventType == DE_Change) {
		client.nscHUD.maxChatMessages = byte(chatAreaLinesInp.getValue());
		client.nscHUD.bForceUpdate = true;	
	}	
	
	// Message HUD font size change 
	if (control == chatAreaFontInp && eventType == DE_Change) {
		client.nscHUD.baseFontSize = chatAreaFontInp.getValue();
		client.nscHUD.bForceUpdate = true;
	}
	
	// Chat messages default color changed
	if (control == chatAreaColorInp && eventType == DE_Change) {
		client.nscHUD.defaultChatFontColor = chatAreaColorInp.GetSelectedIndex();
	}
	
	// Other messages line count change
	if (control == otherAreaLinesInp && eventType == DE_Change) {
		client.nscHUD.maxOtherMessages = byte(otherAreaLinesInp.getValue());
	}
	
	// Other messages font size change 
	if (control == otherAreaFontInp && eventType == DE_Change) {
		client.nscHUD.otherFontSize = otherAreaFontInp.getValue();
		client.nscHUD.bForceUpdate = true;
	}
	
	// Other messages default color changed
	if (control == otherAreaColorInp && eventType == DE_Change) {
		client.nscHUD.defaultOtherFontColor = otherAreaColorInp.GetSelectedIndex();
	}
	
	// Toggle message flash effect on/off.
	if (control == useMsgFlashEffectInp && eventType == DE_Click) {
		// Save setting.
		client.gc.set(client.SSTR_FlashMessages, string(useMsgFlashEffectInp.bChecked));
		client.gc.saveConfig();
		
		// Apply setting.
		client.nscHUD.bFlashMessages = useMsgFlashEffectInp.bChecked;
	}
	
	
	// Toggle show player location in teamsay messages on/off.
	if (control == showPlayerLocationInp && eventType == DE_Click) {
		// Save setting.
		client.gc.set(client.SSTR_ShowPlayerLocation, string(showPlayerLocationInp.bChecked));
		client.gc.saveConfig();
		
		// Apply setting.
		client.nscHUD.bShowPlayerLocation = showPlayerLocationInp.bChecked;
	}
	
	// Toggle private message sound on/off.
	if (control == playPMSoundInp && eventType == DE_Click) {
		// Save setting.
		client.gc.set(client.SSTR_PlayPMSound, string(playPMSoundInp.bChecked));
		client.gc.saveConfig();
	}
	
	// Toggle auto screenshot for normal games on/off.
	if (control == autoSSNormalGameInp && eventType == DE_Click) {
		// Save setting.
		client.gc.set(client.SSTR_AutoSSNormalGame, string(autoSSNormalGameInp.bChecked));
		client.gc.saveConfig();
	}
	
	// Toggle auto screenshot for matches on/off.
	if (control == autoSSMatchInp && eventType == DE_Click) {
		// Save setting.
		client.gc.set(client.SSTR_AutoSSMatch, string(autoSSMatchInp.bChecked));
		client.gc.saveConfig();
	}
	
}



/***************************************************************************************************
 *
 *  $DESCRIPTION  Default properties block.
 *
 **************************************************************************************************/
defaultproperties {
	panelIdentifier="clientsettings"
	panelHeight=320
}

