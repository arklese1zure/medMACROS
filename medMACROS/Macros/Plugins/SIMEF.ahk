; MEDIMACROSADDON
;=============================================================================================================================================================
; Extensión para MediMacros
; SIMEF Consulta Externa
;=============================================================================================================================================================

;##ESTRUCTURA DE LAS EXTENSIONES PARA MEDIMACROS##############################################################################################################
; El formato de las extensiones para mediMACROS es simplemente un script de AutoHotkey con algunas subrutinas predeterminadas que el script principal
; usa para agregar funcionalidad en el lugar correcto. Todas las subrutinas que estén en la plantilla para extensiones deben estar presentes aunque
; no se vayan a usar en la extensión que se esté creando.
; Si no se requiere alguna subrutina, se debe dejar el nombre y el elemento "return", de modo que el script continúe con su estructura.
;#############################################################################################################################################################

PluginLoadOptions: ;==Variables para configurar mediMACROS====================================================================================================
	plugin_Name :=					"SIMEF Consulta Externa"		; Nombre de la extensión, no debe usar caracteres especiales.
	plugin_Version :=				"0.9.14"						; Versión de la extensión.
	plugin_Author :=				"Samuel Bencomo"				; Autor de la extensión.
	plugin_TabEnabled :=			TRUE							; Mostrar pestaña para elementos gráficos.
	plugin_TabName :=				"SIMEF"							; Nombre de la pestaña.
	TE_AddonButtonEnabled :=		TRUE							; Mostrar botón de función especial en el editor de consulta mediMACROS.
	TE_AddonButtonText :=			"SIMEF"							; Texto del botón.
	plugin_MenuEnabled :=			FALSE							; Mostrar menú.
	plugin_QuickMenuEnabled := 		TRUE							; Mostrar entrada en menú rápido.
	plugin_MenuName :=				"SIMEF"							; Nombre del menú.
	plugin_SettingsTabEnabled :=	TRUE							; Habilitar cuadro en dialogo de opciones
return	;-------------------------------------------------------------------------------

;==Funciones - Leer ajustes y archivos========================================================================================================================
PluginReadSettings:
	simefLoginFile := A_WorkingDir . "\Macros\Userdata\SIMEFLogin.ini"					; Archivo con datos de inicio de sesión.
	IniRead, folderSIMEF, %simefLoginFile%, login simef, folderSIMEF					; Leer datos del archivo.
	IniRead, usernameSIMEF, %simefLoginFile%, login simef, usernameSIMEF
	IniRead, passwordSIMEF, %simefLoginFile%, login simef, passwordSIMEF
	IniRead, startupSIMEF, %simefLoginFile%, login simef, startupSIMEF
	simefIcon := folderSIMEF . "\simef.ico"
	if !FileExist(simefIcon)
		missingSIMEF := TRUE
return	;-------------------------------------------------------------------------------

;==Funciones - Menús==========================================================================================================================================
; Aquí se agregan menús que se quieran agregar para realizar funciones.
PluginLoadMenus:
;==Main menu============================================================================
	Menu, PluginMenu, Add, %plugin_Name%, MenuHandler
	Menu, PluginMenu, Disable, 1&
	Menu, PluginMenu, Add ;---------------
	Menu, PluginMenu, Add, Opciones, GUISettings
	Menu, PluginMenu, Add, Acerca de, PluginAbout
;==Paste menu===========================================================================
	Menu, SIMEFPasteMenu, Add, Pegar datos:, MenuHandler
	Menu, SIMEFPasteMenu, Disable, Pegar datos:
	Menu, SIMEFPasteMenu, Add, Nombre, SendNombre
	Menu, SIMEFPasteMenu, Add, Cédula, SendCedula
	Menu, SIMEFPasteMenu, Add, Cédula y tipo, CedulaTipo
	Menu, SIMEFPasteMenu, Add, Cédula/tipo, CedulaSlashTipo
;==SIMEF Tools==========================================================================	
	Menu, principalDropdown, Add, Pacientes agendados, SimefOpenInforme
	Menu, principalDropdown, Add, Catálogo CIE-10, SimefOpenICD
	Menu, principalDropdown, Add, Hoja de informe diario, SIMEFGenInforme
