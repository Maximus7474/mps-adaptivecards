local CardElement = {}
CardElement.__index = CardElement

---@class AdaptiveCardElement: table<string, boolean | string | number | table>
---@field type string
---@field getComponent fun(): table

---@class TextBlockOptions
---@field text string
---@field size? 'extraLarge' | 'large' | 'medium' | 'default' | 'small'
---@field weight? 'default' | 'bolder'
---@field color? 'default' | 'dark' | 'light' | 'accent' | 'good' | 'warning' | 'attention'
---@field style? 'default' | 'heading' | 'code' | 'list'
---@field fontType? 'default' | 'monospace'
---@field isSubtle? boolean
---@field wrap? boolean
---@field maxLines? number
---@field horizontalAlignment? 'Left' | 'Center' | 'Right'

---@class ImageOptions
---@field url string
---@field altText? string
---@field style? 'default' | 'person'
---@field size? 'auto' | 'stretch' | 'small' | 'medium' | 'large'
---@field alignment? 'Left' | 'Center' | 'Right'

---@class MediaSource
---@field mimeType 'video/mp4' | 'video/webm' | 'audio/mpeg' | 'audio/mp3'
---@field url string

---@class MediaOptions
---@field poster string
---@field sources table<integer, MediaSource> | MediaSource
---@field altText? string

---@param cardType string The type of the element.
---@param data table The properties of the element.
---@return CardElement
function CardElement:new(cardType, data)
    if type(cardType) ~= 'string' then
        error("CardElement:new requires a 'type' string.", 2)
    end

    if not data then data = {} end

    local cardElementData = {
        type = cardType
    }

    -- Merge properties from the data table
    for key, value in pairs(data) do
        if value ~= nil then
            cardElementData[key] = value
        end
    end

    local cardElementInstance = {
        cardElementData = cardElementData
    }

    setmetatable(cardElementInstance, self)

    return cardElementInstance
end

---@return table
function CardElement:getComponent()
    return self.cardElementData
end

---@param data TextBlockOptions
---@return CardElement
function CardElement.TextBlock(data)
    if type(data.text) ~= "string" then
        error(('Invalid "text" value (found %s instead of string) passed in TextBlock'):format(type(data.text)), 2)
    end

    local props = {
        text = data.text,
        size = data.size,
        weight = data.weight,
        color = data.color,
        style = data.style,
        fontType = data.fontType,
        isSubtle = data.isSubtle or false,
        wrap = data.wrap,
        maxLines = data.maxLines,
        horizontalAlignment = data.horizontalAlignment,
    }

    return CardElement:new("TextBlock", props)
end

---@param data ImageOptions
---@return CardElement
function CardElement.Image(data)
    if type(data.url) ~= "string" then
        error(('Invalid "url" value (found %s instead of string) passed in Image'):format(type(data.url)), 2)
    end

    local props = {
        url = data.url,
        altText = data.altText,
        style = data.style,
        size = data.size,
        horizontalAlignment = data.alignment,
    }

    return CardElement:new("Image", props)
end

---@param data MediaOptions
---@return CardElement
function CardElement.Media(data)
    if type(data.poster) ~= 'string' then
        error(('Invalid "poster" value (found %s instead of string) passed in Media'):format(type(data.poster)), 2)
    end

    if type(data.sources) ~= "table" then
        error(('Invalid "sources" value (found %s instead of table) passed in Media'):format(type(data.sources)), 2)
    end

    local sources = {}

    if type(data.sources.url) == 'string' then
        table.insert(sources, data.sources)
    elseif #data.sources > 0 then
        sources = data.sources
    end

    if #sources == 0 then
        error('Invalid "sources" value (requires a non-empty table) passed in Media', 2)
    end

    local props = {
        poster = data.poster,
        sources = sources,
        altText = data.altText,
    }

    return CardElement:new("Media", props)
end

return CardElement
