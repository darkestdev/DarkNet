local Types: nil = require(script.Parent.Types)
local BridgeNet2: Types.TableType = require(script.Parent.Parent.BridgeNet2)

local Signal: Types.TableType = {}
Signal.__index = Signal

function Signal.new(Bridge: table, Calls: Types.TableType)
	local self: Types.TableType = setmetatable({}, Signal)

	self.Bridge = Bridge
	self.Calls = Calls

	return self :: Types.TableType
end

function Signal:Fire(Player: Player | { Player }, ...: any)
	local PackedArgs: Types.TableType = table.pack(...)
	PackedArgs.n = nil
	self.Calls += 1
	if typeof(Player) == "table" then
		self.Bridge:Fire(BridgeNet2.Players(Player), PackedArgs)
	else
		self.Bridge:Fire(Player, PackedArgs)
	end
end

function Signal:FireAll(...: any)
	local PackedArgs: Types.TableType = table.pack(...)
	PackedArgs.n = nil
	self.Calls += 1
	self.Bridge:Fire(BridgeNet2.AllPlayers(), PackedArgs)
end

function Signal:FireFilter(Predicate: (Player, ...any) -> boolean, ...: any)
	local PackedArgs: Types.TableType = table.pack(...)
	PackedArgs.n = nil
	self.Calls += 1
	for _, Player in game:GetService("Players"):GetPlayers() do
		if Predicate(Player, ...) then
			self.Bridge:Fire(Player, PackedArgs)
		end
	end
end

function Signal:FireExcept(ExceptionList: { Player }, ...: any)
	local PackedArgs: Types.TableType = table.pack(...)
	PackedArgs.n = nil
	self.Calls += 1
	self.Bridge:Fire(BridgeNet2.PlayersExcept(ExceptionList), PackedArgs)
end

function Signal:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	self = nil
end

return Signal
