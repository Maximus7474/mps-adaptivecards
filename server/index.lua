local Card = require 'server.lib.card'
local CardElement = require 'server.lib.cardElement'
local CardContainer = require 'server.lib.cardContainer'
local CardColumnClasses = require 'server.lib.cardColumnSet'
local CardColumnSet, CardColumn = CardColumnClasses.CardColumnSet, CardColumnClasses.CardColumn

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

    local columnSet = CardColumnSet:new({
        alignement = {
            horizontal = "Left"
        }
    },
        CardColumn:new({},
            CardElement.Image({
                url = 'https://placehold.co/69',
                alignment = 'Center',
                size = 'medium',
            })
        ),
        CardColumn:new({},
            CardElement.TextBlock( {
                text = ('Hello, %s (%d)!'):format(name, tonumber(src)),
                style = 'heading',
            })
        )
    )

    local container = CardContainer:new({
        alignement = {
            horizontal = 'Center',
            vertical = 'Center'
        },
        spacing = 'Large',
    },
        columnSet:getComponent()
    )

    card:addElement(
        container:getComponent(),
        CardElement.Media({
            poster = 'https://placehold.co/69',
            sources = {
                url = 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
                mimeType = 'video/mp4'
            },
        })
    )

    deferrals.presentCard(card:toJson(), function (data, rawData)
        print('adaptive card actions cb', json.encode(data, {indent=true}))
    end)
end

AddEventHandler("playerConnecting", playerConnectingHandler)
