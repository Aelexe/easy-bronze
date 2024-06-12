local AceGUI = LibStub("AceGUI-3.0")

local gemStatCheckBoxes = {}
local gemQualityCheckBoxes = {}

local gemTab = AceGUI:Create("ScrollFrame")

gemTab:SetLayout("Flow")
gemTab:SetFullWidth(true)
gemTab:SetHeight(160)

local statLabel = AceGUI:Create("Label")
statLabel:SetText("Stat")
statLabel:SetFullWidth(true)
statLabel:SetFontObject(GameFontNormalLarge)
gemTab:AddChild(statLabel)

for _, gemStat in ipairs(EasyBronze.GEM_STATS) do
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetLabel(gemStat.name)
	checkbox:SetWidth(100)

	if EasyBronze.db ~= nil then
		checkbox:SetValue(EasyBronze.db.profile.gems.stats[gemStat.id])
	end
	checkbox:SetCallback("OnValueChanged", function(_, _, value)
		EasyBronze.db.profile.gems.stats[gemStat.id] = value
	end)
	gemTab:AddChild(checkbox)

	gemStatCheckBoxes[gemStat.id] = checkbox
end

-- TODO: Find a better way to do this.
local spacer = AceGUI:Create("Label")
spacer:SetText(" ")
spacer:SetFullWidth(true)
gemTab:AddChild(spacer)

local qualityLabel = AceGUI:Create("Label")
qualityLabel:SetText("Quality")
qualityLabel:SetFullWidth(true)
qualityLabel:SetFontObject(GameFontNormalLarge)
gemTab:AddChild(qualityLabel)

for _, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetLabel(gemQuality.name)
	checkbox:SetWidth(100)

	if EasyBronze.db ~= nil then
		checkbox:SetValue(EasyBronze.db.profile.gems.qualities[gemQuality.id])
	end
	checkbox:SetCallback("OnValueChanged", function(_, _, value)
		EasyBronze.db.profile.gems.qualities[gemQuality.id] = value
	end)
	gemTab:AddChild(checkbox)

	gemQualityCheckBoxes[gemQuality.id] = checkbox
end

gemTab.frame:SetScript("OnShow", function()
	for _, gemStat in ipairs(EasyBronze.GEM_STATS) do
		if (gemStatCheckBoxes[gemStat.id] ~= nil) then
			gemStatCheckBoxes[gemStat.id]:SetValue(EasyBronze.db.profile.gems.stats[gemStat.id])
		end
	end

	for _, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
		if (gemQualityCheckBoxes[gemQuality.id] ~= nil) then
			gemQualityCheckBoxes[gemQuality.id]:SetValue(EasyBronze.db.profile.gems.qualities[gemQuality.id])
		end
	end
end)

EasyBronze.gui.gemTab = gemTab;
