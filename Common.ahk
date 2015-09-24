; Replace an old instance of the macros with a new one.
#SingleInstance Force
; Don't warn; libraries we include have too many errors :|
; Allow AutoHotkey to find the config files in this directory.
SetWorkingDir %A_ScriptDir%

#Include <Diablo2>

Diablo2_Init("Controls.json"
	, StrReplace(A_ScriptName, ".ahk", "Skills.json")
	, "FillPotion.json"
	, Format("{}\{}", A_WorkingDir, StrReplace(A_ScriptName, ".ahk", "Log.txt"))
	; Enable voice alerts
	, true)

Hotkey, IfWinActive, % Diablo2.HotkeyCondition

; Specify using Hotkey command instead of usual syntax so that
; the files which include this can have their code run too.

Hotkey, RButton, Diablo2_RightClick

Hotkey, ^!a, Diablo2_ConfigureControls
Hotkey, ^!b, Diablo2_FillPotionGenerateBitmaps
Hotkey, ^!r, Diablo2_Reset
Hotkey, h, Diablo2_FillPotion

; Assign overlay to Alt+F12. Ctrl+MiddleClick or ExtraButtonOne opens and closes it.
Hotkey, ^MButton, SteamOverlayToggle
Hotkey, XButton1, SteamOverlayToggle
SteamOverlayToggle() {
	Diablo2_Send("!{F12}")
}

Hotkey, ^!w, SteamOverlayOpenTabs
SteamOverlayOpenTabs() {
	global Diablo2

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
	TabUrls.Push("file:///" . Diablo2.Log.Path)

	; Place the mouse over the URL bar.
	MouseGetPos, MouseX, MouseY

	Suspend, On
	for _, TabUrl in TabUrls {
		; Use SendEvent to enable delays. Change the key press delay for
		; keystrokes using SendEvent because the Steam overlay is laggy in
		; detecting them. Without this, keys will be dropped.
		;
		; This sets the key delay only for this thread, so we don't need
		; to worry about setting it back.
		SetKeyDelay, 0, 100
		SendEvent, ^t

		; Click where the user had the mouse
		Click, %MouseX%, %MouseY%
		Sleep, 100
		SetKeyDelay, 0, 1
		SendEvent, {Raw}%TabUrl%
		SendEvent, {Enter}
		Sleep, 100 ; Let the tab load a bit
	}
	Suspend, Off
}

; The game won't let me assign ` as a key. Just assign to F10 then
; remap here.
Hotkey, ``, SendBacktick
SendBacktick() {
	Diablo2_Send("``")
}

Hotkey, {, FillPotionDecrement
FillPotionDecrement() {
	global Diablo2
	--Diablo2.FillPotion.FullscreenPotionsPerScreenshot
}
Hotkey, }, FillPotionIncrement
FillPotionIncrement() {
		global Diablo2
		++Diablo2.FillPotion.FullscreenPotionsPerScreenshot
}

SetupMassItem() {
	for Index, FuncName in ["SelectStart", "SelectEnd", "Drop", "MoveSingleCellItems"] {
		Hotkey, F%Index%, Diablo2_MassItem%FuncName%
	}
}
SetupMassItem()

Hotkey, IfWinActive

Hotkey, ^!s, Diablo2_Suspend
Hotkey, ^!x, Diablo2_Exit
