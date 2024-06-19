local eventsModule = {
	events = {},
	registerEvent = function(self, event, callback)
		if self.events[event] == nil then
			self.events[event] = {}
			EasyBronze:RegisterEvent(event, function(...)
				for _, callback in ipairs(self.events[event]) do
					callback(...)
				end
			end)
		end
		tinsert(self.events[event], callback)

		return function()
			for i, v in ipairs(self.events[event]) do
				if v == callback then
					tremove(self.events[event], i)
					break
				end
			end

			if #self.events[event] == 0 then
				self.events[event] = nil
				EasyBronze:UnregisterEvent(event)
			end
		end
	end,

	updateHooked = false,
	updates = {},
	registerUpdate = function(self, callback)
		if not self.updateHooked then
			self.updateHooked = true
			function EasyBronze:onUpdate(delta)
				self.timeSinceLastUpdate = self.timeSinceLastUpdate + delta

				if self.updateMode == "gem-split" then
					if self.timeSinceLastUpdate > 0.1 then
						self:splitGems()
						self.timeSinceLastUpdate = 0
					end
				end
			end
		end
		EasyBronze:RegisterUpdate(callback)
		return function()
			EasyBronze:UnregisterUpdate(callback)
		end
	end
}

EasyBronze.events = eventsModule
