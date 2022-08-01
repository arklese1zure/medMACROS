
;									=========================================================================
;									|||||							medMACROS							|||||
;									=========================================================================

;==STARTUP CONDITIONS=========================================================================================================================================
#SingleInstance, Force
#NoEnv
#Include %A_ScriptDir%/Lib
#Include %A_ScriptDir%/Lang/Active.lang.ahk
path := A_ScriptDir
path := RegExReplace(path,"[^\\]+\\?$")
SetWorkingDir %path%
SetTitleMatchMode, 1
DetectHiddenWindows, On
StringCaseSense, On
ListLines Off

; Plugins and hotstring dictionaries are #included at the end of the script.

;==CHECK PROGRAM FILES========================================================================================================================================
if !FileExist("Macros\Settings")
{
	msgbox, 16,, %errBox_1%
	ExitApp
}

;==MONITOR SYSTEM MESSAGES====================================================================================================================================
OnMessage(0x06, "WM_ACTIVATE")															; Activate on window focus.
OnMessage(0x201, "WM_LBUTTONDOWN")														; Monitor for dragging window.
OnMessage(0x204, "WM_RBUTTONDOWN")														; Monitor for right click on GUI.

;==VARIABLES==================================================================================================================================================
programVersion :=	"2.2.0"
mainAlwaysOnTop :=	TRUE																; Variable for keeping on top.
mainHidden :=		FALSE																; Starting variable for hiding window.
mainLocked :=		FALSE
preventSleep :=		TRUE																; Starting variable for inhibit sleep.
Global 				HMain, XMain														; Needed for gdip.ahk to position drawn stuff.
TrayMenuEnabled :=	TRUE
Gosub, PluginLoadOptions

;==LOAD FILES=================================================================================================================================================
folder_UserFiles :=		A_WorkingDir . "\Files"											; Folder for user files.
folder_Autotext :=		A_WorkingDir . "\Files\Autotext"
file_Hotstrings :=		A_WorkingDir . "\Macros\Dictionaries\Active.ahk"
folder_Documentation :=	A_WorkingDir . "\Macros\Docs"
folder_Icons  :=		A_WorkingDir . "\Macros\Icons"
file_Settings :=		A_WorkingDir . "\Macros\Settings\Settings.ini"					; Settings.
loginDataFile :=		A_WorkingDir . "\Macros\Userdata\UserData.ini"					; Saved user data from settings.
newloginDataFile :=		A_WorkingDir . "\Macros\Userdata\Logindata.csv"					; Saved logins.
file_Phonebook :=		A_WorkingDir . "\Macros\Userdata\Phonebook.csv"					; Saved logins.
file_scratchPad :=		A_WorkingDir . "\Macros\Userdata\ScratchPad.txt"				; File for saving quick notes.
CSV_Load(newLoginDataFile, "passwordCSV", ",")											; Load CSV for creating ListView. Important: add the quotes to CSV_Identifier.
CSV_Load(file_Phonebook, "phonebookCSV", ",")
ImageListID := 			IL_Create(10)
hIL := TAB_CreateImageList(16,16,10)													; Create icon list for tabs.
IL_Add(hIL,folder_Icons . "\key.ico",1)
IL_Add(hIL,folder_Icons . "\folder.ico",1)
IL_Add(hIL,folder_Icons . "\textcursor.ico",1)
IL_Add(hIL,folder_Icons . "\pen.ico",1)
IL_Add(hIL,folder_Icons . "\phone.ico",1)

;==READ SETTINGS==============================================================================================================================================
IniRead, settings_mainWindowX,			%file_Settings%, windowposition, X				; Saved main window placement.
IniRead, settings_mainWindowY,			%file_Settings%, windowposition, Y
IniRead, settings_ToggleGUIEnabled,		%file_Settings%, buttonsettings, enabled		; Floating button enabled.
IniRead, settings_ToggleGUIImage,		%file_Settings%, buttonsettings, buttonFile		; Floating button image file.
IniRead, settings_TrayEnabled,			%file_Settings%, windowsettings, TrayEnabled
IniRead, settings_TitlebarEnabled,		%file_Settings%, windowsettings, TitlebarEnabled
IniRead, settings_PasswordsTabEnabled,	%file_Settings%, windowsettings, PasswordsTabEnabled
IniRead, settings_FilesTabEnabled,		%file_Settings%, windowsettings, FilesTabEnabled
IniRead, settings_HotstringsTabEnabled,	%file_Settings%, windowsettings, HotstringsTabEnabled
IniRead, settings_NotesTabEnabled,		%file_Settings%, windowsettings, NotesTabEnabled
IniRead, settings_PhonebookTabEnabled,	%file_Settings%, windowsettings, PhonebookTabEnabled
IniRead, settings_buttonWindowX,		%file_Settings%, buttonsettings, X				; Floating button position.
IniRead, settings_buttonWindowY,		%file_Settings%, buttonsettings, Y
IniRead, settings_screenSizeW,			%file_Settings%, screensettings, W
IniRead, settings_screenSizeH,			%file_Settings%, screensettings, H
IniRead, settings_userName,				%loginDataFile%, usuario, settings_userName		; User name.
IniRead, settings_workplace,			%loginDataFile%, usuario, settings_workplace	; Workplace.
IniRead, passwordMedimacros, 			%file_Settings%, safety, unlockpassword			; Ultra-secure password storage.
IniRead, settings_firstLaunch,			%file_Settings%, firstlaunch, firstlaunch
GoSub, PluginReadSettings																; Load plugin settings, if any.
GoSub, DictReadSettings																	; Load dictionary data.

MainGUI_Tabs := tabNames_1 . "|" . tabNames_2 . "|" . tabNames_3 . "|" . tabNames_4 . "|" . tabNames_5
if (plugin_TabEnabled = TRUE)
	MainGUI_Tabs := MainGUI_Tabs . plugin_TabName

Settings_Tabs := gui_settings_tabs_1 . "|" . gui_settings_tabs_2 . "|"
if (plugin_SettingsTabEnabled = TRUE)
	Settings_Tabs := Settings_Tabs . plugin_TabName
	
;==WINDOW POSITIONS===========================================================================================================================================
if (A_ScreenHeight<>settings_screenSizeH)												; If current screen size does not match stored screen size
	GoSub, ResetStartPositions															; reset window positions.
if ((settings_mainWindowX<=0) or (settings_buttonWindowX<=0))							; If stored window position is off-limits
	GoSub, ResetStartPositions															; reset window positions.

;==MENUS======================================================================================================================================================
Gosub, PluginLoadMenus
;==Main menu============================================================================
Menu, FileMenu, Add, %menu_filemenu_1%, KeepMainOnTop
Menu, FileMenu, ToggleCheck, %menu_filemenu_1%
Menu, FileMenu, Add, %menu_filemenu_2%, PreventSleep
Menu, FileMenu, Add, %menu_filemenu_3%, Suspendhotstrings
Menu, FileMenu, Add ;---------------
Menu, FileMenu, Add, %menu_filemenu_4%, GUITextEdit
Menu, FileMenu, Add ;---------------
Menu, FileMenu, Add, %menu_filemenu_5%, GUISettings
if (plugin_MenuEnabled = TRUE)
	Menu, FileMenu, Add, %plugin_MenuName%, :PluginMenu
Menu, FileMenu, Add, %menu_filemenu_6%, WindowLock
Menu, FileMenu, Add ;---------------
	Menu, HelpMenu, Add, %menu_helpmenu_1%, GUIHelpViewer
	Menu, HelpMenu, Add, %menu_helpmenu_2%, GUIHelpViewer
	Menu, HelpMenu, Add, %menu_helpmenu_3%, GUIAbout
	Menu, FileMenu, Add, %menu_filemenu_7%, :HelpMenu
