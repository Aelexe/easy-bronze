tinsert(EasyBronze.inits, function()
	local scrapperModule = {
		itemQueue = {},
		gemSplits = {},
		timeSinceLastUpdate = 0,
		loadScrapper = function(self)
			self:createScrapQueue()
			self:loadScrapQueue()
		end,
		createScrapQueue = function(self)
			table.wipe(self.itemQueue)

			local isOutfitterRunning = EasyBronze.apis.addons.Outfitter.isRunning()

			local scrappableGems = {}

			local db = EasyBronze.db.profile

			if db.gems.stats.crit then
				for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
					if db.gems.qualities[gemQuality.id] then
						table.insert(scrappableGems, EasyBronze.CRIT_GEMS[i])
					end
				end
			end
			if db.gems.stats.haste then
				for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
					if db.gems.qualities[gemQuality.id] then
						table.insert(scrappableGems, EasyBronze.HASTE_GEMS[i])
					end
				end
			end
			if db.gems.stats.mastery then
				for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
					if db.gems.qualities[gemQuality.id] then
						table.insert(scrappableGems, EasyBronze.MASTERY_GEMS[i])
					end
				end
			end
			if db.gems.stats.versatility then
				for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
					if db.gems.qualities[gemQuality.id] then
						table.insert(scrappableGems, EasyBronze.VERSATILITY_GEMS[i])
					end
				end
			end
			if db.gems.stats.leech then
				for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
					if db.gems.qualities[gemQuality.id] then
						table.insert(scrappableGems, EasyBronze.LEECH_GEMS[i])
					end
				end
			end
			if db.gems.stats.speed then
				for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
					if db.gems.qualities[gemQuality.id] then
						table.insert(scrappableGems, EasyBronze.SPEED_GEMS[i])
					end
				end
			end
			if db.gems.stats.armour then
				for i, gemQuality in ipairs(EasyBronze.GEM_QUALITIES) do
					if db.gems.qualities[gemQuality.id] then
						table.insert(scrappableGems, EasyBronze.ARMOUR_GEMS[i])
					end
				end
			end

			local equipmentSlots = EasyBronze.apis.gear.getEquipmentSetSlots()

			for bag = 0, 4 do
				for slot = 1, C_Container.GetContainerNumSlots(bag) do
					local itemId = C_Container.GetContainerItemID(bag, slot)

					if itemId and EasyBronze.apis.item.isItemScrappable(itemId) then
						local cont_info = C_Container.GetContainerItemInfo(bag, slot)
						local itemCount = cont_info.stackCount
						local itemLink = cont_info.hyperlink
						local itemName, _, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon, itemSellPrice, itemClassId, itemSubClassId, bindType, expacId, itemSetId, isCraftingReagent =
							C_Item.GetItemInfo(itemLink)

						local scrapType = nil
						if itemClassId == Enum.ItemClass.Armor or itemClassId == Enum.ItemClass.Weapon then
							scrapType = "Gear"
						elseif itemClassId == Enum.ItemClass.Gem then
							scrapType = "Gem"
						end

						local includeItem = scrapType ~= nil;

						-- Don't include gear that's part of an equipment set.
						if scrapType == "Gear" then
							-- Stop equipment set gear from being scrapped.
							for _, equipmentSlot in ipairs(equipmentSlots) do
								if equipmentSlot.bag == bag and equipmentSlot.slot == slot then
									includeItem = false
								end
							end

							-- Stop Outfitter set gear from being scrapped.
							if includeItem and isOutfitterRunning then
								includeItem = not EasyBronze.apis.addons.Outfitter.isOutfitUsingItem(bag, slot)
							end

							-- Stop upgrades from being scrapped.
							if includeItem then
								for _, upgrade in pairs(EasyBronze.upgrades.upgrades) do
									if upgrade.bag == bag and upgrade.slot == slot then
										includeItem = false
										break
									end
								end
							end
						end

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
		end,
		loadScrapQueue = function(self)
			if #self.itemQueue == 0 then
				return
			end

			local scrapType = self.itemQueue[1].scrapType

			-- Reprocess gems to split stacks up.
			if scrapType == "Gem" then
				table.wipe(self.gemSplits)
				local emptySlots = EasyBronze.apis.bags.getEmptyBagSlots()
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
					EasyBronze.gui.scrapperFrame.frame:SetScript("OnUpdate", function(_, delta)
						self:onUpdate(delta)
					end)
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
		end,
		splitGems = function(self)
			-- Stop splitting gems if the scrapper has been closed.
			if not ScrappingMachineFrame:IsVisible() then
				self.updateMode = nil
				EasyBronze.gui.scrapperFrame.frame:SetScript("OnUpdate", nil)
				return
			end

			if #self.gemSplits == 0 then
				self.updateMode = nil
				EasyBronze.gui.scrapperFrame.frame:SetScript("OnUpdate", nil)
				self:loadScrapper()
				return
			end

			local gemSplit = self.gemSplits[1]

			-- Only attempt to move the gem once, otherwise more stacks will be created.
			if not gemSplit.isMoved then
				ClearCursor()
				C_Container.SplitContainerItem(gemSplit.bag, gemSplit.slot, 1)
				C_Container.PickupContainerItem(gemSplit.destBag, gemSplit.destSlot)
				gemSplit.isMoved = true
			end

			-- Check the destination slot is full before attempting to split the next gem.
			if C_Container.GetContainerItemID(gemSplit.destBag, gemSplit.destSlot) ~= nil then
				table.remove(self.gemSplits, 1)
			end
		end,
		onUpdate = function(self, delta)
			self.timeSinceLastUpdate = self.timeSinceLastUpdate + delta

			if self.updateMode == "gem-split" then
				if self.timeSinceLastUpdate > 0.1 then
					self:splitGems()
					self.timeSinceLastUpdate = 0
				end
			end
		end
	}

	EasyBronze.scrapper = scrapperModule
end)
