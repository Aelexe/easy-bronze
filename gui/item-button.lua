local buttonIndex = 0

local itemButtons = {}

EasyBronze.CreateItemButton = function(itemId)
	local button = CreateFrame("Button", "EasyBronzeItemButton_" .. buttonIndex, nil, "EasyBronzeSecureItemButton");
	buttonIndex = buttonIndex + 1
	button:SetSize(40, 40)
	local rarity = EasyBronze.apis.item.getItemRarity(itemId)

	local texture = EasyBronze.apis.item.getItemTexture(itemId, function(actualTexture)
		SetItemButtonTexture(button, actualTexture)
	end)
	SetItemButtonTexture(button, texture)

	local function updateItemCount()
		local itemCount = EasyBronze.apis.bags.getItemCount(itemId)
		SetItemButtonCount(button, itemCount)
		if itemCount == 0 then
			SetItemButtonDesaturated(button, true)
			SetItemButtonQuality(button, 0)
		else
			SetItemButtonDesaturated(button, false)
			SetItemButtonQuality(button, rarity)
		end
	end
	button.updateItemCount = updateItemCount;

	updateItemCount()

	button:RegisterForClicks("AnyUp", "AnyDown")
	button:EnableMouse(true)
	button:SetMouseClickEnabled(true)
	button:SetAttribute("type", "item")
	button:SetAttribute("item", EasyBronze.apis.item.getItemName(itemId))

	-- Item information can be nil if loaded early after game launch.
	button:SetScript("OnShow", function(self)
		updateItemCount()
	end)

	button:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetItemByID(itemId)
		GameTooltip:Show()
	end)

	button:SetScript('OnLeave', GameTooltip_Hide)

	tinsert(itemButtons, button)

	return button
end

EasyBronze.events:registerEvent("BAG_UPDATE", function()
	for _, button in ipairs(itemButtons) do
		button.updateItemCount()
	end
end)
