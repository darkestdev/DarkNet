local Types: nil = require(script.Parent.Types)
local BridgeNet2: Types.TableType = require(script.Parent.Parent.BridgeNet2)

local Signal: Types.TableType = {}
Signal.__index = Signal

function Signal.new(Bridge: table)
	local self: Types.TableType = setmetatable({}, Signal)

	self.Bridge = Bridge

	return self :: Types.TableType
end

function Signal:Fire(Player: Player | { Player }, ...: any)
	if typeof(Player) == "table" then
		self.Bridge:Fire(BridgeNet2.Players(Player), table.pack(...))
	else
		self.Bridge:Fire(Player, table.pack(...))
	end
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