Menu, FileMenu, Add ;---------------
Menu, FileMenu, Add, %menu_filemenu_8%, Exit
;==Hotstrings menu======================================================================
Menu, HotstringMenu, Add, %menu_hostringsmenu_1%, HotstringLVRemove
Menu, HotstringMenu, Add, %menu_hostringsmenu_2%, HotstringAdder
;==Password manager menu================================================================
Menu, LoginMenu, Add, %menu_loginmenu_1%, RemovePassword
Menu, LoginMenu, Add, %menu_loginmenu_2%, NewPassword
;==File organizer menus=================================================================
Menu, OrganizerMenu, Add, %menu_organizermenu_1%, TreeViewOpenFile
Menu, OrganizerMenu, Add ;---------------
Menu, OrganizerMenu, Add, %menu_organizermenu_2%, TreeViewDeleteFile
Menu, OrganizerMenu, Add, %menu_organizermenu_3%, TreeViewRenameFile
Menu, OrganizerOptionsMenu, Add, %menu_organizeroptionsmenu_1%, AddFiles
Menu, OrganizerOptionsMenu, Add, %menu_organizeroptionsmenu_2%, SelectFileShortcut
;==Phonebook menu=======================================================================
Menu, PhonebookMenu, Add, %menu_phonebookmenu_1%, NewPhone
Menu, PhonebookMenu, Add, %menu_phonebookmenu_2%, RemovePhone
;==Quick menu===========================================================================
Menu, QuickMenu, Add, %menu_quickmenu_1%, DummyHandler
Menu, QuickMenu, Disable, %menu_quickmenu_1%
Menu, QuickMenu, Add, %menu_quickmenu_2%, KeepMainOnTop
Menu, QuickMenu, ToggleCheck, %menu_quickmenu_2%
Menu, QuickMenu, Add, %menu_quickmenu_3%, PreventSleep
Menu, QuickMenu, Add, %menu_quickmenu_4%, Suspendhotstrings
Menu, QuickMenu, Add ;---------------
Menu, QuickMenu, Add, %menu_quickmenu_5%, GUITextEdit
;==Tray menu============================================================================
Menu, Tray, NoStandard
Menu, Tray, Tip, %menu_traymenu_1%
Menu, Tray, Click, 1
Menu, Tray, Add, %menu_traymenu_1%, NewWindowHide 
Menu, Tray, Default, %menu_traymenu_1%
Menu, Tray, Disable, %menu_traymenu_1%
Menu, Tray, Add, %menu_traymenu_2%, KeepMainOnTop
Menu, Tray, ToggleCheck, %menu_traymenu_2%
Menu, Tray, Add, %menu_traymenu_3%, PreventSleep
Menu, Tray, Add, %menu_traymenu_4%, Suspendhotstrings
Menu, Tray, Add ;---------------
Menu, Tray, Add, %menu_traymenu_5%, GUITextEdit
;==Addons for quick and tray menu=======================================================
if (plugin_QuickMenuEnabled = TRUE)
	GoSub, PluginQuickMenu
Menu, QuickMenu, Add ;---------------
Menu, QuickMenu, Add, %menu_quickmenu_6%, Exit
Menu, Tray, Add ;---------------
Menu, Tray, Add, %menu_traymenu_6%, Exit

;==MAIN GUI===================================================================================================================================================
Gui +LastFound +AlwaysOnTop +OwnDialogs +HwndHMainWindow
if (settings_TitlebarEnabled = 0)
	Gui -Sysmenu +Toolwindow
;--Header-------------------------------------------------------------------------------
Gui, Add, Button,		x263 y2 h20 w20 gMainMenu hwndmainMenu,	
	GuiButtonIcon(mainMenu, "shell32.dll", 268, "s16 a0 l2")
Gui, Font, bold s8
Gui, Add, Text, 		xp-260 yp+2 w260, %settings_userName% - %settings_workplace%
Gui, Font, norm s8
Gui, Add, Text, 		yp+15 w200 vclockDisplay gGUICalendar,							; Date and time display.
Gosub, CurrentTime																		; Start time display immediately.
SetTimer, CurrentTime, 1000																; Update it every 1000 milliseconds.
;--Tab control--------------------------------------------------------------------------
Gui, Add, Tab3, 		x-1 yp+15 h263 w289 vMainTabs hwndMainTabs -Wrap, %MainGUI_Tabs%
	TAB_SetImageList(MainTabs,hIL)
	Loop 5
		TAB_SetIcon(MainTabs,A_Index,A_Index)
	GUIControl,,%MainTabs%
	Loop % TAB_GetItemCount(MainTabs)
		TAB_Tooltips_SetText(MainTabs,A_Index,TAB_GetText(MainTabs,A_Index))
Gui, Tab, 1	;--Passwords Tab------------------------------------------------------------
Gui, Add, GroupBox, 	x1 y+3 h208 w283, %gui_groupbox_1%
passwordColumns := passwords_1 . "|" . passwords_2 . "|" . passwords_3 . "|" . passwords_4
CSV_LVLoad("passwordCSV", 1, 1, 77, 283, 190, passwordColumns, 1, 1)
	Gui, ListView, SysListView321
	GuiControl, +AltSubmit Grid +gPasswordListView, SysListView321
	LV_ModifyCol(1, 80)
	LV_ModifyCol(2, 90)
	LV_ModifyCol(3, 109)
	LV_ModifyCol(4, 0)
Gui, Add, Button, 		x2 y270 w50 gPasswordLVOpen hwndOpenLogin, %gui_button_1%
	GuiButtonIcon(OpenLogin, "shell32.dll", 101, "s16 a0 l2")
Gui, Add, Button, 		x+1 y270 w90 gPasswordLVLogin hwndPasswordLVLogin, %gui_button_2%
	GuiButtonIcon(PasswordLVLogin, "shell32.dll", 105, "s16 a0 l2")
Gui, Add, Button,		x227 y270 w57 gPasswordsMenu, %gui_button_3%
Gui, Tab, 2	;--Quick access Tab---------------------------------------------------------
Gui, Add, GroupBox, 	x1 y+3 h208 w283, %gui_groupbox_2%
Gui, Add, TreeView, 	x1 y77 h190 w283 ImageList%ImageListID% vTreeView gfileTreeView AltSubmit
	TV_Delete()
	TVString := CreateString(folder_UserFiles)
	CreateTreeView(TVString)
Gui, Add, Button, 		x3 w25 y270 hwndrefreshTreeView gTreeViewRefresh,
	GuiButtonIcon(refreshTreeView, "shell32.dll", 239, "s16 a4 l2")
	AddTooltip(refreshTreeView, gui_button_4)
Gui, Add, Button,		x227 y270 gOrganizerOptionsMenu,	%gui_button_5%
Gui, Tab, 3	;--Hotstrings Tab-----------------------------------------------------------
Gui, Add, GroupBox, 	x1 y+3 h208 w283, %gui_groupbox_3%
Gui, Add, listview, 	x1 y77 h190 w283 vMyListView gHotstringLVMenu AltSubmit Sort, Abreviatura|Texto completo
	LV_ModifyCol(1, 90)
	LV_ModifyCol(2, 300)
	GoSub, HotstringLVFill																; Populate ListView with parsed content from Hotstrings.ahk
