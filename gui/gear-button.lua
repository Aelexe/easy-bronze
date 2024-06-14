local buttonIndex = 0

function CreateGearButton(gearLink, bag, slot, equipSlotId)
	--- @class GearButton: Button
	--- @field Ahhh string
	--- @field SetLink number
	local button = CreateFrame("Button", "ItemButton_" .. buttonIndex, nil, "BronzeItemButtonTemplate");
	buttonIndex = buttonIndex + 1
	button:SetSize(40, 40)

	local rarity = ItemAPI.getItemRarity(gearLink)
	SetItemButtonQuality(button, rarity)

	local texture = ItemAPI.getItemTexture(gearLink, function(actualTexture)
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
		local rarity = ItemAPI.getItemRarity(link)
		SetItemButtonQuality(button, rarity)

		local texture = ItemAPI.getItemTexture(link, function(actualTexture)
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
