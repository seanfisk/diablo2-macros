; Recommended for performance and compatibility with future AutoHotkey releases.
#NoEnv
; Replace an old instance of the macros with a new one.
#SingleInstance Force
; Don't warn; libraries we include have too many errors :|
; Allow AutoHotkey to find the config files in this directory.
SetWorkingDir %A_ScriptDir%
; Works great with Diablo II.
SendMode, Input

LogPath := Format("{}\{}", A_WorkingDir, StrReplace(A_ScriptName, ".ahk", "Log.txt"))
Diablo2_Init("Controls.json"
	, StrReplace(A_ScriptName, ".ahk", "Skills.json")
	, "FillPotion.json"
	, LogPath
	; Enable voice alerts
	, true)

Hotkey, IfWinActive, % Diablo2.HotkeyCondition

; Specify using Hotkey command instead of usual syntax so that
; the files which include this can have their code run too.

Hotkey, ^!a, Diablo2_ConfigureControls
Hotkey, ^!b, Diablo2_FillPotionGenerateBitmaps
Hotkey, ^!r, Diablo2_Reset
Hotkey, h, Diablo2_FillPotion

; Assign overlay to Alt+F12. Ctrl+MiddleClick or ExtraButtonOne opens and closes it.
Hotkey, ^MButton, SteamOverlayToggle
Hotkey, XButton1, SteamOverlayToggle
SteamOverlayToggle() {
	; The Steam overlay does not respond well to SendInput.
	SendEvent, "!{F12}"
}

Hotkey, ^!w, SteamOverlayOpenTabs
SteamOverlayOpenTabs() {
	global LogPath

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
	TabUrls.Push("file:///" . LogPath)

	; Place the mouse over the URL bar.
	MouseGetPos, MouseX, MouseY

	; Use SendEvent to enable delays.
	SendMode, Event
	OldDelay := A_KeyDelay

	Suspend, On
	for _, TabUrl in TabUrls {
		; Change the key press delay for keystrokes using SendEvent because
		; the Steam overlay is laggy in detecting them. Without this, keys
		; will be dropped.
		SetKeyDelay, 0, 100
		Send, ^t

		; Click where the user had the mouse
		Click, %MouseX%, %MouseY%
		Sleep, 100
		SetKeyDelay, 0, 1
		SendRaw, %TabUrl%
		Send, % "{Enter}"
		Sleep, 100 ; Let the tab load a bit
	}
	Suspend, Off

	; Set to original delay and default press duration of -1.
	SetKeyDelay, %OldDelay%, -1
}

; The game won't let me assign ` as a key. Just assign to F10 then
; remap here.
Hotkey, ``, SendBacktick
SendBacktick() {
	Send, ``
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

Hotkey, IfWinActive

Hotkey, ^!s, SuspendMacros
SuspendMacros() {
	Suspend
}
Hotkey, ^!x, ExitMacros
ExitMacros() {
	Suspend, Permit
	ExitApp
}
