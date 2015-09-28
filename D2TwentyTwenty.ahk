#Include Common.ahk

Hotkey, IfWinActive, % Diablo2.HotkeyCondition

Hotkey, % Diablo2.Controls["Show Items"], ShowItemsWithTelekinesis
ShowItemsWithTelekinesis() {
	global Diablo2

	; This is so that Show Items can be assigned a hotkey that is or is
	; not its Diablo II key.
	ThisHotkey := A_ThisHotkey

	ShowItemsKey := Diablo2.Controls["Show Items"]
	ShowItemsSendKey := Diablo2_HotkeySyntaxToSendSyntax(ShowItemsKey)

	Diablo2_Send(Format("{{}{} Down{}}", ShowItemsSendKey))
	OldSkill := Diablo2_SkillGet()
	Diablo2_SkillActivate("n")

	KeyWait, %ThisHotkey%
	Diablo2_Send(Format("{{}{} Up{}}", ShowItemsSendKey))
	Diablo2_SkillActivate(OldSkill)
}

; One-off skills
SetupOneOff() {
	global Diablo2
	; Teleport, Shiver Armor, Static Field, Town Portal
	for _, SkillNum in [5, 6, 8, 12] {
		Key := Diablo2.Controls.Skills[SkillNum]
		Function := Func("Diablo2_SkillOneOff").Bind(Key)
		; Note: Overrides hotkey created Diablo2_Init
		Hotkey, %Key%, %Function%
	}
}
SetupOneOff()
