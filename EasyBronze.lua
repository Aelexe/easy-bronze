C_AddOns.LoadAddOn("Blizzard_ScrappingMachineUI")

EasyBronze = LibStub("AceAddon-3.0"):NewAddon("Easy Bronze", "AceEvent-3.0", "AceConsole-3.0")

EasyBronze.itemCache = {}
EasyBronze.itemQueue = {}
EasyBronze.gui = {}

function EasyBronze:OnInitialize()
	local default = {
		gems = {
			stats = {},
			qualities = {}
		}
	}

	for _, gemStat in ipairs(EasyBronze.GEM_STATS) do
		default.gems.stats[gemStat.id] = false
	end

	for _, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
		default.gems.stats[gemQuality.id] = true
	end

	self.db = LibStub("AceDB-3.0"):New("EasyBronzeDB", { profile = default }, true)

	MigrateDatabase(self.db)
end

EasyBronze:RegisterChatCommand("easybronze", "slashFunc")

EasyBronze:RegisterEvent("UNIT_SPELLCAST_START", function(event, ...)
	local target, _, spellId = ...
	if target == "player" and spellId == C_ScrappingMachineUI.GetScrapSpellID() then
		EasyBronze.button:SetDisabled(true)

		local callback = function()
			EasyBronze.button:SetDisabled(false)
			EasyBronze:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
			EasyBronze:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		end

		EasyBronze:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", callback)
		EasyBronze:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", callback)
	end
end)

function EasyBronze:slashFunc(input)
	if ScrappingMachineFrame == nil or not ScrappingMachineFrame:IsVisible() then
		self:Print("Scrapping Machine not open")
		return
	end
	if input == "get" then
		self:Print("Getting items")
		self:createScrapQueue()
	elseif input == "set" then
		self:Print("Setting items")
		self:loadScrapQueue()
	end
end

EasyBronze.timeSinceLastUpdate = 0
function EasyBronze:onUpdate(delta)
	self.timeSinceLastUpdate = self.timeSinceLastUpdate + delta

	if self.updateMode == "gem-split" then
		if self.timeSinceLastUpdate > 0.1 then
			self:splitGems()
			self.timeSinceLastUpdate = 0
		end
	end
end

function EasyBronze:loadScrapper()
	EasyBronze:createScrapQueue()
	EasyBronze:loadScrapQueue()
end

function EasyBronze:createScrapQueue()
	table.wipe(self.itemQueue)

	local isOutfitterRunning = C_AddOns.IsAddOnLoaded("Outfitter") and Outfitter:IsInitialized()

	local scrappableGems = {}

	if self.db.profile.gems.stats.crit then
		for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
			if self.db.profile.gems.qualities[gemQuality.id] then
				table.insert(scrappableGems, EasyBronze.CRIT_GEMS[i])
			end
		end
	end
	if self.db.profile.gems.stats.haste then
		for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
			if self.db.profile.gems.qualities[gemQuality.id] then
				table.insert(scrappableGems, EasyBronze.HASTE_GEMS[i])
			end
		end
	end
	if self.db.profile.gems.stats.mastery then
		for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
			if self.db.profile.gems.qualities[gemQuality.id] then
				table.insert(scrappableGems, EasyBronze.MASTERY_GEMS[i])
			end
		end
	end
	if self.db.profile.gems.stats.versatility then
		for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
			if self.db.profile.gems.qualities[gemQuality.id] then
				table.insert(scrappableGems, EasyBronze.VERSATILITY_GEMS[i])
			end
		end
	end
	if self.db.profile.gems.stats.leech then
		for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
			if self.db.profile.gems.qualities[gemQuality.id] then
				table.insert(scrappableGems, EasyBronze.LEECH_GEMS[i])
			end
		end
	end
	if self.db.profile.gems.stats.speed then
		for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
			if self.db.profile.gems.qualities[gemQuality.id] then
				table.insert(scrappableGems, EasyBronze.SPEED_GEMS[i])
			end
		end
	end
	if self.db.profile.gems.stats.armour then
		for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
			if self.db.profile.gems.qualities[gemQuality.id] then
				table.insert(scrappableGems, EasyBronze.ARMOUR_GEMS[i])
			end
		end
	end

	local equipmentSlots = self:getEquipmentSetSlots()

	for bag = 0, 4 do
		for slot = 1, C_Container.GetContainerNumSlots(bag) do
			local itemId = C_Container.GetContainerItemID(bag, slot)

			if itemId and self:isItemScrappable(itemId) then
				local cont_info = C_Container.GetContainerItemInfo(bag, slot)
				local texture = tonumber(cont_info.iconFileID)
				local itemCount = cont_info.stackCount
				local quality = cont_info.quality
				local itemLink = cont_info.hyperlink
				local itemName, _, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon, itemSellPrice, itemClassId, itemSubClassId, bindType, expacId, itemSetId, isCraftingReagent =
					C_Item.GetItemInfo(itemLink)

				local scrapType = nil
				if itemType == "Armor" or itemType == "Weapon" then
					scrapType = "Gear"
				elseif itemType == "Gem" then
					scrapType = "Gem"
				end

				local includeItem = true;

				-- Don't include gear that's part of an equipment set.
				-- TODO: Stock equipment manager.
				if scrapType == "Gear" then
					for _, equipmentSlot in ipairs(equipmentSlots) do
						if equipmentSlot.bag == bag and equipmentSlot.slot == slot then
							includeItem = false
						end
					end

					if includeItem and isOutfitterRunning then
						local outfitterItemInfo = Outfitter:GetBagItemInfo(bag, slot)
						if outfitterItemInfo then
							local outfits = Outfitter:GetOutfitsUsingItem(outfitterItemInfo)
							if outfits then
								includeItem = false
							end
						end
					end
				end

				-- TODO: Temporary limiting to armor gems.
				if scrapType == "Gem" then
					includeItem = false
					for _, gemId in ipairs(scrappableGems) do
						if itemId == gemId then
							includeItem = true
							break
						end
					end
				end

				if includeItem then
					table.insert(self.itemQueue,
						{ bag = bag, slot = slot, name = itemName, scrapType = scrapType, itemCount = itemCount, })
				end
			end
		end
	end

	-- Sort the item queue so that gear comes first, followed by smallest gem stacks.
	table.sort(self.itemQueue, function(a, b)
		if (a.scrapType ~= b.scrapType) then
			if (a.scrapType == "Gear") then
				return true
			else
				return false
			end
		elseif a.scrapType == "Gem" then
			return a.itemCount < b.itemCount
		end
		return false
	end)
