local Card = {}
Card.__index = Card

---@class Card
---@field cardData table<string, string | table> 

---@class AdaptiveCardSettings
---@field version? string defaults to 1.4
---@field body? table[]
---@field actions? table[] 

function Card:new(data)
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

    return cardInstance
end

function Card:addElement(element)
    table.insert(self.cardData.body, element)
end

function Card:toJson()
    return json.encode(self.cardData)
end

return Card
