local BridgeNet2: table = require(script.Parent.Parent.BridgeNet2)

local Signal: table = {}
Signal.__index = Signal

function Signal.new(Bridge: table)
	local self: table = setmetatable({}, Signal)

	self.Bridge = Bridge

	return self :: table
end

function Signal:Fire(Player: Player, ...: any)
	self.Bridge:Fire(Player, table.pack(...))
end

function Signal:FireAll(...: any)
	self.Bridge:Fire(BridgeNet2.AllPlayers(), table.pack(...))
end

function Signal:FireFilter(Predicate: (Player, ...any) -> boolean, ...: any)
	for _, Player in game:GetService("Players"):GetPlayers() do
		if Predicate(Player, ...) then
			self.Bridge:Fire(Player, table.pack(...))
		end
	end
end

function Signal:FireExcept(ExceptionList: { Player }, ...: any)
	self.Bridge:Fire(BridgeNet2.PlayersExcept(ExceptionList), table.pack(...))
end

function Signal:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	self = nil
end

return Signal
