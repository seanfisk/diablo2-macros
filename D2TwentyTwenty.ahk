#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory. Necessary for the Diablo2 library to find the Config.json file.
CoordMode, Mouse, Window

StringReplace, SkillWeaponSetJSONFile, A_ScriptName, .ahk, Skills.json
Diablo2_Init("CommonKeys.json", SkillWeaponSetJSONFile)

#IfWinActive ahk_class Diablo II

^!a::Diablo2_SetKeyBindings()

; Overlay
; Assign overlay to Alt+F12. Ctrl+MiddleClick or ExtraButtonOne opens and closes it.
^MButton::
XButton1::
Send !{F12}
return

; Combat

; Teleport in, frost nova, then set to teleport out
RemoteFreezeFire() {
	Global Diablo2
	
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
}

MButton::RemoteFreezeFire()

#IfWinActive

^!s::Suspend
^!x::ExitApp