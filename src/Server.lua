local BridgeNet2: table = require(script.Parent.Parent.BridgeNet2)
local ServerSignal: table = require(script.Parent.ServerSignal)

local Server: table = {}
Server.__index = Server

function Server.new(ServiceName: string)
	local self: table = setmetatable({}, Server)

	self.ServiceName = ServiceName
	self.ReplicationData = {}

	return self :: table
end

function Server:WrapMethod(Table: table, Name: string, InboundMiddleware: any, OutboundMiddleware: any)
	local Bridge: table = BridgeNet2.ServerBridge(`{self.ServiceName}_{Name}`)

	if InboundMiddleware then
		Bridge:InboundMiddleware(InboundMiddleware)
	end

	if OutboundMiddleware then
		Bridge:OutboundMiddleware(OutboundMiddleware)
	end

	Bridge.OnServerInvoke = function(Player: Player, Content: table)
		return Table[Name](Table, Player, table.unpack(Content))
	end

	self.ReplicationData[Name] = "Method"
end

function Server:ConstructSignal(Name: string, InboundMiddleware: any, OutboundMiddleware: any)
	local Bridge: table = BridgeNet2.ServerBridge(`{self.ServiceName}_{Name}`)

	if InboundMiddleware then
		Bridge:InboundMiddleware(InboundMiddleware)
	end

	if OutboundMiddleware then
		Bridge:OutboundMiddleware(OutboundMiddleware)
	end

	self.ReplicationData[Name] = "Signal"

	return ServerSignal.new(Bridge)
end

return Server
