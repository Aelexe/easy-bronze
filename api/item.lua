local scrappableCache = {}

EasyBronze.apis.item = {
	getItemName = function(itemId)
		local itemName, _ = C_Item.GetItemInfo(itemId)
		return itemName
	end,
	getItemRarity = function(itemId, callback)
		local itemRarity = select(3, C_Item.GetItemInfo(itemId))

		if itemRarity then
			if callback ~= nil then
				callback(itemRarity)
			end
			return itemRarity
		end

		if callback ~= nil then
			local item = Item:CreateFromItemID(itemId)
			item:ContinueOnItemLoad(function()
				callback(item:GetItemQuality())
			end)
		end
	end,
	getUnknownItemTexture = function()
		return "Interface\\Icons\\INV_Misc_QuestionMark"
	end,
	getItemTexture = function(itemId, callback)
		local itemTexture = select(10, C_Item.GetItemInfo(itemId))

		if (itemTexture) then
			if callback ~= nil then
				callback(itemTexture)
			end
			return itemTexture
		end

		if callback ~= nil then
			local item = Item:CreateFromItemID(itemId)
			item:ContinueOnItemLoad(function()
				callback(item:GetItemIcon())
			end)
		end
	end,
	getItemLevel = function(itemLink)
		local _, _, _, itemLevel = C_Item.GetItemInfo(itemLink)
		return itemLevel
	end,
	isItemScrappable = function(itemId)
		if scrappableCache[itemId] ~= nil then
			return scrappableCache[itemId]
		else
			local tooltipScanner = EasyBronze.tooltipScanner
			tooltipScanner:ClearLines()
			if C_Item.GetItemInfo(itemId) then
				tooltipScanner:SetItemByID(itemId)
				for i = tooltipScanner:NumLines(), tooltipScanner:NumLines() - 3, -1 do
					if i >= 1 then
						local text = _G["EasyBronzeTooltipScannerTextLeft" .. i]:GetText()
						if text == ITEM_SCRAPABLE_NOT then
							scrappableCache[itemId] = false
							return false
						elseif text == ITEM_SCRAPABLE then
							scrappableCache[itemId] = true
							return true
						end
					end
				end
				return false
			else
				-- TODO: Handle tooltip scan failures if needed.
				return false
			end
		end
	end,
	getQualityName = function(qualityId)
		local qualityName = "Poor"

		if qualityId == Enum.ItemQuality.Poor then
			qualityName = "Poor"
		elseif qualityId == Enum.ItemQuality.Common then
			qualityName = "Common"
		elseif qualityId == Enum.ItemQuality.Uncommon then
			qualityName = "Uncommon"
		elseif qualityId == Enum.ItemQuality.Rare then
			qualityName = "Rare"
		elseif qualityId == Enum.ItemQuality.Epic then
			qualityName = "Epic"
		elseif qualityId == Enum.ItemQuality.Legendary then
			qualityName = "Legendary"
		elseif qualityId == Enum.ItemQuality.Artifact then
			qualityName = "Artifact"
		elseif qualityId == Enum.ItemQuality.Heirloom then
			qualityName = "Heirloom"
		elseif qualityId == Enum.ItemQuality.WoWToken then
			qualityName = "WoW Token"
		end

		return qualityName
	end,
	getQualityColor = function(qualityId)
		local qualityColor = "FF9D9D9D"

		if qualityId == Enum.ItemQuality.Poor then
			qualityColor = "FF9D9D9D"
		elseif qualityId == Enum.ItemQuality.Common then
			qualityColor = "FFFFFFFF"
		elseif qualityId == Enum.ItemQuality.Uncommon then
			qualityColor = "FF1EFF00"
		elseif qualityId == Enum.ItemQuality.Rare then
			qualityColor = "FF0070DD"
		elseif qualityId == Enum.ItemQuality.Epic then
			qualityColor = "FFA335EE"
		elseif qualityId == Enum.ItemQuality.Legendary then
			qualityColor = "FFFF8000"
		elseif qualityId == Enum.ItemQuality.Artifact then
			qualityColor = "FFE6CC80"
		elseif qualityId == Enum.ItemQuality.Heirloom then
			qualityColor = "FF00CCFF"
		elseif qualityId == Enum.ItemQuality.WoWToken then
			qualityColor = "FF00CCFF"
		end

		return qualityColor
	end
}
