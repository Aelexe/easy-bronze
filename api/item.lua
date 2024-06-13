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
}
