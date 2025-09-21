local CardElement = {}

---@class TextBlockOptions
---@field text string
---@field size? 'extraLarge' | 'large' | 'medium' | 'default' | 'small'
---@field weight? 'default' | 'bolder'
---@field color? 'default' | 'dark' | 'light' | 'accent' | 'good' | 'warning' | 'attention'
---@field style? 'default' | 'heading' | 'code' | 'list'
---@field fontType? 'default' | 'monospace'
---@field isSubtle? boolean

--- Create a text block
---@param data TextBlockOptions
function CardElement.TextBlock(data)
    if type(data.text) ~= "string" then
        error(('Invalid "text" value (found %s instead of string) passed in TextBlock'):format(type(data.text)), 2)
    end

    return {
        type = "TextBlock",
        text = data.text,

        size = data.size or nil,
        weight = data.weight or nil,
        color = data.color or nil,
        style = data.style or nil,
        fontType = data.fontType or nil,
        isSubtle = data.isSubtle or false,
    }
end

---@class CardElement
---@field TextBlock fun(data: TextBlockOptions): table create a text block

return CardElement
