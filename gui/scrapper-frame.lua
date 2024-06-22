C_AddOns.LoadAddOn("Blizzard_ScrappingMachineUI")

local AceGUI = LibStub("AceGUI-3.0")

-- Window
local window = AceGUI:Create("Window")
window:SetWidth(ScrappingMachineFrame:GetWidth())
window:SetHeight(ScrappingMachineFrame:GetHeight())
window:SetLayout("List")
window.frame:SetParent(ScrappingMachineFrame)
-- Put the scrapper frame behind the Blizzard scrapper, and disable popping forward when clicked.
window.frame:SetFrameLevel(ScrappingMachineFrame:GetFrameLevel() - 1)
window.frame:SetToplevel(false)

local verticalOffset = 32
if AddonsAPI.ElvUI.isRunning() then
	verticalOffset = 0
end

window:ClearAllPoints()
window:SetPoint('TOP', ScrappingMachineFrame, 'BOTTOM', 0, verticalOffset)
window.sizer_s:Hide()
window.sizer_e:Hide()
window.sizer_se:Hide()
window.closebutton:Hide()


local currentTab = nil
local function selectTab(container, _, group)
	if currentTab ~= nil then
		tremove(container.children, 1)
		currentTab.frame:SetParent(nil)
		currentTab.frame:Hide()
	end

	if group == "gems" then
		currentTab = EasyBronze.gui.gemTab
		container:AddChild(currentTab)
	end
end

-- Queue Scrap Button
local queueScrapButton = AceGUI:Create("Button")
queueScrapButton:SetFullWidth(true)
queueScrapButton:SetText("Queue Scrap")
queueScrapButton:SetCallback("OnClick", function()
	EasyBronze.scrapper:loadScrapper()
end)
window:AddChild(queueScrapButton)

local tabGroup = AceGUI:Create("TabGroup")
tabGroup:SetFullWidth(true)
tabGroup:SetLayout("Flow")
tabGroup:SetTabs({ { text = "Gems", value = "gems" } })
tabGroup:SetCallback("OnGroupSelected", selectTab)
tabGroup:SelectTab("gems")
window:AddChild(tabGroup)

local unregisterSpellCastEvent = nil

window.frame:SetScript("OnShow", function()
	if unregisterSpellCastEvent ~= nil then
		unregisterSpellCastEvent()
		unregisterSpellCastEvent = nil
	end

	unregisterSpellCastEvent = EasyBronze.events:registerEvent("UNIT_SPELLCAST_START", function(event, ...)
		local target, _, spellId = ...
		if target == "player" and spellId == C_ScrappingMachineUI.GetScrapSpellID() then
			queueScrapButton:SetDisabled(true)

			local unregisters = {}

			local callback = function()
				queueScrapButton:SetDisabled(false)
				for _, unregister in ipairs(unregisters) do
					unregister()
				end
			end

			tinsert(unregisters, EasyBronze.events:registerEvent("UNIT_SPELLCAST_INTERRUPTED", callback))
			tinsert(unregisters, EasyBronze.events:registerEvent("UNIT_SPELLCAST_SUCCEEDED", callback))
		end
	end)
end)

window.frame:SetScript("OnHide", function()
	if unregisterSpellCastEvent ~= nil then
		unregisterSpellCastEvent()
		unregisterSpellCastEvent = nil
	end
end)

EasyBronze.gui.scrapperFrame = window
