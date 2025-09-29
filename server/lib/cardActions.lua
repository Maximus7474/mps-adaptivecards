local CardAction = {}
CardAction.__index = CardAction

---@class CardAction
---@field cb? fun(relatedData: any, completeData: table): nil
---@field actionData table
---@field getComponent fun(self): table

---@class CardActionOptions
---@field id string
---@field title string
---@field type 'url' | 'submit'
-- ---@field type 'url' | 'submit' | 'showcard' | 'toggle' not sure if all are available ('execute' doesn't seem to work)
---@field tooltip? string
---@field iconUrl? string
---@field url? string required when using type = 'url'
---@field mode? 'primary' | 'secondary'
---@field style? 'Default' | 'Positive' | 'Destructive'

---Create a new action component
---@param data CardActionOptions
---@param args? table<string, any>
---@param cb? fun(relatedData: any, completeData: table): nil not yet implemented
function CardAction:new(data, args, cb)
    if type(data) ~= 'table' then
        error('No data was provided to "CardAction:new"', 2)
    end

    if type(data.id) ~= 'string' then
        error('No id was provided for "CardAction:new", this is required', 2)
    end

    if data.type ~= 'url' and data.type ~= 'submit' then
        error(('An invalid type was passed to "CardAction:new" (received: %s)'):format(data.type), 2)
    end

    local actionType
    if data.type == 'url' then
        actionType = 'Action.OpenUrl'
    elseif data.type == 'submit' then
        actionType = 'Action.Submit'
    end

    local url = nil
    if data.type == 'url' then
        if type(data.url) ~= 'string' then
            error('No string was passed to data.url which is required for type = "url" !', 2)
        end

        url = data.url
    end

    local actionData = {
        type = actionType,

        title = data.title,
        url = url,
        toolTip = data.tooltip,
        mode = data.mode,
        iconUrl = data.iconUrl,
        style = data.style,

        data = args,
    }

    local actionInstanceData = {
        cb = cb,
        actionData = actionData,
    }

    setmetatable(actionInstanceData, self)

    return actionInstanceData
end

function CardAction:getComponent()
    return self.actionData
end

return CardAction
