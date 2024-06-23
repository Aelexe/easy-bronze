EasyBronze.apis.player = {
	getPlayerLevel = function()
		return UnitLevel("player")
	end,
	getPlayerClass = function()
		local _, playerClass = UnitClass("player")
		return playerClass
	end,
	getPlayerArmorType = function()
		local playerClass = EasyBronze.apis.player.getPlayerClass()

		if playerClass == "MAGE" or playerClass == "PRIEST" or playerClass == "WARLOCK" then
			return "CLOTH"
		elseif playerClass == "DEMONHUNTER" or playerClass == "DRUID" or playerClass == "MONK" or playerClass == "ROGUE" then
			return "LEATHER"
		elseif playerClass == "EVOKER" or playerClass == "HUNTER" or playerClass == "SHAMAN" then
			return "MAIL"
		elseif playerClass == "DEATHKNIGHT" or playerClass == "PALADIN" or playerClass == "WARRIOR" then
			return "PLATE"
		end
	end,
	isTimeRunner = function()
		return PlayerGetTimerunningSeasonID and PlayerGetTimerunningSeasonID() ~= nil
	end
}
