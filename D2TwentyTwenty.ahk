#Include Common.ahk

class Telekinesis extends Diablo2._EnabledFeature {
	static _GoldVacuumHotkey := "MButton"

	__New() {
		this._ShowItemsHotkey := Diablo2.GetControl("Show Items")
		this._ShowItemsSendKey := Diablo2.GetControl("Show Items", true)
		; Assign this just in case we want our "Show Items with Telekinesis" hotkey to be different from
		; our "Show Items" key (right now it's the same).
		Diablo2.Assign(this._ShowItemsHotkey, ObjBindMethod(this, "_ShowItems"))

		; Note: This hotkey only works in fullscreen, because the needle image was created from a full
		; screen screenshot.
		; XXX Add something to the library so that we don't have to manual wrap with _CatchExceptions.
		Function := ObjBindMethod(Diablo2, "_CatchExceptions"
			, ObjBindMethod(Diablo2, "TakeScreenshot"
				, ObjBindMethod(this, "_GoldVacuum")))
		HCC := new Diablo2._HotkeyConditionContext()
		Hotkey, % this._GoldVacuumHotkey, %Function%, Off
		this._NeedleBitmap := Diablo2.SafeCreateBitmapFromFile(A_WorkingDir . "\Images\Fullscreen\Gold.png")
	}

	__Delete() {
		; XXX: We don't know if this will be called before or after FillPotion's Gdip_Shutdown().
		Gdip_DisposeImage(this._NeedleBitmap)
	}

	g_ShowItems() {
		; This is so that Show Items can be assigned a hotkey that is or is not its Diablo II key.
		ThisHotkey := A_ThisHotkey

		; Send Show Items and switch to Telekinesis.
		Diablo2.Send(Format("{{}{} Down{}}", this._ShowItemsSendKey))
		OldSkill := Diablo2.Skills.Get()
		Diablo2.Skills.Activate("n")

		; Enable GoldVacuum hotkey.
		HCC := new Diablo2._HotkeyConditionContext()
		Hotkey, % this._GoldVacuumHotkey, On

		; Wait for the key to be physically released (default).
		KeyWait, %ThisHotkey%
		Diablo2.Send(Format("{{}{} Up{}}", this._ShowItemsSendKey))
		Diablo2.Skills.Activate(OldSkill)

		; Disable GoldVacuum hotkey.
		Hotkey, % this._GoldVacuumHotkey, Off
	}

	g_GoldVacuum(HaystackPath) {
		HaystackBitmap := ""
		try {
			HaystackBitmap := Diablo2.SafeCreateBitmapFromFile(HaystackPath)
			NumGoldFound := Gdip_ImageSearch(HaystackBitmap
				, this._NeedleBitmap
				, CoordsListString
				, 0, 0
				, 800, 600
				; XXX: Private setting stolen from FillPotion
				, Diablo2.FillPotion._Variation
				; These two blank parameters are transparency color and search direction.
				, ,
				; Find all instances.
				, 0)

			; Anything less than 0 indicates an error.
			if (NumGoldFound < 0) {
				Diablo2._Throw("Gdip_ImageSearch call failed with error code " . NumGoldFound)
			}

			MPRestore := new Diablo2._MousePosRestore()
			for _, CoordsString in StrSplit(CoordsListString, "`n") {
				; Using GetKeyState here assumes this._ShowItemsHotkey is just one key.
				;
				; Get the physical state of the key. If the Show Items key is also the hotkey, the logical
				; state will always be down because ShowItems() is waiting for it to be physically released to
				; logically release it.
				if (!GetKeyState(this._ShowItemsHotkey, "P")) {
					; Stop vacuuming if the ShowItemsHotkey is up.
					break
				}
				Coords := StrSplit(CoordsString, "`,")
				; The coordinates returned are the top left of the image. The "G" in GOLD will be near the
				; horizontal center of the item, but the vertical middle is a little farther down.
				MouseMove, Coords[1], Coords[2] + 7
				; Sleeping after moving but before clicking increases the chances of the macro successfully
				; picking up the item, especially on the last item for some reason.
				Sleep, 50
				Click, Right
				; This will work most of the time at 400, but add a little just to ensure reliability.
				Sleep, 450
			}
		}
		finally {
			if (HaystackBitmap) {
				Gdip_DisposeImage(HaystackBitmap)
			}
			; Remove the screen shot regardless.
			FileDelete, %HaystackPath%
		}
	}
}

_Telekinesis := new Telekinesis()

; One-off skills
SetupOneOff() {
	; Teleport, Frozen Armor, Static Field, Town Portal
	for _, SkillNum in [5, 8, 10, 12] {
		Key := Diablo2.Controls.Skills[SkillNum]
		; Note: Overrides hotkey created by Diablo2.Init
		Diablo2.Assign(Key, {Function: "Skills.OneOff", Args: [Key]})
	}
}
SetupOneOff()
