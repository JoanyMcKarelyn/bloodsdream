local data = require("JosephMcKean.Bloodsdream.data")
local log = require("logging.logger").new({ name = "Bloodsdream", logLevel = "DEBUG" })

local isTrappedInDreamWorld = data.isTrappedInDreamWorld
local previousCell

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
	vectorTable2TableTable(weather, data.weatherColors)
	data.normalCloudTexture = weather.cloudTexture
end
event.register("loaded", getWeatherColors, { priority = -246 })

local function alienSky()
	local weatherController = tes3.worldController.weatherController
	local weather = weatherController.weathers[6]
	local cell = tes3.player.cell
	if isTrappedInDreamWorld[cell and cell.id:lower()] then
		-- weather colors and cloud texture
		tableTable2VectorTable(data.alienColors, weather)
		weather.cloudTexture = data.alienCloudTexture
		log:debug("weather.cloudTexture = %s", data.alienCloudTexture)
		-- switch weather to thunderstorm and block any weather transition
		weatherController:switchImmediate(weather.index)
		weatherController:updateVisuals()
		previousCell = cell
	elseif isTrappedInDreamWorld[previousCell and previousCell.id:lower()] then
		tableTable2VectorTable(data.weatherColors, weather)
		weather.cloudTexture = data.normalCloudTexture
		weatherController:switchImmediate(weather.index)
		weatherController:updateVisuals()
		previousCell = cell
	end
end

event.register("cellChanged", alienSky, { priority = -246 })
event.register("weatherChangedImmediate", alienSky, { priority = -246 })
event.register("weatherTransitionStarted", alienSky, { priority = -246 })
event.register("weatherTransitionFinished", alienSky, { priority = -246 })
