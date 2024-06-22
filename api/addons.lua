EasyBronze.apis.addons = {
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
			local outfitterItemInfo = EasyBronze.apis.addons.Outfitter.getBagItemInfo(bag, slot)
			if outfitterItemInfo then
				local outfits = EasyBronze.apis.addons.Outfitter.getOutfitsUsingItem(outfitterItemInfo)
				if outfits then
					return true
				end
			end

			return false
		end,
	},
}
