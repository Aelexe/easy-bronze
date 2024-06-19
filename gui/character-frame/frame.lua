local AceGUI = LibStub("AceGUI-3.0")

-- Window
local window = AceGUI:Create("Window")
window:SetTitle("Easy Bronze")
window:SetWidth(ScrappingMachineFrame:GetWidth())
window:SetHeight(CharacterFrame:GetHeight())
window:SetLayout("List")
window.sizer_s:Hide()
window.sizer_e:Hide()
window.sizer_se:Hide()
window.closebutton:ClearAllPoints()
window.closebutton:SetPoint("TOPRIGHT", window.frame, "TOPRIGHT", -3, -3)
window.frame:SetParent(CharacterFrame)
window:ClearAllPoints()
window:SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT", 0, 0)

local currentTab = nil
local function selectTab(container, _, group)
	if currentTab ~= nil then
		tremove(container.children, 1)
		currentTab.frame:SetParent(nil)
		currentTab.frame:Hide()
	end

	if group == "loot" then
		currentTab = EasyBronze.gui.lootTab
		container:AddChild(currentTab)
	elseif group == "upgrades" then
		currentTab = EasyBronze.gui.upgradesTab()
		container:AddChild(currentTab)
	end
end

local tabGroup = AceGUI:Create("TabGroup")
tabGroup:SetFullWidth(true)
tabGroup:SetLayout("Flow")
tabGroup:SetTabs({ { text = "Loot", value = "loot" }, { text = "Upgrades", value = "upgrades" } })
tabGroup:SetCallback("OnGroupSelected", selectTab)
tabGroup:SelectTab("loot")

window:AddChild(tabGroup)

CharacterFrame:HookScript("OnShow", function()
	window.frame:Show()
end)

window.frame:SetScript("OnShow", function()
	RegisterAttributeDriver(window.frame, "state-visibility", "[combat]hide;show")
end)

window.frame:SetScript("OnHide", function()
	UnregisterAttributeDriver(window.frame, "state-visibility")
end)
