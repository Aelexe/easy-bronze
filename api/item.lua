ItemAPI = {
	getItemName = function(itemId)
		local itemName, _ = C_Item.GetItemInfo(itemId)
		return itemName
	end,
	getItemRarity = function(itemId)
		local _, _, itemRarity = C_Item.GetItemInfo(itemId)
		return itemRarity
	end,
	getItemTexture = function(itemId, callback)
		local _, _, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemId)

		if (itemTexture == nil) then
			itemTexture = "Interface\\Icons\\INV_Misc_QuestionMark"

			if callback ~= nil then
				local item = Item:CreateFromItemID(itemId)
				item:ContinueOnItemLoad(function()
					callback(item:GetItemIcon())
				end)
			end
		end

		return itemTexture
	end,
	getItemLevel = function(itemLink)
		local _, _, _, itemLevel = C_Item.GetItemInfo(itemLink)
		return itemLevel
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
