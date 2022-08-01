; MEDMACROS

;=============================================================================================================================================================
; MedMACROS translation file
; By Arklese1zure
;=============================================================================================================================================================

;==DIALOG BOXES========================================================================================================================================
errBox_1 :=						"Unable to start medMACROS.`n Please verify that all installation files exist."
tabNames_1 :=                   "Password manager"
tabNames_2 :=                   "Files"
tabNames_3 :=                   "Autocomplete"
tabNames_4 :=                   "Notepad and tools"
tabNames_5 :=                   "Phonebook"

;==MENUS======================================================================================================================================================
;==Main menu============================================================================
menu_filemenu_1 :=				"Keep above"
menu_filemenu_2 :=				"Suspend sleep"
menu_filemenu_3 :=				"Disable autocomplete"
menu_filemenu_4 :=				"Consultation editor"
menu_filemenu_5 :=				"Settings"
menu_filemenu_6 :=				"Lock medMACROS"
menu_filemenu_7 :=				"Help"
menu_filemenu_8 :=				"Exit"
;==Help menu============================================================================
menu_helpmenu_1 :=				"User manual"
menu_helpmenu_2 :=				"Keyboard shortcuts"
menu_helpmenu_3 :=				"About"
;==Hotstrings menu======================================================================
menu_hostringsmenu_1 :=			"Delete hotstring"
menu_hostringsmenu_2 :=			"New hotstring"
;==Password manager menu================================================================
menu_loginmenu_1 :=				"Delete login"
menu_loginmenu_2 :=				"New login..."
;==File organizer menus=================================================================
menu_organizermenu_1 :=			"Open"
menu_organizermenu_2 :=			"Delete"
menu_organizermenu_3 :=			"Rename"
menu_organizeroptionsmenu_1 :=	"Open in Explorer"
menu_organizeroptionsmenu_2 :=	"New shortcut"
;==Phonebook menu=======================================================================
menu_phonebookmenu_1 :=			"Add"
menu_phonebookmenu_2 :=			"Delete"
;==Quick menu===========================================================================
menu_quickmenu_1 :=				"medMACROS"
menu_quickmenu_2 :=				"Keep above"
menu_quickmenu_3 :=				"Suspend sleep"
menu_quickmenu_4 :=				"Disable autocomplete"
menu_quickmenu_5 :=				"Consultation editor"
menu_quickmenu_6 :=				"Exit"
;==Tray menu============================================================================
menu_traymenu_1 :=				"medMACROS"
menu_traymenu_2 :=				"Keep above"
menu_traymenu_3 :=				"Suspend sleep"
menu_traymenu_4 :=				"Disable autocomplete"
menu_traymenu_5 :=				"Consultation editor"
menu_traymenu_6 :=				"Exit"

;==MAIN GUI===================================================================================================================================================
;--Passwords Tab------------------------------------------------------------
gui_groupbox_1 :=				"Password manager"
gui_button_1 :=					"Open"
gui_button_2 :=					"Login"
gui_button_3 :=					"Options"
passwords_1 :=                  "Name"
passwords_2 :=                  "Username"
passwords_3 :=                  "Location (URL)"
passwords_4 :=                  "Password"
;--Quick access Tab---------------------------------------------------------
gui_groupbox_2 :=				"Saved files"
gui_button_4 :=					"Refresh"
gui_button_5 :=					"Options"
;--Hotstrings Tab-----------------------------------------------------------
gui_groupbox_3 :=				"Autocomplete & Autotext"
gui_button_6 :=					"Autotext templates"
gui_button_7 :=					"Options"
;--Scratchpad Tab-----------------------------------------------------------
gui_groupbox_4 :=				"Notepad and tools"
gui_button_8 :=					"Delete"
gui_button_9 :=					"Save"
gui_text_1 :=					"Tools:"
tools_1 :=						"Calculator"
tools_2 :=						"Medical calculator"
tools_3 :=						"Vademecum"
tools_4 :=						"ICD-10"
;--Phonebook Tab------------------------------------------------------------
gui_groupbox_5 :=				"Phonebook"
phonebooklistviewcolumn_1 :=	"Name"
phonebooklistviewcolumn_2 :=	"Number/extension"
gui_button_10 :=				"Options"

;##About GUI##################################################################################################################################################
gui_text_2 :=					"Version:"
gui_text_3 :=					"Sistema experto para manejo de`nconsulta electrónica."
gui_text_4 :=					"Author:"
gui_button_11 :=				"Software and libraries"
gui_button_12 :=				"Software licenses"

;##Help Viewer GUI############################################################################################################################################
gui_windowtitle_1 :=			"User manual"

;##Quick Text GUI#############################################################################################################################################
gui_text_5 :=					"Escoja la plantilla a usar.`nPara cancelar presione ESC."
gui_windowtitle_2:=				"Lista de texto rápido"
errBox_2 :=						"Compruebe que el archivo no haya sido movido y que tenga permiso para acceder."