return	;-------------------------------------------------------------------------------
;==Quick menu addon=====================================================================
; Si se requiere agregar apartados extra al menú rápido, aquí se ponen. Se debe agregar una entrada para el menú del botón (quickmenu)
; y una entrada para el menú de la bandeja del sistema (tray), ya que se manejan por separado.
PluginQuickMenu:
	Menu, QuickMenu, Add, Iniciar SIMEF, AbrirSIMEF
	Menu, Tray, Add, Iniciar SIMEF, AbrirSIMEF
return	;-------------------------------------------------------------------------------


;==Funciones - Editor de texto================================================================================================================================
; La acción que ejecutará el botón especial del editor de texto mediMACROS.
PluginTextEdit:
	Msgbox, 262144, Pegar en SIMEF, Haga clic en la casilla de temperatura en SIMEF y presione ENTER.`nPresione ESC para cancelar.
	Input, singleKey, L1 T10, {Esc}, {Enter}										; Wait for Enter key to be pressed, timeout 10 seconds
	if (singlekey = "`n")
		{
		Gui, TextEdit:Submit, NoHide
		consulta := TF_Tab2Spaces(consulta, TabStop=2, Startline=1, Endline=0)		; Remove tabs.
		consulta := TF_RemoveBlankLines(consulta)									; Remove empty lines.
		talla := talla/100
		talla := Round(talla,2)
		Send %temperatura% {TAB}
		Send %frecuencia% {TAB}
		Send %respiracion% {TAB}
		Send %talla% {TAB}
		Send %peso% {TAB}
		Send %sistolica% {TAB}
		Send %diastolica% {TAB}
		Send %consulta% {TAB}
		Send %diag1% {TAB}
		Send %diag2% {TAB}
		Send %diag3% {TAB}
		return
		}
return	;-------------------------------------------------------------------------------
	
;==Funciones - Invocar ventana================================================================================================================================
; Esta es una acción que se activa cada vez que se llame la ventana mediMACROS con CTRL+F1.
PluginSummonAction:
	GuiControl, ChooseString, SysTabControl321, %plugin_TabName%
	ControlFocus, , ahk_id %hwnd_cedulaPaciente%
return	;-------------------------------------------------------------------------------
	
;==Funciones - Botón de ayuda=================================================================================================================================
; Casilla Acerca De para la extensión.
PluginAbout:
	MsgBox, 0x40000, Extensión mediMACROS,
	(
	%plugin_Name%
Versión %plugin_Version%
Autor: %plugin_Author%
	)
return	;-------------------------------------------------------------------------------

;==Funciones - Opciones=======================================================================================================================================
; Contenido de la pestaña extensión en el diálogo de opciones y la subrutina para escribir las opciones en el archivo de configuración.
PluginSettings:
	Gui, SettingsGUI:Add, GroupBox, x3 y+5 w470 h120, Inicio de sesión SIMEF
	Gui, SettingsGUI:Add, Text, x12 yp+18, Usuario										; Username.
	Gui, SettingsGUI:Add, Edit, w130 vSIMEF_userBox, %usernameSIMEF%
	Gui, SettingsGUI:Add, Text, x152 yp-19, Contraseña									; Password.
	Gui, SettingsGUI:Add, Edit, w130 vSIMEF_passwordBox Password, %passwordSIMEF%
	Gui, SettingsGUI:Add, Text, x12 yp+30, Carpeta de instalación						; Installation folder.
	Gui, SettingsGUI:Add, Edit, w200 vSIMEF_locationBox, %foldersimef%
	Gui, SettingsGUI:Add, Button, w20 x+5 yp-1 gSelectFolderSIMEF, Examinar...			; Specify installation directory for SIMEF.
	Gui, SettingsGUI:Add, GroupBox, x3 y+15 w470 h60, Inicio SIMEF
	Gui, SettingsGUI:Add, CheckBox, x13 yp+20 vSIMEF_startupbutton Checked%startupSIMEF%, Iniciar SIMEF directo en consulta
	Gui, SettingsGUI:Add, Text, x4 y246 cGray, %plugin_Name% %plugin_Version%
	return

PluginSaveSettings:																		; Save settings.
	IniWrite, %SIMEF_locationBox%, %simefLoginFile%, login simef, folderSIMEF
	IniWrite, %SIMEF_userBox%, %simefLoginFile%, login simef, usernameSIMEF
	IniWrite, %SIMEF_passwordBox%, %simefLoginFile%, login simef, passwordSIMEF
	IniWrite, %SIMEF_startupbutton%, %simefLoginFile%, login simef, startupSIMEF
return	;-------------------------------------------------------------------------------

