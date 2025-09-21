local Card = require 'server.lib.card'
local CardElement = require 'server.lib.cardElement'
local CardContainer = require 'server.lib.cardContainer'

---@param name string
---@param setKickReason fun(reason: string) used to set a reason message for when the event is canceled
---@param deferrals Deferrals
local function playerConnectingHandler(name, setKickReason, deferrals)
    local src = source

    deferrals.defer()

    Wait(100)

    local card = Card:new({
        actions = {{
            type = "Action.Submit",
            title = 'This is a title',
            data = { 'this is data '}
        }}
    })

    local container = CardContainer:new(nil,
        CardElement.TextBlock( {
            text = ('Hello, %s (%d)!'):format(name, tonumber(src)),
            style = 'heading',
        }),
        CardElement.Image({
            url = 'https://placehold.co/69',
            alignment = 'Center',
            size = 'medium',
        }),
        CardElement.Media({
            poster = 'https://placehold.co/69',
            sources = {
                url = 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
                mimeType = 'video/mp4'
            },
        })
    )

    card:addElement(container:getComponent())

    deferrals.presentCard(card:toJson(), function (data, rawData)
        print(json.encode(data, {indent=true}))
    end)
end

AddEventHandler("playerConnecting", playerConnectingHandler)
