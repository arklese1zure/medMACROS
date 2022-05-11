/*
========================================================================

 				TreeView Browser (Only functions)

 Author:		Pulover [Rodolfo U. Batista]
				rodolfoub@gmail.com

 Requires CreateTreeView.ahk (Thanks Learning one for this function)
 http://www.autohotkey.com/board/topic/92863-function-createtreeview/

========================================================================
*/
CreateString(Folder, Call=0)
{
	global LoadIcons
	Call++
	Loop, %Folder%\*.*, 1
	{
			Icon := "`tIcon" GetIcon(A_LoopFileFullPath)
		If InStr(FileExist(A_LoopFileFullPath), "D")
		{
			Loop, %Call%
				String .= "`t"
			String .= A_LoopFileName . Icon "`n"
			String .= CreateString(A_LoopFileFullPath, Call)
		}
		Else
		{
			Loop, %Call%
				Files .= "`t"
			Files .= A_LoopFileName . Icon "`n"
		}
	}
	String .= Files
	Call--
	return String
}

GetIcon(FileName)
{
	global ImageListID

	sfi_size := A_PtrSize + 8 + (A_IsUnicode ? 680 : 340)
	VarSetCapacity(sfi, sfi_size)
	SplitPath, FileName,,, FileExt
	if FileExt in EXE,ICO,ANI,CUR
	{
		ExtID := FileExt
		IconNumber = 0
	}
	else
	{
		ExtID = 0
		Loop 7
		{
			StringMid, ExtChar, FileExt, A_Index, 1
			If not ExtChar
				break
			ExtID := ExtID | (Asc(ExtChar) << (8 * (A_Index - 1)))
		}
		IconNumber := IconArray%ExtID%
	}
	If not IconNumber
	{
		if not DllCall("Shell32\SHGetFileInfo" . (A_IsUnicode ? "W":"A"), "str",  "." FileExt
			, "uint", (FileExt ? 0x80 : 0), "ptr", &sfi, "uint", sfi_size, "uint", (FileExt ? 0x111 : 0x101))
			IconNumber = 9999999
		else
		{
			hIcon := NumGet(sfi, 0)
			IconNumber := DllCall("ImageList_ReplaceIcon", "ptr", ImageListID, "int", -1, "ptr", hIcon) + 1
			DllCall("DestroyIcon", "ptr", hIcon)
			IconArray%ExtID% := IconNumber
		}
	}
	return IconNumber
}