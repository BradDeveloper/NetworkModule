local ReplicatedStorage = game:GetService("ReplicatedStorage")

--assertion-properties
local types = {"RemoteEvent", "RemoteFunction", "BindableEvent", "BindableFunction"}
local fires = {"FireServer", "FireClient", "FireAllClients", "InvokeServer", "InvokeClient", "Fire", "Invoke"}
local wraps = {"OnClientEvent", "OnServerEvent", "OnClientInvoke", "OnServerInvoke", "Event", "Wait", "OnInvoke"}
--

local Events = ReplicatedStorage.BEngine.Storage.Events
local network = {}

function network:Create(name: string, typ: string): any
    assert(name and type(name) == "string" and typ and type(typ) == "string" and table.find(types, typ), "net:Create failed")
    local event = Instance.new(typ)
    event.Name = name
    event.Parent = Events
    return event
end

function network:Fire(name: string, call: string, ...): boolean
    assert(name and type(name) == "string" and call and type(call) == "string" and table.find(fires, call), "net:Fire failed")
    local event = Events:FindFirstChild(name)
    if event then
        if call == "FireServer" then
            event:FireServer(...)
        elseif call == "FireClient" then
            event:FireClient(...)
        elseif call == "InvokeServer" then
            return event:InvokeServer(...)
        elseif call == "InvokeClient" then
            return event:InvokeClient(...)
        elseif call == "FireAllClients" then
            event:FireAllClients(...)
        elseif call == "Fire" then
            event:Fire(...)
        elseif call == "Invoke" then
            event:Invoke(...)
        end
    else
        return error("failed to find")
    end
end

function network:Wrap(name: string, call: string, funct: RBXScriptConnection)
    assert(name and type(name) == "string" and call and type(call) == "string" and table.find(wraps, call) and funct and typeof(funct) == "function","net:Wrap failed")
    local event = Events:FindFirstChild(name)
    if event then
        if call == "OnClientEvent" then
            return event.OnClientEvent:Connect(funct)
        elseif call == "OnServerEvent" then
            return event.OnServerEvent:Connect(funct)
        elseif call == "Event" then
            return event.Event:Connect(funct)
        elseif call == "OnClientInvoke" then
            event.OnClientInvoke = funct
        elseif call == "OnServerInvoke" then
            event.OnServerInvoke = funct
        elseif call == "Wait" then
            return event:Wait()
        elseif call == "OnInvoke" then
            event.OnInvoke = funct
        end
    else
        return error("failed to find")
    end
end

return network