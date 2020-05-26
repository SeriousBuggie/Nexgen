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
var UWindowCheckbox useGameHUDColorInp;
var UWindowComboControl HUDStyleInp;

var bool bCheckingHUDStyle;

const minChatMsgs  = 3;
const maxChatMsgs  = 8;
const minOtherMsgs = 0;
const maxOtherMsgs = 12;

/***************************************************************************************************
 *
 *  $DESCRIPTION  Creates the contents of the panel.
 *  $OVERRIDE
 *
 **************************************************************************************************/
function setContent() {
	local NexgenContentPanel p, pp;
	local int tmpRegion, index;	
	
	// Create layout & add components.
	setAcceptsFocus();
	createPanelRootRegion();
	splitRegionV(196, defaultComponentDist);
	
	// Keybindings.
    addSubPanel(class'NexgenCPKeyBind');
	
	// User Interface settings.
	splitRegionH(208, defaultComponentDist);
	p = addContentPanel();
	p.splitRegionH(16);
	p.addLabel(client.lng.UISettingsTxt, true, TA_Center);
	p.splitRegionH(56, defaultComponentDist);
	p.divideRegionH(3, defaultComponentDist);
	p.splitRegionH(40, defaultComponentDist, , true);
	enableNexgenHUDInp = p.addCheckBox(TA_Left, client.lng.enableMsgHUDTxt);
	useMsgFlashEffectInp = p.addCheckBox(TA_Left, client.lng.msgFlashEffectTxt);
	showPlayerLocationInp = p.addCheckBox(TA_Left, client.lng.showPlayerLocationTxt);
	p.divideRegionV(2, defaultComponentDist);
	tmpRegion = p.currRegion++;
	pp = p.addContentPanel();
	pp.divideRegionH(4, defaultComponentDist);
	pp.addLabel(client.lng.chatBoxTxt, true, TA_Center);
	pp.splitRegionV(32, defaultComponentDist, , true);
	pp.splitRegionV(80, defaultComponentDist, , true);
	pp.splitRegionV(64, defaultComponentDist, , true);
	pp.addLabel(client.lng.numberOfLinesTxt);
	chatAreaLinesInp = pp.addListCombo();
	pp.addLabel(client.lng.fontSizeTxt);
	chatAreaFontInp = pp.addHSlider();
	pp.addLabel(client.lng.fontColorTxt);
	chatAreaColorInp = pp.addListCombo();
	pp = p.addContentPanel();
	pp.divideRegionH(4, defaultComponentDist);
	pp.addLabel(client.lng.otherMessagesTxt, true, TA_Center);
	pp.splitRegionV(32, defaultComponentDist, , true);
	pp.splitRegionV(80, defaultComponentDist, , true);
	pp.splitRegionV(64, defaultComponentDist, , true);
	pp.addLabel(client.lng.numberOfLinesTxt);
	otherAreaLinesInp = pp.addListCombo();
	pp.addLabel(client.lng.fontSizeTxt);
	otherAreaFontInp = pp.addHSlider();
	pp.addLabel(client.lng.fontColorTxt);
	otherAreaColorInp = pp.addListCombo();
	p.selectRegion(tmpRegion);
	p.selectRegion(p.divideRegionH(2, defaultComponentDist));
	useGameHUDColorInp = p.addCheckBox(TA_Left, client.lng.useUTHUDColorTxt);
	p.splitRegionV(96, defaultComponentDist, , true);
	p.addLabel(client.lng.HUDStyleTxt);
	HUDStyleInp = p.addListCombo();

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
	useMsgFlashEffectInp.register(self);
	showPlayerLocationInp.register(self);
	chatAreaLinesInp.register(self);
	chatAreaFontInp.register(self);
	chatAreaColorInp.register(self);
	otherAreaLinesInp.register(self);
	otherAreaFontInp.register(self);
	otherAreaColorInp.register(self);
	useGameHUDColorInp.register(self);
	HUDStyleInp.register(self);
	playPMSoundInp.register(self);
	autoSSNormalGameInp.register(self);
	autoSSMatchInp.register(self);
	
	// Configure edit boxes
	for(index=minChatMsgs;  index<=maxChatMsgs;  index++) chatAreaLinesInp.addItem(string(index));
	for(index=minOtherMsgs; index<=maxOtherMsgs; index++) otherAreaLinesInp.addItem(string(index));
	for(index=0; index <=10; index++) {
		chatAreaColorInp.addItem(client.lng.getTextColorName(index));
		otherAreaColorInp.addItem(client.lng.getTextColorName(index));
	}
	HUDStyleInp.addItem(client.lng.defaultTxt);
	HUDStyleInp.addItem(client.lng.mhaTxt);
	HUDStyleInp.addItem(client.lng.customTxt);

	// H sliders
	chatAreaFontInp.SetRange(0, 6, 1);
	otherAreaFontInp.SetRange(0, 6, 1);
	
	// Load settings
	enableNexgenHUDInp.bChecked = client.gc.get(client.SSTR_UseNexgenHUD, "true") ~= "true";
	useMsgFlashEffectInp.bChecked = client.gc.get(client.SSTR_FlashMessages, "false") ~= "true";
	showPlayerLocationInp.bChecked = client.gc.get(client.SSTR_ShowPlayerLocation, "true") ~= "true";
	playPMSoundInp.bChecked = client.gc.get(client.SSTR_PlayPMSound, "true") ~= "true";
	autoSSNormalGameInp.bChecked = client.gc.get(client.SSTR_AutoSSNormalGame, "false") ~= "true";
	autoSSMatchInp.bChecked = client.gc.get(client.SSTR_AutoSSMatch, "true") ~= "true";
	chatAreaLinesInp.setSelectedIndex(client.nscHUD.chatMsgMaxCount-minChatMsgs);
	chatAreaFontInp.setValue(client.nscHUD.chatMsgSize);
	chatAreaColorInp.setSelectedIndex(client.nscHUD.chatMsgColor);
	otherAreaLinesInp.setSelectedIndex(client.nscHUD.otherMsgMaxCount-minOtherMsgs);
	otherAreaFontInp.setValue(client.nscHUD.otherMsgSize);
	otherAreaColorInp.setSelectedIndex(client.nscHUD.otherMsgColor);
	useGameHUDColorInp.bChecked = client.nscHUD.useUTHUDColor;
	checkHUDStyle();
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
	
	// Message HUD line count change
	if (control == chatAreaLinesInp && eventType == DE_Change) {
		client.nscHUD.chatMsgMaxCount = byte(chatAreaLinesInp.getValue());
		client.nscHUD.bForceUpdate = true;	
		client.saveExtendedHUDSettings();
	}	
	
	// Message HUD font size change 
	if (control == chatAreaFontInp && eventType == DE_Change) {
		client.nscHUD.chatMsgSize = chatAreaFontInp.getValue();
		client.nscHUD.bForceUpdate = true;
		client.saveExtendedHUDSettings();
	}
	
	// Chat messages default color changed
	if (control == chatAreaColorInp && eventType == DE_Change) {
		client.nscHUD.chatMsgColor = chatAreaColorInp.GetSelectedIndex();
		client.saveExtendedHUDSettings();
		checkHUDStyle();
	}
	
	// Other messages line count change
	if (control == otherAreaLinesInp && eventType == DE_Change) {
		client.nscHUD.otherMsgMaxCount = byte(otherAreaLinesInp.getValue());
		client.saveExtendedHUDSettings();
	}
	
	// Other messages font size change 
	if (control == otherAreaFontInp && eventType == DE_Change) {
		client.nscHUD.otherMsgSize = otherAreaFontInp.getValue();
		client.nscHUD.bForceUpdate = true;
		client.saveExtendedHUDSettings();
	}
	
	// Other messages default color changed
	if (control == otherAreaColorInp && eventType == DE_Change) {
		client.nscHUD.otherMsgColor = otherAreaColorInp.GetSelectedIndex();
		client.saveExtendedHUDSettings();
		checkHUDStyle();
	}
	
	// Toggle usage of UT HUD color on/off.
	if (control == useGameHUDColorInp && eventType == DE_Click) {
		// Save setting.
		client.nscHUD.useUTHUDColor = useGameHUDColorInp.bChecked;
		client.saveExtendedHUDSettings();
		checkHUDStyle();
	}
	
	// Style changed by user
	if (control == HUDStyleInp && eventType == DE_Change && !bCheckingHUDStyle) {
		if(HUDStyleInp.GetSelectedIndex() < 2) {
			client.setHUDStyle(HUDStyleInp.GetSelectedIndex());
			chatAreaColorInp.setSelectedIndex(client.nscHUD.chatMsgColor);
			otherAreaColorInp.setSelectedIndex(client.nscHUD.otherMsgColor);
			useGameHUDColorInp.bChecked = client.nscHUD.useUTHUDColor;
		}
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
 *  $DESCRIPTION  Compares current settings with the predefined schemes and adjusts style boxes
 *                if required (prevents infinite recursion).
 *
 **************************************************************************************************/
function checkHUDStyle() {
	bCheckingHUDStyle = true;
	HUDStyleInp.setSelectedIndex(client.checkHUDStyle());
	bCheckingHUDStyle = false;
}


/***************************************************************************************************
 *
 *  $DESCRIPTION  Default properties block.
 *
 **************************************************************************************************/
defaultproperties {
	panelIdentifier="clientsettings"
	panelHeight=304
}

