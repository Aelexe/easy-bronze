function MigrateDatabase(db)
	local profile = db.profile
	local version = profile.version
	if (version == nil) then
		version = 0
	end

	if (version < 1) then
		profile.gems = {
			stats = profile.gems,
			qualities = {}
		}

		for _, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
			profile.gems.qualities[gemQuality.id] = true
		end

		profile.version = 1
	end

	if (version < 2) then
		profile.minimap = {
			hide = false
		}

		profile.version = 2
	end

	if (version < 3) then
		profile.upgrades = {
			chat = true,
			sound = true
		}

		profile.version = 3
	end
end
