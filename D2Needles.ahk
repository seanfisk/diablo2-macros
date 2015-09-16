#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory. Necessary for the Diablo2 library to find the Config.json file.

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

#IfWinActive

^!s::Suspend
^!x::ExitApp
