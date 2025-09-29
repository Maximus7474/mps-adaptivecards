local CardInput = {}
CardInput.__index = CardInput

---@class CardInput
---@field new fun(type: string, data: InputChoiceSetElement|InputToggleElement|InputNumberElement|InputTextElement|InputDateElement|InputTimeElement): CardInput
---@field getComponent fun(): table

---@class InputCommonOptions
---@field id string The unique input id.
---@field label string|nil The label for the input.
---@field value string|number|nil The initial value.
---@field placeholder string|nil The placeholder text.
---@field spacing? 'Small' | 'Default' | 'Medium' | 'Large' | 'ExtraLarge' | 'Padding'
---@field separator? boolean
---@field isRequired? boolean
---@field errorMessage? string

---@class TextBlockElement
---@field text string
---@field size? 'Small' | 'Default' | 'Medium' | 'Large' | 'ExtraLarge'
---@field weight? 'Lighter' | 'Default' | 'Bolder'
---@field color? 'Default' | 'Dark' | 'Light' | 'Accent' | 'Good' | 'Warning' | 'Attention'
---@field isSubtle? boolean
---@field wrap? boolean
---@field maxLines? number
---@field horizontalAlignment? 'Left' | 'Center' | 'Right'
---@field regex? string

---@class InputTextElement: InputCommonOptions
---@field isMultiline? boolean
---@field maxLength? number
---@field style? 'text' | 'tel' | 'url' | 'email'

---@class InputDateElement, InputCommonOptions
---@field min string|nil The minimum date (YYYY-MM-DD).
---@field max string|nil The maximum date (YYYY-MM-DD).

---@class InputTimeElement, InputCommonOptions
---@field min string|nil The minimum time (HH:MM).
---@field max string|nil The maximum time (HH:MM).

---@class InputNumberElement, InputCommonOptions
---@field min number|nil The minimum value.
---@field max number|nil The maximum value.

---@class Choice
---@field title string
---@field value string|number|boolean

---@class InputChoiceSetElement: InputCommonOptions
---@field choices Choice[]
---@field style? 'compact' | 'expanded'
---@field isMultiSelect? boolean
---@field wrap? boolean

---@class InputToggleElement
---@field id string The unique input id.
---@field title string The label for the toggle.
---@field label string|nil The label for the entire input (if different from title).
---@field value string|nil The initial value (usually 'true' or 'false').
---@field valueOff string|nil The value to be written if the toggle is off.
---@field valueOn string|nil The value to be written if the toggle is on.
---@field wrap? boolean
---@field isRequired? boolean
---@field errorMessage? string

local types = {
    choice = 'Input.ChoiceSet',
    text = 'Input.Text',
    date = 'Input.Date',
    time = 'Input.Time',
    number = 'Input.Number',
    toggle = 'Input.Toggle',
}

---@param cardType 'choice' | 'text' | 'date' | 'time' | 'number' | 'toggle'
---@param data InputChoiceSetElement|InputToggleElement|InputNumberElement|InputTextElement|InputDateElement|InputTimeElement
---@return CardInput
function CardInput:new(cardType, data)
    local validatedYype = types[cardType] or nil

    if type(validatedYype) ~= 'string' then
        error('CardInput:new requires a valid "type" string.', 2)
    end

    if type(data.id) ~= 'string' then
        error('CardInput:new requires an "id" string.', 2)
    end

    if not data then data = {} end

    local cardElementData = {
        type = validatedYype
    }

    for key, value in pairs(data) do
        if value ~= nil then
            cardElementData[key] = value
        end
    end

    local cardInputInstance = {
        cardElementData = cardElementData
    }

    setmetatable(cardInputInstance, self)

    return cardInputInstance
end

---@return table
function CardInput:getComponent()
    return self.cardElementData
end

return CardInput
