local CardElement = require 'server.lib.cardElement'
local CardInput = require 'server.lib.cardInput'

---@class CardColumn: CardContainer
---@field columnData table
local CardColumn = {}
CardColumn.__index = CardColumn

---@class CardColumnSet: CardContainer
---@field columnSetData table
local CardColumnSet = {}
CardColumnSet.__index = CardColumnSet

---@class ColumnOptions: ContainerOptions
---@field width? 'auto' | 'stretch' | number in pixels
---@field verticalContentAlignment? 'Top' | 'Center' | 'Bottom'
---@field items? table

local validColumnElements = {
    CardElement, CardInput
}

---create a new column
---@param ... CardElement | CardInput
function CardColumn:new(data, ...)
    if not data then data = {} end

    local columnData = {
        type = 'Column',
        width = data.width or 'auto',
        verticalContentAlignment = data.verticalContentAlignment or nil,
        spacing = data.spacing or nil,
        style = data.style or nil,
        bleed = data.bleed or nil,
        separator = data.separator or nil,
        height = data.height or nil,
        minHeight = data.minHeight or nil,
        items = {},
    }

    local columnInstance = {
        columnData = columnData
    }

    setmetatable(columnInstance, self)

    if #{ ... } > 0 then
        self.addElements(...)
    end

    return columnInstance
end

---add an element to the column
---@param ... CardElement | CardInput
function CardColumn:addElements(...)
    local elements = { ... }
    for i = 1, #elements, 1 do
        local element = elements[i]

        local metatable = getmetatable(element)
        for idx = 1, #validColumnElements do
            local metatableElement = validColumnElements[idx]

            if metatable == metatableElement then
                goto valid
            end
        end

        error('Invalid element passed through "CardColumn:new", it has to be on of: CardElement, CardInput, CardContainer', 2)

        ::valid::

        table.insert(self.columnData.items, element:getComponent())
    end
end

function CardColumn:getComponent()
    return self.columnData
end

---@class ColumnSetOptions: ContainerOptions
---@field columns? CardColumn[]

---Create a column set
---@param data ColumnSetOptions | nil
---@param ...? CardColumn
function CardColumnSet:new(data, ...)
    if not data then data = {} end

    local columnSetData = {
        type = 'ColumnSet',

        spacing = data.spacing or nil,
        style = data.style or nil,
        bleed = data.bleed or nil,
        separator = data.separator or nil,
        height = data.height or nil,
        minHeight = data.minHeight or nil,

        horizontalAlignment = data.alignement?.horizontal or nil,
        verticalContentAlignment = data.alignement?.vertical or nil,

        columns = {},
    }

    local columnSetInstance = {
        columnSetData = columnSetData
    }

    setmetatable(columnSetInstance, self)

    if #{ ... } > 0 then
        self:addColumn(...)
    end

    return columnSetInstance
end

---add a column to the set 
---@param ... CardColumn
function CardColumnSet:addColumn(...)
    local elements = { ... }
    for i = 1, #elements, 1 do
        local element = elements[i]

        if getmetatable(element) == CardColumn then
            goto valid
        end

        error('Invalid element passed through "CardColumnSet:new", it has to be CardColumn', 2)

        ::valid::

        table.insert(self.columnSetData.items, element:getComponent())
    end
end

function CardColumnSet:getComponent()
    return self.columnSetData
end

return {
    CardColumnSet = CardColumnSet,
    CardColumn = CardColumn
}