Gui, Add, Button, 		x2 y270 gTextTemplates, %gui_button_6%
Gui, Add, Button,		x227 y270 w57 gHotstringLVMenu,	%gui_button_7%
Gui, Tab, 4	;--Scratchpad Tab-----------------------------------------------------------
Gui, Add, GroupBox, 	x1 y+3 h208 w283, %gui_groupbox_4%
Gui, Add, Edit, 		x1 y77 w283 h190 vscratchPad									; For jotting down quick notes
	FileRead, scratchPadContents, %file_scratchpad%
	GuiControl,, scratchPad, %scratchPadContents%
Gui, Add, Button, 		x3 w25 y270 hwndCleanScratchPad gCleanScratchPad,
	GuiButtonIcon(CleanScratchPad, "shell32.dll", 132, "s16 a4 l2")
	AddTooltip(CleanScratchPad,gui_button_8)
Gui, Add, Button, gSaveScratchPad hwndSaveScratchPad x+1 w25 y270,  ;--Buttons-
	GuiButtonIcon(SaveScratchPad, "shell32.dll", 259, "s16 a0 l2")
	AddTooltip(SaveScratchPad,gui_button_9)
Gui, Add, Text, 		x+5 y275,|
Gui, Add, Text, 		x+5 y275, %gui_text_1%
toolsList := tools_1 . "|" . tools_2 . "|" . tools_3 . "|" . tools_4
Gui, Add, DropDownList, x+3 y270 w150 h20 r5 vtoolsDropdown gToolsDropDown Choose1, %toolsList%
Gui, Tab, 5	;--Phonebook Tab------------------------------------------------------------
Gui, Add, GroupBox, 	x1 y+3 h208 w283, Directorio telefónico
phonebooklistviewcolumns :=		phonebooklistviewcolumn_1 . "|" . phonebooklistviewcolumn_2
CSV_LVLoad("phonebookCSV", 1, 1, 77, 283, 190, phonebooklistviewcolumns, 1, 1)
	LV_ModifyCol(2, 100)
	Gui, ListView, SysListView323
	GuiControl, +AltSubmit Grid +gPhonebookListView -readonly, SysListView323
Gui, Add, Button,		x227 y270 w57 gPhonebookListView,	%gui_button_10%
Gui, Tab, 6	;--Addon 1 Tab--------------------------------------------------------------
GoSub, PluginTab
Gui, Tab
Gui, Show, NoActivate x%settings_mainWindowX% y%settings_mainWindowY% h295 w285, medMACROS
;-- Things to do after building GUI-----------------------------------------------------
Loop 5																					; Remove tab names (main tabs only).
	TAB_SetText(MainTabs,A_Index,"")
Gosub, PreventSleep																		; Start timer for sleep prevention.
if (settings_TrayEnabled = 0)															; Check if button GUI is enabled in settings and either load it or skip it.
	Menu, Tray, NoIcon
if (settings_ToggleGUIEnabled = 1)														; Check if button GUI is enabled in settings and either load it or skip it.
	GoSub, GUIToggle
WinSet, Redraw,, ahk_id %HMainWindow%													; Redraw window to mitigate Tab shenanigans.
if (settings_firstLaunch = "TRUE")
	GoSub, FirstLaunch
return

