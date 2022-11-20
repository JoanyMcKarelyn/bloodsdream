local mod = "JosephMcKean.Bloodsdream"
local log = require("logging.logger").new({ name = "Bloodsdream", logLevel = "DEBUG" })

local insideTimescale = 1 / 3
local isTrappedInDreamWorld = { ["adanja's dream, pelagiad"] = true, ["shrine of vaermina"] = true }

local skyColor = { 0.368, 0.313, 0.410 }
local fogColor = { 0.190, 0.092, 0.195 }
local ambientColor = { 0.135, 0.097, 0.238 }
local sunColor = { 0.266, 0.280, 0.334 }
local sundiscSunsetColor = { 0.501, 0.501, 0.501 }
local alienColors = {
	skySunriseColor = skyColor,
	skyDayColor = skyColor,
	skySunsetColor = skyColor,
	skyNightColor = skyColor,
	fogSunriseColor = fogColor,
	fogDayColor = fogColor,
	fogSunsetColor = fogColor,
	fogNightColor = fogColor,
	ambientSunriseColor = ambientColor,
	ambientDayColor = ambientColor,
	ambientSunsetColor = ambientColor,
	ambientNightColor = ambientColor,
	sunSunriseColor = sunColor,
	sunDayColor = sunColor,
	sunSunsetColor = sunColor,
	sunNightColor = sunColor,
	sundiscSunsetColor = sundiscSunsetColor,
}
local weatherColors = {
	skySunriseColor = {},
	skyDayColor = {},
	skySunsetColor = {},
	skyNightColor = {},
	fogSunriseColor = {},
	fogDayColor = {},
	fogSunsetColor = {},
	fogNightColor = {},
	ambientSunriseColor = {},
	ambientDayColor = {},
	ambientSunsetColor = {},
	ambientNightColor = {},
	sunSunriseColor = {},
	sunDayColor = {},
	sunSunsetColor = {},
	sunNightColor = {},
	sundiscSunsetColor = {},
}
local cloudTx

---@param vectorTable table
---@param tableTable table
local function vectorTable2TableTable(vectorTable, tableTable)
	-- Turns tes3vectors to 1x3 table. The first parameter is the output table, the second parameter is the input vector. 
	---@param vector tes3vector3
	---@param table table
	local function vector2Table(table, vector)
		table[1] = vector.r
		table[2] = vector.g
		table[3] = vector.b
	end
	vector2Table(tableTable.skySunriseColor, vectorTable.skySunriseColor)
	vector2Table(tableTable.skyDayColor, vectorTable.skyDayColor)
	vector2Table(tableTable.skySunsetColor, vectorTable.skySunsetColor)
	vector2Table(tableTable.skyNightColor, vectorTable.skyNightColor)
	vector2Table(tableTable.fogSunriseColor, vectorTable.fogSunriseColor)
	vector2Table(tableTable.fogDayColor, vectorTable.fogDayColor)
	vector2Table(tableTable.fogSunsetColor, vectorTable.fogSunsetColor)
	vector2Table(tableTable.fogNightColor, vectorTable.fogNightColor)
	vector2Table(tableTable.ambientSunriseColor, vectorTable.ambientSunriseColor)
	vector2Table(tableTable.ambientDayColor, vectorTable.ambientDayColor)
	vector2Table(tableTable.ambientSunsetColor, vectorTable.ambientSunsetColor)
	vector2Table(tableTable.ambientNightColor, vectorTable.ambientNightColor)
	vector2Table(tableTable.sunSunriseColor, vectorTable.sunSunriseColor)
	vector2Table(tableTable.sunDayColor, vectorTable.sunDayColor)
	vector2Table(tableTable.sunSunsetColor, vectorTable.sunSunsetColor)
	vector2Table(tableTable.sunNightColor, vectorTable.sunNightColor)
	vector2Table(tableTable.sundiscSunsetColor, vectorTable.sundiscSunsetColor)
end

