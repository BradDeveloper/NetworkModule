local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local IS_SERVER = RunService:IsServer()

--assertion-properties
local types = {"RemoteEvent", "RemoteFunction", "BindableEvent", "BindableFunction"}
--

local Events = Instance.new("Folder")
Events.Name = "NetworkEvents"
Events.Parent = ReplicatedStorage

local Network = {}

--Handles network creation
function Network:Create(name: string, typ: string): (RemoteEvent | RemoteFunction | BindableEvent | BindableFunction)
    assert(type(name) == "string" and table.find(types, typ), "net:Create failed")
    local event = Instance.new(typ)
    event.Name = name
    event.Parent = Events
    return event
end

--Handles general remote firing
function Network:Fire(name: string, ...)
    local event = Events:WaitForChild(name, 5)
    if event then
        if event:IsA("BindableEvent") then
            event:Fire(...)            
        elseif event:IsA("RemoteEvent") then
            if IS_SERVER then
                event:FireClient(...)
            else
                event:FireServer(...)
            end
        else
            error("cannot handle remote type")
        end
    else
        return error("failed to find" .. name)
    end
end

--Handles remote firing for all
function Network:FireAll(name: string, ...)
    local event = Events:WaitForChild(name, 5)
    if event then
        event:FireAllClients(...)
    else
        return error("failed to find" .. name)
    end
end

--Handles network wait event
function Network:Wait(name: string): any
    local event = Events:WaitForChild(name, 5)
    if event then
        return event:Wait()
    else
        return error("failed to find" .. name)
    end
end

--Handles remote invokes
function Network:Invoke(name: string, ...): any
    local event = Events:WaitForChild(name, 5)
    if event then
        if event:IsA("RemoteFunction") then
            if IS_SERVER then
                return event:InvokeClient(...)
            else
                return event:InvokeServer(...)
            end
        elseif event:IsA("BindableFunction") then
            return event:Invoke(...)
        else
            return error("failed to find" .. name)
        end
    end
end

--Handles remote wrappers (events and invokes)
function Network:Wrap(name: string, funct: RBXScriptConnection): any
    local event = Events:WaitForChild(name, 5)
    if event then
        if event:IsA("BindableEvent") then
            return event.Event:Connect(funct)
        elseif event:IsA("RemoteEvent") then
            if IS_SERVER then
                return event.OnServerEvent:Connect(funct)
            else
                return event.OnClientEvent:Connect(funct)
            end
        elseif event:IsA("BindableFunction") then
            event.OnInvoke = funct
        elseif event:IsA("RemoteFunction") then
            if IS_SERVER then
                event.OnServerInvoke = funct
            else
                event.OnClientInvoke = funct
            end
        else
            error("cannot handle remote type")
        end
    else
        return error("failed to find" .. name)
    end
end

return Network
