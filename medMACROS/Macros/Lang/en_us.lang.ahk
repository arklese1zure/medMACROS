; MEDMACROS

;=============================================================================================================================================================
; MedMACROS translation file
; By Arklese1zure
;=============================================================================================================================================================

;==DIALOG BOXES========================================================================================================================================
errBox_1 :=						"Missing files were detected. `nPlease verify your medMACROS installation."
tabNames_1 :=                   "Password manager"
tabNames_2 :=                   "File manager"
tabNames_3 :=                   "Autocomplete"
tabNames_4 :=                   "Scratchpad and tools"
tabNames_5 :=                   "Phonebook"

;==MENUS======================================================================================================================================================
;==Main menu============================================================================
menu_filemenu_1 :=				"Keep above"
menu_filemenu_2 :=				"Prevent sleep"
menu_filemenu_3 :=				"Disable autocomplete"
menu_filemenu_4 :=				"Text editor"
menu_filemenu_5 :=				"Settings"
menu_filemenu_6 :=				"Lock MedMACROS"
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
menu_loginmenu_1 :=				"Delete"
menu_loginmenu_2 :=				"New login..."
;==File organizer menus=================================================================
menu_organizermenu_1 :=			"Open file"
menu_organizermenu_2 :=			"Delete file"
menu_organizermenu_3 :=			"Rename"
menu_organizeroptionsmenu_1 :=	"Open file in Windows Explorer"
menu_organizeroptionsmenu_2 :=	"New shortcut"
;==Phonebook menu=======================================================================
menu_phonebookmenu_1 :=			"Add"
menu_phonebookmenu_2 :=			"Delete"
;==Quick menu===========================================================================
menu_quickmenu_1 :=				"medMACROS"
menu_quickmenu_2 :=				"Keep above"
menu_quickmenu_3 :=				"Prevent sleep"
menu_quickmenu_4 :=				"Disable autocomplete"
menu_quickmenu_5 :=				"Text editor"
menu_quickmenu_6 :=				"Exit"
;==Tray menu============================================================================
menu_traymenu_1 :=				"medMACROS"
menu_traymenu_2 :=				"Keep above"
menu_traymenu_3 :=				"Prevent sleep"
menu_traymenu_4 :=				"Disable autocomplete"
menu_traymenu_5 :=				"Text editor"
menu_traymenu_6 :=				"Exit"

;==MAIN GUI===================================================================================================================================================
;--Passwords Tab------------------------------------------------------------
gui_groupbox_1 :=				"Password manager"
gui_button_1 :=					"Open"
gui_button_2 :=					"Login"
gui_button_3 :=					"Options"
;--Quick access Tab---------------------------------------------------------
gui_groupbox_2 :=				"Saved files"
gui_button_4 :=					"Refresh"
gui_button_5 :=					"Options"
;--Hotstrings Tab-----------------------------------------------------------
gui_groupbox_3 :=				"Autocomplete and autotext"
gui_button_6 :=					"Autotext templates"
gui_button_7 :=					"Options"
;--Scratchpad Tab-----------------------------------------------------------
gui_groupbox_4 :=				"Scratchpad and tools"
gui_button_8 :=					"Erase notes"
gui_button_9 :=					"Save notes"
gui_text_1 :=					"Tools:"
;--Scratchpad Tab-----------------------------------------------------------
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
gui_text_3 :=					"Assistant for writing to`nelectronic medical records."
gui_text_4 :=					"Author:"
gui_button_11 :=				"Software and libraries"
gui_button_12 :=				"Software licences"

;##Help Viewer GUI############################################################################################################################################
gui_windowtitle_1 :=			"User manual"

;##Quick Text GUI#############################################################################################################################################
gui_text_5 :=					"Choose a text template.`nPress ESC to cancel."
gui_windowtitle_2:=				"Autotext list"
errBox_2 :=						"Please verify that you have access to this file."

