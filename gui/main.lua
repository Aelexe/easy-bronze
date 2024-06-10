local AceGUI = LibStub("AceGUI-3.0")

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

local currentTab = nil
local function selectTab(container, _, group)
	if currentTab ~= nil then
		currentTab.frame:Hide()
		currentTab.frame:SetParent(UIParent)
	end

	if group == "gems" then
		container:AddChild(EasyBronze.gui.gemTab)
	end
end

-- Queue Scrap Button
local button = AceGUI:Create("Button")
button:SetFullWidth(true)
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

window.frame:SetScript("OnUpdate", function(_, delta)
	EasyBronze:onUpdate(delta)
end)

EasyBronze.button = button
