local Card = require 'server.classes.card'
local CardElement = require 'server.classes.cardElement'

---@param name string
---@param setKickReason fun(reason: string) used to set a reason message for when the event is canceled
---@param deferrals Deferrals
local function playerConnectingHandler(name, setKickReason, deferrals)
    local src = source

    deferrals.defer()

    Wait(100)

    local card = Card:new({
        body = {
            CardElement.TextBlock( {
                text = ('Hello, %s (%d)!'):format(name, tonumber(src)),
                style = 'heading',
            }),
        },
        actions = {{
            type = "Action.Submit",
            title = 'This is a title',
            data = { 'this is data '}
        }}
    })

    deferrals.presentCard(card:toJson(), function (data, rawData)
        print(json.encode(data, {indent=true}))
    end)
end

AddEventHandler("playerConnecting", playerConnectingHandler)
