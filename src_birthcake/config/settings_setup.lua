--luacheck: no max line length
local Mod = BirthcakeRebaked
local SettingsHelper = BirthcakeRebaked.SettingsHelper

SettingsHelper.AddChoiceSetting("Settings", Mod.Setting.TaintedName,
	"The display name of Tainted characters display when picking up Birthcake", {
		"Default name",
		"\"Tainted\" prefix",
		"Title",
	}, 2)
