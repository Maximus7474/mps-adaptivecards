local CardColumn = {}
CardColumn.__index = CardColumn

---@class ColumnOptions: ContainerOptions
---@field width? 'auto' | 'stretch' | number in pixels
---@field verticalContentAlignment? 'Top' | 'Center' | 'Bottom'
---@field items? table

---@class CardColumn: CardContainer

function CardColumn:new(data, ...)
    if not data then data = {} end

    local items = { ... }
    for i = 1, #items, 1 do
        local element = items[i]
        if type(element) ~= 'table' or type(element.type) ~= 'string' then
            warn('An invalid object was passed to CardColumn constructor', json.encode(element))
            table.remove(items, i)
        end
    end

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
        items = items,
    }

    local columnInstance = {
        columnData = columnData
    }

    setmetatable(columnInstance, self)

    return columnInstance
end

---add a new element to the column
---@param ... table
function CardColumn:addElement(...)
    local items = { ... }
    for i = 1, #items, 1 do
        local element = items[i]
        if type(element) ~= 'table' or type(element.type) ~= 'string' then
            warn('An invalid object was passed to CardColumn constructor', json.encode(element))
        else
            table.insert(self.columnData.items, element)
        end
    end
end

function CardColumn:getComponent()
    return self.columnData
end


---@class CardColumnSet: CardContainer
---@field columnSetData table
local CardColumnSet = {}
CardColumnSet.__index = CardColumnSet

---@class ColumnSetOptions: ContainerOptions
---@field columns? CardColumn[]

---Create a column set
---@param data ColumnSetOptions | nil
---@param ...? CardColumn
function CardColumnSet:new(data, ...)
    if not data then data = {} end

    local columns = { ... }
    for i = 1, #columns, 1 do
        if getmetatable(columns[i]) ~= CardColumn then
            warn('An invalid object was passed to CardColumnSet constructor. Expected a CardColumn.', json.encode(columns[i]))
            table.remove(columns, i)
        end
    end

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

    for i = 1, #columns, 1 do
        local column = columns[i]
        table.insert(columnSetData.columns, column:getComponent())
    end

    local columnSetInstance = {
        columnSetData = columnSetData
    }

    setmetatable(columnSetInstance, self)

    return columnSetInstance
end

function CardColumnSet:getComponent()
    return self.columnSetData
end

-- Return the new standalone components
return {
    CardColumnSet = CardColumnSet,
    CardColumn = CardColumn
}
