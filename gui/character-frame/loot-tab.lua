tinsert(EasyBronze.inits, function()
	local AceGUI = LibStub("AceGUI-3.0")

	local function addLabel(text, parent)
		local label = AceGUI:Create("Label")
		label:SetText(text)
		label:SetFullWidth(true)
		label:SetFontObject(GameFontNormal)
		parent:AddChild(label)
		return label
	end

	local function addSpacer(parent)
		local spacer = AceGUI:Create("Label")
		spacer:SetText(" ")
		spacer:SetFontObject(GameFontNormal)
		parent:AddChild(spacer)
	end

	local function addSpacers(count, parent)
		for i = 1, count do
			addSpacer(parent)
		end
	end

	local lootTab = AceGUI:Create("ScrollFrame")
	lootTab:SetFullWidth(true)
	lootTab:SetHeight(200)

	-- Caches
	local label = addLabel("Caches", lootTab)
	addSpacers(5, lootTab)

	local cacheButton = EasyBronze.CreateItemButton(EasyBronze.CACHE.id)
	cacheButton:SetParent(lootTab.content)
	cacheButton:SetPoint('TOPLEFT', label.frame, "BOTTOMLEFT", 0, -5)

	-- Spools
	local label = addLabel("Threads", lootTab)
	addSpacers(5, lootTab)

	local lastButton = nil
	for _, spool in ipairs(EasyBronze.SPOOLS) do
		local button = EasyBronze.CreateItemButton(spool.id)
		button:SetParent(lootTab.content)

		if lastButton == nil then
			button:SetPoint('TOPLEFT', label.frame, "BOTTOMLEFT", 0, -5)
		else
			button:SetPoint('TOPLEFT', lastButton, "TOPRIGHT", 5, 0)
		end

		lastButton = button
	end

	-- Bronze Caches
	local label = addLabel("Bronze", lootTab)
	addSpacers(3, lootTab)

	local lastButton = nil
	for _, cache in ipairs(EasyBronze.BRONZE_CACHES) do
		local button = EasyBronze.CreateItemButton(cache.id)
		button:SetParent(lootTab.content)

		if lastButton == nil then
			button:SetPoint('TOPLEFT', label.frame, "BOTTOMLEFT", 0, -5)
		else
			button:SetPoint('TOPLEFT', lastButton, "TOPRIGHT", 5, 0)
		end

		lastButton = button
	end

	EasyBronze.gui.lootTab = lootTab;
end)
