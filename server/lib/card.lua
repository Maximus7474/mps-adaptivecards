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

---Add elements to the adapative card
---@param ... CardElement a tuple of elements
function Card:addElement(...)
    local elements = { ... }
    for i = 1, #elements, 1 do
        local element = elements[i]

        if type(element.type) ~= 'string' then
            warn('An invalid object was passed to Card:addElement', json.encode(element))
        else
            table.insert(self.cardData.body, element)
        end
    end
end

---Add action sets to the adapative card
---@param ... table, a tuple of actions
function Card:addAction(...)
    local elements = { ... }
    for i = 1, #elements, 1 do
        local element = elements[i]

        if type(element.type) ~= 'string' then
            warn('An invalid object was passed to Card:addAction', json.encode(element))
        else
            table.insert(self.cardData.actions, element)
        end
    end
end

---convert card to json string
---@param debug? boolean
---@return string
function Card:toJson(debug)
    return json.encode(self.cardData, debug and { indent = true, sort_keys = true } or nil)
end

return Card
