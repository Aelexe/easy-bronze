BagsAPI = {
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
	end
}
