local Types: nil = require(script.Parent.Types)
local Signal: Types.TableType = {}
Signal.__index = Signal

function Signal.new(Bridge: Types.TableType)
	local self: Types.TableType = setmetatable({}, Signal)

	self.Bridge = Bridge

	return self :: Types.TableType
end

function Signal:Connect(Func: (...any) -> ())
	return self.Bridge:Connect(function(Content: Types.TableType)
		return Func(table.unpack(Content))
	end)
end

function Signal:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	self = nil
end

return Signal
