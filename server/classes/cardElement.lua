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

---@class ImageOptions
---@field url string
---@field altText? string
---@field style? 'default' | 'person'
---@field size? 'auto' | 'stretch' | 'small' | 'medium' | 'large'
---@field alignment? 'Left' | 'Center' | 'Right'

--- Create an image block
---@param data ImageOptions
function CardElement.Image(data)

    if type(data.url) ~= "string" then
        error(('Invalid "url" value (found %s instead of string) passed in Image'):format(type(data.url)), 2)
    end

    return {
        type = "Image",
        url = data.url,

        altText = data.altText or nil,
        style = data.style or nil,
        size = data.size or nil,
        horizontalAlignment = data.alignment or nil,
    }
end

---@class CardElement
---@field TextBlock fun(data: TextBlockOptions): table create a text block
---@field Image fun(data: ImageOptions): table create an image

return CardElement
