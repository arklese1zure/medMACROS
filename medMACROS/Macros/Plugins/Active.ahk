; MEDMACROS
;=============================================================================================================================================================
; Extensión para MediMacros
; Plantilla para crear extensiones
;=============================================================================================================================================================

;##ESTRUCTURA DE LAS EXTENSIONES PARA MEDIMACROS##############################################################################################################
; El formato de las extensiones para mediMACROS es simplemente un script de AutoHotkey con algunas subrutinas predeterminadas que el script principal
; usa para agregar funcionalidad en el lugar correcto. Todas las subrutinas que estén en la plantilla para extensiones deben estar presentes aunque
; no se vayan a usar en la extensión que se esté creando.
; Si no se requiere alguna subrutina, se debe dejar el nombre y el elemento "return", de modo que el script continúe con su estructura.
;#############################################################################################################################################################

PluginLoadOptions: ;==Variables para configurar mediMACROS====================================================================================================
	plugin_Name :=					"Placeholder"					; Nombre de la extensión, no debe usar caracteres especiales.
	plugin_Version :=				""								; Versión de la extensión.
	plugin_Author :=				""								; Autor de la extensión.
	plugin_TabEnabled :=			FALSE							; Mostrar pestaña para elementos gráficos.
	plugin_TabName :=				""								; Nombre de la pestaña.
	TE_AddonButtonEnabled :=		FALSE							; Mostrar botón de función especial en el editor de consulta mediMACROS.
	TE_AddonButtonText :=			""								; Texto del botón.
	plugin_MenuEnabled :=			FALSE							; Mostrar menú.
	plugin_QuickMenuEnabled := 		FALSE							; Mostrar entrada en menú rápido.
	plugin_MenuName :=				""								; Nombre del menú.
	plugin_SettingsTabEnabled :=	FALSE							; Habilitar cuadro en dialogo de opciones
return	;-------------------------------------------------------------------------------

;==Funciones - Leer ajustes y archivos========================================================================================================================
PluginReadSettings:
return	;-------------------------------------------------------------------------------

;==Funciones - Menús==========================================================================================================================================
; Aquí se agregan menús que se quieran agregar para realizar funciones.
PluginLoadMenus:
;==Main menu============================================================================
	Menu, PluginMenu, Add, %plugin_Name%, MenuHandler
	Menu, PluginMenu, Disable, 1&
return	;-------------------------------------------------------------------------------
;==Quick menu addon=====================================================================
; Si se requiere agregar apartados extra al menú rápido, aquí se ponen. Se debe agregar una entrada para el menú del botón (quickmenu)
; y una entrada para el menú de la bandeja del sistema (tray), ya que se manejan por separado.
PluginQuickMenu:
return	;-------------------------------------------------------------------------------


;==Funciones - Editor de texto================================================================================================================================
; La acción que ejecutará el botón especial del editor de texto mediMACROS.
PluginTextEdit:

return	;-------------------------------------------------------------------------------
	
;==Funciones - Invocar ventana================================================================================================================================
; Esta es una acción que se activa cada vez que se llame la ventana mediMACROS con CTRL+F1.
PluginSummonAction:

return	;-------------------------------------------------------------------------------

;==Funciones - Opciones=======================================================================================================================================
; Contenido de la pestaña extensión en el diálogo de opciones y la subrutina para escribir las opciones en el archivo de configuración.
PluginSettings:

return	;-------------------------------------------------------------------------------

PluginSaveSettings:																		; Save settings.

return	;-------------------------------------------------------------------------------

;==Funciones - Pestaña========================================================================================================================================
; Aquí se agrega el contenido que se desee mostrar en una pestaña en mediMACROS, así como funciones y subrutinas que desee que se realicen.
PluginTab:
Gui, Add, GroupBox,		x2 y+2 w281 h47, Sample

return	;-------------------------------------------------------------------------------

;==Funciones - Hotkeys========================================================================================================================================
; Las teclas F5 a F8 están disponibles para usarlas en extensiones
^F5::

	return
	
^F6::

	return

;==Funciones - Subrutinas=====================================================================================================================================
; Aquí van todas las subrutinas que se deseen agregar además de las que se incluyen en la plantilla.

return	;-------------------------------------------------------------------------------