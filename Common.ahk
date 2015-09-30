; Replace an old instance of the macros with a new one.
#SingleInstance Force
; Don't warn; libraries we include have too many errors :|
; Allow AutoHotkey to find the config files in this directory.
SetWorkingDir %A_ScriptDir%

#Include <Diablo2>

GetTabUrls() {
	TabUrls := []
	; Can't use brace on same line with this Loop
	Loop, Files, Characters\*.html, F
	{
		TabUrls.Push("file:///" . A_LoopFileLongPath) ; Always yields absolute path
	}
	for _, WikiPage in ["Horadric_Cube_Recipes", "Rune_Words"] {
		TabUrls.Push(Format("http://diablo.gamepedia.com/{}_%28Diablo_II%29", WikiPage))
	}
	for _, DocID in ["1kSOhKy2va5T77qo9MGpDfZIRiWX0Yd7S_ML5wO3Saz8"
	, "1cd5toYNZCAPvMdCj2fFu32GnjWCkxGqHMdy7HzPcO5k"] {
		TabUrls.Push(Format("https://docs.google.com/document/d/{}/edit", DocID))
	}
	; TODO: Show the log. Can't use Diablo2.Log.Path right here because
	; it's not set.
	return TabUrls
}

Diablo2.Init("Controls.json"
	, {Skills: StrReplace(A_ScriptName, ".ahk", "Skills.json")
		, FillPotion: {Fullscreen: true}
		, Log: {}
		, Voice: {}
		, MassItem: {}
		, Steam: {OverlayKey: "!{F12}", BrowserTabUrls: GetTabUrls()}})

; Specify using Hotkey command instead of usual syntax so that
; the files which include this can have their code run too.

Diablo2.AssignMultiple({"^!a": "Controls.AutoAssign"
	, "^!b": "FillPotion.GenerateBitmaps"
	, "^!r": "Reset"
	, "^!t": "Status"
	, "h": "FillPotion.Activate"
	, "RButton": "RightClick"
	, "F1": "MassItem.SelectStart"
	, "F2": "MassItem.SelectEnd"
	, "F3": "MassItem.Drop"
	, "F4": "MassItem.MoveSingleCellItems"
	, "^!w": "Steam.BrowserOpenTabs"
	, "^MButton": "Steam.OverlayToggle"
	, "XButton1": "Steam.OverlayToggle"
	; The game won't let me assign ` as a key. Just assign to F10 then remap here.
	, "``": {Function: "Send", Args: ["{F10}"]}})

Diablo2.AssignMultiple({"^!s": "Suspend"
	, "^!x": "Exit"
	; Launch the game (no Steam)
	, "^!k": "LaunchGame"
	; Launch the game through Steam
	, "^!l": {Function: "Steam.LaunchGame", Args: ["steam://rungameid/15078221207973134336"]}}, false)