;##Hovering Button GUI########################################################################################################################################
GUIToggle:		; Small floating image, when you click it main GUI shows up, click it again and it hides. Can be disabled.
{
	Gui, Toggle:-Caption +AlwaysOnTop +LastFound +HwndHToggle +E0x80000 +Owner1
	sFile :=		"Macros/Buttons/" . settings_ToggleGUIImage							; Button image.
	pToken :=		Gdip_Startup()
	pBitmap:=		Gdip_CreateBitmapFromFile(sFile)
	Gdip_GetDimensions(pBitmap, w, h)
	hbm :=			CreateDIBSection(w,h)
	hdc :=			GetDC(HToggle)
	mdc :=			CreateCompatibleDC(hdc)
	obm :=			SelectObject(mdc, hbm)
	pGraphics :=	Gdip_GraphicsFromHDC(mdc)
	Gdip_DrawImage(pGraphics, pBitmap,0,0,w,h)
	UpdateLayeredWindow(HToggle, mdc, (A_ScreenWidth-w)//2, (A_ScreenHeight-h)//2, w,h)
	DeleteObject(hbm)
	DeleteDC(mdc)
	ReleaseDC(hdc, HToggle)
	Gdip_DeleteGraphics(pGraphics)
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)
	Gui, Toggle: Show, NoActivate w%w% h%h% x%settings_buttonWindowX% y%settings_buttonWindowY%, MiniMacro
	return 
}
;##About GUI##################################################################################################################################################
GUIAbout:		; About this program, shows things in a pretty box with graphics.
{
	WinGetPos, aboutX, aboutY, , , medMACROS
	aboutX := aboutX+3
	aboutY := aboutY+80
	Gui, About:+owner1 -caption	+border													; Make the main window the owner of the "about box"
	Gui +Disabled																		; Disable main window.
	Gui, About:Add, Picture,	y+10 w97 h112, %A_WorkingDir%\Macros\ProgramLogo.png
	Gui, About:Add, GroupBox, 	x3 y1 w276 h120, 
	Gui, About:Font,			bold s10
	Gui, About:Add, Text, 		xp+105 yp+10, medMACROS
	Gui, About:Font,			norm s8
	Gui, About:Add, Text, 		yp+20, %gui_text_2% %programVersion%
	Gui, About:Font,			italic s8
	Gui, About:Add, Text, 		yp+20, %gui_text_3%
	Gui, About:Font,			norm s8
	Gui, About:Add, Text, ,		%gui_text_4% Arklese1zure`nTwitter: @Arklese1zure
	Gui, About:Add, Button,		x3 yp+35 w137 h30 gGUIHelpViewer, %gui_button_11%
	Gui, About:Add, Button,		x+3 w137 h30 gGUIHelpViewer, %gui_button_12%
	Gui, About:Add, Button, 	x110 w60 Default, OK
	Gui, About:Show, 			x%aboutX% y%aboutY% w283, AboutMacros
	return

AboutButtonOK:																			; Things to do when box is closed.
AboutGuiClose:
AboutGuiEscape:
	Gui, 1:-Disabled																	; Re-enable the main window.
	Gui, Destroy																		; Destroy the about box.
	return
}
;##Help Viewer GUI############################################################################################################################################
GUIHelpViewer: 	; This GUI loads readmes. Maybe pdf or md would be nice, but I don't wanna rely on external viewers.
{
	Gui, GUIHelpViewer:Default
	Gui, GUIHelpViewer:Add, ListView, x3 y3 h279 w150 gHelpTreeView AltSubmit -Hdr, Name
	Loop, %folder_Documentation%\*.*													; Gather a list of file names from a folder and put them into the ListView:
    LV_Add("", A_LoopFileName)
	LV_ModifyCol()																		; Auto-size each column to fit its contents.
	Gui, GUIHelpViewer:Add, Edit, ReadOnly vhelpFileDisplay h279 w497 x+3
	Gui, GUIHelpViewer:Show, w656 h285, medMACROS — %gui_windowtitle_1%
	return
	
HelpTreeView:
	if (A_GuiEvent = "Normal")
		{	
		LV_GetText(RowText, A_EventInfo)												; Get the text from the row's first field.
		loadedHelpFile := folder_Documentation . "\" . RowText
		FileRead, loadedHelpFileText, %loadedHelpFile%
		GuiControl, GUIHelpViewer:, helpFileDisplay, %loadedHelpFileText% 
		return
		}
return

GUIHelpViewerGuiClose:																	; Exit GUI.
	Gui, Destroy
	return
}
;##Calendar GUI###############################################################################################################################################
GUICalendar:	; Shows a calendar widget when clock is clicked on.
{
	if WinExist("ahk_id" HCalendar)
		return
	WinGetPos, calendarX, calendarY, , , medMACROS
	calendarX := calendarX+13
	calendarY := calendarY+50
	Gui, Calendar:+owner1 +AlwaysOnTop +ToolWindow -Caption +Border +HwndHCalendar
	Gui, Calendar:Add, MonthCal, x1 y1 vMyCalendar 0x10
	Gui, Calendar:Show, X%calendarX% Y%calendarY% w227 h145, Calendario medMACROS
	return
	
CalendarGuiClose:
CalendarGuiEscape:
	Gui, Calendar:Destroy
	return	

}
;##Quick Text GUI#############################################################################################################################################
GUIQuicktext:	; For quick writing of repetitive paragraphs.
{
	CoordMode, Mouse, Screen
	MouseGetPos, pasterX, pasterY
	ActWin := WinActive("A")															; Retrieve the current window's ID.
	Gui, Paster:+owner1 +AlwaysOnTop +ToolWindow -Caption +Border
	Gui, Paster:Add, Text,, %gui_text_5%
	Gui, Paster:Add, ComboBox, vMyListBox w140 r10
	Gui, Paster:Add, Button, Default xp+143 yp-1, OK
	Loop, %folder_Autotext%\*.txt														; Retrieve file list.
		{
		GuiControl, Paster:, MyListBox, %A_LoopFileName%
		}
	Gui, Paster:Show, X%pasterX% Y%pasterY%, %gui_windowtitle_2%
	CoordMode, Mouse, Window
	return

MyListBox:																				; Allow keyboard navigation without triggering g-label.
	if (A_GuiEvent = "Normal")
		return

PasterButtonOK:
	Gui, Submit
	GuiControlGet, MyListBox, ,MyListBox												; Retrieve the ListBox's current selection.
	Fileread, sendText, %folder_Autotext%\%MyListBox%
	WinActivate, ahk_id %ActWin%														; Activate original window.
	Send %sendText%
	if (ErrorLevel = "ERROR")
		MsgBox % errBox_2

PasterGuiClose:
PasterGuiEscape:
	Gui, Destroy
	return
}
;##Settings GUI###############################################################################################################################################
GUISettings:	; Settings GUI.
{
	Gui, SettingsGUI: +owndialogs -alwaysontop
	Gui +Disabled																		; Disable main GUI (owner).
	Gui, SettingsGUI:Default
	Gui, SettingsGUI:Add, Tab3, x1 +Theme h258 w476, %Settings_Tabs%
	Gui, Tab, 1	;--Start Tab----------------------------------------------------------------
	Gui, SettingsGUI:Add, GroupBox, x3 y+5 w470 h70, %gui_settings_groupbox_1%			; User data box.
	Gui, SettingsGUI:Add, Text, 	x12 yp+18 w100, %gui_settings_text_1%:
	Gui, SettingsGUI:Add, Edit, 	x+5 w222 vuserNameBox, %settings_userName%
	Gui, SettingsGUI:Add, Text,		x12 yp+25 w100, %gui_settings_text_2%:
	Gui, SettingsGUI:Add, Edit,		x+5 w222 vworkPlaceBox, %settings_workplace%
	Gui, SettingsGUI:Add, GroupBox, x3 y+10 h50 w470, %gui_settings_groupbox_2%
	Gui, SettingsGUI:Add, Edit, 	x12 yp+20 w258 vpluginNameBox -Wrap ReadOnly, %plugin_Name%
	Gui, SettingsGUI:Add, Button, 	x+3 yp-1 gLoadAddon, %gui_settings_button_1%		; Load addon
	Gui, SettingsGUI:Add, Button, 	x+3 gUnloadAddon, %gui_settings_button_2%			; Unload addon
	Gui, SettingsGUI:Add, GroupBox, x3 y+10 h50 w470, %gui_settings_groupbox_3%
	Gui, SettingsGUI:Add, Edit, 	x12 yp+20 w258 vdictNameBox -Wrap ReadOnly, %dict_Name%
	Gui, SettingsGUI:Add, Button, 	x+3 yp-1 gLoadDictionary, %gui_settings_button_3%	; Load addon
	Gui, SettingsGUI:Add, GroupBox, x3 y+10 h50 w470, %gui_settings_groupbox_8%
	Gui, SettingsGUI:Add, DropDownList, 	x12 yp+20 w258 vlangNameBox -Wrap ReadOnly Choose1, %gui_settings_ddl_1%
	Loop, %A_WorkingDir%\Macros\Lang\*.lang.ahk											; Retrieve file list.
		{
		if (A_LoopFileName = "Active.lang.ahk")											; Skip active file.
			Continue
		GuiControl, SettingsGUI:, langNameBox, %A_LoopFileName%
		}
	Gui, SettingsGUI:Add, Button, 	x+3 yp-1 gLoadLanguage, %gui_settings_button_8%		; Load language
	Gui, Tab, 2	;--GUI Settings Tab----------------------------------------------------------
	Gui, SettingsGUI:Add, GroupBox, x3 y+5 h76 w200, %gui_settings_groupbox_5%
	Gui, SettingsGUI:Add, CheckBox, xp+8 yp+20 vsettings_ToggleGUIEnabled Checked%settings_ToggleGUIEnabled%, %gui_settings_checkbox_1%
	Gui, SettingsGUI:Add, Button,	x10 yp+20 gLoadButtonImage, %gui_settings_button_4%
	Gui, SettingsGUI:Add, Picture,	x+32 y42 w64 h64, %A_WorkingDir%\Macros\Buttons\%settings_ToggleGUIImage%
	Gui, SettingsGUI:Add, GroupBox, x+20 y33 h76 w260, %gui_settings_groupbox_6%
	Gui, SettingsGUI:Add, CheckBox, xp+8 yp+22 vsettings_TrayEnabled Checked%settings_TrayEnabled%, %gui_settings_checkbox_2%
	Gui, SettingsGUI:Add, CheckBox, xp yp+22 w258 vsettings_TitlebarEnabled Checked%settings_TitlebarEnabled%, %gui_settings_checkbox_3%
	Gui, SettingsGUI:Add, GroupBox, x3 y+20 h150 w200, %gui_settings_groupbox_7%
	Gui, SettingsGUI:Add, CheckBox, xp+8 yp+22 vsettings_PasswordsTabEnabled Checked%settings_PasswordsTabEnabled%, %gui_settings_checkbox_4%
	Gui, SettingsGUI:Add, CheckBox, yp+22 vsettings_FilesTabEnabled Checked%settings_FilesTabEnabled%, %gui_settings_checkbox_5%
	Gui, SettingsGUI:Add, CheckBox, yp+22 vsettings_HotstringsTabEnabled Checked%settings_HotstringsTabEnabled%, %gui_settings_checkbox_6%
	Gui, SettingsGUI:Add, CheckBox, yp+22 vsettings_NotesTabEnabled Checked%settings_NotesTabEnabled%, %gui_settings_checkbox_7%
	Gui, SettingsGUI:Add, CheckBox, yp+22 vsettings_PhonebookTabEnabled Checked%settings_PhonebookTabEnabled%, %gui_settings_checkbox_8%
	Gui, SettingsGUI:Add, GroupBox, x210 y110 h50 w260, %gui_settings_groupbox_4%
	Gui, SettingsGUI:Add, Edit, 	xp+10 yp+19 w130 vmedimacros_passwordBox Password, %passwordMedimacros%
	Gui, SettingsGUI:Add, Button, 	x+3 yp-1 w30 gPeekPasswordField, Mostrar
	Gui, SettingsGUI:Add, Button, 	x+3 yp+0 w30 gNewLockPassword, Cambiar
	Gui, Tab, 3	;--Plugin Tab---------------------------------------------------------------
	GoSub, PluginSettings
	Gui, Tab	;---------------------------------------------------------------------------
	Gui, SettingsGUI:Add, Button, 	w80 x1 y265 gGUIHelpViewer, %gui_settings_button_5%
	Gui, SettingsGUI:Add, Button, 	w80 x312 y265 gSaveSettings, %gui_settings_button_6%
	Gui, SettingsGUI:Add, Button, 	w80 x+3 yp gSettingsGUIGuiClose, %gui_settings_button_7%
	Gui, SettingsGUI:Show, w476 h290, medMACROS — %gui_windowtitle_3%
	return

SaveSettings:																			; Save settings.
	Gui, SettingsGUI:Submit, NoHide
	IniWrite, %userNameBox%,					%loginDataFile%, usuario, settings_userName
	IniWrite, %workPlaceBox%, 					%loginDataFile%, usuario, settings_workplace
	IniWrite, %settings_ToggleGUIEnabled%, 		%file_Settings%, buttonsettings, enabled
;	IniWrite, %medimacros_passwordBox%, 		%file_Settings%, safety, unlockpassword
	IniWrite, %settings_TrayEnabled%,			%file_Settings%, windowsettings, TrayEnabled
	IniWrite, %settings_TitlebarEnabled%,		%file_Settings%, windowsettings, TitlebarEnabled
	IniWrite, %settings_PasswordsTabEnabled%,	%file_Settings%, windowsettings, PasswordsTabEnabled
	IniWrite, %settings_FilesTabEnabled%,		%file_Settings%, windowsettings, FilesTabEnabled
	IniWrite, %settings_HotstringsTabEnabled%,	%file_Settings%, windowsettings, HotstringsTabEnabled
	IniWrite, %settings_NotesTabEnabled%,		%file_Settings%, windowsettings, NotesTabEnabled
	IniWrite, %settings_PhonebookTabEnabled%,	%file_Settings%, windowsettings, PhonebookTabEnabled
	GoSub, PluginSaveSettings
	Reload
	return

LoadAddon:
	FileSelectFile, selectedPluginName, 3, %A_WorkingDir%\Macros\Plugins, %fileSelectDialog_1%,  %fileSelectDialog_2% (*.ahk)
	if (SelectedPluginName = "")
		return
	GoSub, CheckValidPlugin
	if (pluginIsValid = false)
		return
	FileDelete, %A_WorkingDir%\Macros\Plugins\Active.ahk
	FileCopy, %selectedPluginName%, %A_WorkingDir%\Macros\Plugins\Active.ahk
	GuiControl, %selectedPluginName%, pluginNameBox
	return
	
LoadDictionary:
	FileSelectFile, selectedDictName, 3, %A_WorkingDir%\Macros\Dictionaries, %fileSelectDialog_3%, %fileSelectDialog_4% (*.ahk)
	if (SelectedDictName = "")
		return
	selectedPluginName := selectedDictName
	GoSub, CheckValidPlugin
	if (pluginIsValid = FALSE)
		return
	FileDelete, %A_WorkingDir%\Macros\Dictionaries\Active.ahk
	FileCopy, %selectedDictName%, %A_WorkingDir%\Macros\Dictionaries\Active.ahk
	GuiControl, %selectedDictName%, dictNameBox
	return

LoadLanguage:
	Gui, SettingsGUI:Submit, NoHide
	selectedLangName := langNameBox
	if (selectedLangName = "")
		return
	if (selectedLangName = gui_settings_ddl_1)
		{
		MsgBox, 4096, Error, %errBox_12%
		return
		}
	selectedPluginName := A_WorkingDir . "\Macros\Lang\" . selectedLangName
	;MsgBox % selectedPluginName
	;Return
	GoSub, CheckValidPlugin
	if (pluginIsValid = FALSE)
	{
	MsgBox % "Invalid plugin file."
	return
	}
	FileDelete, %A_WorkingDir%\Macros\Lang\Active.lang.ahk
	FileCopy, %selectedPluginName%, %A_WorkingDir%\Macros\Lang\Active.lang.ahk
	GuiControl, %selectedLangName%, langNameBox
	return

CheckValidPlugin:
	FileReadLine, checkedLine, %selectedPluginName%, 1
	if (checkedLine <> "; MEDMACROS")
		{
		MsgBox, 4096, Error, %errBox_3%
		pluginIsValid := FALSE
		}
	return

UnloadAddon:
	FileDelete, %A_WorkingDir%\Macros\Plugins\Active.ahk
	FileCopy,  %A_WorkingDir%\Macros\Plugins\Placeholder.ahk, %A_WorkingDir%\Macros\Plugins\Active.ahk
	GuiControl, , pluginNameBox
	return

LoadButtonImage:
	FileSelectFile, selectedButtonName, 3, %A_WorkingDir%\Macros\Buttons, Seleccionar imagen para botón, Imagen PNG (*.png)
	if (SelectedButtonName = "")
		return
	SplitPath, selectedButtonName, buttonname
	IniWrite, %buttonname%, %file_Settings%, buttonsettings, buttonFile					; Floating button image.
	return

PeekPasswordField:
	if (passwordFieldVisible = TRUE)
		{
		GuiControl,SettingsGUI: +Password, medimacros_passwordBox
		passwordFieldVisible := FALSE
		}
	else
		{
		GuiControl,SettingsGUI: -Password, medimacros_passwordBox
		passwordFieldVisible := TRUE
		}
	Return

NewLockPassword:
	Gui, SettingsGUI:Submit, NoHide
	if (medimacros_passwordBox = passwordMedimacros)
		{
		MsgBox % "Please input a new password in the field"
		return
		}
	InputBox, newLockPassword, Input new password, Please confirm your new password, HIDE, 240, 140
	if (medimacros_passwordBox <> newLockPassword)
		{
		MsgBox % "Passwords do not match, please try again"
		return
		}
	IniWrite, %medimacros_passwordBox%, 		%file_Settings%, safety, unlockpassword
	msgbox % "The new lock password has been set."
	Return

SettingsGUIGuiClose:																	; Things to do when GUI is closed.
	Gui, Destroy
	Gui, 1:-Disabled																	; Re-enable the main GUI.
SettingsGUIGuiEscape:
	return
}	
;##New hotstring GUI##########################################################################################################################################
HotstringAdder:	; Gui for adding new hotstrings. Basically a two field inputbox.
{
	Gui, Hotstrings:+owner1 +AlwaysOnTop +ToolWindow -Sysmenu
	Gui, Hotstrings:Add, Text,		x12 y8 w350 h20 , %gui_hotstrings_text_1%
	Gui, Hotstrings:Add, Text,		x12 y30 w120 h20, %gui_hotstrings_text_2%:
	Gui, Hotstrings:Add, Text,		x12 y58 w120 h20, %gui_hotstrings_text_3%:
	Gui, Hotstrings:Add, Edit,		x100 y25 w230 vabrevCompleta
	Gui, Hotstrings:Add, Edit,		x100 y55 w230 vHotstring
	Gui, Hotstrings:Add, Button,	x252 y80 w80 gHotstringsGuiClose, %gui_hotstrings_button_1%
	Gui, Hotstrings:Add, Button,	x172 y80 w80 gHotstringAppend, OK
	Gui, Hotstrings:Show,			h110 w340, %gui_hotstrings_button_2%
	return
	
HotstringAppend:
	Gui, Submit, NoHide
	GuiControlGet, abrevCompleta														; Retrieve the contents of the Edit control.
	GuiControlGet, Hotstring															; Retrieve the contents of the Edit control.
	if (abrevCompleta = "" or Hotstring = "")											; Check if strings are not empty
		{
		MsgBox, 4096, Error, %errBox_4%
		return
		}
	StringReplace, Hotstring, Hotstring, `r`n, ``r, All									; Using `r works better than `n in MS Word, etc.
	StringReplace, Hotstring, Hotstring, `n, ``r, All
	StringReplace, Hotstring, Hotstring, %A_Tab%, ``t, All
	StringReplace, Hotstring, Hotstring, `;, ```;, All
	FileAppend, `n:R:%Hotstring%::%abrevCompleta%, %file_Hotstrings%
	Reload																				; If successful, the reload will close this instance during the Sleep
	Sleep 300
	MsgBox, 0, 16, %errBox_5%
	return
	
HotstringsGuiClose:
HotstringsGuiEscape:
	Gui, Destroy
	return

;##New Password GUI###########################################################################################################################################
NewPassword:
	Gui, Passwords:+owner1 +AlwaysOnTop +ToolWindow -Sysmenu
	Gui +Disabled																		; Disable main GUI (owner).
	Gui, Passwords:Add, Text,	x8 y8 w100 h20, %gui_passwords_text_1%:
	Gui, Passwords:Add, Text,	x8 y+3 w100 h20, %gui_passwords_text_2%:
	Gui, Passwords:Add, Text,	x8 y+3 w100 h20, %gui_passwords_text_3%:
	Gui, Passwords:Add, Text,	x8 y+3 w100 h20, %gui_passwords_text_4%:
	Gui, Passwords:Add, Edit,	x90 y8 w220 h20 vresourceName,
	Gui, Passwords:Add, Edit,	x90 y+3 w220 h20 vresourceUserName,
	Gui, Passwords:Add, Edit,	x90 y+3 w220 h20 vresourcePassword,
	Gui, Passwords:Add, Edit,	x90 y+3 w220 h20 vresourceLocation,
	Gui, Passwords:Add, Button,	x+2 w20 gPickResourceLocation, %gui_passwords_button_1%
	Gui, Passwords:Add, Button,	x221 y105 w80 gAppendNewPassword, OK
	Gui, Passwords:Add, Button,	x+2 y105 w80 gPasswordsGuiClose, %gui_passwords_button_2%
	Gui, Passwords:Show, , medMACROS — %gui_windowtitle_4%
	return
	
AppendNewPassword:
	Gui, Submit, NoHide
	GuiControlGet, resourceName
	GuiControlGet, resourceUserName
	GuiControlGet, resourceLocation
	GuiControlGet, resourcePassword
	newRow = %resourceName%`,%resourceUserName%`,%resourceLocation%`,%resourcePassword%
	Gui, 1:Default																		; Re-focus on Main GUI and then on appropriate ListView.
	Gui, ListView, passwordCSV
	LV_Add(, resourceName, resourceUserName, resourceLocation, resourcePassword)		; Add newly added password to listview.
	GoSub, PasswordsGuiClose															; Exit when done
	return
	
PickResourceLocation:
	FileSelectFile, newResource , , , %fileSelectDialog_4%
	GuiControl,, resourceLocation, %newResource%
	return

PasswordsGuiClose:
PasswordsGuiEscape:
	Gui, 1:-Disabled																	; Re-enable the main GUI.
	Gui, Passwords:Destroy
	return
}
;##HOTKEYS####################################################################################################################################################
;==F KEYS===============================================================================
; F5 to F8 are reserved for addons.

