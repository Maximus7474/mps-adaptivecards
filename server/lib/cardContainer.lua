local CardElement = require 'server.lib.cardElement'
local CardInput = require 'server.lib.cardInput'
local CardColumnSet = (require 'server.lib.cardColumnSet').CardColumnSet

local CardContainer = {}
CardContainer.__index = CardContainer

---@class CardContainer
---@field elements table
---@field getComponent fun(): table

---@class CardElement: table<string, boolean | string | number>
---@field type string

---@class ContainerAlignement
---@field horizontal? 'Left' | 'Center' | 'Right'
---@field vertical? 'Top' | 'Center' | 'Bottom'
---@field rightToLeft? boolean

---@class ContainerBackground
---@field url? string
---@field mode? 'Cover' | 'RepeatHorizontally' | 'RepeatVertically' | 'Repeat'
---@field horizontal? 'Left' | 'Center' | 'Right'
---@field vertical? 'Top' | 'Center' | 'Bottom'

---@class ContainerOptions
---@field spacing? 'Small' | 'Default' | 'Medium' | 'Large' | 'ExtraLarge' | 'Padding'
---@field style? 'default' | 'emphasis' | 'accent' | 'good' | 'attention' | 'warning'
---@field bleed? boolean 
---@field separator? boolean
---@field height? 'automatic' | 'strech'
---@field minHeight? number in pixels
---@field alignement? ContainerAlignement
---@field background? ContainerBackground

local validContainerElements = {
    CardElement, CardColumnSet, CardInput
}

---Create a container
---@param data ContainerOptions | nil
---@param ...? CardElement | CardColumnSet | CardInput a tuple of elements
function CardContainer:new(data, ...)

    if not data then data = {} end

    local backgroundImage = nil
    if type(data.background) == 'table' then
        if type(data.background.url) ~= 'string' then
            warn(('Invalid "url" value (found %s instead of string) passed in CardContainer for background image'):format(type(data.background.url)))
        else
            backgroundImage = {
                url = data.background.url,
                fillMode = data.background.mode or nil,
                horizontalAlignment = data.background.horizontal or nil,
                verticalAlignment = data.background.vertical or nil,
            }
        end
    end

    local items = {}
    local elements = { ... }
    for i = 1, #elements, 1 do
        local element = elements[i]

        local metatable = getmetatable(element)
        for idx = 1, #validContainerElements do
            local metatableElement = validContainerElements[idx]

            if metatable == metatableElement then
                goto valid
            end
        end

        error('Invalid element passed through "Card:addElement", it has to be on of: CardElement, CardColumnSet, CardInput, CardContainer', 2)

        ::valid::

        table.insert(items, element:getComponent())
    end

    local containerData = {
        type = 'Container',

        spacing = data.spacing or nil,
        style = data.style or nil,
        bleed = data.bleed or nil,
        separator = data.separator or nil,
        height = data.height or nil,
        minHeight = data.minHeight or nil,

        horizontalAlignment = data.alignement?.horizontal or nil,
        verticalContentAlignment = data.alignement?.vertical or nil,
        rtl = data.alignement?.rightToLeft or nil,

        backgroundImage = backgroundImage,

        items = items,
    }

    local containerInstance = {
        containerData = containerData
    }

    setmetatable(containerInstance, self)

    return containerInstance
end

---Add elements to a container
---@param ... CardElement | CardColumnSet | CardInput a tuple of elements
function CardContainer:addElement(...)
    local elements = { ... }
    for i = 1, #elements, 1 do
        local element = elements[i]

        local element = elements[i]

        local metatable = getmetatable(element)
        for idx = 1, #validContainerElements do
            local metatableElement = validContainerElements[idx]

            if metatable == metatableElement then
                goto valid
            end
        end

        error('Invalid element passed through "Card:addElement", it has to be on of: CardElement, CardColumnSet, CardInput, CardContainer', 2)

        ::valid::

        table.insert(self.containerData.items, element:getComponent())
    end
end

function CardContainer:getComponent()
    return self.containerData
end

return CardContainer
