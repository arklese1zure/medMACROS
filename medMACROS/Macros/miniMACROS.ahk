
;									=========================================================================
;									|||||							medMACROS							|||||
;									=========================================================================

;==STARTUP CONDITIONS=========================================================================================================================================
#SingleInstance, Force
#NoEnv
#Include %A_ScriptDir%/lib
path := A_ScriptDir
path := RegExReplace(path,"[^\\]+\\?$")
SetWorkingDir %path%
SetTitleMatchMode, 1
DetectHiddenWindows, On
StringCaseSense, On
ListLines Off

; Plugins, components and hotstring dictionaries are included at the end of the script.

;==CHECK PROGRAM FILES========================================================================================================================================
if !FileExist("Macros\Settings")
{
	msgbox, 16,, Faltan componentes para el funcionamiento de medMACROS. `nPor favor verifique la instalación.
	ExitApp
}

;==MONITOR SYSTEM MESSAGES====================================================================================================================================
OnMessage(0x06, "WM_ACTIVATE")															; Activate on window focus.
OnMessage(0x201, "WM_LBUTTONDOWN")														; Monitor for dragging window.
OnMessage(0x204, "WM_RBUTTONDOWN")														; Monitor for right click on GUI.

;==VARIABLES==================================================================================================================================================
programVersion :=	"2.1.4"
mainAlwaysOnTop :=	TRUE																; Variable for keeping on top.
mainHidden :=		FALSE																; Starting variable for hiding window.
mainLocked :=		FALSE
preventSleep :=		TRUE																; Starting variable for inhibit sleep.
Global 				HMain, XMain														; Needed for gdip.ahk to position drawn stuff.
TrayMenuEnabled :=	TRUE
Gosub, PluginLoadOptions

;==LOAD FILES=================================================================================================================================================
folder_UserFiles :=		A_WorkingDir . "\Archivos"										; Folder for user files.
folder_Autotext :=		A_WorkingDir . "\Archivos\Autotexto"
file_Hotstrings :=		A_WorkingDir . "\Macros\Dictionaries\Active.ahk"
folder_Documentation :=	A_WorkingDir . "\Macros\Docs"
folder_Icons  :=		A_WorkingDir . "\Macros\Icons"
file_Settings :=		A_WorkingDir . "\Macros\Settings\Settings.ini"					; Settings.
loginDataFile :=		A_WorkingDir . "\Macros\Userdata\UserData.ini"					; Saved user data from settings.
newloginDataFile :=		A_WorkingDir . "\Macros\Userdata\Logindata.csv"					; Saved logins.
file_Phonebook :=		A_WorkingDir . "\Macros\Userdata\Phonebook.csv"					; Saved logins.
file_scratchPad :=		A_WorkingDir . "\Macros\Userdata\ScratchPad.txt"				; File for saving quick notes.
CSV_Load(newLoginDataFile, "passwordCSV", ",")											; Load CSV for creating ListView. Extremely important: add the quotes to CSV_Identifier.
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
IniRead, clinica,						%loginDataFile%, usuario, clinica				; Workplace.
IniRead, passwordMedimacros, 			%file_Settings%, safety, unlockpassword			; Ultra-secure password storage.
IniRead, settings_firstLaunch,			%file_Settings%, firstlaunch, firstlaunch
GoSub, PluginReadSettings																; Load plugin settings, if any.
GoSub, DictReadSettings																	; Load dictionary data.
MainGUI_Tabs := "Administrador de contraseñas|Archivos|Autocompletar|Notas y herramientas|Directorio|"
if (plugin_TabEnabled = TRUE)
	MainGUI_Tabs := MainGUI_Tabs . plugin_TabName
Settings_Tabs := "Principal|Interfaz|"
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
Menu, FileMenu, Add, Mantener visible, KeepMainOnTop
Menu, FileMenu, ToggleCheck, Mantener visible
Menu, FileMenu, Add, No suspender, PreventSleep
Menu, FileMenu, Add, Desactivar autocompletar, Suspendhotstrings
Menu, FileMenu, Add ;---------------
Menu, FileMenu, Add, Editor de texto, GUITextEdit
Menu, FileMenu, Add ;---------------
Menu, FileMenu, Add, Ajustes, GUISettings
if (plugin_MenuEnabled = TRUE)
	Menu, FileMenu, Add, %plugin_MenuName%, :PluginMenu
Menu, FileMenu, Add, Bloquear medMACROS, WindowLock
Menu, FileMenu, Add ;---------------
	Menu, HelpMenu, Add, Manual del usuario, GUIHelpViewer
	Menu, HelpMenu, Add, Atajos de teclado, GUIHelpViewer
	Menu, HelpMenu, Add, Acerca de, GUIAbout
	Menu, FileMenu, Add, Ayuda, :HelpMenu
Menu, FileMenu, Add ;---------------
Menu, FileMenu, Add, Salir, Exit
;==Hotstrings menu======================================================================
Menu, HotstringMenu, Add, Eliminar abreviatura, HotstringLVRemove
Menu, HotstringMenu, Add, Nueva abreviatura, HotstringAdder
;==Password manager menu================================================================
Menu, LoginMenu, Add, Eliminar, RemovePassword
Menu, LoginMenu, Add, Nueva contraseña..., NewPassword
;==File organizer menus=================================================================
Menu, OrganizerMenu, Add, Abrir, TreeViewOpenFile
Menu, OrganizerMenu, Add ;---------------
Menu, OrganizerMenu, Add, Eliminar, TreeViewDeleteFile
Menu, OrganizerMenu, Add, Cambiar nombre, TreeViewRenameFile
Menu, OrganizerOptionsMenu, Add, Ver archivos en Explorer, AddFiles
Menu, OrganizerOptionsMenu, Add, Nuevo acceso directo, SelectFileShortcut
;==Phonebook menu=======================================================================
Menu, PhonebookMenu, Add, Agregar, NewPhone
Menu, PhonebookMenu, Add, Eliminar, RemovePhone
;==Quick menu===========================================================================
Menu, QuickMenu, Add, medMACROS, DummyHandler
Menu, QuickMenu, Disable, medMACROS
Menu, QuickMenu, Add, Mantener visible, KeepMainOnTop
Menu, QuickMenu, ToggleCheck, Mantener visible
Menu, QuickMenu, Add, No suspender, PreventSleep
Menu, QuickMenu, Add, Desactivar autocompletar, Suspendhotstrings
Menu, QuickMenu, Add ;---------------
Menu, QuickMenu, Add, Editor de texto, GUITextEdit
;==Tray menu============================================================================
Menu, Tray, NoStandard
Menu, Tray, Tip, medMACROS
Menu, Tray, Click, 1
Menu, Tray, Add, medMACROS, NewWindowHide 
Menu, Tray, Default, medMACROS
Menu, Tray, Disable, medMACROS
Menu, Tray, Add, Mantener visible, KeepMainOnTop
Menu, Tray, ToggleCheck, Mantener visible
Menu, Tray, Add, No suspender, PreventSleep
Menu, Tray, Add, Desactivar autocompletar, Suspendhotstrings
Menu, Tray, Add ;---------------
Menu, Tray, Add, Editor de texto, GUITextEdit
;==Addons for quick and tray menu=======================================================
if (plugin_QuickMenuEnabled = TRUE)
	GoSub, PluginQuickMenu
Menu, QuickMenu, Add ;---------------
Menu, QuickMenu, Add, Salir, Exit
Menu, Tray, Add ;---------------
Menu, Tray, Add, Salir, Exit

;==MAIN GUI===================================================================================================================================================
Gui +LastFound +AlwaysOnTop +OwnDialogs +HwndHMainWindow
if (settings_TitlebarEnabled = 0)
	Gui -Sysmenu +Toolwindow
;--Header-------------------------------------------------------------------------------
Gui, Add, Button,		x263 y2 h20 w20 gMainMenu hwndmainMenu,	
	GuiButtonIcon(mainMenu, "shell32.dll", 268, "s16 a0 l2")
Gui, Font, bold s8
Gui, Add, Text, 		xp-260 yp+2 w260, %settings_userName% - %clinica%
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
Gui, Add, GroupBox, 	x1 y+3 h208 w283, Administrador de contraseñas
CSV_LVLoad("passwordCSV", 1, 1, 77, 283, 190, "Nombre|Usuario|Lugar (URL)|Contraseña", 1, 1)
	Gui, ListView, SysListView321
	GuiControl, +AltSubmit Grid +gPasswordListView, SysListView321
Gui, Add, Button, 		x2 y270 w50 gPasswordLVOpen hwndOpenLogin, Abrir
	GuiButtonIcon(OpenLogin, "shell32.dll", 101, "s16 a0 l2")
Gui, Add, Button, 		x+1 y270 w90 gPasswordLVLogin hwndPasswordLVLogin, Iniciar sesión
	GuiButtonIcon(PasswordLVLogin, "shell32.dll", 105, "s16 a0 l2")
Gui, Add, Button,		x227 y270 gPasswordsMenu,	Opciones
Gui, Tab, 2	;--Quick access Tab---------------------------------------------------------
Gui, Add, GroupBox, 	x1 y+3 h208 w283, Archivos guardados
Gui, Add, TreeView, 	x1 y77 h190 w283 ImageList%ImageListID% vTreeView gfileTreeView AltSubmit
	TV_Delete()
	TVString := CreateString(folder_UserFiles)
	CreateTreeView(TVString)
Gui, Add, Button, 		x3 w25 y270 hwndrefreshTreeView gTreeViewRefresh,
	GuiButtonIcon(refreshTreeView, "shell32.dll", 239, "s16 a4 l2")
	AddTooltip(refreshTreeView,"Actualizar vista")
Gui, Add, Button,		x227 y270 gOrganizerOptionsMenu,	Opciones
Gui, Tab, 3	;--Hotstrings Tab-----------------------------------------------------------
Gui, Add, GroupBox, 	x1 y+3 h208 w283, Autocompletar y autotexto
Gui, add, listview, 	x1 y77 h190 w283 vMyListView gHotstringLVMenu AltSubmit Sort, Abreviatura|Texto completo
	LV_ModifyCol(1, 90)
	LV_ModifyCol(2, 300)
	GoSub, HotstringLVFill																; Populate ListView with parsed content from Hotstrings.ahk
Gui, Add, Button, 		x2 y270 gTextTemplates, Plantillas para Autotexto
Gui, Add, Button,		x227 y270 gHotstringLVMenu,	Opciones
Gui, Tab, 4	;--Scratchpad Tab-----------------------------------------------------------
Gui, Add, GroupBox, 	x1 y+3 h208 w283, Notas y herramientas
Gui, Add, Edit, 		x1 y77 w283 h190 vscratchPad									; For jotting down quick notes
	FileRead, scratchPadContents, %file_scratchpad%
	GuiControl,, scratchPad, %scratchPadContents%
Gui, Add, Button, 		x3 w25 y270 hwndCleanScratchPad gCleanScratchPad,
	GuiButtonIcon(CleanScratchPad, "shell32.dll", 132, "s16 a4 l2")
	AddTooltip(CleanScratchPad,"Borrar")
Gui, Add, Button, gSaveScratchPad hwndSaveScratchPad x+1 w25 y270,  ;--Buttons-
	GuiButtonIcon(SaveScratchPad, "shell32.dll", 259, "s16 a0 l2")
	AddTooltip(SaveScratchPad,"Guardar")
Gui, Add, Text, 		x+5 y275,|
Gui, Add, Text, 		x+5 y275, Herramientas:
toolsList = Calculadora|Calculadora médica|Vademecum|CIE-10
Gui, Add, DropDownList, x+3 y270 w150 h20 r5 vtoolsDropdown gToolsDropDown Choose1, %toolsList%
Gui, Tab, 5	;--Phonebook Tab------------------------------------------------------------
Gui, Add, GroupBox, 	x1 y+3 h208 w283, Directorio telefónico
CSV_LVLoad("phonebookCSV", 1, 1, 77, 283, 190, "Nombre|Extensión", 1, 1)
	LV_ModifyCol(2, 100)
	Gui, ListView, SysListView323
	GuiControl, +AltSubmit Grid +gPhonebookListView -readonly, SysListView323
Gui, Add, Button,		x227 y270 gPhonebookListView,	Opciones
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
	Gui, About:Add, Text, 		yp+20, Versión %programVersion%
	Gui, About:Font,			italic s8
	Gui, About:Add, Text, 		yp+20, Sistema experto para manejo de`nconsulta electrónica.
	Gui, About:Font,			norm s8
	Gui, About:Add, Text, ,		Por: Samuel Bencomo`nTwitter: @Arklese1zure
	Gui, About:Add, Button,		x3 yp+35 gGUIHelpViewer, Software y librerías utilizados
	Gui, About:Add, Button,		x3 y+2 gGUIHelpViewer, Licencias
	Gui, About:Add, Button, 	x+170 w50 Default, OK
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
GUIHelpViewer: 	; This GUI loads readmes. Maybe move to pdfs, but you don't have to rely on external viewers this way.
{
	Gui, GUIHelpViewer:Default
	Gui, GUIHelpViewer:Add, ListView, x3 y3 h279 w150 gHelpTreeView AltSubmit -Hdr, Name
	Loop, %folder_Documentation%\*.*													; Gather a list of file names from a folder and put them into the ListView:
    LV_Add("", A_LoopFileName)
	LV_ModifyCol()																		; Auto-size each column to fit its contents.
	Gui, GUIHelpViewer:Add, Edit, ReadOnly vhelpFileDisplay h279 w497 x+3
	Gui, GUIHelpViewer:Show, w656 h285, medMACROS — Ayuda
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
	Gui, Paster:Add, Text,, Escoja la plantilla a usar.`nPara cancelar presione ESC.
	Gui, Paster:Add, ComboBox, vMyListBox w140 r10
	Gui, Paster:Add, Button, Default xp+143 yp-1, OK
	Loop, %folder_Autotext%\*.txt															; Retrieve file list.
		{
		GuiControl, Paster:, MyListBox, %A_LoopFileName%
		}
	Gui, Paster:Show, X%pasterX% Y%pasterY%, Lista de texto rápido
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
		MsgBox Compruebe que el archivo no haya sido movido y que tenga permiso para acceder.

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
	Gui, SettingsGUI:Add, GroupBox, x3 y+5 w470 h70, Datos del usuario					; User data box.
	Gui, SettingsGUI:Add, Text, 	x12 yp+18 w100, Nombre:
	Gui, SettingsGUI:Add, Edit, 	x+5 w222 vnombreMedicoBox, %settings_userName%
	Gui, SettingsGUI:Add, Text,		x12 yp+25 w100, Lugar de trabajo:
	Gui, SettingsGUI:Add, Edit,		x+5 w222 vclinicabox, %clinica%
	Gui, SettingsGUI:Add, GroupBox, x3 y+10 h50 w470, Extensiones para medMACROS
	Gui, SettingsGUI:Add, Edit, 	x12 yp+20 w258 vpluginNameBox -Wrap ReadOnly, %plugin_Name%
	Gui, SettingsGUI:Add, Button, 	x+3 yp-1 gLoadAddon, Cambiar extensión				; Load addon
	Gui, SettingsGUI:Add, Button, 	x+3 gUnloadAddon, Desactivar						; Unload addon
	Gui, SettingsGUI:Add, GroupBox, x3 y+10 h50 w470, Diccionario de abreviaturas
	Gui, SettingsGUI:Add, Edit, 	x12 yp+20 w258 vdictNameBox -Wrap ReadOnly, %dict_Name%
	Gui, SettingsGUI:Add, Button, 	x+3 yp-1 gLoadDictionary, Cambiar diccionario		; Load addon
	Gui, SettingsGUI:Add, GroupBox, x3 y+10 h50 w200, Contraseña medMACROS
	Gui, SettingsGUI:Add, Edit, 	xp+10 yp+19 w130 vmedimacros_passwordBox Password, %passwordMedimacros%
	Gui, Tab, 2	;--GUI Settings Tab----------------------------------------------------------
	Gui, SettingsGUI:Add, GroupBox, x3 y+5 h76 w200, Botón acceso rápido
	Gui, SettingsGUI:Add, CheckBox, xp+8 yp+20 vsettings_ToggleGUIEnabled Checked%settings_ToggleGUIEnabled%, Mostrar botón
	Gui, SettingsGUI:Add, Button,	x10 yp+20 gLoadButtonImage, Elegir imagen...
	Gui, SettingsGUI:Add, Picture,	x+32 y42 w64 h64, %A_WorkingDir%\Macros\Buttons\%settings_ToggleGUIImage%
	Gui, SettingsGUI:Add, GroupBox, x+20 y33 h76 w260, Ventana y barra de tareas
	Gui, SettingsGUI:Add, CheckBox, xp+8 yp+22 vsettings_TrayEnabled Checked%settings_TrayEnabled%, Mostrar icono en la bandeja del sistema
	Gui, SettingsGUI:Add, CheckBox, xp yp+22 w258 vsettings_TitlebarEnabled Checked%settings_TitlebarEnabled%, Mostrar controles en ventana principal
	Gui, SettingsGUI:Add, GroupBox, x3 y+20 h150 w200, Pestañas habilitadas
	Gui, SettingsGUI:Add, CheckBox, xp+8 yp+22 vsettings_PasswordsTabEnabled Checked%settings_PasswordsTabEnabled%, Administrador de contraseñas
	Gui, SettingsGUI:Add, CheckBox, yp+22 vsettings_FilesTabEnabled Checked%settings_FilesTabEnabled%, Archivos guardados
	Gui, SettingsGUI:Add, CheckBox, yp+22 vsettings_HotstringsTabEnabled Checked%settings_HotstringsTabEnabled%, Autocompletar
	Gui, SettingsGUI:Add, CheckBox, yp+22 vsettings_NotesTabEnabled Checked%settings_NotesTabEnabled%, Notas y herramientas
	Gui, SettingsGUI:Add, CheckBox, yp+22 vsettings_PhonebookTabEnabled Checked%settings_PhonebookTabEnabled%, Directorio telefónico
	Gui, Tab, 3	;--Plugin Tab---------------------------------------------------------------
	GoSub, PluginSettings
	Gui, Tab	;---------------------------------------------------------------------------
	Gui, SettingsGUI:Add, Button, 	w80 x1 y265 gGUIHelpViewer, Ayuda
	Gui, SettingsGUI:Add, Button, 	w80 x312 y265 gSaveSettings, Guardar
	Gui, SettingsGUI:Add, Button, 	w80 x+3 yp gSettingsGUIGuiClose, Cancelar
	Gui, SettingsGUI:Show, w476 h290, medMACROS — Ajustes
	return

SaveSettings:																			; Save settings.
	Gui, SettingsGUI:Submit, NoHide
	IniWrite, %nombreMedicoBox%,				%loginDataFile%, usuario, settings_userName
	IniWrite, %clinicabox%, 					%loginDataFile%, usuario, clinica
	IniWrite, %settings_ToggleGUIEnabled%, 		%file_Settings%, buttonsettings, enabled
	IniWrite, %medimacros_passwordBox%, 		%file_Settings%, safety, unlockpassword
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
	FileSelectFile, selectedPluginName, 3, %A_WorkingDir%\Macros\Plugins, Cargar extensión nueva, Extensión medMACROS (*.ahk)
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
	FileSelectFile, selectedDictName, 3, %A_WorkingDir%\Macros\Dictionaries, Cargar diccionario, Diccionario medMACROS (*.ahk)
	if (SelectedDictName = "")
		return
	GoSub, CheckValidPlugin
	if (pluginIsValid = FALSE)
		return
	FileDelete, %A_WorkingDir%\Macros\Dictionaries\Active.ahk
	FileCopy, %selectedDictName%, %A_WorkingDir%\Macros\Dictionaries\Active.ahk
	GuiControl, %selectedDictName%, dictNameBox
	return

CheckValidPlugin:
	selectedPluginName := selectedPluginName . selectedDictName
	FileReadLine, checkedLine, %selectedPluginName%, 1
	if (checkedLine <> "; MEDIMACROSADDON")
		{
		MsgBox, 4096, Error, Formato de extensión no válido, favor de verificar.
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
	Gui, Hotstrings:Add, Text,		x12 y8 w350 h20 , Escriba la palabra o frase que quiere abreviar.
	Gui, Hotstrings:Add, Text,		x12 y30 w120 h20, Texto completo:
	Gui, Hotstrings:Add, Text,		x12 y58 w120 h20, Texto abreviado:
	Gui, Hotstrings:Add, Edit,		x100 y25 w230 vabrevCompleta
	Gui, Hotstrings:Add, Edit,		x100 y55 w230 vHotstring
	Gui, Hotstrings:Add, Button,	x252 y80 w80 gHotstringsGuiClose, Cancelar
	Gui, Hotstrings:Add, Button,	x172 y80 w80 gHotstringAppend, OK
	Gui, Hotstrings:Show,			h110 w340, Agregar nueva abreviatura...
	return
	
HotstringAppend:
	Gui, Submit, NoHide
	GuiControlGet, abrevCompleta														; Retrieve the contents of the Edit control.
	GuiControlGet, Hotstring															; Retrieve the contents of the Edit control.
	if (abrevCompleta = "" or Hotstring = "")											; Check if strings are not empty
		{
		MsgBox, 4096, Error, No se pueden dejar campos en blanco, favor de verificar.
		return
		}
	StringReplace, Hotstring, Hotstring, `r`n, ``r, All									; Using `r works better than `n in MS Word, etc.
	StringReplace, Hotstring, Hotstring, `n, ``r, All
	StringReplace, Hotstring, Hotstring, %A_Tab%, ``t, All
	StringReplace, Hotstring, Hotstring, `;, ```;, All
	FileAppend, `n:R:%Hotstring%::%abrevCompleta%, %file_Hotstrings%
	Reload																				; If successful, the reload will close this instance during the Sleep
	Sleep 300
	MsgBox, 0, 16, Agregando abreviatura, espere por favor.
	return
	
HotstringsGuiClose:
HotstringsGuiEscape:
	Gui, Destroy
	return

;##New Password GUI###########################################################################################################################################
NewPassword:
	Gui, Passwords:+owner1 +AlwaysOnTop +ToolWindow -Sysmenu
	Gui +Disabled																		; Disable main GUI (owner).
	Gui, Passwords:Add, Text,	x8 y8 w100 h20, Nombre:
	Gui, Passwords:Add, Text,	x8 y+3 w100 h20, Usuario:
	Gui, Passwords:Add, Text,	x8 y+3 w100 h20, Contraseña:
	Gui, Passwords:Add, Text,	x8 y+3 w100 h20, Ubicación:
	Gui, Passwords:Add, Edit,	x90 y8 w220 h20 vresourceName,
	Gui, Passwords:Add, Edit,	x90 y+3 w220 h20 vresourceUserName,
	Gui, Passwords:Add, Edit,	x90 y+3 w220 h20 vresourcePassword,
	Gui, Passwords:Add, Edit,	x90 y+3 w220 h20 vresourceLocation,
	Gui, Passwords:Add, Button,	x+2 w20 gPickResourceLocation, Seleccionar
	Gui, Passwords:Add, Button,	x221 y105 w80 gAppendNewPassword, OK
	Gui, Passwords:Add, Button,	x+2 y105 w80 gPasswordsGuiClose, Cancelar
	Gui, Passwords:Show, , medMACROS — Contraseñas
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
	FileSelectFile, newResource , , , Seleccione un archivo ejecutable...
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
	Send {Raw}%Clipboard%
	return

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
	FileCopy, %DroppedFileName%, %A_WorkingDir%\Archivos\*.*
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
		Menu, FileMenu, ToggleCheck, No suspender
		Menu, QuickMenu, ToggleCheck, No suspender
		if (TrayMenuEnabled = TRUE)
			Menu, Tray, ToggleCheck, No suspender
		preventSleep := FALSE
		return
		}
	if preventSleep = 0
		{
		SetTimer, CheckIdle, off
		Menu, FileMenu, ToggleCheck, No suspender
		Menu, QuickMenu, ToggleCheck, No suspender
		if (TrayMenuEnabled = TRUE)
			Menu, Tray, ToggleCheck, No suspender
		preventSleep := TRUE
		return
		}
	return
	
;==SHORTCUTS==================================================================================================================================================
FirstLaunch:
	MsgBox, 64, medMACROS — Instalación, 
	(
¡Bienvenido a medMACROS!

A continuación se mostrará la ventana de Ajustes.
Para aprovechar al máximo todas las funciones que ofrece medMACROS, introduzca los datos requeridos en los campos.

En caso de dudas, presione el botón ayuda. En el manual de usuario se explica el propósito de cada función.
	)
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
		MsgBox, 4, Eliminar contraseña, ¿Desea eliminar `"%searchText1%`"?
	IfMsgBox, No
		return																			; User pressed the "No" button.
	LV_Delete(focusedRowNumber)
	return

PasswordLVOpen:																			; Open selected resource with variables obtained from FetchPasswordLV.
	if (focusedrownumber = "0")															; Don't do anything if no row is focused, inform user.
		{
		MsgBox, Por favor haga una selección.
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
		MsgBox, 16, Error, No se pudo abrir el archivo.`nCompruebe que no haya sido movido y que tenga permiso para acceder.
	return

TreeViewDeleteFile:
	if ((selecteditemtext = "Accesos directos") or (selecteditemtext = "Autotexto"))
		{
		MsgBox, 16, Error, Elemento necesario para funcionamiento de medMACROS, no se puede eliminar.
		return
		}
	MsgBox, 4, Eliminar archivo, ¿Desea eliminar %selecteditemtext%?
	IfMsgBox, No
		return																			; User pressed the "No" button.
	FileDelete, %selectedFullPath%
	GoSub, TreeViewRefresh
	return

SelectFileShortcut: ;--Make shortcuts---------------------------------------------------
	FileSelectFile, newShortcut , , 0, Seleccione un archivo para crear un acceso directo.
	SplitPath, newShortcut, , , ,newShortcutName
	FileCreateShortcut, %newShortcut%, %A_WorkingDir%\Archivos\Accesos directos\%newShortcutName%.lnk
	GoSub, TreeViewRefresh
	return
	
TreeViewRenameFile:
	InputBox, newFileName, medMACROS — Archivos, Escriba nombre nuevo.,, 240, 140
	if ErrorLevel
		return
	SplitPath, selectedFullPath,, dir, ext
	newname := dir . "\" . newfilename "." ext
	FileMove, %selectedFullPath%, %newname%, 1
	if ErrorLevel
		{
		MsgBox, 16, Error, Error al cambiar nombre de archivo.`nCompruebe que no utilizó caracteres no permitidos.
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
	if ((A_GuiEvent = "RightClick") or (A_GuiControl = "Opciones"))						; Menu for more actions.
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
	MsgBox, 4, , ¿Desea eliminar la siguiente abreviatura?`n`n %tfvar1% - %tfvar2%
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
	if (toolsDropdownOption = "Calculadora médica")
		Run, https://reference.medscape.com/guide/medical-calculators
	if (toolsDropdownOption = "Calculadora")
		{
		RunWait, calc.exe
		WinSet, AlwaysOnTop, On, ahk_exe Calc.exe
		}
	if (toolsDropdownOption = "Vademecum")
		Run, https://dailymed.nlm.nih.gov
	if (toolsDropdownOption = "CIE-10")
		Run, https://eciemaps.mscbs.gob.es/ecieMaps/browser/index_10_mc.html
	return

CleanScratchPad: ;--Does just that------------------------------------------------------
	GuiControl,, scratchPad
	return
	
;==PHONEBOOK=================================================================================================================================================
PhonebookListView:
	if ((A_GuiEvent = "RightClick") or (A_GuiControl = "Opciones"))						; Menu for more actions.
		Menu, PhonebookMenu, Show
	return

NewPhone:
	Gui, ListView, phonebookCSV
	InputBox, phoneName, medMACROS — Directorio, Escriba nombre del contacto,, 240, 140
	if ErrorLevel
		return
	InputBox, phoneNumber, medMACROS — Directorio, Escriba teléfono del contacto,, 240, 140
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
	Menu, FileMenu, ToggleCheck, Desactivar autocompletar
	Menu, QuickMenu, ToggleCheck, Desactivar autocompletar
	if (TrayMenuEnabled = TRUE)
		Menu, Tray, ToggleCheck, Desactivar autocompletar
	Suspend, Toggle
	return

DummyHandler: ;--Generic subroutine for debug-------------------------------------------
MenuHandler:
	ToolTip, Todavía no existo!
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
		InputBox, password, medMACROS — Bloqueado, Escriba contraseña para desbloquear, hide, 240, 140
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
			MsgBox, Contraseña incorrecta.
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
		Menu, FileMenu, ToggleCheck, Mantener visible
		Menu, QuickMenu, ToggleCheck, Mantener visible
		if (TrayMenuEnabled = TRUE)
			Menu, Tray, ToggleCheck, Mantener visible
		}
    else
		{
        Gui, +AlwaysOnTop
		mainAlwaysOnTop := TRUE
		Menu, FileMenu, ToggleCheck, Mantener visible
		Menu, QuickMenu, ToggleCheck, Mantener visible
		if (TrayMenuEnabled = TRUE)
			Menu, Tray, ToggleCheck, Mantener visible
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

;==APPEND PLUGINS============================================================================================================================================
#Include %A_ScriptDir%/Dictionaries/Active.ahk
#Include %A_ScriptDir%/Plugins/Active.ahk
#Include %A_ScriptDir%/Plugins/Medical notes.ahk