;##Settings GUI###############################################################################################################################################
gui_settings_tabs_1 :=          "Principal"
gui_settings_tabs_2 :=          "Interfaz"
gui_settings_groupbox_1 :=		"Datos del usuario"
gui_settings_text_1 :=			"Nombre"
gui_settings_text_2 :=			"Lugar de trabajo"
gui_settings_groupbox_2 := 		"Extensiones para medMACROS"
gui_settings_button_1 :=		"Cambiar extensión"
gui_settings_button_2 :=		"Desactivar"
gui_settings_groupbox_3 :=		"Diccionario de abreviaturas"
gui_settings_button_3 :=		"Cambiar diccionario"
gui_settings_groupbox_4 :=		"Contraseña medMACROS"
;--GUI Settings Tab----------------------------------------------------------
gui_settings_groupbox_5 :=		"Botón acceso rápido"
gui_settings_checkbox_1 :=		"Mostrar botón"
gui_settings_button_4 :=		"Elegir imagen..."
gui_settings_groupbox_6 :=		"Ventana y barra de tareas"
gui_settings_checkbox_2 :=		"Mostrar icono en la bandeja del sistema"
gui_settings_checkbox_3 :=		"Mostrar controles en ventana principal"
gui_settings_groupbox_7 :=		"Pestañas habilitadas"
gui_settings_checkbox_4 :=		"Password manager"
gui_settings_checkbox_5 :=		"Files guardados"
gui_settings_checkbox_6 :=		"Autocomplete"
gui_settings_checkbox_7 :=		"Notepad and tools"
gui_settings_checkbox_8 :=		"Phonebook telefónico"
gui_settings_groupbox_8 :=		"Idioma"
gui_settings_ddl_1 :=		    "Seleccione un idioma"
;--Plugin Tab---------------------------------------------------------------
gui_settings_button_5 :=		"Help"
gui_settings_button_6 :=		"Guardar"
gui_settings_button_7 :=		"Cancelar"
gui_windowtitle_3:=				"Settings"
gui_settings_button_8 :=		"Cambiar idioma"
;--LoadExtension------------------------------------------------------------
fileSelectDialog_1 :=			"Cargar extensión nueva"
fileSelectDialog_2 :=			"Extensión medMACROS"
;--LoadDictionary-----------------------------------------------------------
fileSelectDialog_3 :=			"Cargar diccionario"
fileSelectDialog_4 :=			"Diccionario medMACROS"
;--LoadLanguage-------------------------------------------------------------
fileSelectDialog_6 :=			"Cargar lenguaje"
fileSelectDialog_7 :=			"Archivo de lenguaje medMACROS"
;--CheckValidPlugin---------------------------------------------------------
errBox_3 :=						"Formato de extensión no válido, favor de verificar."
errBox_12 :=					"Seleccione un idioma de la lista."

;##New hotstring GUI##########################################################################################################################################
gui_hotstrings_text_1 :=		"Escriba la palabra o frase que quiere abreviar."
gui_hotstrings_text_2 :=		"Texto completo"
gui_hotstrings_text_3 :=		"Texto abreviado"
gui_hotstrings_button_1 :=		"Cancelar"
gui_hotstrings_button_2 :=		"Agregar nueva abreviatura..."
	
;--HotstringAppend:----------------------------------------------------------
errBox_4 :=						"No se pueden dejar campos en blanco, favor de verificar."
errBox_5 :=						"Agregando abreviatura, espere por favor."

;##New Password GUI###########################################################################################################################################
gui_passwords_text_1 :=			"Nombre"
gui_passwords_text_2 :=			"Usuario"
gui_passwords_text_3 :=			"Contraseña"
gui_passwords_text_4 :=			"Ubicación"
gui_passwords_button_1 :=		"Seleccionar"
gui_passwords_button_2 :=		"Cancelar"
gui_windowtitle_4 :=			"Contraseñas"
fileSelectDialog_4 :=			"Seleccione un archivo ejecutable..."

;##MAIN GUI SUBROUTINES#######################################################################################################################################
;==FIRST LAUNCH===============================================================================================================================================
infoBox_1 :=					"medMACROS — Instalación"
gui_text_6 :=					"¡Bienvenido a medMACROS!`n`nA continuación se mostrará la ventana de Settings.`nPara aprovechar al máximo todas las funciones que ofrece medMACROS, introduzca los datos requeridos en los campos.`n`nEn caso de dudas, presione el botón ayuda. En el manual de usuario se explica el propósito de cada función."

;==PASSWORD MANAGER===========================================================================================================================================
promptBox_1 :=					"Eliminar contraseña"
promptBox_2 :=					"Se eliminará"
promptBox_3 :=					", ¿Desea continuar?"
promptBox_4 :=					"Es necesario hacer una selección."

;==TREE VIEW==================================================================================================================================================
errBox_6 :=						"Error"
errBox_7 :=						"Error opening the file.`nPlease verify that the file exists and you have permission to open it."
errBox_8 :=						"Error"
errBox_9 :=						"This file is necessary for medMACROS to work, and shouldn't be deleted."
promptBox_5 :=					"Delete file"
promptBox_6 :=					"Do you wish to delete this file?"
fileSelectDialog_5 :=			"Select a file or executable for creating a new shortcut."
promptBox_6 :=					"medMACROS — Files"
promptBox_7 :=					"Write a new name."
errBox_10 :=					"Error"
errBox_11 :=					"Error renaming this file.`nPlease verify that no forbidden characters were used and that you have permission to change this file."
;==HOTSTRINGS=================================================================================================================================================
promptBox_8 :=					"Do you wish to erase this hotstring?"

;==PHONEBOOK=================================================================================================================================================
gui_windowtitle_5 :=			"Phonebook"
promptBox_9 :=					"Write a name for this contact"
promptBox_10 :=					"Phone number or extension"

;==WINDOW ACTIONS============================================================================================================================================
promptBox_11 :=					"Locked"
promptBox_12 :=					"Type your password"
promptBox_13 :=					"Incorrect password, please try again."