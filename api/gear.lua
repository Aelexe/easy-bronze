GearAPI = {
	--- func description
	---@param equipSlot string
	equipSlotToInventorySlots = function(equipSlot)
		local inventorySlots = {}

		if equipSlot == "INVTYPE_HEAD" then
			tinsert(inventorySlots, "HEADSLOT")
		elseif equipSlot == "INVTYPE_NECK" then
			tinsert(inventorySlots, "NECKSLOT")
		elseif equipSlot == "INVTYPE_SHOULDER" then
			tinsert(inventorySlots, "SHOULDERSLOT")
		elseif equipSlot == "INVTYPE_CLOAK" then
			tinsert(inventorySlots, "BACKSLOT")
		elseif equipSlot == "INVTYPE_CHEST" then
			tinsert(inventorySlots, "CHESTSLOT")
		elseif equipSlot == "INVTYPE_WRIST" then
			tinsert(inventorySlots, "WRISTSLOT")
		elseif equipSlot == "INVTYPE_HAND" then
			tinsert(inventorySlots, "HANDSSLOT")
		elseif equipSlot == "INVTYPE_WAIST" then
			tinsert(inventorySlots, "WAISTSLOT")
		elseif equipSlot == "INVTYPE_LEGS" then
			tinsert(inventorySlots, "LEGSSLOT")
		elseif equipSlot == "INVTYPE_FEET" then
			tinsert(inventorySlots, "FEETSLOT")
		elseif equipSlot == "INVTYPE_FINGER" then
			tinsert(inventorySlots, "FINGER0SLOT")
			tinsert(inventorySlots, "FINGER1SLOT")
		elseif equipSlot == "INVTYPE_TRINKET" then
			tinsert(inventorySlots, "TRINKET0SLOT")
			tinsert(inventorySlots, "TRINKET1SLOT")
		elseif equipSlot == "INVTYPE_WEAPON" then
			tinsert(inventorySlots, "MAINHANDSLOT")
			tinsert(inventorySlots, "SECONDARYHANDSLOT")
		elseif equipSlot == "INVTYPE_SHIELD" then
			tinsert(inventorySlots, "SECONDARYHANDSLOT")
		elseif equipSlot == "INVTYPE_2HWEAPON" then
			tinsert(inventorySlots, "MAINHANDSLOT")
		elseif equipSlot == "INVTYPE_WEAPONMAINHAND" then
			tinsert(inventorySlots, "MAINHANDSLOT")
		elseif equipSlot == "INVTYPE_WEAPONOFFHAND" then
			tinsert(inventorySlots, "SECONDARYHANDSLOT")
		elseif equipSlot == "INVTYPE_HOLDABLE" then
			tinsert(inventorySlots, "SECONDARYHANDSLOT")
		elseif equipSlot == "INVTYPE_RANGED" then
			tinsert(inventorySlots, "MAINHANDSLOT")
		end

		return inventorySlots
	end
}
