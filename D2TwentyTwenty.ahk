#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory. Necessary for the Diablo2 library to find the Config.json file.
CoordMode, Mouse, Window

; Initialize
StringReplace, SkillWeaponSetJSONFile, A_ScriptName, .ahk, Skills.json
Diablo2_Init("CommonKeys.json", SkillWeaponSetJSONFile)

; Functions
SteamOverlayOpenTabs() {
	TabUrls := ["file:///C:/Users/Sean/games/d2/Javazon%20Build%20by%20lMarcusl.html"
		, "file:///C:/Users/Sean/games/d2/MeteOrb%20Sorceress%20by%20Lethal%20Weapon.html"
		, "https://docs.google.com/document/d/1kSOhKy2va5T77qo9MGpDfZIRiWX0Yd7S_ML5wO3Saz8/edit"
		, "https://docs.google.com/document/d/1cd5toYNZCAPvMdCj2fFu32GnjWCkxGqHMdy7HzPcO5k/edit"
		, "http://diablo.gamepedia.com/Horadric_Cube_Recipes_%28Diablo_II%29"
		, "http://diablo.gamepedia.com/Rune_Words_%28Diablo_II%29"]
	Suspend, On
	for TabUrlIndex, TabUrl in TabUrls {
		; Change the key press delay for this keystroke. This is crucial to getting this keystroke detected.
		SetKeyDelay, 0, 100
		SendEvent, ^t
		
		; Set delays, which give the overlay time to react. 0 sets the smallest possible delay, which is different than no delay (set by -1).
		; These only work for SendEvent, which we subsequently use.
		SetKeyDelay, 0, 0
		
		; Click in the approximate place for the default positioning of the right side of the URL bar.
		Click, 690, 90
		Sleep, 100
		
		SendEvent, {Raw}%TabUrl%
		SendEvent, {Enter}
		Sleep, 100
	}
	Suspend, Off
}

RemoteFreezeFire() {
	; Teleport in, frost nova, then set to teleport out
	Global Diablo2
	
	Suspend, On
	
	TeleportKey := Diablo2.KeysConfig.Skills[5]
	; Teleport
	Send, %TeleportKey%{Click Right}
	Sleep, 500
	
	; Frost Nova
	Send, % Diablo2.KeysConfig.Skills[6] "{Click Right}"
	Sleep, 500
	
	; Fire Wall just above character
	MouseGetPos, OldMouseX, OldMouseY
	MouseMove, 400, 270 ; Try to center just above the character
	Sleep, 100
	Send, % Diablo2.KeysConfig.Skills[3] "{Click Right}"
	
	; Return mouse to original position
	MouseMove, %OldMouseX%, %OldMouseY%
	
	; Switch skill to Teleport, so we can get out of there.
	Send, %TeleportKey%
	
	Suspend, Off
}

#IfWinActive ahk_class Diablo II

^!a::Diablo2_SetKeyBindings()

; Overlay
; Assign overlay to Alt+F12. Ctrl+MiddleClick or ExtraButtonOne opens and closes it.
^MButton::
XButton1::
Send, !{F12}
return

; Open web browser tabs
^!w::SteamOverlayOpenTabs()

; Combat
MButton::RemoteFreezeFire()

#IfWinActive

^!s::Suspend
^!x::ExitApp