;==Funciones - Pestaña========================================================================================================================================
; Aquí se agrega el contenido que se desee mostrar en una pestaña en mediMACROS, así como funciones y subrutinas que desee que se realicen.
PluginTab:
Gui, Add, GroupBox,		x2 y+2 w281 h47, Sesión SIMEF
Gui, Add, Button,		x7 yp+14 w90 gAbrirSIMEF vbuttonAbrirSimef hwndbuttonAbrirSimef, Iniciar SIMEF
	GuiButtonIcon(buttonAbrirSimef, simefIcon, , "s16 a0 l2")
if ((usernameSIMEF = "ERROR") or (missingSIMEF = TRUE))									; Verify saved login, otherwise disable button
	GuiControl, Disable, buttonAbrirSIMEF
Gui, Add, Text,			x+6 yp+5, Usuario:
Gui, Add, Edit,			x+3 yp-3 w131 ReadOnly, %usernameSIMEF%
;--Derechohabiente----------------------------------------------------------------------
Gui, Add, GroupBox,		x2 y+10 w281 h67, Datos derechohabiente
Gui, Add, Button, gGrabPatientInfo x7 yp+16 w25 hwndbutton_copyName, 
	GuiButtonIcon(button_copyName, "shell32.dll", 135, "s16 a0 l2")
	AddTooltip(button_copyName,"Copiar el nombre del paciente desde SIMEF")
Gui, Add, Edit,			x+0 yp+1 w244 vnombrePaciente hwndhwnd_nombrePaciente			; First add editbox, then DllCall in order to add placeholder text
	DllCall("user32.dll\SendMessage", "Ptr", hwnd_nombrePaciente, "UInt", 0x1501, "Ptr", True, "Str", "Nombre del paciente", "Ptr")
Gui, Add, Text,			x8 yp+29, Cédula
Gui, Add, Edit,			x+4 yp-4 w80 vCedula Limit10 gLabel Uppercase hwndhwnd_cedulaPaciente
	DllCall("user32.dll\SendMessage", "Ptr", hwnd_cedulaPaciente, "UInt", 0x1501, "Ptr", True, "Str", "XAXX010101", "Ptr")
Gui, Add, Edit,			x+2 w20 vTipo Limit2 Number hwndhwnd_tipoPaciente
	DllCall("user32.dll\SendMessage", "Ptr", hwnd_tipoPaciente, "UInt", 0x1501, "Ptr", True, "Str", "00", "Ptr")
Gui, Add, Button,		x+4 yp-2 w100 gAbrirExpediente, Abrir en SIMEF...
Gui, Add, Button, gPastePatientInfo x+1 w25 hwndbutton_pasteCedula, 
	GuiButtonIcon(button_pasteCedula, "shell32.dll", 261, "s16 a0 l2")
	AddTooltip(button_pasteCedula,"Pegar datos")
;--Historial----------------------------------------------------------------------------
Gui, Add, GroupBox,		x3 y+6 h119 w96, Historial
Gui, Add, Button,		xp+4 yp+15 w88 gAbrirHistorial hwndAbrirHistorial, Abrir
	GuiButtonIcon(AbrirHistorial, "shell32.dll", 21, "s16 a0 l2")
Gui, Add, Button,		y+3 w88 -wrap gAnteriorConsulta hwndAnteriorHistorial, Anterior
	GuiButtonIcon(AnteriorHistorial, "shell32.dll", 247, "s16 a0 l2")
Gui, Add, Button,		y+3 w88 -wrap gSiguienteConsulta hwndSiguienteHistorial, Siguiente
	GuiButtonIcon(SiguienteHistorial, "shell32.dll", 248, "s16 a0 l2")
Gui, Add, Button,		y+3 w88 gCerrarHistorial hwndCerrarHistorial, Cerrar
	GuiButtonIcon(CerrarHistorial, "shell32.dll", 132, "s16 a0 l2")
;--Consulta-----------------------------------------------------------------------------
Gui, Add, GroupBox,		x+6 yp-93 h119 w182, Consulta
Gui, Add, Button,		xp+3 yp+15 w88 -wrap gNuevaConsulta hwndNuevaConsulta, Nueva
	GuiButtonIcon(NuevaConsulta, "shell32.dll", 71, "s16 a0 l2")
Gui, Add, Button,		y+3 w88 -wrap gSaveConsulta hwndSaveConsulta, Guardar
	GuiButtonIcon(SaveConsulta, "shell32.dll", 259, "s16 a0 l2")
