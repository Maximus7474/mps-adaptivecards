local CardElement = require 'server.lib.cardElement'
local CardContainer = require 'server.lib.cardContainer'
local CardAction = require 'server.lib.cardActions'
local CardInput = require 'server.lib.cardInput'
local CardColumnSet = (require 'server.lib.cardColumnSet').CardColumnSet

local Card = {}
Card.__index = Card

---@class Card
---@field cardData table<string, string | table> 

---@class AdaptiveCardSettings
---@field version? string defaults to 1.4
---@field body? table[]
---@field actions? table[] 

function Card:new(data, ...)
    if not data then data = {} end

    local cardData = {
        type = 'AdaptiveCard',
        version = data.version or '1.4',
        body = type(data.body) == 'table' and data.body or {},
        actions = type(data.actions) == 'table' and data.actions or {},
    }

    local cardInstance = {
        cardData = cardData
    }

    setmetatable(cardInstance, self)

    self:addElement(...)

    return cardInstance
end

local validCardBodyElements = {
    CardElement, CardColumnSet, CardInput, CardContainer
}

---Add elements to the adapative card
---@param ... CardElement | CardColumnSet | CardInput | CardContainer a tuple of elements
function Card:addElement(...)
    local elements = { ... }
    for i = 1, #elements, 1 do
        local element = elements[i]

        local metatable = getmetatable(element)
        for idx = 1, #validCardBodyElements do
            local metatableElement = validCardBodyElements[idx]

            if metatable == metatableElement then
                goto valid
            end
        end

        error('Invalid element passed through "Card:addElement", it has to be on of: CardElement, CardColumnSet, CardInput, CardContainer', 2)

        ::valid::

        table.insert(self.cardData.body, element:getComponent())
    end
end

---Add action sets to the adapative card
---@param ... CardAction, a tuple of actions
function Card:addAction(...)
    local elements = { ... }
    for i = 1, #elements, 1 do
        local element = elements[i]

        if getmetatable(element) ~= CardAction then
            error('Invalid element passed through "Card:addAction", it has to be a CardAction', 2)
        end

        table.insert(self.cardData.actions, element:getComponent())
    end
end

---convert card to json string
---@param debug? boolean
---@return string
function Card:toJson(debug)
    return json.encode(self.cardData, debug and { indent = true, sort_keys = true } or nil)
end

return Card
