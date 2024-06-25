local buttonIndex = 0

EasyBronze.CreateGearButton = function(gearLink, bag, slot, equipSlotId)
	local button = CreateFrame("Button", "EasyBronzeGearButton_" .. buttonIndex, nil, "EasyBronzeItemButton");
	buttonIndex = buttonIndex + 1
	button:SetSize(40, 40)

	EasyBronze.apis.item.getItemRarity(gearLink, function(itemRarity)
		SetItemButtonQuality(button, itemRarity)
	end)

	SetItemButtonTexture(button, EasyBronze.apis.item.getUnknownItemTexture())
	EasyBronze.apis.item.getItemTexture(gearLink, function(texture)
		SetItemButtonTexture(button, texture)
	end)

	button:RegisterForClicks("AnyUp")
	button:EnableMouse(true)
	button:SetMouseClickEnabled(true)

	local removeModifierEvent = nil

	button:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetHyperlink(gearLink)
		GameTooltip:Show()

		-- Trigger refresh of tooltip when modifier state is changed to show/hide gear comparison.
		removeModifierEvent = EasyBronze.events:registerEvent("MODIFIER_STATE_CHANGED", function()
			GameTooltip:SetHyperlink(gearLink)
		end)
	end)

	button:SetScript('OnLeave',
		function()
			if removeModifierEvent then
				removeModifierEvent()
				removeModifierEvent = nil
			end
			GameTooltip_Hide()
		end)

	button:SetScript('OnClick', function()
		C_Container.PickupContainerItem(bag, slot)
		EquipCursorItem(equipSlotId)
		EquipPendingItem(equipSlotId)
	end)

	button.SetLink = function(link)
		button:SetScript('OnEnter', function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(link)
			GameTooltip:Show()
		end)
		EasyBronze.apis.item.getItemRarity(gearLink, function(itemRarity)
			SetItemButtonQuality(button, itemRarity)
		end)
		EasyBronze.apis.item.getItemTexture(link, function(texture)
			SetItemButtonTexture(button, texture)
		end)
	end

	button.SetEquip = function(bag, slot, equipSlotId)
		button:SetScript('OnClick', function()
			C_Container.PickupContainerItem(bag, slot)
			EquipCursorItem(equipSlotId)
			EquipPendingItem(equipSlotId)
		end)
	end

	return button
end