Gui, Add, Button,		y+3 w88 -wrap gDescartarConsulta hwndDescartarConsulta, Descartar
	GuiButtonIcon(DescartarConsulta, "shell32.dll", 153, "s16 a0 l2")
Gui, Add, Button,		y+3 w88 -wrap gEditConsulta hwndEditConsulta, Modificar
	GuiButtonIcon(EditConsulta, "shell32.dll", 270, "s16 a0 l2")
Gui, Add, Button,		x+2 yp-78 w88 h23 vconsultaDropdown gGUITextEdit, Editor
Gui, Add, Button,		y+3 w88 h23 vprincipalDropdown gPrincipalDropdown hwndPrincipalDropdown, Herramientas
	GuiButtonIcon(PrincipalDropdown, "shell32.dll", 268, "s16 a1 12")
;--Misc---------------------------------------------------------------------------------
return	;-------------------------------------------------------------------------------

;==Funciones - Hotkeys========================================================================================================================================
; Las teclas F5 a F8 están disponibles para usarlas en extensiones
^F5:: ;--Grab patient info subroutine---------------------------------------------------
	GoSub, SimefWindowStatus															; Grab SIMEF currently open windows.
	if WinExist("ahk_id" simefWindowReportes)
		WinActivate
	return
^F6::
	Send {F5}
	Sleep 1000
	Send {Tab 5}
	Send TEST
	return

;==Funciones - Subrutinas=====================================================================================================================================
; Aquí van todas las subrutinas que se deseen agregar además de las que se incluyen en la plantilla.
;--GUI Functions----------------------------------------------------------------------------------------------------------------------------------------------
SelectFolderSIMEF:																		; Select SIMEF folder for launching, activated from Settings.
    FileSelectFolder, selectedfolderSIMEF , , 0, Seleccione la carpeta donde se encuentra instalado SIMEF.
	if selectedfolderSIMEF =
		return
	GuiControl,, SIMEF_locationBox, %selectedfolderSIMEF%
	return

Label:																					; Auto focus next field when 10 characters are written.
	Gui, Submit, NoHide
	if StrLen(Cedula) > 9
		{
		GuiControl,, Tipo
		GuiControl, Focus, Tipo
		}	
	return
SendCedula:																				; Cedula.
	Gui, Submit, NoHide
	Sleep 100
	Send !{Esc}
	Send %cedula%
	return

CedulaTipo:																				; Cedula tipo.
	Gui, Submit, NoHide
	Send !{Esc}
	Sleep 100
	Send %cedula%
	Send {TAB}
	Send %tipo%
	return

CedulaSlashTipo:																		; Cedula/tipo.
	Gui, Submit, NoHide
	Send !{Esc}
	Send %cedula%/%tipo%
	return

SendNombre:																				; Patient name.
	Send !{Esc}
	Gui, Submit, NoHide
	Send %nombrePaciente%
	return

GrabPatientInfo:																		; Patient info.
	Gui, Submit, NoHide
	if winexist("Informe")
		{
		WinActivate Informe diario de labores del médico
		MouseClick, WheelUp, , , 100, 0, D, R
		Sleep 100
		Click, 180 360 Right
		Send {UP}{ENTER}
		WinActivate, mediMACROS
		GuiControl, ChooseString, SysTabControl321, SIMEF
		Sleep 100
		GuiControl, , nombrePaciente, %clipboard%
		return
		}
	return
	
PastePatientInfo:																		; Show menu for pasting stuff.
	Menu, SIMEFPasteMenu, Show
	return
	
PrincipalDropDown:																		; Dropdown for SIMEF tools.
	Menu, PrincipalDropDown, Show
	return
	
ConsultaDropDown:																		; Dropdown for other stuff.
	Gui, Submit, NoHide
	GuiControlGet, consultaDropdownSelected, , consultaDropdown
	if (consultaDropdownSelected = "Editor de texto")
		GoSub GUITextEdit
	return

