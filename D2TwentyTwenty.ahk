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
	Diablo2_SkillActivate("t")

	KeyWait, %ThisHotkey%
	Diablo2_Send(Format("{{}{} Up{}}", ShowItemsSendKey))
	Diablo2_SkillActivate(OldSkill)
}
