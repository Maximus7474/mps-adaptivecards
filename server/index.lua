-- The generic demo, shows some of the "main" features
local handleConnecting = require 'server.demos.genericDemo'

AddEventHandler("playerConnecting", handleConnecting)