;--SIMEF Handlers---------------------------------------------------------------------------------------------------------------------------------------------	
SIMEFScreenHandler:
	MsgBox, 16, mediMACROS, No se puede acceder a la herramienta desde la pantalla actual.`nCiérrela y vuelva a intentar.
	return
	
SIMEFWindowStatus:																		; Fetch info about current windows
	Winget, simefWindowMain, ID, Sistema de Estadística de Medicina Curativa
	Winget, simefWindowSchedule, ID, Informe Diario de Labores del Médico
	Winget, simefWindowConsulta, ID, Informe diario de labores del médico
	Winget, simefWindowHistorial, ID, Historial del Paciente
	Winget, simefWindowReportes, ID, Reportes
	return

AbrirSIMEF:																				; Open SIMEF
	GoSub, SimefWindowStatus
	if WinExist("ahk_id" simefWindowMain)
		{
		WinActivate
		return
		}
	else
		Run, %folderSIMEF%\bin\gdc.exe -S SimefP,, UseErrorLevel
		if ErrorLevel
			{
			MsgBox, 16, mediMACROS, No se pudo iniciar SIMEF.`nIngrese a la sección de ajustes para verificar la carpeta de instalación.
			return
			}
		else
			{
			WinWait, screen,,30
			if ErrorLevel
				{
				MsgBox, 16, Error, Tiempo de espera excedido para cliente SIMEF.`nEs probable que SIMEF se encuentre en mantenimiento o que el equipo no tenga conectividad.
				return
				}
			}
		Sleep 1000
		WinActivate, Sistema
		Sleep 1000
		Send %usernameSIMEF%
		Send {TAB}
		Send %passwordSIMEF%
		Send {ENTER}
		sleep 4000
		Gosub SimefOpenInforme
		if (startupSIMEF = 1)
			Send ^s
	return
	
NuevaConsulta:																			; Open consultation window
	GoSub, SimefWindowStatus
	if WinExist("ahk_id" simefWindowConsulta) 											; If consulta window exists, activate and show msgbox.
		{
		WinActivate
		MsgBox, 3, MediMACROS, Hay una consulta ya abierta.`n¿Desea guardar los datos antes de iniciar una nueva?
		IfMsgBox, Yes																	; Save everything and wait for window to close in order to open again.
			{
			Send {F2}																	; F2 is the button for saving.
			WinWaitClose, ahk_id %simefWindowConsulta%
			GoSub, SimefOpenConsulta
			return
			}
		IfMsgBox, No
			{
			Send {F5}
			return
			}
		return
		}

DescartarConsulta:
	GoSub, SimefWindowStatus
	if WinExist("ahk_id" simefWindowConsulta) 											; If consulta window exists, activate and show msgbox.
		{
		WinActivate
		MsgBox, 3, MediMACROS, ¿Desea descartar la consulta actual y comenzar una nueva?
		IfMsgBox, Yes																	; Save everything and wait for window to close in order to open again.
			{
			Send {F5}																	; F2 is the button for saving.
			return
			}
		IfMsgBox, No
			return
		return
		}


SimefOpenConsulta:																		; Open consultation window
	if WinExist("ahk_id" simefWindowSchedule)											; If schedule window exists, activate and press control s.
		{
		WinActivate
		Send ^s
		return
		}
	if WinExist("ahk_id" simefWindowMain)												; Otherwise, check if main window is open.
		{
		WinActivate
		Sleep 1000
		Send !cn
		WinWait, Informe Diario de Labores del Médico
		Send ^s
		return
		}
	else
		MsgBox, 16, mediMACROS, SIMEF no se encuentra abierto.
	return

;--SIMEF Main screen------------------------------------------------------------------------------------------------------------------------------------------
SimefOpenInforme:																		; Open informe diario
	GoSub, SimefWindowStatus
	if (WinExist("ahk_id" simefWindowSchedule) or WinExist("ahk_id" simefWindowConsulta))
		GoSub SIMEFScreenHandler
	else if WinExist("ahk_id" simefWindowMain)
		{
		WinActivate
		Sleep 1000
		Send !c
		Sleep 100
		Send n
		WinWait, Informe Diario de Labores del Médico
		}
	return

SimefOpenICD:																			; Open SIMEF ICD code lookup tool
	GoSub, SimefWindowStatus
	if (WinExist("ahk_id" simefWindowSchedule) or WinExist("ahk_id" simefWindowConsulta))
		GoSub SIMEFScreenHandler
	else if WinExist("ahk_id" simefWindowMain)
		{
		WinActivate
		Send !tt
		Sleep 100
		Send i
		WinWait, Diagnósticos CIE10
		Send {F3}
		Send {TAB}
		}
	return

;--SIMEF Consulta Screen--------------------------------------------------------------------------------------------------------------------------------------	
SaveConsulta:
	GoSub, SimefWindowStatus
	if WinExist("ahk_id" simefWindowConsulta) 											; If consulta window exists, activate and show msgbox.
		{
		WinActivate
		MsgBox, 1, MediMACROS, ¿Desea finalizar la consulta actual?`nUna vez finalizada no se podrán agregar nuevos medicamentos.
		IfMsgBox, OK																	; Save everything and wait for window to close in order to open again.
			{
			Send {F2}																	; F2 is the button for saving.
			return
			}
		IfMsgBox, Cancel
			return
		return
		}

EditConsulta:
	GoSub, SimefWindowStatus															; Grab SIMEF currently open windows.
	if WinExist("ahk_id" simefWindowConsulta) 											; If consulta window exists, activate and show msgbox.
		{
		WinActivate
		MsgBox, 1, MediMACROS, Introduzca los datos en la ventana siguiente para abrir una consulta ya guardada y modificarla
		IfMsgBox, OK																	; Save everything and wait for window to close in order to open again.
			{
			Send {F3}
			Sleep 500
			Send {ENTER}
			return
			}
	return
		}

return

SIMEFGenInforme: ;--Generate daily activities report------------------------------------
	GoSub, SimefWindowStatus															; Grab SIMEF currently open windows.
	if WinExist("ahk_id" simefWindowConsulta) 											; If consulta window exists, activate and show msgbox.
		{
		WinActivate
		Send {Appskey}
		Send {Down 10}
		Send {Enter}
		Winwait, Reporte SM10-1
		Winactivate
		Send {F4}
		return
		}
	return

AbrirExpediente: ;--Open patient's file in SIMEF----------------------------------------
	GoSub, SimefWindowStatus
	Gui, Submit, NoHide
	checkTipo := SubStr(tipo,2,1)														; Check if patient code ends with zero.
	if WinExist("ahk_id" simefWindowConsulta) 											; If consulta window exists, activate and show msgbox.
		{
		WinActivate
		Send {F5}																		; Clear previously open patient file.
		Sleep 1000																		; Wait for crappy program to catch up.
		Send +{Tab}
		Send %cedula%
		Send {TAB}																		; Workaround for horrible dropdown control
		Sleep  100
		if (checkTipo<>0)																; If patient type doesn't end with zero,
			{
			Send !{DOWN}																; open drop-down menu for manual selection.
			Sleep 300
			Send %tipo%
			Send {ENTER}
			return
			}
		else
			Send %tipo%																	; Otherwise, automatically open patient file.
			return
		}
	else
		MsgBox, Favor de abrir la ventana de consulta en SIMEF.
		return

;--SIMEF Patient file-----------------------------------------------------------------------------------------------------------------------------------------	
AbrirHistorial:																			; Open patient history
	WinWait, Informe
	if winexist("Informe")
		{
		WinActivate
		Send {Appskey}
		Send {Up 5}
		Send {Enter}
		Winwait, Historial
		Winactivate
		Send {Backspace}
		Sleep 500
		Click, 65, 110
		return
		}
	return
	
SiguienteConsulta:																		; Next entry in patient records.
	WinClose, Hoja de Urgencias - Internet Explorer
	if WinExist("Reportes")
		{
		WinActivate
		Send {ESC}
		Send {DOWN}
		Send {ENTER}
		}
	else
		return
	sleep 1000
	if winexist("Reportes")
		{
		MouseGetPos, StartX, StartY
		winactivate		
		Click, 120, 120
		MouseMove, StartX, StartY
		}
	return

AnteriorConsulta:																		; Previous entry in patient records.
	WinClose, Hoja de Urgencias - Internet Explorer
	if WinExist("Reportes")
		{
		WinActivate
		Send {ESC}
		Send {UP}
		Send {ENTER}
		}
	else
		return
	sleep 1000
	if winexist("Reportes")
		{
		MouseGetPos, StartX, StartY
		winactivate		
		Click, 120, 120
		MouseMove, StartX, StartY
		}
	return

CerrarHistorial:																		; Close patient history
	GoSub, SimefWindowStatus															; Grab SIMEF currently open windows.
	WinClose, Hoja de Urgencias - Internet Explorer
	if WinExist("ahk_id" simefWindowReportes)
		{
		WinActivate																		; use the window found above
		Send {ESC}
		}
	sleep 1000
	if WinExist("ahk_id" simefWindowHistorial)
		{
		WinActivate																		; use the window found above
		}
	Send {ESC}
	return