;
;									=========================================================================
;									|||||					medMACROS - Installer						|||||
;									=========================================================================
;

;==STARTUP CONDITIONS=========================================================================================================================================
#SingleInstance, Force
#NoEnv
StringCaseSense, On

FileSelectFolder, selectedInstallFolder , , 0, Seleccione la carpeta donde se instalará medMACROS.
	if selectedInstallFolder =
	{
		Exitapp
		return
	}
	
FileCreateDir, %selectedInstallFolder%\medMACROS
FileCreateDir, %selectedInstallFolder%\medMACROS\Archivos
FileCreateDir, %selectedInstallFolder%\medMACROS\Archivos\Accesos directos
FileCreateDir, %selectedInstallFolder%\medMACROS\Macros
FileCreateDir, %selectedInstallFolder%\medMACROS\Archivos\Autotexto
FileCreateDir, %selectedInstallFolder%\medMACROS\Macros\Settings
FileCreateDir, %selectedInstallFolder%\medMACROS\Macros\Userdata

FileCopyDir, %A_WorkingDir%\Macros\Buttons\, %selectedInstallFolder%\medMACROS\Macros\Buttons\
FileCopyDir, %A_WorkingDir%\Macros\Dictionaries\, %selectedInstallFolder%\medMACROS\Macros\Dictionaries\
FileCopyDir, %A_WorkingDir%\Macros\Docs\, %selectedInstallFolder%\medMACROS\Macros\Docs\
FileCopyDir, %A_WorkingDir%\Macros\Icons\, %selectedInstallFolder%\medMACROS\Macros\Icons\
FileCopyDir, %A_WorkingDir%\Macros\Lib\, %selectedInstallFolder%\medMACROS\Macros\Lib\
FileCopyDir, %A_WorkingDir%\Macros\Plugins\, %selectedInstallFolder%\medMACROS\Macros\Plugins\

FileCopy,  %A_WorkingDir%\Macros\AutoHotkeyU64.exe, %selectedInstallFolder%\medMACROS\Macros\*.*, 1
FileCopy,  %A_WorkingDir%\Macros\miniMACROS.ahk, %selectedInstallFolder%\medMACROS\Macros\*.*, 1
FileCopy,  %A_WorkingDir%\Macros\programlogo.png, %selectedInstallFolder%\medMACROS\Macros\*.* , 1
FileCopy,  %A_WorkingDir%\medMACROS.exe, %selectedInstallFolder%\medMACROS\*.* , 1
Sleep 100

FileAppend, Para agregar autotexto en esta sección`, cree un nuevo archivo de texto y a continuación escriba lo que quiera. ,%selectedInstallFolder%\medMACROS\Archivos\Autotexto\Muestra.txt
FileAppend, En esta sección puede hacer anotaciones rápidas, se guarda automáticamente al salir o al presionar el botón guardar. ,%selectedInstallFolder%\medMACROS\Userdata\ScratchPad.txt
FileAppend, ,%selectedInstallFolder%\medMACROS\Macros\Userdata\Logindata.csv
FileAppend, , %selectedInstallFolder%\medMACROS\Macros\Userdata\UserData.ini
FileAppend, , %selectedInstallFolder%\medMACROS\Macros\Settings\Settings.ini

Sleep 100
IniWrite, Invitado, %selectedInstallFolder%\medMACROS\Macros\Userdata\UserData.ini, usuario, settings_userName
IniWrite, Clínica sin nombre, %selectedInstallFolder%\medMACROS\Macros\Userdata\UserData.ini, usuario, clinica
IniWrite, 1, %selectedInstallFolder%\medMACROS\Macros\Settings\Settings.ini, buttonsettings, enabled
IniWrite, android.png, %selectedInstallFolder%\medMACROS\Macros\Settings\Settings.ini, buttonsettings, buttonFile
IniWrite, 123, %selectedInstallFolder%\medMACROS\Macros\Settings\Settings.ini, safety, unlockpassword
IniWrite, TRUE, %selectedInstallFolder%\medMACROS\Macros\Settings\Settings.ini, firstlaunch, firstlaunch
Sleep 100

SetWorkingDir, %selectedInstallFolder%\medMACROS
MsgBox, 4, Instalación medMACROS, Instalación exitosa, se recomienda abrir la sección de ajustes en medMACROS para introducir sus datos y personalizar el programa.`nDesea abrir medMACROS ahora?
	IfMsgBox, Yes
		Run, medMACROS.exe
	ExitApp
		