;##Settings GUI###############################################################################################################################################
gui_settings_groupbox_1 :=		"User information"
gui_settings_text_1 :=			"Name"
gui_settings_text_2 :=			"Work place"
gui_settings_groupbox_2 := 		"MedMACROS addons"
gui_settings_button_1 :=		"Switch addon"
gui_settings_button_2 :=		"Disable"
gui_settings_groupbox_3 :=		"Hotstring dictionary"
gui_settings_button_3 :=		"Switch dictionary"
gui_settings_groupbox_4 :=		"Password for locking"
;--GUI Settings Tab----------------------------------------------------------
gui_settings_groupbox_5 :=		"Quick access button"
gui_settings_checkbox_1 :=		"Show button"
gui_settings_button_4 :=		"Choose image..."
gui_settings_groupbox_6 :=		"Window and taskbar"
gui_settings_checkbox_2 :=		"Show icon in system tray"
gui_settings_checkbox_3 :=		"Show controls in main window"
gui_settings_groupbox_7 :=		"Enabled tabs"
gui_settings_checkbox_4 :=		"Password manager"
gui_settings_checkbox_5 :=		"Saved files"
gui_settings_checkbox_6 :=		"Hotstrings"
gui_settings_checkbox_7 :=		"Scratchpad and tools"
gui_settings_checkbox_8 :=		"Phonebook"
;--Plugin Tab---------------------------------------------------------------
gui_settings_button_5 :=		"Help"
gui_settings_button_6 :=		"Save"
gui_settings_button_7 :=		"Cancel"
gui_windowtitle_3:=				"Settings"
;--LoadExtension------------------------------------------------------------
fileSelectDialog_1 :=			"Load addon"
fileSelectDialog_2 :=			"medMACROS addon"
;--LoadDictionary-----------------------------------------------------------
fileSelectDialog_3 :=			"Load dictionary"
fileSelectDialog_4 :=			"medMACROS dictionary"
;--CheckValidPlugin---------------------------------------------------------
errBox_3 :=						"Invalid addon file."

;##New hotstring GUI##########################################################################################################################################
gui_hotstrings_text_1 :=		"Please input the word or sentence that will be shortened."
gui_hotstrings_text_2 :=		"Complete text"
gui_hotstrings_text_3 :=		"Abbreviated text (hotstring)"
gui_hotstrings_button_1 :=		"Cancel"
gui_hotstrings_button_2 :=		"Add new hotstring..."
	
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
gui_text_6 :=					"¡Bienvenido a medMACROS!`n`nA continuación se mostrará la ventana de Ajustes.`nPara aprovechar al máximo todas las funciones que ofrece medMACROS, introduzca los datos requeridos en los campos.`n`nEn caso de dudas, presione el botón ayuda. En el manual de usuario se explica el propósito de cada función."

;==PASSWORD MANAGER===========================================================================================================================================
promptBox_1 :=					"Eliminar contraseña"
promptBox_2 :=					"Se eliminará"
promptBox_3 :=					", ¿Desea continuar?"
promptBox_4 :=					"Es necesario hacer una selección."

;==TREE VIEW==================================================================================================================================================
errBox_6 :=						"Error"
errBox_7 :=						"No se pudo abrir el archivo.`nCompruebe que no haya sido movido y que tenga permiso para acceder."
errBox_8 :=						"Error"
errBox_9 :=						"Elemento necesario para funcionamiento de medMACROS, no se puede eliminar."
promptBox_5 :=					"Eliminar archivo"
promptBox_6 :=					"¿Desea eliminar el archivo seleccionado?"
fileSelectDialog_5 :=			"Seleccione un archivo para crear un acceso directo."
promptBox_6 :=					"medMACROS — Archivos"
promptBox_7 :=					"Escriba nombre nuevo."
errBox_10 :=					"Error"
errBox_11 :=					"Error al cambiar nombre de archivo.`nCompruebe que no utilizó caracteres no permitidos."
;==HOTSTRINGS=================================================================================================================================================
promptBox_8 :=					"¿Desea eliminar la siguiente abreviatura?"

;==PHONEBOOK=================================================================================================================================================
gui_windowtitle_5 :=			"Directorio"
promptBox_9 :=					"Escriba nombre del contacto"
promptBox_10 :=					"Escriba teléfono del contacto"

;==WINDOW ACTIONS============================================================================================================================================
promptBox_11 :=					"Bloqueado"
promptBox_12 :=					"Escriba contraseña para desbloquear"
promptBox_13 :=					"Contraseña incorrecta."