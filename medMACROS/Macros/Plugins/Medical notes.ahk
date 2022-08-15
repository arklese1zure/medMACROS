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
	Gui, TextEdit:Default
	;--Buttons---------------
	Gui, TextEdit:Add, GroupBox, x3 y0 h38 w768,
	Gui, TextEdit:Add, Button, gFileMenu hwndFileMenu x5 yp+10 w25, Archivo
	Gui, TextEdit:Add, Button, gFileSave hwndFileSave x+3 yp w25,
		GuiButtonIcon(FileSave, "shell32.dll", 259, "s16 a0 l2")
	Gui, TextEdit:Add, Button, gFileExit x+3 yp w25 hwndCancel,
		GuiButtonIcon(Cancel, "shell32.dll", 132, "s16 a0 l2")
	if (TE_AddonButtonEnabled = TRUE)
		Gui, TextEdit:Add, Button, gPluginTextEdit x524 yp+25 w80 hwndTEAddonButton, %TE_AddonButtonText%
		GuiButtonIcon(TEAddonButton, "shell32.dll", 261, "s16 a0 l2")
	;--Patients treeview---------------
	Gui, TextEdit:Add, GroupBox, x3 y41 h429 w153,	Pacientes
		Gui, TextEdit:Add, TreeView, x5 y58 h410 w150 gNotesTreeView vNotesTreeView
		TVString2 := CreateString(folder_Patients)
		CreateTreeView(TVString2)
	;--Patient info---------------
	Gui, TextEdit:Add, GroupBox, x160 y41 h72 w608, Datos del paciente
	Gui, TextEdit:Add, Text, x169 yp+20 w40 r1, Nombre:
	Gui, TextEdit:Add, Edit, x+3 yp w300 h20 vp_Name
	Gui, TextEdit:Add, Text, x+12 yp h20, ID:
	Gui, TextEdit:Add, Edit, x+3 w100 h20 vp_ID

	Gui, TextEdit:Add, Text, x169 y+5 w40 r1, Edad:
	Gui, TextEdit:Add, Edit, x+3 yp w40 h20 Number vp_Age
	Gui, TextEdit:Add, Text, x+6 yp h20 , Sexo:
	Gui, TextEdit:Add, DropDownList, x+3 yp w40 r10 vp_Gender, M|F

	Gui, TextEdit:Add, Text, x+37 yp h20 , Fecha:
	Gui, TextEdit:Add, DateTime, vc_Date x+3 yp, LongDate

	Gui, TextEdit:Add, GroupBox, x160 y+8 h68 w608, Signos vitales ;--Vitals---------------
	Gui, TextEdit:Add, Text, x169 yp+20 w80 h20 , Temperatura								; First add editbox, then DllCall in order to add placeholder text
	Gui, TextEdit:Add, Text, x+3 yp w80 h20 , FC
	Gui, TextEdit:Add, Text, x+3 yp w80 h20 , FR
	Gui, TextEdit:Add, Text, x+3 yp w80 h20 , Talla
	Gui, TextEdit:Add, Text, x+3 yp w80 h20 , Peso
	Gui, TextEdit:Add, Text, x+3 yp w80 h20 , T/A	
	Gui, TextEdit:Add, Edit, x169 yp+17 w40 h20 vtemperatura Limit4 hwndhwnd_temperatura
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
	
	Gui, TextEdit:Add, GroupBox, x160 y+12 h180 w608, Consulta ;--Main edit control--------
	Gui, TextEdit:Add, Edit, x169 yp+20 w590 h150 vconsulta gMainEditor
	
	Gui, TextEdit:Add, GroupBox, x160 y+12 h100 w608, Diagnósticos ;--Diagnoses--------------
	Gui, TextEdit:Add, Text, x169 yp+20 w70 h20, Diagnóstico 1:
	Gui, TextEdit:Add, Edit, x+3 yp-2 w320 h20 vdiag1 hwndhwnd_diag1
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_diag1, "UInt", 0x1501, "Ptr", True, "Str", "Diagnóstico 1", "Ptr") 
	Gui, TextEdit:Add, Text, x169 y+10 w70 h20, Diagnóstico 2:
	Gui, TextEdit:Add, Edit, x+3 yp-2 w320 h20 vdiag2 hwndhwnd_diag2
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_diag2, "UInt", 0x1501, "Ptr", True, "Str", "Diagnóstico 2", "Ptr") 
	Gui, TextEdit:Add, Text, x169 y+10 w70 h20, Diagnóstico 3:
	Gui, TextEdit:Add, Edit, x+3 yp-2 w320 h20 vdiag3 hwndhwnd_diag3
		DllCall("user32.dll\SendMessage", "Ptr", hwnd_diag3, "UInt", 0x1501, "Ptr", True, "Str", "Diagnóstico 3", "Ptr")
	CurrentFileName := ""															; Indicate that there is no current file.
	Gui, Add, StatusBar,,
	SB_SetText("Ready.")