^F1:: ;--Open main GUI and focus on "cedula" field--------------------------------------
	GoSub, FocusMainGUI
	return
	
^F2:: ;--Trigger quick text GUI---------------------------------------------------------
	GoSub, GUIQuicktext
	return
	
^F3:: ;--Keep window above--------------------------------------------------------------
	GoSub, KeepWindowAbove
	return
	
^F4:: ;--Keep window above--------------------------------------------------------------
	return
	
^F12:: ;--Refresh script----------------------------------------------------------------
	GoSub, SaveProgramData
	Reload
	return

^+F12:: ;--Refresh script---------------------------------------------------------------
	Reload
	return
	
;==OTHER KEYS===========================================================================
^+d:: ;--Send date----------------------------------------------------------------------
	Send %A_DD%/%A_MM%/%A_YYYY%
	return
	
^!d:: ;--Send first day of the year-----------------------------------------------------
	Send 01/01/%A_YYYY%
	return

^+v:: ;--Alternate paste for security circumvention-------------------------------------
	GoSub, AlternatePaste
	Return

;##MAIN GUI SUBROUTINES#######################################################################################################################################
;==MENU TRIGGERS==============================================================================================================================================
MainMenu: ;--Main menu trigger----------------------------------------------------------
	Menu, FileMenu, Show
	return

