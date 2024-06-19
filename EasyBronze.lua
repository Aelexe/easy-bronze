C_AddOns.LoadAddOn("Blizzard_ScrappingMachineUI")

EasyBronze = LibStub("AceAddon-3.0"):NewAddon("Easy Bronze", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

EasyBronze.gui = {}

function EasyBronze:OnInitialize()
	-- Database Setup
	local default = {
		version = 3,
		gems = {
			stats = {},
			qualities = {}
		},
		upgrades = {
			chat = true,
			sound = true
		}
	}

	for _, gemStat in ipairs(EasyBronze.GEM_STATS) do
		default.gems.stats[gemStat.id] = false
	end

	for _, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
		default.gems.stats[gemQuality.id] = true
	end

	self.db = LibStub("AceDB-3.0"):New("EasyBronzeDB", { profile = default }, true)

	MigrateDatabase(self.db)
end
