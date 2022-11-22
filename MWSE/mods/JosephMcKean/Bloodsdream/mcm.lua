local configPath = "Bloodsdream"
local config = require("JosephMcKean.Bloodsdream.config")
local function registerModConfig()
	local template = mwse.mcm.createTemplate {
		name = "Bloodsdream",
		headerImagePath = "textures\\jo\\banner_bloodsdream.dds",
	}
	template:register()
	template.onClose = function()
		mwse.saveConfig(configPath, config)
	end
	local preferences = template:createSideBarPage{ label = "Mod Preferences", noScroll = true }
	preferences:createSlider{
		label = "Mod Difficulty",
		description = "- Mod difficulty determines how easy or hard to pass attribute/skill/disposition checks throughout the mod, such as in conversations, unknown item identification, and opening doors. In hard difficulty, the attribute/skill/disposition checks can be as high as 100/45/100." ..
		"\n" .. "\n" ..
		"In addition, this mod bundles with a few gameplay changes (while the character is in specific cells) that some gamers might not want in their game. See below for more details." ..
		"\n" .. "\n" .. "0: Easy" .. "\n" .. "\n" .. "1 (Default): Normal" .. "\n" .. "  - Restricted resting" .. "\n" .. "\n" ..
		"2: Hard" .. "\n" .. "  - Restricted resting",
		min = 0,
		max = 2,
		step = 1,
		jump = 1,
		variable = mwse.mcm.createTableVariable { id = "modDifficulty", table = config },
	}
	preferences:createSlider{
		label = "Combat Difficulty",
		description = "Combat difficulty determines the number of enemies that spawn in encounters, attribute and skill value of the enemies." ..
		"\n" .. "\n" .. "0 (Default): Easy" .. "\n" .. "\n" .. "1: Normal" .. "\n" .. "\n" .. "2: Hard",
		min = 0,
		max = 2,
		step = 1,
		jump = 1,
		variable = mwse.mcm.createTableVariable { id = "combatDifficulty", table = config },
	}
end
event.register("modConfigReady", registerModConfig)
