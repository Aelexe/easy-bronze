local alertSoundDebounced = false
local function alertUpgrade(upgrade)
	if EasyBronze.db.profile.upgrades.sound and not alertSoundDebounced then
		PlaySoundFile("Interface\\AddOns\\EasyBronze\\sfx\\alert.mp3", "SFX")
		EasyBronze:ScheduleTimer(function()
			alertSoundDebounced = false
		end, 5)
	end

	if not EasyBronze.db.profile.upgrades.chat then
		return
	end

	local message = "Upgrade: |c" ..
		EasyBronze.apis.item.getQualityColor(upgrade.quality) ..
		upgrade.name ..
		"|r (" .. upgrade.itemLevel .. ") > "

	if upgrade.replaces ~= nil then
		message = message ..
			"|c" ..
			EasyBronze.apis.item.getQualityColor(upgrade.replaces.quality) ..
			upgrade.replaces.name ..
			"|r (" .. upgrade.replaces.itemLevel .. ")"
	else
		message = message .. "Nothing"
	end

	EasyBronze:Print(message)
end

local upgradesModule = {
	-- Table of current upgrades for the player.
	upgrades = {},
	-- Change callbacks for upgrades.
	changeCallbacks = {},
	onChange = function(self, callback)
		tinsert(self.changeCallbacks, callback)

		return function()
			for i, cb in ipairs(self.changeCallbacks) do
				if cb == callback then
					tremove(self.changeCallbacks, i)
					break
				end
			end
		end
	end,
	loadUpgrades = function(self)
		-- Table of upgrades for the current check.
		local upgrades = {}

		local gear = EasyBronze.apis.bags.getGearInBags()

		-- Iterate the bag gear and add any upgrades to the upgrade table.
		for _, item in ipairs(gear) do
			local equipSlot = item.equipSlot

			local inventorySlots = EasyBronze.apis.gear.equipSlotToInventorySlots(equipSlot)

			-- Check whether the gear is an upgrade against each valid slot.
			for _, inventorySlot in ipairs(inventorySlots) do
				local inventorySlotId = GetInventorySlotInfo(inventorySlot)
				local equippedItemLink = GetInventoryItemLink("player", inventorySlotId)

				local itemIsUpgrade = false

				local originalItem = nil

				if equippedItemLink ~= nil then
					local name, _, quality, itemLevel = C_Item.GetItemInfo(equippedItemLink)

					-- If an item is missing its item level then details have not been cached. Reschedule an upgrade check.
					if item.itemLevel == nil or itemLevel == nil then
						EasyBronze:ScheduleTimer(function()
							self:loadUpgrades()
						end, 1)
						return
					end

					-- An item is an upgrade if its rarity is greater, or rarity is equal and item level is greater.
					if item.quality > quality or (item.quality == quality and item.itemLevel > itemLevel) then
						itemIsUpgrade = true
						originalItem = {
							link = equippedItemLink,
							name = name,
							quality = quality,
							itemLevel = itemLevel,
						}
					end
				elseif inventorySlot ~= "SECONDARYHANDSLOT" then
					-- TODO: Handle offhands being compared with a two handed weapon.
					itemIsUpgrade = true
				end

				if itemIsUpgrade then
					-- Only add the item to the upgrades table if it is a greater upgrade than the current upgrade.
					if upgrades[inventorySlotId] == nil or upgrades[inventorySlotId].quality < item.quality or
						(upgrades[inventorySlotId].quality == item.quality and upgrades[inventorySlotId].itemLevel < item.itemLevel) then
						upgrades[inventorySlotId] = item

						if originalItem ~= nil then
							upgrades[inventorySlotId].replaces = originalItem
						end
					end
				end
			end
		end

		-- Check if any of the upgrades are new, or if the upgrades have changed.
		local newUpgrades = {}
		local changedUpgrades = false

		for slotId, upgrade in pairs(upgrades) do
			local existingUpgrade = self.upgrades[slotId]
			if existingUpgrade == nil or upgrade.quality > existingUpgrade.quality or (upgrade.quality == existingUpgrade.quality and upgrade.itemLevel > existingUpgrade.itemLevel) then
				tinsert(newUpgrades, upgrade)
				changedUpgrades = true
				break
			end
		end

		if not changedUpgrades then
			for slotId, upgrade in pairs(self.upgrades) do
				if upgrades[slotId] == nil then
					changedUpgrades = true
					break
				end
			end
		end

		-- Update the upgrades now that they've been processed.
		self.upgrades = upgrades

		-- If the upgrades have changed, trigger the change callbacks.
		if changedUpgrades then
			for _, cb in ipairs(self.changeCallbacks) do
				cb(self.upgrades)
			end
		end

		-- Trigger alerts for new upgrades.
		for _, upgrade in pairs(newUpgrades) do
			alertUpgrade(upgrade)
		end
	end,
}

EasyBronze.events:registerEvent("UNIT_INVENTORY_CHANGED", function()
	upgradesModule:loadUpgrades()
end)
EasyBronze.events:registerEvent("BAG_UPDATE", function()
	upgradesModule:loadUpgrades()
end)

EasyBronze.upgrades = upgradesModule