end

function EasyBronze:loadScrapQueue()
	if #self.itemQueue == 0 then
		return
	end

	local scrapType = self.itemQueue[1].scrapType

	-- Reprocess gems to split stacks up.
	if scrapType == "Gem" then
		self.gemSplits = {}
		local emptySlots = self:getEmptyBagSlots()
		-- The number of individual items processed for the scrapper.
		local itemCount = 0
		-- The slot index to be used for the next split.
		local slotCount = 1

		local i = 1
		while i <= #self.itemQueue do
			local item = self.itemQueue[i]
			if item.itemCount > 1 then
				local splitCount = math.min(item.itemCount - 1, 9 - itemCount)

				local j = 1

				while j <= splitCount and slotCount <= #emptySlots and itemCount < 8 do
					local emptySlot = emptySlots[slotCount]

					table.insert(self.gemSplits,
						{ bag = item.bag, slot = item.slot, destBag = emptySlot.bag, destSlot = emptySlot.slot })
					j = j + 1
					slotCount = slotCount + 1
					itemCount = itemCount + 1
				end
			end
			itemCount = itemCount + 1
			if itemCount == 9 or slotCount > #emptySlots then
				break
			end
			i = i + 1
		end

		-- If gem splits are required, set update mode to gem split and wait for it to finish.
		if #self.gemSplits > 0 then
			self.updateMode = "gem-split"
			return
		end
	end

	for i = 1, #self.itemQueue do
		local item = self.itemQueue[i]

		-- Scrap gear together, then gems.
		if scrapType ~= item.scrapType then
			return
		end

		C_Container.UseContainerItem(item.bag, item.slot)
	end
end

function EasyBronze:splitGems()
	-- Stop splitting gems if the scrapper has been closed.
	if not ScrappingMachineFrame:IsVisible() then
		self.updateMode = nil
		return
	end

	local gemSplits = EasyBronze.gemSplits

	if #gemSplits == 0 then
		self.updateMode = nil
		self:loadScrapper()
		return
	end

	local gemSplit = gemSplits[1]

	-- Only attempt to move the gem once, otherwise more stacks will be created.
	if not gemSplit.isMoved then
		ClearCursor()
		C_Container.SplitContainerItem(gemSplit.bag, gemSplit.slot, 1)
		C_Container.PickupContainerItem(gemSplit.destBag, gemSplit.destSlot)
		gemSplit.isMoved = true
	end

	-- Check the destination slot is full before attempting to split the next gem.
	if C_Container.GetContainerItemID(gemSplit.destBag, gemSplit.destSlot) ~= nil then
		table.remove(gemSplits, 1)
	end
end

function EasyBronze:getEmptyBagSlots()
	local emptySlots = {}
	for bag = 0, 4 do
		for slot = 1, C_Container.GetContainerNumSlots(bag) do
			if C_Container.GetContainerItemID(bag, slot) == nil then
				table.insert(emptySlots, { bag = bag, slot = slot })
			end
		end
	end
	return emptySlots
end

function EasyBronze:getEquipmentSetSlots()
	local equipmentSetSlots = {}

	local equipmentSetIds = C_EquipmentSet.GetEquipmentSetIDs()

	for _, equipmentSetId in ipairs(equipmentSetIds) do
		local itemLocations = C_EquipmentSet.GetItemLocations(equipmentSetId)
		for i = 0, 19 do
			local itemLocation = itemLocations[i]
			if itemLocation ~= nil then
				local player, bank, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(itemLocation)
				if bags and not bank then
					table.insert(equipmentSetSlots, { bag = bag, slot = slot })
				end
			end
		end
	end

	return equipmentSetSlots
end

--Determine if item can be scrapped by checking if text is in tooltip
function EasyBronze:isItemScrappable(itemId)
	if self.itemCache[itemId] ~= nil then
		return self.itemCache[itemId]
	else
		self.tooltipReader:ClearLines()
		if C_Item.GetItemInfo(itemId) then
			self.tooltipReader:SetItemByID(itemId)
			for i = self.tooltipReader:NumLines(), self.tooltipReader:NumLines() - 3, -1 do
				if i >= 1 then
					local text = _G["EasyBronzeTooltipReaderTextLeft" .. i]:GetText()
					if text == ITEM_SCRAPABLE_NOT then
						self.itemCache[itemId] = false
						return false
					elseif text == ITEM_SCRAPABLE then
						self.itemCache[itemId] = true
						return true
					end
				end
			end
			return false
		else
			table.insert(self.failedItems, itemId)
			return false
		end
	end
end
