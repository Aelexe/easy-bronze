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
	end
}

EasyBronze.events = eventsModule
