AddonsAPI = {
	ElvUI = {
		isRunning = function()
			return C_AddOns.IsAddOnLoaded("ElvUI")
		end,
	},
	Outfitter = {
		isRunning = function()
			return C_AddOns.IsAddOnLoaded("Outfitter") and Outfitter:IsInitialized()
		end,
		getBagItemInfo = function(bag, slot)
			return Outfitter:GetBagItemInfo(bag, slot)
		end,
		getOutfitsUsingItem = function(outfitterItemInfo)
			return Outfitter:GetOutfitsUsingItem(outfitterItemInfo)
		end,
		isOutfitUsingItem = function(bag, slot)
			local outfitterItemInfo = AddonsAPI.Outfitter.getBagItemInfo(bag, slot)
			if outfitterItemInfo then
				local outfits = AddonsAPI.Outfitter.getOutfitsUsingItem(outfitterItemInfo)
				if outfits then
					return true
				end
			end

			return false
		end,
	},
}