---@param vectorTable table
---@param tableTable table
local function tableTable2VectorTable(tableTable, vectorTable)
	-- Turns 1x3 table to tes3vectors. The first parameter is the input table, the second parameter is the output vector. 
	---@param vector tes3vector3
	---@param table table
	local function table2Vector(table, vector)
		vector.r = table[1]
		vector.g = table[2]
		vector.b = table[3]
	end
	table2Vector(tableTable.skySunriseColor, vectorTable.skySunriseColor)
	table2Vector(tableTable.skyDayColor, vectorTable.skyDayColor)
	table2Vector(tableTable.skySunsetColor, vectorTable.skySunsetColor)
	table2Vector(tableTable.skyNightColor, vectorTable.skyNightColor)
	table2Vector(tableTable.fogSunriseColor, vectorTable.fogSunriseColor)
	table2Vector(tableTable.fogDayColor, vectorTable.fogDayColor)
	table2Vector(tableTable.fogSunsetColor, vectorTable.fogSunsetColor)
	table2Vector(tableTable.fogNightColor, vectorTable.fogNightColor)
	table2Vector(tableTable.ambientSunriseColor, vectorTable.ambientSunriseColor)
	table2Vector(tableTable.ambientDayColor, vectorTable.ambientDayColor)
	table2Vector(tableTable.ambientSunsetColor, vectorTable.ambientSunsetColor)
	table2Vector(tableTable.ambientNightColor, vectorTable.ambientNightColor)
	table2Vector(tableTable.sunSunriseColor, vectorTable.sunSunriseColor)
	table2Vector(tableTable.sunDayColor, vectorTable.sunDayColor)
	table2Vector(tableTable.sunSunsetColor, vectorTable.sunSunsetColor)
	table2Vector(tableTable.sunNightColor, vectorTable.sunNightColor)
	table2Vector(tableTable.sundiscSunsetColor, vectorTable.sundiscSunsetColor)
end

local function getWeatherColors()
	local weatherController = tes3.worldController.weatherController
	local weather = weatherController.weathers[6]
	vectorTable2TableTable(weather, weatherColors)
	cloudTx = weather.cloudTexture
end

---@param e cellChangedEventData
local function alienSky(e)
	local weatherController = tes3.worldController.weatherController
	local weather = weatherController.weathers[6]
	if isTrappedInDreamWorld[e.cell and e.cell.id:lower()] then
		tableTable2VectorTable(alienColors, weather)
		weather.cloudTexture = "Textures\\jo\\sky_vaermina_01.dds"
		weatherController:switchImmediate(weather.index)
		weatherController:updateVisuals()
	elseif isTrappedInDreamWorld[e.previousCell and e.previousCell.id:lower()] then
		tableTable2VectorTable(weatherColors, weather)
		weather.cloudTexture = cloudTx
	end
end

-- Time in Vaermina's realm keeps moving while irl, Time Stands Still (or very close to it). 
---@param e cellChangedEventData
local function yearInsideHourOutside(e)
	-- If the player is in Vaermina's realm
	if isTrappedInDreamWorld[e.cell and e.cell.id:lower()] then
		include("DynamicTimescale.interop").blocks[mod] = true
		tes3.player.data.Bloodsdream.outsideTimescale = tes3.findGlobal("Timescale").value
		tes3.findGlobal("Timescale").value = insideTimescale
	elseif isTrappedInDreamWorld[e.previousCell and e.previousCell.id:lower()] then
		include("DynamicTimescale.interop").blocks[mod] = false
		tes3.findGlobal("Timescale").value = tes3.player.data.Bloodsdream.outsideTimescale
	end
end

local function onInit()
	event.register("loaded", function()
		tes3.player.data.Bloodsdream = tes3.player.data.Bloodsdream or {}
	end)
	event.register("cellChanged", yearInsideHourOutside)
	event.register("loaded", getWeatherColors, { priority = -73 })
	event.register("cellChanged", alienSky)
end
event.register("initialized", onInit)

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
-- event.register("simulate", yearInsideHourOutside, {priority = -73})
