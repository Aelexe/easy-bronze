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
end
