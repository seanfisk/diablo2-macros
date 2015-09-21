#Include Common.ahk

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
