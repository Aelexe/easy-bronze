ItemAPI = {
	getItemName = function(itemId)
		local itemName, _ = C_Item.GetItemInfo(itemId)
		return itemName
	end,
	getItemRarity = function(itemId)
		local _, _, itemRarity = C_Item.GetItemInfo(itemId)
		return itemRarity
	end,
	getItemTexture = function(itemId)
		local _, _, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemId)
		return itemTexture
	end,
}
