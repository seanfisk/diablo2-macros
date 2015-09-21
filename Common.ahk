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
	, LogPath)

SteamOverlayOpenTabs() {
	TabUrls := ["file:///C:/Users/Sean/games/d2/Javazon%20Build%20by%20lMarcusl.html"
		, "file:///C:/Users/Sean/games/d2/MeteOrb%20Sorceress%20by%20Lethal%20Weapon.html"
		, "https://docs.google.com/document/d/1kSOhKy2va5T77qo9MGpDfZIRiWX0Yd7S_ML5wO3Saz8/edit"
		, "https://docs.google.com/document/d/1cd5toYNZCAPvMdCj2fFu32GnjWCkxGqHMdy7HzPcO5k/edit"
		, "http://diablo.gamepedia.com/Horadric_Cube_Recipes_%28Diablo_II%29"
		, "http://diablo.gamepedia.com/Rune_Words_%28Diablo_II%29"
		, "C:\Users\Sean\src\personal\diablo2-macros\Log.txt"]
	; Place the mouse over the URL bar.
	MouseGetPos, MouseX, MouseY
	Suspend, On
	for TabUrlIndex, TabUrl in TabUrls {
		; Change the key press delay for this keystroke. This is crucial to getting this keystroke detected.
		SetKeyDelay, 0, 100
		SendEvent, ^t

		; Set delays, which give the overlay time to react. 0 sets the smallest possible delay, which is different than no delay (set by -1).
		; These only work for SendEvent, which we subsequently use.
		SetKeyDelay, 0, 0

		; Click in the approximate place for the default positioning of the right side of the URL bar.
		Click, %MouseX%, %MouseY%
		Sleep, 100

		SendEvent, {Raw}%TabUrl%
		Sleep, 10000
		SendEvent, {Enter}
	}
	Suspend, Off
}

#IfWinActive ahk_class Diablo II

^!a::Diablo2_ConfigureControls()
^!b::Diablo2_FillPotionGenerateBitmaps()
^!r::Diablo2_Reset()
h::Diablo2_FillPotion()

; Assign overlay to Alt+F12. Ctrl+MiddleClick or ExtraButtonOne opens and closes it.
^MButton::
XButton1::
Diablo2_Send("!{F12}")
return

^!w::SteamOverlayOpenTabs()

; The game won't let me assign ` as a key. Just assign to F10 then remap here.
`::F10

{::--Diablo2.FillPotion.FullscreenPotionsPerScreenshot
}::++Diablo2.FillPotion.FullscreenPotionsPerScreenshot

#IfWinActive

^!s::Suspend
^!x::ExitApp
