;
;											=========================================================================
;											|||||						medMACROS Launcher						|||||
;											=========================================================================
;
;==STARTUP CONDITIONS=========================================================================================================================================
#SingleInstance, Force
#NoTrayIcon
SetWorkingDir A_ScriptDir

;==VERIFY FILES===============================================================================================================================================
mainScriptWorkingDir := A_WorkingDir . "\Macros\"
mainScript := mainScriptWorkingDir . "Main.ahk"

newExecutable := A_WorkingDir . "\MedMACROS.exe"

SetWorkingDir %mainScriptWorkingDir%
executableFile := mainScriptWorkingDir . "AutoHotkeyU64.exe"



;==MAIN GUI===================================================================================================================================================
Run, %executableFile% %mainScript%
;Run, %newExecutable% /script /ErrorStdOut %mainScript%

ExitApp