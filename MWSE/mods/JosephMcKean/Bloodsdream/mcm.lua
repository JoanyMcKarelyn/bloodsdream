local configPath = "Bloodsdream"
local config = require("JosephMcKean.Bloodsdream.config")
local data = require("JosephMcKean.Bloodsdream.data")

local function registerModConfig()
	local template = mwse.mcm.createTemplate { name = "Bloodsdream", headerImagePath = data.headerImagePath }
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
		"\n" .. "\n" .. "0: Easier Than Standard" .. "\n" .. "\n" .. "1 (Default): Standard" .. "\n" ..
		"  - Restricted resting" .. "\n" .. "\n" .. "2: Harder Than Standard" .. "\n" .. "  - Restricted resting",
		min = 0,
		max = 2,
		step = 1,
		jump = 1,
		variable = mwse.mcm.createTableVariable { id = "modDifficulty", table = config },
	}
	preferences:createSlider{
		label = "Combat Difficulty",
		description = "CHANGES WILL ONLY APPLY TO NEWLY ENEMIES. Combat difficulty determines the number of enemies that spawn in encounters, attribute and skill value of the enemies." ..
		"\n" .. "\n" .. "0 (Default): Standard" .. "\n" .. "\n" .. "1: Harder Than Standard" .. "\n" .. "\n" ..
		"2: Harder Than Harder Than Standard",
		min = 0,
		max = 2,
		step = 1,
		jump = 1,
		variable = mwse.mcm.createTableVariable { id = "combatDifficulty", table = config },
	}
end
event.register("modConfigReady", registerModConfig)
