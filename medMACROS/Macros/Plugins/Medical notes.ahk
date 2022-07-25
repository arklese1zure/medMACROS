;=============================================================================================================================================================
; MedMACROS module
; Text editor for medical consultation
;=============================================================================================================================================================

GUITextEdit:
;==MENUS======================================================================================================================================================
	Menu, TextEditMenu, Add, Nuevo`tCtrl+N, FileNew ;--Menu Bar---------------------------------
	Menu, TextEditMenu, Add, Abrir`tCtrl+O, FileOpen
	Menu, TextEditMenu, Add, Guardar`tCtrl+S, FileSave
	Menu, TextEditMenu, Add ;-----------------------------------------------------------
	Menu, TextEditMenu, Add, Salir`tCtrl+Q, FileExit
	
;==MAIN GUI===================================================================================================================================================
	Gui, TextEdit:+LastFound +AlwaysOnTop
	Gui, TextEdit:Add, GroupBox, x3 y0 h38 w608,						;--Buttons---------------
	Gui, TextEdit:Add, Button, gFileMenu hwndFileMenu x5 yp+10 w25, Archivo
	Gui, TextEdit:Add, Button, gFileSave hwndFileSave x+3 yp w25,
		GuiButtonIcon(FileSave, "shell32.dll", 259, "s16 a0 l2")
	Gui, TextEdit:Add, Button, gFileExit x+3 yp w25 hwndCancel,
		GuiButtonIcon(Cancel, "shell32.dll", 132, "s16 a0 l2")