Gui, TextEdit:Show, x198 y257 h500 w770, medMACROS — Editor de texto ;--GUI--------
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
	FileRead, consulta, %SelectedFileName%
	if ErrorLevel
		{
		MsgBox, No se pudo abrir "%SelectedFileName%".`nVerifique que el archivo se encuentre disponible y que pueda acceder al mismo.
		return
		}
	fileHeader := TF_ReadLines(consulta,1,1,1)											; Check if it's a specially formatted txt file and parse it.
	fileHeader := subStr(fileHeader,0,1)
	if (fileHeader <> "=")																; If it's a regular file, don't parse and just load everything into the main edit field.
		{
		GoSub OtherFileRead
		return
		}
	c_Date := TF_ReadLines(consulta,2,2,1)
	c_Date := StrSplit(c_Date, ":", ".")
	c_Date := c_Date[2]
	p_Name := TF_ReadLines(consulta,4,4,1)
	p_Name := StrSplit(p_Name, ":", ".")
	p_Name := p_Name[2]
	p_ID := TF_ReadLines(consulta,5,5,1)
	p_ID := StrSplit(p_ID, ":", ".")
	p_ID := p_ID[2]
	p_Age := TF_ReadLines(consulta,6,6,1)
	p_Age := StrSplit(p_Age, ":", ".")
	p_Age := p_Age[2]
	p_Gender := TF_ReadLines(consulta,7,7,1)
	p_Gender := StrSplit(p_Gender, ":", ".")
	p_Gender := p_Gender[2]
	temperatura := TF_ReadLines(consulta,9,9,1)											; Functions for parsing text and placing it into variables.
	temperatura := StrSplit(temperatura, ":", ".")
	temperatura := temperatura[2]
	frecuencia := TF_ReadLines(consulta,10,10,1)
	frecuencia := StrSplit(frecuencia, ":", ".")
	frecuencia := frecuencia[2]
	respiracion := TF_ReadLines(consulta,11,11,1)
	respiracion := StrSplit(respiracion, ":", ".")
	respiracion := respiracion[2]
	talla := TF_ReadLines(consulta,12,12,1)
	talla := StrSplit(talla, ":", ".")
	talla := talla[2]
	peso := TF_ReadLines(consulta,13,13,1)
	peso := StrSplit(peso, ":", ".")
	peso := peso[2]
	tension := TF_ReadLines(consulta,14,14,1)
	tension := StrSplit(tension, ":", ".")
	tension := tension[2]
	tension := StrSplit(tension, "/", ".")
	sistolica := tension[1]
	diastolica := tension[2]
	diag1 := TF_ReadLines(consulta,16,16,1)
	diag1 := StrSplit(diag1, ":", ".")
	diag1 := diag1[2]
	diag2 := TF_ReadLines(consulta,17,17,1)
	diag2 := StrSplit(diag2, ":", ".")
	diag2 := diag2[2]
	diag3 := TF_ReadLines(consulta,18,18,1)
	diag3 := StrSplit(diag3, ":", ".")
	diag3 := diag3[2]
	consulta := TF_ReadLines(consulta,20,0,1)
	Gui, GUIHelpViewer:Default
	GuiControl, TextEdit:, p_name, %p_Name%
	GuiControl, TextEdit:, p_ID, %p_ID%
	GuiControl, TextEdit:, p_Age, %p_Age%
	GuiControl, TextEdit:, p_Gender, %p_Gender%
	GuiControl, TextEdit:, c_Date, %c_Date%
	GuiControl, TextEdit:, temperatura, %temperatura%												; Load parsed variables into their fields.
	GuiControl, TextEdit:, frecuencia, %frecuencia%
	GuiControl, TextEdit:, respiracion, %respiracion%
	GuiControl, TextEdit:, talla, %talla%
	GuiControl, TextEdit:, peso, %peso%
	GuiControl, TextEdit:, sistolica, %sistolica%
	GuiControl, TextEdit:, diastolica, %diastolica%
	GuiControl, TextEdit:, consulta, %consulta%
	GuiControl, TextEdit:, diag1, %diag1%
	GuiControl, TextEdit:, diag2, %diag2%
	GuiControl, TextEdit:, diag3, %diag3%
	CurrentFileName := SelectedFileName
	SB_SetText("File loaded.")
	Gui, TextEdit:Show,, mediMACROS — %CurrentFileName%									; Show file name in title bar.
	return

OtherFileRead:
	GuiControl,, consulta, %consulta%
	CurrentFileName := SelectedFileName
	SB_SetText("Unformatted text file loaded.")
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
	GuiControlGet, p_Name
	GuiControlGet, p_ID
	GuiControlGet, p_Age
	GuiControlGet, p_Gender
	GuiControlGet, c_Date
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
	consulta := TF_Tab2Spaces(consulta, TabStop=2, Startline=1, Endline=0)				; Remove tab characters.
	consulta := TF_RemoveBlankLines(consulta)											; Remove empty lines.
	FileAppend, ==CONSULTA MÉDICA==`n,				%CurrentFileName%					; Append contents to specially formatted file.
	FileAppend, •Date:%c_Date%`n,					%CurrentFileName%
	FileAppend, ----Patient data----`n,				%CurrentFileName%
	FileAppend, •Name:%p_Name%`n,					%CurrentFileName%
	FileAppend, •ID:%p_ID%`n,						%CurrentFileName%
	FileAppend, •Age:%p_Age%`n,						%CurrentFileName%
	FileAppend, •Gender:%p_Gender%`n,				%CurrentFileName%
	FileAppend, ----Vital signs----`n,				%CurrentFileName%
	FileAppend, •Temperatura:%temperatura%`n,		%CurrentFileName%
	FileAppend, •FC:%frecuencia%`n,					%CurrentFileName%
	FileAppend, •FR:%respiracion%`n,				%CurrentFileName%
	FileAppend, •Talla:%talla%`n,					%CurrentFileName%
	FileAppend, •Peso:%peso%`n,						%CurrentFileName%
	FileAppend, •T/A:%sistolica%/%diastolica%`n,	%CurrentFileName%
	FileAppend, ----Diagnoses----`n,				%CurrentFileName%
	FileAppend, •Diagnóstico:%diag1%`n,				%CurrentFileName%
	FileAppend, •Diagnóstico:%diag2%`n,				%CurrentFileName%
	FileAppend, •Diagnóstico:%diag3%`n,				%CurrentFileName%
	FileAppend, ----Note----`n,						%CurrentFileName%
	FileAppend, %consulta%`n,						%CurrentFileName%
	justSaved := 1
	SB_SetText("File successfully saved.")
	Gui, TextEdit:Show,, mediMACROS — %CurrentFileName%									; Upon success, Show file name in title bar.
	return

MainEditor:
if(justSaved = 1)
	{
	Gui, TextEdit:Show,, mediMACROS — %CurrentFileName% *
	justSaved := 0
	}
return
NotesTreeView:
Return

FileExit:																				; Choosing "exit" from filemenu or "cancel" button.
TextEditGuiClose:  																		; User closed the window.
	if(justSaved = 0)
		{
		MsgBox, 3, MedMACROS, Changes have been made.`nDo you wish to save before exiting?
		IfMsgBox, Yes																	; Save everything and wait for window to close in order to open again.
			{
			GoSub, SaveCurrentFile
			return
			}
		}
	consulta := ""																		; Theoretically frees memory.
	Menu, TextEditMenu, DeleteAll
	Gui, Destroy
	return