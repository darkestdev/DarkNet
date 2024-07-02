local Signal: table = {}
Signal.__index = Signal

function Signal.new(Bridge: table)
	local self: table = setmetatable({}, Signal)

	self.Bridge = Bridge

	return self :: table
end

function Signal:Connect(Func: (...any) -> ())
	return self.Bridge:Connect(function(Content: table)
		return Func(table.unpack(Content))
	end)
end

function Signal:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	self = nil
end

return Signal
