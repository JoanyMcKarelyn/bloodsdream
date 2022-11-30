local config = require("JosephMcKean.Bloodsdream.config")
local data = require("JosephMcKean.Bloodsdream.data")

local log = require("logging.logger").new({ name = "Bloodsdream", logLevel = "DEBUG" })

local function difficultyLevelsButtonsCallback(e)
	tes3.player.data.Bloodsdream.difficultyLevelsAsked = true
	if e.button == 1 then -- "Leave"
		return false
	end
end

--- @param e activateEventData
local function difficultyLevels(e)
	if e.activator == tes3.player and e.target and e.target.object and e.target.object.id == data.strangeSecretDoorID then
		log:debug("Player activated strange secret door.")
		if not tes3.player.data.Bloodsdream.difficultyLevelsAsked then
			log:debug("Player has not activated strange secret door before.")
			-- if tes3.player.object.level >= 15 and config.combatDifficulty == 0 then
			tes3.messageBox({
				message = "Your character is considered high level for the content in Bloodsdream." .. "\n" ..
				"If you would like, you could adjust the mod difficulty and combat difficulty in the mod config menu." .. "\n" ..
				"The rewards will be the same regardless of the difficulty you choose.",
				buttons = { "Enter the tunnel", "Leave" },
				showInDialog = false,
				callback = difficultyLevelsButtonsCallback,
			})
			-- end
		end
	end
end
event.register("activate", difficultyLevels)

--- @param e projectileHitObjectEventData
local function strangeSecretEntrance(e)
	log:debug("Projectile hits object.")
	if e.target and e.target.object and e.target.object.id ~= data.strangeSecretRockID then
		log:debug("Projectile hits strange secret rock.")
		local trueSight
		local effects = e.mobile.spellInstance and e.mobile.spellInstance.sourceEffects
		if effects then
			for _, effect in pairs(effects) do
				if effect.object.id == tes3.effect.dispel then
					log:debug("Dispel spell hits strange secret rock.")
					trueSight = true
				end
			end
		end
		if trueSight then
			e.target:disable()
			timer.delayOneFrame(function()
				e.target.deleted = true
			end, timer.simulate)
		end
	end
end
event.register("projectileHitObject", strangeSecretEntrance)
