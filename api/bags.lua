BagsAPI = {
	--- Returns an array of bags and slots that are empty.
	getEmptyBagSlots = function()
		local emptySlots = {}
		for bag = 0, 4 do
			for slot = 1, C_Container.GetContainerNumSlots(bag) do
				if C_Container.GetContainerItemID(bag, slot) == nil then
					table.insert(emptySlots, { bag = bag, slot = slot })
				end
			end
		end
		return emptySlots
	end,
	getItemCount = function(itemId)
		local itemCount = 0

		for bag = 0, 4 do
			for slot = 1, C_Container.GetContainerNumSlots(bag) do
				if C_Container.GetContainerItemID(bag, slot) == itemId then
					local stackCount = C_Container.GetContainerItemInfo(bag, slot).stackCount
					itemCount = itemCount + stackCount
				end
			end
		end

		return itemCount
	end,
	getGearInBags = function()
		local gear = {}

		for bag = 0, 4 do
			for slot = 1, C_Container.GetContainerNumSlots(bag) do
				local item = C_Container.GetContainerItemInfo(bag, slot)
				if item ~= nil then
					local itemLink = C_Container.GetContainerItemLink(
						bag, slot)
					local name, _, quality, itemLevel, _, type, subType, _, equipSlot = C_Item.GetItemInfo(
						itemLink)

					if equipSlot ~= nil and equipSlot ~= "INVTYPE_NON_EQUIP_IGNORE" and C_Item.IsEquippableItem(itemLink) then
						tinsert(gear, {
							link = itemLink,
							name = item.itemName,
							bag = bag,
							slot = slot,
							quality = quality,
							itemLevel = itemLevel,
							type = type,
							subType = subType,
							equipSlot = equipSlot
						})
					end
				end
			end
		end

		return gear
	end
}