if (TE_AddonButtonEnabled = TRUE)
		Gui, TextEdit:Add, Button, gPluginTextEdit x524 yp+25 w80 hwndTEAddonButton, %TE_AddonButtonText%
		GuiButtonIcon(TEAddonButton, "shell32.dll", 261, "s16 a0 l2")
	Gui, TextEdit:Add, GroupBox, x3 y+8 h72 w608, Datos de la consulta	;--Patient info---------------
	Gui, TextEdit:Add, Text, x12 yp+20 w40 r1, Nombre:
	Gui, TextEdit:Add, Edit, x+3 yp w300 h20
	Gui, TextEdit:Add, Text, x+12 yp h20, ID:
	Gui, TextEdit:Add, Edit, x+3 w40 h20
	Gui, TextEdit:Add, Text, x+12 yp h20, Número de consulta:
	Gui, TextEdit:Add, Edit, x+3 yp w30 h20 ReadOnly, 1
	Gui, TextEdit:Add, Text, x12 y+5 w40 r1, Edad:
	Gui, TextEdit:Add, Edit, x+3 yp w40 h20 Number
	Gui, TextEdit:Add, Text, x+6 yp h20 , Sexo:
	Gui, TextEdit:Add, DropDownList, x+3 yp w40 r10, M|F
	Gui, TextEdit:Add, GroupBox, x3 y+8 h68 w608, Signos vitales ;--Vitals---------------
	Gui, TextEdit:Add, Text, x12 yp+20 w80 h20 , Temperatura								; First add editbox, then DllCall in order to add placeholder text
	Gui, TextEdit:Add, Text, x+3 yp w80 h20 , FC
	Gui, TextEdit:Add, Text, x+3 yp w80 h20 , FR
	Gui, TextEdit:Add, Text, x+3 yp w80 h20 , Talla
	Gui, TextEdit:Add, Text, x+3 yp w80 h20 , Peso
	Gui, TextEdit:Add, Text, x+3 yp w80 h20 , T/A	
	Gui, TextEdit:Add, Edit, x12 yp+17 w40 h20 vtemperatura Limit4 hwndhwnd_temperatura
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_temperatura, "UInt", 0x1501, "Ptr", True, "Str", "36.5", "Ptr")
	Gui, TextEdit:Add, Text, x+2 yp+3 w20 h20 , °C
	Gui, TextEdit:Add, Edit, x+20 yp-3 w30 h20 vfrecuencia Limit3 Number hwndhwnd_frecuencia
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_frecuencia, "UInt", 0x1501, "Ptr", True, "Str", "70", "Ptr")
	Gui, TextEdit:Add, Text, x+2 yp+3 w20 h20 , lpm
		Gui, TextEdit:Add, Edit, x+30 yp-3 w30 h20 vrespiracion Limit2 Number hwndhwnd_respiracion
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_respiracion, "UInt", 0x1501, "Ptr", True, "Str", "15", "Ptr")
	Gui, TextEdit:Add, Text, x+2 yp+3 w20 h20 , rpm
		Gui, TextEdit:Add, Edit, x+32 yp-3 w30 h20 vtalla Limit3 Number hwndhwnd_talla
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_talla, "UInt", 0x1501, "Ptr", True, "Str", "170", "Ptr")
	Gui, TextEdit:Add, Text, x+2 yp+3 w20 h20 , cm
	Gui, TextEdit:Add, Edit, x+30 yp-3 w30 h20 vpeso gLabelPeso Limit4 hwndhwnd_peso
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_peso, "UInt", 0x1501, "Ptr", True, "Str", "58", "Ptr")
	Gui, TextEdit:Add, Text, x+2 yp+3 w20 h20 , kg
	Gui, TextEdit:Add, Edit, x+32 yp-3 w30 h20 vsistolica gLabelSistolica Number hwndhwnd_sistolica
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_sistolica, "UInt", 0x1501, "Ptr", True, "Str", "120", "Ptr")
	Gui, TextEdit:Add, Text, x+2 yp+3 w7 h20 , /
	Gui, TextEdit:Add, Edit, x+3 yp-3 w30 h20 vdiastolica Limit3 Number hwndhwnd_diastolica
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_diastolica, "UInt", 0x1501, "Ptr", True, "Str", "80", "Ptr")
	Gui, TextEdit:Add, Text, x+2 yp+3 w30 h20 , mmHg
	Gui, TextEdit:Add, GroupBox, x3 y+8 h242 w608, Consulta ;--Main edit control--------
	Gui, TextEdit:Add, Edit, x12 yp+20 w590 h130 vconsulta
	Gui, TextEdit:Add, Text, x12 y+10 w70 h20, Diagnóstico 1: ;--Diagnoses--------------
	Gui, TextEdit:Add, Edit, x+3 yp-2 w320 h20 vdiag1 hwndhwnd_diag1
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_diag1, "UInt", 0x1501, "Ptr", True, "Str", "Diagnóstico 1", "Ptr") 
	Gui, TextEdit:Add, Text, x12 y+10 w70 h20, Diagnóstico 2:
	Gui, TextEdit:Add, Edit, x+3 yp-2 w320 h20 vdiag2 hwndhwnd_diag2
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_diag2, "UInt", 0x1501, "Ptr", True, "Str", "Diagnóstico 2", "Ptr") 
	Gui, TextEdit:Add, Text, x12 y+10 w70 h20, Diagnóstico 3:
	Gui, TextEdit:Add, Edit, x+3 yp-2 w320 h20 vdiag3 hwndhwnd_diag3
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_diag3, "UInt", 0x1501, "Ptr", True, "Str", "Diagnóstico 3", "Ptr")
/*
	Gui, TextEdit:Add, Radio, x424 y220 vradio_primeraVez, Primera vez ;--Radio buttons------------------
	Gui, TextEdit:Add, Radio, x424 yp+25 vradio_subsecuente, Subsecuente									; WIP: We need a way to store this in the output files.
	Gui, TextEdit:Add, Radio, x424 yp+25, No otorgada
*/
	Gui, TextEdit:Show, x198 y257 h438 w614, medMACROS — Editor de texto ;--GUI--------
	CurrentFileName := ""																; Indicate that there is no current file.
	return

FileMenu:
	Menu, TextEditMenu, Show
	Return

