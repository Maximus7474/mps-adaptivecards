-- The generic demo, shows some of the "main" features
local handleConnecting = require 'server.demos.genericDemo'

-- A demo for discord whitelisting, has different cards to show depending on the status
-- local handleConnecting = require 'server.demos.whitelistExample'

-- A demo for a basic server password set via convar
-- local handleConnecting = require 'server.demos.basicPassword'

AddEventHandler("playerConnecting", handleConnecting)
