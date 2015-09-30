#Include Common.ahk

Hotkey, IfWinActive, % Diablo2.HotkeyCondition

Hotkey, % Diablo2.Controls["Show Items"], ShowItemsWithTelekinesis
ShowItemsWithTelekinesis() {
	; This is so that Show Items can be assigned a hotkey that is or is
	; not its Diablo II key.
	ThisHotkey := A_ThisHotkey

	ShowItemsKey := Diablo2.Controls["Show Items"]
	ShowItemsSendKey := Diablo2.HotkeySyntaxToSendSyntax(ShowItemsKey)

	Diablo2.Send(Format("{{}{} Down{}}", ShowItemsSendKey))
	OldSkill := Diablo2.Skills.Get()
	Diablo2.Skills.Activate("n")

	KeyWait, %ThisHotkey%
	Diablo2.Send(Format("{{}{} Up{}}", ShowItemsSendKey))
	Diablo2.Skills.Activate(OldSkill)
}

; One-off skills
SetupOneOff() {
	; Teleport, Shiver Armor, Static Field, Town Portal
	for _, SkillNum in [5, 6, 8, 12] {
		Key := Diablo2.Controls.Skills[SkillNum]
		; Note: Overrides hotkey created by Diablo2.Init
		Diablo2.Assign(Key, {Function: "Skills.OneOff", Args: [Key]})
	}
}
SetupOneOff()
