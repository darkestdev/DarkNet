local BridgeNet2: table = require(script.Parent.Parent.BridgeNet2)
local ServerSignal: table = require(script.Parent.ClientSignal)

local Client: table = {}
Client.__index = Client

function Client.new(ServiceName: string, ReplicationData: { [string]: string })
	local self: table = setmetatable({}, Client)

	self.ServiceName = ServiceName
	self.ReplicationData = ReplicationData

	return self :: table
end

function Client:GetServiceMethods(Middleware: table | nil)
	local Methods: { [string]: table | () -> table } = {}

	for MethodKey, MethodType in pairs(self.ReplicationData) do
		local Bridge: table = BridgeNet2.ClientBridge(`{self.ServiceName}_{MethodKey}`)

		if Middleware.Inbound then
			Bridge:InboundMiddleware(Middleware.Inbound)
		end

		if Middleware.Outbound then
			Bridge:OutboundMiddleware(Middleware.Outbound)
		end

		if MethodType == "Method" then
			Methods[MethodKey] = function(_self: any, ...: any)
				return Bridge:InvokeServerAsync(table.pack(...))
			end
		elseif MethodType == "Signal" then
			Methods[MethodKey] = ServerSignal.new(Bridge)
		end
	end

	return Methods
end

return Client
