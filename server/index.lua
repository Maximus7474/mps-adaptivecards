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
            CardElement.Image({
                url = 'https://placehold.co/400',
                alignment = 'Center',
                size = 'medium',
            }),
            CardElement.Media({
                poster = 'https://placehold.co/69',
                sources = {
                    url = 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
                    mimeType = 'video/mp4'
                },
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
