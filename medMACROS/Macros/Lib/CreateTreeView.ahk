CreateTreeView(TreeViewDefinitionString) {	; by Learning one
	IDs := {} 
	Loop, parse, TreeViewDefinitionString, `n, `r
	{
		if A_LoopField is space
			continue
		Item := RTrim(A_LoopField, A_Space A_Tab), Item := LTrim(Item, A_Space), Level := 0
		While (SubStr(Item,1,1) = A_Tab)
			Level += 1,	Item := SubStr(Item, 2)
		RegExMatch(Item, "([^`t]*)([`t]*)([^`t]*)", match)	; match1 = ItemName, match3 = Options
		if (Level=0)
			IDs["Level0"] := TV_Add(match1, 0, match3)
		else
			IDs["Level" Level] := TV_Add(match1, IDs["Level" Level-1], match3)
	}
}	; http://www.autohotkey.com/board/topic/92863-function-createtreeview/