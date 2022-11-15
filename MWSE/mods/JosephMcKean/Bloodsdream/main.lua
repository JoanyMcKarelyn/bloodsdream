local mod = "JosephMcKean.Bloodsdream"
local log = require("logging.logger").new({
    name = "Bloodsdream",
    logLevel = "DEBUG"
})

local insideTimescale = 1 / 3
local isTrappedInDreamWorld = {["adanja's dream, pelagiad"] = true}

--[[
-- Time in Vaermina's realm keeps moving while irl, Time Stands Still (or very close to it). Temporary workaround for Dynamic Timescale
---@param e simulateEventData
local function yearInsideHourOutside(e)
    -- If the player is in Vaermina's realm
    if isTrappedInDreamWorld[tes3.player.cell.id:lower()] then
        tes3.findGlobal("Timescale").value = insideTimescale
        log:debug("Vaermina's realm operates on a timescale of %s.",
                  tes3.findGlobal("Timescale").value)
    end
end]]

-- Time in Vaermina's realm keeps moving while irl, Time Stands Still (or very close to it). 
---@param e cellChangedEventData
local function yearInsideHourOutside(e)
    -- If the player is in Vaermina's realm
    if isTrappedInDreamWorld[e.cell and e.cell.id:lower()] then
        include("DynamicTimescale.interop").blocks[mod] = true
        tes3.player.data.Bloodsdream.outsideTimescale = tes3.findGlobal(
                                                            "Timescale").value
        tes3.findGlobal("Timescale").value = insideTimescale
    elseif isTrappedInDreamWorld[e.previousCell and e.previousCell.id:lower()] then
        include("DynamicTimescale.interop").blocks[mod] = false
        tes3.findGlobal("Timescale").value =
            tes3.player.data.Bloodsdream.outsideTimescale
    end
end

local function onInit()
    event.register("loaded", function()
        tes3.player.data.Bloodsdream = tes3.player.data.Bloodsdream or {}
    end)
    -- event.register("simulate", yearInsideHourOutside, {priority = -73})
    event.register("cellChanged", yearInsideHourOutside)
end
event.register("initialized", onInit)
