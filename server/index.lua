local Card = require 'server.class'

---@param name string
---@param setKickReason fun(reason: string) used to set a reason message for when the event is canceled
---@param deferrals Deferrals
local function playerConnectingHandler(name, setKickReason, deferrals)
    local src = source

    deferrals.defer()

    Wait(1000)

    local card = Card:new({
        body = { {
            type = 'TextBlock',
            text = ('Hello, %s (%d)!'):format(name, tonumber(src))
        }},
        actions = {{
            type = "Action.Submit",
            title = 'This is a title',
            data = { 'this is data '}
        }}
    })

    print('showing card', card:toJson())

    deferrals.presentCard(card:toJson(), function (data, rawData)
        print(json.encode(data, {indent=true}))
    end)
end

AddEventHandler("playerConnecting", playerConnectingHandler)
