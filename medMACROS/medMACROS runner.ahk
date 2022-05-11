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
mainScript := mainScriptWorkingDir . "miniMACROS.ahk"
SetWorkingDir %mainScriptWorkingDir%
executableFile := mainScriptWorkingDir . "AutoHotkeyU64.exe"

;==MAIN GUI===================================================================================================================================================
Run, %executableFile% %mainScript%
ExitApp