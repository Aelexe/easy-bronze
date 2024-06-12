local buttonIndex = 0

function CreateItemButton(itemId)
	local button = CreateFrame("Button", "ItemButton_" .. buttonIndex, nil, "BronzeItemButtonTemplate");
	buttonIndex = buttonIndex + 1
	button:SetSize(40, 40)
	SetItemButtonTexture(button, ItemAPI.getItemTexture(itemId))
	local rarity = ItemAPI.getItemRarity(itemId)

	local function updateItemCount()
		local itemCount = BagsAPI.getItemCount(itemId)
		SetItemButtonCount(button, itemCount)
		if itemCount == 0 then
			--SetItemButtonDesaturated(button, true)
			SetItemButtonQuality(button, 0)
		else
			SetItemButtonDesaturated(button, false)
			SetItemButtonQuality(button, rarity)
		end
	end

	updateItemCount()

	EasyBronze:RegisterEvent("BAG_UPDATE", updateItemCount)

	button:RegisterForClicks("AnyUp", "AnyDown")
	button:EnableMouse(true)
	button:SetMouseClickEnabled(true)
	button:SetAttribute("type", "item")
	button:SetAttribute("item", ItemAPI.getItemName(itemId))

	button:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetItemByID(itemId)
		GameTooltip:Show()
	end)

	button:SetScript('OnLeave',
		function(self)
			GameTooltip_Hide()
		end)

	return button
end
