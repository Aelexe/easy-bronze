tinsert(EasyBronze.inits, function()
	local AceGUI = LibStub("AceGUI-3.0")

	local upgradesTab = nil
	local function createUpgradesTab()
		upgradesTab = AceGUI:Create("ScrollFrame")
		upgradesTab:SetFullWidth(true)
		upgradesTab:SetHeight(320)

		local label = AceGUI:Create("Label")
		label:SetFullWidth(100)
		label:SetText("Gear upgrades will be shown below.")
		label:SetFontObject(GameFontNormal)
		upgradesTab:AddChild(label)

		local chatCheckbox = AceGUI:Create("CheckBox")
		chatCheckbox:SetLabel("Chat Alerts")
		chatCheckbox:SetValue(EasyBronze.db.profile.upgrades.chat)
		chatCheckbox:SetCallback("OnValueChanged", function(_, _, value)
			EasyBronze.db.profile.upgrades.chat = value
		end)
		upgradesTab:AddChild(chatCheckbox)

		local soundcheckbox = AceGUI:Create("CheckBox")
		soundcheckbox:SetLabel("Sound Alerts")
		soundcheckbox:SetValue(EasyBronze.db.profile.upgrades.sound)
		soundcheckbox:SetCallback("OnValueChanged", function(_, _, value)
			EasyBronze.db.profile.upgrades.sound = value
		end)
		upgradesTab:AddChild(soundcheckbox)

		local gearButtonPool = {}
		local gearButtons = {}

		local function refreshButtons()
			for _, button in ipairs(gearButtons) do
				button:Hide()
				button:ClearAllPoints()
				tinsert(gearButtonPool, button)
			end

			gearButtons = {}

			for upgradeSlotId, item in pairs(EasyBronze.upgrades.upgrades) do
				local button = nil

				if #gearButtonPool > 0 then
					button = tremove(gearButtonPool)
					button.SetLink(item.link)
					button.SetEquip(item.bag, item.slot, upgradeSlotId)
				else
					button = EasyBronze.CreateGearButton(item.link, item.bag, item.slot, upgradeSlotId)
				end
				button:Show()
				button:SetParent(upgradesTab.frame)
				if #gearButtons == 0 then
					button:SetPoint('TOPLEFT', soundcheckbox.frame, "BOTTOMLEFT", 0, 0)
				else
					button:SetPoint('TOPLEFT', gearButtons[#gearButtons], "TOPRIGHT", 5, 0)
				end
				tinsert(gearButtons, button)
			end
		end

		upgradesTab.frame:Hide()
		upgradesTab.frame:HookScript("OnShow", function()
			refreshButtons()
		end)

		EasyBronze.upgrades:onChange(function()
			refreshButtons()
		end)
	end

	EasyBronze.gui.upgradesTab = function()
		if upgradesTab == nil then
			createUpgradesTab()
		end

		return upgradesTab
	end
end)
