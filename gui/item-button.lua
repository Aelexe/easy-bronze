local buttonIndex = 0

function CreateItemButton(itemId)
	local button = CreateFrame("Button", "ItemButton_" .. buttonIndex, nil, "BronzeItemButtonTemplate");
	buttonIndex = buttonIndex + 1
	button:SetSize(40, 40)
	local rarity = ItemAPI.getItemRarity(itemId)
	local texture = nil

	local function updateItemCount()
		local itemCount = BagsAPI.getItemCount(itemId)
		SetItemButtonCount(button, itemCount)
		if itemCount == 0 then
			SetItemButtonDesaturated(button, true)
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

	-- Textures can be nil if loaded early in the game launch lifecycle. This is a partial workaround.
	-- TODO: Check repeatedly if still nil after load.
	button:SetScript("OnShow", function(self)
		if texture == nil then
			texture = ItemAPI.getItemTexture(itemId)
			if texture ~= nil then
				SetItemButtonTexture(button, texture)
			end
		end

		updateItemCount()
	end)

	button:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetItemByID(itemId)
		GameTooltip:Show()
	end)

	button:SetScript('OnLeave',
		function(self)
			GameTooltip_Hide()
		end)

	-- Hacky workaround to item counts not updating correctly.
	button:SetScript("OnMouseDown", function()
		EasyBronze:ScheduleTimer(updateItemCount, 0)
		EasyBronze:ScheduleTimer(updateItemCount, 0.25)
		EasyBronze:ScheduleTimer(updateItemCount, 0.5)
	end)
	button:SetScript("OnMouseUp", function()
		EasyBronze:ScheduleTimer(updateItemCount, 0)
		EasyBronze:ScheduleTimer(updateItemCount, 0.25)
		EasyBronze:ScheduleTimer(updateItemCount, 0.5)
	end)

	return button
end
