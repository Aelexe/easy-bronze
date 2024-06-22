local buttonIndex = 0

EasyBronze.CreateGearButton = function(gearLink, bag, slot, equipSlotId)
	local button = CreateFrame("Button", "EasyBronzeGearButton_" .. buttonIndex, nil, "EasyBronzeItemButton");
	buttonIndex = buttonIndex + 1
	button:SetSize(40, 40)

	local rarity = EasyBronze.apis.item.getItemRarity(gearLink)
	SetItemButtonQuality(button, rarity)

	local texture = EasyBronze.apis.item.getItemTexture(gearLink, function(actualTexture)
		SetItemButtonTexture(button, actualTexture)
	end)
	SetItemButtonTexture(button, texture)

	button:RegisterForClicks("AnyUp")
	button:EnableMouse(true)
	button:SetMouseClickEnabled(true)

	button:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetHyperlink(gearLink)
		GameTooltip:Show()
	end)

	button:SetScript('OnLeave',
		function(self)
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
		local rarity = EasyBronze.apis.item.getItemRarity(link)
		SetItemButtonQuality(button, rarity)

		local texture = EasyBronze.apis.item.getItemTexture(link, function(actualTexture)
			SetItemButtonTexture(button, actualTexture)
		end)
		SetItemButtonTexture(button, texture)
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
