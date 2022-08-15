;
;											=========================================================================
;											|||||						medMACROS Launcher						|||||
;											=========================================================================

;==COMPILER DIRECTIVES========================================================================================================================================

;==STARTUP CONDITIONS=========================================================================================================================================
#SingleInstance, Force
#NoTrayIcon
SetWorkingDir A_ScriptDir

;==VERIFY FILES===============================================================================================================================================
mainScriptWorkingDir := A_WorkingDir . "\Macros\"
mainScript := mainScriptWorkingDir . "Main.ahk"

SetWorkingDir %mainScriptWorkingDir%
ahkExecutable := mainScriptWorkingDir . "AutoHotkeyU64.exe"

;Check if AHK portable is present, otherwise run with installed AHK
if FileExist(ahkExecutable)
{
	Run, %ahkExecutable% %mainScript%,, UseErrorLevel
		if ErrorLevel
			{
			MsgBox, 16, MedMACROS, Unable to run main program.`nPlease install AutoHotKey or place the portable executable in the "Macros" folder and rename it to "AutoHotKey".
			ExitApp
			}
	ExitApp
}
else
    Run, %mainScript%
ExitApp