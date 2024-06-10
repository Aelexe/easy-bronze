local AceGUI = LibStub("AceGUI-3.0")

EasyBronze.gemCheckBoxes = {}

-- Window
local window = AceGUI:Create("Window")
window:SetWidth(ScrappingMachineFrame:GetWidth())
window:SetHeight(ScrappingMachineFrame:GetHeight())
window:SetLayout("List")
window.frame:SetParent(ScrappingMachineFrame)
window.frame:SetFrameLevel(ScrappingMachineFrame:GetFrameLevel() - 1)

local verticalOffset = 32
if C_AddOns.IsAddOnLoaded("ElvUI") then
	verticalOffset = 0
end

window:SetPoint('TOP', ScrappingMachineFrame, 'BOTTOM', 0, verticalOffset)
window.sizer_se:Hide()
window.closebutton:Hide()

local function drawGemTab(container)
	local gemScroller = AceGUI:Create("ScrollFrame")
	gemScroller:SetLayout("Flow")
	gemScroller:SetFullWidth(true)
	gemScroller:SetFullHeight(true)
	gemScroller:SetHeight(160)
	container:AddChild(gemScroller)

	for _, gemType in ipairs(EasyBronze.GEM_TYPES) do
		local checkbox = AceGUI:Create("CheckBox")
		checkbox:SetLabel(gemType.name)
		if EasyBronze.db ~= nil then
			checkbox:SetValue(EasyBronze.db.profile.gems[gemType.id])
		end
		checkbox:SetCallback("OnValueChanged", function(_, _, value)
			EasyBronze.db.profile.gems[gemType.id] = value
		end)
		gemScroller:AddChild(checkbox)
		EasyBronze.gemCheckBoxes[gemType.id] = checkbox
	end
end

local function selectTab(container, _, group)
	container:ReleaseChildren()
	if group == "gems" then
		drawGemTab(container)
	end
end

-- Queue Scrap Button
local button = AceGUI:Create("Button")
button:SetText("Queue Scrap")
button:SetCallback("OnClick", function()
	EasyBronze:loadScrapper()
end)
window:AddChild(button)

local tabGroup = AceGUI:Create("TabGroup")
tabGroup:SetFullWidth(true)
tabGroup:SetLayout("Flow")
tabGroup:SetTabs({ { text = "Gems", value = "gems" } })
tabGroup:SetCallback("OnGroupSelected", selectTab)
tabGroup:SelectTab("gems")
window:AddChild(tabGroup)

window.frame:SetScript("OnShow", function()
	for _, gemType in ipairs(EasyBronze.GEM_TYPES) do
		if (EasyBronze.gemCheckBoxes[gemType.id] ~= nil) then
			EasyBronze.gemCheckBoxes[gemType.id]:SetValue(EasyBronze.db.profile.gems[gemType.id])
		end
	end
end)

window.frame:SetScript("OnUpdate", function(_, delta)
	EasyBronze:onUpdate(delta)
end)

EasyBronze.button = button
