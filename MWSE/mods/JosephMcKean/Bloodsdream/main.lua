---@diagnostic disable: deprecated
local mod = "JosephMcKean.Bloodsdream"
local config = require("JosephMcKean.Bloodsdream.config")
local data = require("JosephMcKean.Bloodsdream.data")
local DynamicTimescale = include("DynamicTimescale.interop")

local log = require("logging.logger").new({ name = "Bloodsdream", logLevel = "DEBUG" })

local isTrappedInDreamWorld = data.isTrappedInDreamWorld

--- Even the Dark Brotherhood can't invade the realm of Vaermina.
---@param e cellChangedEventData
local function stopDarkBrotherhoodAttackScript(e)
	if isTrappedInDreamWorld[e.cell and e.cell.id:lower()] then
		if mwscript.scriptRunning({ script = tes3.getScript("dbattackScript") }) then
			tes3.runLegacyScript({ command = "stopScript dbattackScript" })
		end
	elseif isTrappedInDreamWorld[e.previousCell and e.previousCell.id:lower()] then
		if not mwscript.scriptRunning({ script = tes3.getScript("dbattackScript") }) then
			tes3.runLegacyScript({ command = "startScript dbattackScript" })
		end
	end
end

local isUsingBed

---@param e uiShowRestMenuEventData
event.register("uiShowRestMenu", function(e)
	isUsingBed = e.scripted
end)

-- Unfortunately, you can't just set up camp in the realm of Vaermina.
---@param e uiActivatedEventData
local function thereAreNoTents(e)
	if isTrappedInDreamWorld[tes3.player.cell and tes3.player.cell.id:lower()] then
		if config.modDifficulty > 0 then
			local menuRestWait = e.element
			if not isUsingBed then
				menuRestWait:findChild("MenuRestWait_label_text").visible = false
			end
			local restButton = menuRestWait:findChild("MenuRestWait_rest_button")
			restButton:register("mouseClick", function()
				tes3.worldController.menuClickSound:play()
				tes3.closeRestMenu()
				tes3.fadeOut({ duration = 0.5 })
				tes3.advanceTime({ hours = 1 / 6 })
				tes3.fadeIn({ duration = 1.5 })
				timer.start({
					type = timer.real,
					duration = 2,
					callback = function()
						tes3.messageBox({ message = "You can't seem to sleep, like, at all." })
					end,
				})
			end)
		end
	end
end

-- Time in Vaermina's realm keeps moving while irl, Time Stands Still (or very close to it). 
---@param e cellChangedEventData
local function yearInsideHourOutside(e)
	-- If the player is in Vaermina's realm
	if isTrappedInDreamWorld[e.cell and e.cell.id:lower()] then
		if DynamicTimescale then
			DynamicTimescale.blocks[mod] = true
		end
		tes3.player.data.Bloodsdream.outsideTimescale = tes3.findGlobal("Timescale").value
		tes3.findGlobal("Timescale").value = data.insideTimescale
	elseif isTrappedInDreamWorld[e.previousCell and e.previousCell.id:lower()] then
		if DynamicTimescale then
			DynamicTimescale.blocks[mod] = false
		end
		tes3.findGlobal("Timescale").value = tes3.player.data.Bloodsdream.outsideTimescale
	end
end

local function onInit()
	if tes3.isModActive("Bloodsdream.esp") then
		event.register("loaded", function()
			tes3.player.data.Bloodsdream = tes3.player.data.Bloodsdream or {}
		end)
		-- timescale changes
		event.register("cellChanged", yearInsideHourOutside, { priority = -246 })
		-- weather changes
		dofile("JosephMcKean.Bloodsdream.weather")
		-- resting changes
		event.register("cellChanged", stopDarkBrotherhoodAttackScript, { priority = -246 })
		event.register("uiActivated", thereAreNoTents, { filter = "MenuRestWait", priority = -246 })
		-- Cave Behind the Rocks
		dofile("JosephMcKean.Bloodsdream.CaveBehindtheRocks")
	end
end
event.register("initialized", onInit, { priority = -246 })

dofile("JosephMcKean.Bloodsdream.mcm")
