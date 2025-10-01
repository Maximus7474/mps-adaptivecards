-- The generic demo, shows some of the "main" features
local handleConnecting = require 'server.demos.genericDemo'

-- A demo for discord whitelisting, has different cards to show depending on the status
-- local handleConnecting = require 'server.demos.whitelistExample'

AddEventHandler("playerConnecting", handleConnecting)