PasswordsMenu:
	Menu, LoginMenu, Show
	return
	
OrganizerOptionsMenu:
	Menu, OrganizerOptionsMenu, Show
	return

;==DROP FILES=================================================================================================================================================
GuiDropFiles:																			; Support drag & drop.
	Loop, Parse, A_GuiEvent, `n
		{
		DroppedFileName := A_LoopField													; Get the first file only (in case there's more than one).
		break
		}
	FileCopy, %DroppedFileName%, %A_WorkingDir%\Files\*.*
	TV_Delete()
	TVString := CreateString(folder_UserFiles)
	CreateTreeView(TVString)
return

;==CLOCK & SLEEP INHIBITOR====================================================================================================================================
CheckIdle: ;--Check idle time-----------------------------------------------------------
	if ( A_TimeIdle > 5999 ) 
		{
		Send {RShift}
		}
	return
	
CurrentTime: ;--Update clock------------------------------------------------------------
	GuiControl,, clockDisplay, %A_DD%/%A_MM%/%A_YYYY% - %A_Hour%:%A_Min%:%A_Sec%
	return	

PreventSleep: ;--Disable computer sleeping----------------------------------------------
	if (preventSleep = TRUE)															; Could maybe merge with clock timer but it's hard
		{
		SetTimer, CheckIdle, 600														; 60 sec / 1 min
		Menu, FileMenu, ToggleCheck, %menu_filemenu_2%
		Menu, QuickMenu, ToggleCheck, %menu_quickmenu_3%
		if (TrayMenuEnabled = TRUE)
			Menu, Tray, ToggleCheck, %menu_traymenu_3%
		preventSleep := FALSE
		return
		}
	if preventSleep = 0
		{
		SetTimer, CheckIdle, off
		Menu, FileMenu, ToggleCheck, %menu_filemenu_2%
		Menu, QuickMenu, ToggleCheck, %menu_quickmenu_3%
		if (TrayMenuEnabled = TRUE)
			Menu, Tray, ToggleCheck, %menu_traymenu_3%
		preventSleep := TRUE
		return
		}
	return
	
;==SHORTCUTS==================================================================================================================================================
FirstLaunch:
	MsgBox, 64, %infoBox_1%, %gui_text_6%
	IniWrite, FALSE, %file_Settings%, firstlaunch, firstlaunch
	GoSub, GUISettings
	return

;==PASSWORD MANAGER===========================================================================================================================================
PasswordListView: ;--Actions for password manager---------------------------------------
	if (A_GuiEvent = "Normal")															; Handle user actions on password manager listview.
		GoSub FetchPasswordLV
	if (A_GuiEvent = "DoubleClick")														; Double click automatically launches location.
		{
		GoSub PasswordLVOpen
		return
		}
	if (A_GuiEvent = "RightClick")														; Right click spawns menu for more actions.
		{
		GoSub FetchPasswordLV															; Retrieve row data before showing menu for subroutines. Might change later.
		Menu, Loginmenu, Show
		}
	return

FetchPasswordLV:																		; Subroutine for retrieving row data.
	Gui, ListView, passwordCSV
	focusedRowNumber := LV_GetNext(0, "F")
	LV_GetText(resourceName, focusedRowNumber, 1)										; These fetch the name, login data and location.
	LV_GetText(resourceUsername, focusedRowNumber, 2)
	LV_GetText(resourceLocation, focusedRowNumber, 3)
	LV_GetText(resourcePassword, focusedRowNumber, 4)
	return

RemovePassword:
	Gui, ListView, passwordCSV															; Make sure it's the correct ListView.
	focusedRowNumber := LV_GetNext(0, "F")
	if not focusedRowNumber																; No row is focused.
		return
	LV_GetText(searchText1, focusedRowNumber, 1)
	foundCell := CSV_MatchCellColumn("PasswordCSV", searchText1, 1)
		MsgBox, 4, %promptBox_1%, %promptBox_2% %searchText1% %promptBox_3%
	IfMsgBox, No
		return																			; User pressed the "No" button.
	LV_Delete(focusedRowNumber)
	return

PasswordLVOpen:																			; Open selected resource with variables obtained from FetchPasswordLV.
	if (focusedrownumber = "0")															; Don't do anything if no row is focused, inform user.
		{
		MsgBox % promptBox_4
		return
		}
	Run, %resourceLocation%
	return

PasswordLVLogin: ;--Submit login--------------------------------------------------------
	Send !{Esc}
	Send %resourceUsername%
	Send {TAB}
	Send %resourcePassword%
	Send {ENTER}
	return

;==TREE VIEW==================================================================================================================================================
fileTreeView: ;--Handle user actions on TreeView----------------------------------------
	if (A_GuiEvent = "RightClick") 
		{
		GoSub, TreeViewSelectedItem
		Menu, OrganizerMenu, Show
		return
		}
	if (A_GuiEvent = "DoubleClick")
		{
		GoSub, TreeViewSelectedItem
		GoSub, TreeViewOpenFile
		}
	else
		return
	return

AddFiles: ;--Add files to Treeview------------------------------------------------------
	Run, %folder_UserFiles%
	return

TreeViewSelectedItem:
	TV_GetText(SelectedItemText, A_EventInfo)											; Determine the full path of the selected folder.
	ParentID := A_EventInfo
	Loop																				; Build the full path to the selected folder.
		{
		ParentID := TV_GetParent(ParentID)
		if not ParentID																	; No more ancestors.
			break
		TV_GetText(ParentText, ParentID)
		SelectedItemText := ParentText "\" SelectedItemText
		}
	SelectedFullPath := folder_UserFiles "\" SelectedItemText
	return

TreeViewRefresh:
	TV_Delete()
	TVString := CreateString(folder_UserFiles)
	CreateTreeView(TVString)
	return

TreeViewOpenFile:
	Run, %selectedFullPath%, , UseErrorLevel
	if ErrorLevel
		MsgBox, 16, %errBox_6%, %errBox_7%
	return

TreeViewDeleteFile:
	if ((selecteditemtext = "Shortcuts") or (selecteditemtext = "Autotext"))
		{
		MsgBox, 16, %errBox_8%, %errBox_9%
		return
		}
	MsgBox, 4, %promptBox_5%, %promptBox_6%
	IfMsgBox, No
		return																			; User pressed the "No" button.
	FileDelete, %selectedFullPath%
	GoSub, TreeViewRefresh
	return

SelectFileShortcut: ;--Make shortcuts---------------------------------------------------
	FileSelectFile, newShortcut , , 0, %fileSelectDialog_5%
	SplitPath, newShortcut, , , ,newShortcutName
	FileCreateShortcut, %newShortcut%, %A_WorkingDir%\Files\Shortcuts\%newShortcutName%.lnk
	GoSub, TreeViewRefresh
	return
	
TreeViewRenameFile:
	InputBox, newFileName, %promptBox_6%, %promptBox_7%,, 240, 140
	if ErrorLevel
		return
	SplitPath, selectedFullPath,, dir, ext
	newname := dir . "\" . newfilename "." ext
	FileMove, %selectedFullPath%, %newname%, 1
	if ErrorLevel
		{
		MsgBox, 16, %errBox_10%, %errBox_11%
		return
		}
	GoSub, TreeViewRefresh
	return
	
;==HOTSTRINGS=================================================================================================================================================
HotstringLVFill: ;--Fill hotstrings listview--------------------------------------------
	Gui, Listview, MyListView
	GuiControl,1: -Redraw, MyListView
	Loop, read, %file_Hotstrings%
		{
		Loop, parse, A_LoopReadLine, ¢, %A_Space% %A_Tab%
			{
			if InStr(A_LoopReadLine, ";")												; Skip commented lines on "dictionary" files.
				Continue
			Array := StrSplit(A_Loopfield, ":")
			var1 := Array[3]
			var2 := Array[5]
			LV_Add(,var1,var2)
			}
		}
	GuiControl,1: +Redraw, MyListView
	return

HotstringLVMenu: ;--Spawn right-click menu on hotstring listview------------------------
	if ((A_GuiEvent = "RightClick") or (A_GuiControl = gui_button_7))						; Menu for more actions.
		Menu, Hotstringmenu, Show
	return

HotstringLVRemove: ;--Remove selected hotstring on listview-----------------------------
	Gui, Listview, MyListView
	focusedRowNumber := LV_GetNext(0, "F")
	if not focusedRowNumber																; No row is focused.
		return
	LV_GetText(rowContents, focusedRowNumber)
	hsfile := "!" . file_Hotstrings
	TFound := TF_Find(hsFile, 1, 0, rowContents, 1, 0)
	TFoundText := TF_Find(hsFile, 1, 0, rowContents, 1, 1)
	Array := StrSplit(TFoundText, ":")
		tfvar1 := Array[3]
		tfvar2 := Array[5]
	MsgBox, 4, , %promptBox_8%`n`n %tfvar1% - %tfvar2%
		IfMsgBox No
		return
	TF_RemoveLines(hsFile, Tfound, Tfound)
	Reload
	return

TextTemplates: ;--Open templates folder-------------------------------------------------
	Run, %folder_Autotext%
	return

;==SCRATCH PAD================================================================================================================================================	
ToolsDropDown:
	Gui, Submit, NoHide
	GuiControlGet, toolsDropdownOption, , toolsDropdown
	if (toolsDropdownOption = tools_2)
		Run, https://reference.medscape.com/guide/medical-calculators
	if (toolsDropdownOption = tools_1)
		{
		RunWait, calc.exe
		WinSet, AlwaysOnTop, On, ahk_exe Calc.exe
		}
	if (toolsDropdownOption = tools_3)
		Run, https://dailymed.nlm.nih.gov
	if (toolsDropdownOption = tools_4)
		Run, https://eciemaps.mscbs.gob.es/ecieMaps/browser/index_10_mc.html
	return

CleanScratchPad: ;--Does just that------------------------------------------------------
	GuiControl,, scratchPad
	return
	
;==PHONEBOOK=================================================================================================================================================
PhonebookListView:
	if ((A_GuiEvent = "RightClick") or (A_GuiControl = gui_button_10))						; Menu for more actions.
		Menu, PhonebookMenu, Show
	return

NewPhone:
	Gui, ListView, phonebookCSV
	InputBox, phoneName, medMACROS — %gui_windowtitle_5%, %promptBox_9%,, 240, 140
	if ErrorLevel
		return
	InputBox, phoneNumber, medMACROS — %gui_windowtitle_5%, %promptBox_10%,, 240, 140
	if ErrorLevel
		return
	LV_Add(,phoneName, phoneNumber)
	return

RemovePhone:
	Gui, ListView, phonebookCSV
	focusedRowNumber := LV_GetNext(0, "F")
	if not focusedRowNumber																; No row is focused.
		return
	LV_Delete(focusedRowNumber)
	return

;==EXIT GUI==================================================================================================================================================
GuiClose: ;--Exit program---------------------------------------------------------------
	GoSub, NewWindowHide
	return
Exit:
	GoSub SaveProgramData
	IL_Destroy(hIL)
	ExitApp
	return
	
SaveProgramData: ;--Save data and window positions--------------------------------------
	IniWrite, %A_ScreenWidth%, %file_Settings%, screensettings, W
	Iniwrite, %A_ScreenHeight%, %file_Settings%, screensettings, H
	WinGetPos, aboutX, aboutY, , , ahk_id %HMainWindow%									; Get Main and Toggle GUI positions on screen.
	WinGetPos, settings_buttonWindowX, settings_buttonWindowY, , , ahk_id %HToggle%
	IniWrite, %aboutX%, %file_Settings%, windowposition, X								; Write window positions to INI.
	IniWrite, %aboutY%, %file_Settings%, windowposition, Y
	IniWrite, %settings_buttonWindowX%, %file_Settings%, buttonsettings, X
	IniWrite, %settings_buttonWindowY%, %file_Settings%, buttonsettings, Y
	CSV_LVSave(newloginDataFile, "passwordCSV", ",", 1, 1)
	CSV_LVSave(file_Phonebook, "phonebookCSV", ",", 1, 1)

SaveScratchPad:
	Gui, Submit, NoHide
	GuiControlGet, scratchPadContents, , scratchPad										; Retrieve the contents of the scratchPad Edit control.
	FileDelete %file_scratchPad%														; Erase previous file contents and replace with Edit control contents.
	FileAppend, %scratchPadContents%, %file_scratchPad%
	return
	
ResetStartPositions: ;--Reset window positions------------------------------------------; Reset window positions if something doesn't match.
	settings_mainWindowX := A_ScreenWidth/2-142
	settings_mainWindowY := A_ScreenHeight/2-147
	settings_buttonWindowX := A_ScreenWidth/4
	settings_buttonWindowY := A_ScreenHeight-147
	return

GuiEscape: ;--Ignore ESC----------------------------------------------------------------
	return
	
;==MENU ACTIONS==============================================================================================================================================
Suspendhotstrings:	;--Suspend hotstrings-----------------------------------------------
	Menu, FileMenu, ToggleCheck, %menu_filemenu_3%
	Menu, QuickMenu, ToggleCheck, %menu_quickmenu_4%
	if (TrayMenuEnabled = TRUE)
		Menu, Tray, ToggleCheck, %menu_traymenu_4%
	Suspend, Toggle
	return

DummyHandler: ;--Generic subroutine for debug-------------------------------------------
MenuHandler:
	ToolTip, Not yet implemented.
	Sleep 1000
	Tooltip
	return
	
;==WINDOW ACTIONS============================================================================================================================================
WM_ACTIVATE() ;--Monitor current window and act accordingly-----------------------------
	{	
	Gosub WindowActions
	}
	return

WM_LBUTTONDOWN() ;--Drag windows from anywhere------------------------------------------
	{
	if (A_Gui = "Calendar")
		return
	if (A_Gui = "About")															; Don't drag About GUI
		return
	PostMessage, 0xA1, 2
	if (A_Gui = "Toggle")															; Toggle main GUI visibility when "button" GUI is clicked
	   GoSub NewWindowHide
	if WinExist(Calendario medMACROS)
		{
		Gui, Calendar:Destroy
		return
		}
	}
	return

WM_RBUTTONDOWN() ;--Display main menu with right click----------------------------------
	{
	if (A_Gui = "Toggle")
	Menu, QuickMenu, Show
	}
	return

WindowActions: ;--Control main GUI transparency-----------------------------------------
	if WinActive(ahk_id %HMainWindow%)
		WinSet, Transparent, 255, ahk_id %HMainWindow%									; Transparency off
	else
		WinSet, Transparent, 130, ahk_id %HMainWindow%									; Set transparency between 0-255
	return

WindowLock:
	mainLocked := TRUE
	if (mainHidden = FALSE)
		{
		WinHide, ahk_id %HMainWindow%
		mainHidden := TRUE
		return
		}
	return

NewWindowHide: ;--Hiding window toggle-----------------------------------------------------
	if (mainHidden = FALSE)
		{
		WinHide, ahk_id %HMainWindow%
		mainHidden := TRUE
		return
		}
	if (mainHidden = TRUE && mainLocked = FALSE)
		{
		mainHidden := FALSE
		GoSub ShowWindow
		return
		}
	if (mainHidden = TRUE && mainLocked = TRUE)
		{
		InputBox, password, medMACROS — %promptBox_11%, %promptBox_12%, hide, 240, 140
		if ErrorLevel
			return
		if (password = passwordMedimacros)
			{
			mainLocked := FALSE
			mainHidden := FALSE
			GoSub ShowWindow
			return
			}
		else
			MsgBox % promptBox_13
		return
		}
	return

ShowWindow:
	WinShow, ahk_id %HMainWindow%
	WinSet, Redraw,, ahk_id %HMainWindow%											; Redraw window to mitigate weird Tab
	WinSet, Transparent, 255, ahk_id %HMainWindow%									; Transparency off
	WinActivate, ahk_id %HMainWindow%
	return

KeepMainOnTop: ;--Toggle window always on top-------------------------------------------
    Gui, Submit, NoHide
    if (mainAlwaysOnTop = TRUE)
		{
        Gui, -AlwaysOnTop
		mainAlwaysOnTop := FALSE
		Menu, FileMenu, ToggleCheck, %menu_filemenu_1%
		Menu, QuickMenu, ToggleCheck, %menu_quickmenu_2%
		if (TrayMenuEnabled = TRUE)
			Menu, Tray, ToggleCheck, %menu_traymenu_2%
		}
    else
		{
        Gui, +AlwaysOnTop
		mainAlwaysOnTop := TRUE
		Menu, FileMenu, ToggleCheck, %menu_filemenu_1%
		Menu, QuickMenu, ToggleCheck, %menu_quickmenu_2%
		if (TrayMenuEnabled = TRUE)
			Menu, Tray, ToggleCheck, %menu_traymenu_2%
		}
	return

KeepWindowAbove: ;--Make any window stay above others-----------------------------------
	WinGetActiveTitle, currentActiveWindow
	WinSet, AlwaysOnTop, Toggle, %currentActiveWindow%
return
	

;==HOTKEY SUBROUTINES========================================================================================================================================
FocusMainGUI:
	GoSub, NewWindowHide
	GoSub, PluginSummonAction														; Addons can add extra functionality here.
	return

AlternatePaste:
	clipboard := TF_Tab2Spaces(clipboard, TabStop=2, Startline=1, Endline=0)		; Remove tabs.
	clipboard := TF_RemoveBlankLines(clipboard)										; Remove empty lines.
	Send {Raw}%clipboard%
	Return

;==APPEND PLUGINS============================================================================================================================================
#Include %A_ScriptDir%/Dictionaries/Active.ahk
#Include %A_ScriptDir%/Plugins/Active.ahk
#Include %A_ScriptDir%/Plugins/Medical notes.ahk