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

---@class MediaSource
---@field mimeType 'video/mp4' | 'video/webm' | 'audio/mpeg' | 'audio/mp3'
---@field url string

---@class MediaOptions
---@field poster string
---@field sources table<integer, MediaSource> | MediaSource
---@field altText? string

---Add media elements
---@param data MediaOptions
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
        error(('Invalid "sources" value (requires a non empty table) passed in Media'):format(type(data.sources)), 2)
    end

    return {
        type = 'Media',
        poster = data.poster,
        sources = sources,

        altText = data.altText or nil,
    }
end

---@class CardElement
---@field TextBlock fun(data: TextBlockOptions): table create a text block
---@field Image fun(data: ImageOptions): table create an image
---@field Media fun(data: MediaOptions): table create a media element

return CardElement
