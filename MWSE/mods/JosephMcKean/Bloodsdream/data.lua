local this = {}

this.texturesPath = "textures\\jsmk\\bd\\"
this.headerImagePath = this.texturesPath .. "banner_bloodsdream.dds"
this.alienCloudTexture = this.texturesPath .. "sky_vaermina1.dds"

this.insideTimescale = 1 / 3
this.isTrappedInDreamWorld = { ["adanja's dream, pelagiad"] = true, ["shrine of vaermina"] = true }

this.skyColor = { 0.368, 0.313, 0.410 }
this.fogColor = { 0.190, 0.092, 0.195 }
this.ambientColor = { 0.135, 0.097, 0.238 }
this.sunColor = { 0.266, 0.280, 0.334 }
this.sundiscSunsetColor = { 0.501, 0.501, 0.501 }
this.alienColors = {
	skySunriseColor = this.skyColor,
	skyDayColor = this.skyColor,
	skySunsetColor = this.skyColor,
	skyNightColor = this.skyColor,
	fogSunriseColor = this.fogColor,
	fogDayColor = this.fogColor,
	fogSunsetColor = this.fogColor,
	fogNightColor = this.fogColor,
	ambientSunriseColor = this.ambientColor,
	ambientDayColor = this.ambientColor,
	ambientSunsetColor = this.ambientColor,
	ambientNightColor = this.ambientColor,
	sunSunriseColor = this.sunColor,
	sunDayColor = this.sunColor,
	sunSunsetColor = this.sunColor,
	sunNightColor = this.sunColor,
	sundiscSunsetColor = this.sundiscSunsetColor,
}
this.weatherColors = {
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
this.normalCloudTexture = ""

this.strangeSecretRockID = "jsmk_terrian_rock_ai"
this.strangeSecretDoorID = "jsmk_cave_entrance"

return this
