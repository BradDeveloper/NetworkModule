# Network Modules
Handles remote networking between Server and Client

## Functions
- NetworkModule:Create(name, remote type) -Creates a remote
- NetworkModule:Fire(name, args) -Fires Events (FireServer, FireClient, Fire)
- Network:FireAll(name, args) -Fires All (For FireAllClients)
- Network:Invoke(name, args) -Invokes Events (InvokeServer, InvokeClient, Invoke)
- Network:Wrap(name, handler function) -Wraps Events and OnInvokes (OnServerEvent, OnClientEvent, Event, OnServerInvoke, OnClientInvoke, OnInvoke)
- Network:Wait(name) -Waits for event (BindableEvent:Wait())