LabelPeso:
	Gui, Submit, NoHide
	if peso is space
		return
	if peso is not number
		GuiControl,, peso
return

LabelSistolica:
	Gui, Submit, NoHide
	if StrLen(sistolica) = 3															; Auto focus next field when 10 characters are written
		{
		GuiControl,, diastolica
		GuiControl, Focus, diastolica
		}	
	return

FileNew:
	GuiControl,, consulta																; Clear all controls and clear title.
	GuiControl,, diag1
	GuiControl,, diag2
	GuiControl,, diag3
	GuiControl,, temperatura
	GuiControl,, frecuencia
	GuiControl,, respiracion
	GuiControl,, talla
	GuiControl,, peso
	GuiControl,, sistolica
	GuiControl,, diastolica
	CurrentFileName := ""																; Indicate that there is no current file.
	Gui, TextEdit:Show,, mediMACROS — Editor de texto
	return

FileOpen:
	Gui +OwnDialogs																		; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
	FileSelectFile, SelectedFileName, 3,, Abrir archivo, Archivos de texto (*.txt)
	if not SelectedFileName																; No file selected.
		return
	Gosub FileRead
	return

FileRead:  																				; Caller has set the variable SelectedFileName for us.
	FileRead, consulta, %SelectedFileName%												; Read the file's contents into the variable.
	if ErrorLevel
		{
		MsgBox, No se pudo abrir "%SelectedFileName%".`nVerifique que el archivo se encuentre disponible y que los permisos estén correctamente configurados.
		return
		}
	fileHeader := TF_ReadLines(consulta,1,1,1)											; Check if it's a specially formatted txt file and parse it.
	fileHeader := subStr(fileHeader,0,1)
	if (fileHeader <> "=")																; If it's a regular file, don't parse and just load everything into the main edit field.
		{
		GoSub OtherFileRead
		return
		}
	temperatura := TF_ReadLines(consulta,2,2,1)											; Functions for parsing text and placing it into variables.
	temperatura := StrSplit(temperatura, ":", ".")
	temperatura := temperatura[2]
	frecuencia := TF_ReadLines(consulta,3,3,1)
	frecuencia := StrSplit(frecuencia, ":", ".")
	frecuencia := frecuencia[2]
	respiracion := TF_ReadLines(consulta,4,4,1)
	respiracion := StrSplit(respiracion, ":", ".")
	respiracion := respiracion[2]
	talla := TF_ReadLines(consulta,5,5,1)
	talla := StrSplit(talla, ":", ".")
	talla := talla[2]
	peso := TF_ReadLines(consulta,6,6,1)
	peso := StrSplit(peso, ":", ".")
	peso := peso[2]
	tension := TF_ReadLines(consulta,7,7,1)
	tension := StrSplit(tension, ":", ".")
	tension := tension[2]
	tension := StrSplit(tension, "/", ".")
	sistolica := tension[1]
	diastolica := tension[2]
	diag1 := TF_ReadLines(consulta,8,8,1)
	diag1 := StrSplit(diag1, ":", ".")
	diag1 := diag1[2]
	diag2 := TF_ReadLines(consulta,9,9,1)
	diag2 := StrSplit(diag2, ":", ".")
	diag2 := diag2[2]
	diag3 := TF_ReadLines(consulta,10,10,1)
	diag3 := StrSplit(diag3, ":", ".")
	diag3 := diag3[2]
	subsecuente := TF_ReadLines(consulta,11,11,1)
	subsecuente := StrSplit(subsecuente, ":", ".")
	subsecuente := subsecuente[2]
	if (subsecuente = " No")
		{	
		primeravez := 1
		subsecuente := 0
		}
	else 
		{
		primeravez := 0
		subsecuente := 1
		}
	consulta := TF_ReadLines(consulta,12,0,1)
	GuiControl,, temperatura, %temperatura%												; Load parsed variables into their fields.
	GuiControl,, frecuencia, %frecuencia%
	GuiControl,, respiracion, %respiracion%
	GuiControl,, talla, %talla%
	GuiControl,, peso, %peso%
	GuiControl,, sistolica, %sistolica%
	GuiControl,, diastolica, %diastolica%
	GuiControl,, consulta, %consulta%
	GuiControl,, diag1, %diag1%
	GuiControl,, diag2, %diag2%
	GuiControl,, diag3, %diag3%
	GuiControl,, radio_primeraVez, %primeravez%
	GuiControl,, radio_subsecuente, %subsecuente%
	CurrentFileName := SelectedFileName
	Gui, TextEdit:Show,, mediMACROS — %CurrentFileName%									; Show file name in title bar.
	return

OtherFileRead:
	GuiControl,, consulta, %consulta%
	CurrentFileName := SelectedFileName
	Gui, TextEdit:Show,, mediMACROS — %CurrentFileName%									; Show file name in title bar.
	return

FileSave:
	if not CurrentFileName																; No filename selected yet, so do Save-As instead.
		Goto FileSaveAs
	Gosub SaveCurrentFile
	return

FileSaveAs:
	Gui +OwnDialogs																		; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
	FileSelectFile, SelectedFileName, S16, %cedula% %A_DD%-%A_MM%-%A_YYYY%, Guardar archivo como..., Archivo de texto (*.txt)
	if not SelectedFileName																; No file selected.
		return
	CurrentFileName := SelectedFileName . .txt
	Gosub SaveCurrentFile
	return

SaveCurrentFile:																		; Caller has ensured that CurrentFileName is not blank.
	if FileExist(CurrentFileName)
		{
		FileDelete %CurrentFileName%
		if ErrorLevel
			{
			MsgBox No se puede sobreescribir el archivo "%CurrentFileName%".
			return
			}
		}
	GuiControlGet, consulta																; Retrieve the contents of the each edit control.
	GuiControlGet, diag1
	GuiControlGet, diag2
	GuiControlGet, diag3
	GuiControlGet, temperatura
	GuiControlGet, frecuencia
	GuiControlGet, respiracion
	GuiControlGet, talla
	GuiControlGet, peso
	GuiControlGet, sistolica
	GuiControlGet, diastolica
	GuiControlGet, radio_primeraVez
	if (radio_primeraVez=1)
		primeraVez := "No"
	else
		primeraVez := "Sí"
	consulta := TF_Tab2Spaces(consulta, TabStop=2, Startline=1, Endline=0)				; Remove tab characters.
	consulta := TF_RemoveBlankLines(consulta)											; Remove empty lines.
	FileAppend, ==CONSULTA MÉDICA==`n, %CurrentFileName%								; Append contents to specially formatted file.
	FileAppend, •Temperatura: %temperatura%`n, %CurrentFileName%
	FileAppend, •FC: %frecuencia%`n, %CurrentFileName%
	FileAppend, •FR: %respiracion%`n, %CurrentFileName%
	FileAppend, •Talla: %talla%`n, %CurrentFileName%
	FileAppend, •Peso: %peso%`n, %CurrentFileName%
	FileAppend, •T/A: %sistolica%/%diastolica%`n, %CurrentFileName%
	FileAppend, •Diagnóstico: %diag1%`n, %CurrentFileName%
	FileAppend, •Diagnóstico: %diag2%`n, %CurrentFileName%
	FileAppend, •Diagnóstico: %diag3%`n, %CurrentFileName%
	FileAppend, •Subsecuente: %primeravez%`n, %CurrentFileName%
	FileAppend, %consulta%`n, %CurrentFileName%
	Gui, TextEdit:Show,, mediMACROS — %CurrentFileName%									; Upon success, Show file name in title bar.
	return

FileExit:																				; Choosing "exit" from filemenu or "cancel" button.
TextEditGuiClose:  																		; User closed the window.
	consulta := ""																		; Theoretically frees memory.
	Menu, TextEditMenu, DeleteAll
	Gui, Destroy
	return