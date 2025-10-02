local Card = require 'server.lib.card'
local CardElement = require 'server.lib.cardElement'
local CardAction = require 'server.lib.cardActions'
local CardInput = require 'server.lib.cardInput'

-- Obvious enough, does not need an explanation
local PASSWORD = GetConvar('deferrals:password', 'NO_PASSWORD')
-- If it's 0 then it won't limit the attempt number of the user
local MAX_ATTEMPTS = GetConvarInt('deferrals:max_attempts', 0)
-- Should attempts be persistent,
-- hence if the resource/server restarts previous failed attempts still count
local PERSIST_ATTEMPTS = GetConvarInt('deferrals:persist_attempts', 0) == 1

if PASSWORD == 'NO_PASSWORD' then
    warn('Password is still set to the default, please change this !')
end

AddConvarChangeListener('deferrals:password', function ()
    PASSWORD = GetConvar('deferrals:password', 'NO_PASSWORD')
    print('[^3INFO^7]', GetCurrentResourceName(), 'password has been changed.')
end)

-- Keep track of attempts by a user
local attempts = {}

if PERSIST_ATTEMPTS then
    print('[^3INFO^7]', GetCurrentResourceName(), 'initialized with persistent attempts.')
    local kvpAttemptsData = GetResourceKvpString('attempts')

    pcall(function ()
        local parsed = json.decode(kvpAttemptsData)

        if type(parsed) == 'table' then
            attempts = parsed
            print('[^3INFO^7]', GetCurrentResourceName(), 'reloaded previous attempts from kvp.')
        end
    end)
end

---update the attempts in kvp storage, only if PERSIST_ATTEMPTS is enabled
local function storeFailedAttempts()
    if not PERSIST_ATTEMPTS then return end

    SetResourceKvp('attempts', json.encode(attempts))
end

---check if the identifier has exceeded his attempt limit 
---@param identifier string
---@return boolean
local function exceededAttempts(identifier)
    return MAX_ATTEMPTS > 0 and attempts[identifier] and MAX_ATTEMPTS <= attempts[identifier]
end

---update the attempt counter for the player having failed his attempt
---@param name string
---@param identifier string
local function addFailedAttempt(name, identifier)
    attempts[identifier] = (attempts?[identifier] or 0) + 1

    if exceededAttempts(identifier) then
        print(('[^3INFO^7] %s (%s) has exceeded the %d attempt limit for connection password.'):format(name, identifier, MAX_ATTEMPTS))
    end

    storeFailedAttempts()
end

RegisterCommand('clear_attempts', function (source, args, raw)
    if source ~= 0 then return end

    local identifier = args[1]

    if not identifier then
        print('[^3INFO^7] No identifier was provided.')
        return
    end

    if type(attempts[identifier]) ~= 'number' then
        print('[^3INFO^7] The provided identifier doesn\'t have any failed attempts.')
        return
    end

    attempts[identifier] = nil
    storeFailedAttempts()
    print('[^3INFO^7] Attempts were reset for the identifier.')
end)

RegisterCommand('view_attempts', function (source, args, raw)
    if source ~= 0 then return end

    local identifier = args[1]

    if not identifier then
        print('[^3INFO^7] No identifier was provided.')
        return
    end

    if type(attempts[identifier]) ~= 'number' then
        print('[^3INFO^7] The provided identifier doesn\'t have any failed attempts.')
        return
    end

    print(('[^3INFO^7] %s has %d failed attempt(s).'):format(identifier, attempts[identifier]))
end)

---generate the password card and return the json payload
---@param identifier string
---@param previousFailed? boolean has the user's previous attempt failed ?
---@return table cardJson adaptive card json payload as string
local function passwordCard(identifier, previousFailed)
    local card = Card:new(nil,
        CardInput:new('text', {
            id = 'password',
            label = 'This server is password protected, please enter it to obtain access.',
            placeholder = 'Server Password',
        })
    )

    if previousFailed then
        local remainingAttempts = MAX_ATTEMPTS > 0 and (MAX_ATTEMPTS - attempts[identifier]) or false

        card:addElement(
            CardElement.TextBlock({
                isSubtle = true,
                text = ('The previous password was incorrect. Please try again%s'):format(
                    type(remainingAttempts) == 'number' and (' (%d attempts remaining)'):format(remainingAttempts) or ''
                ),
                color = 'warning',
            })
        )
    end

    card:addAction(
        CardAction:new({
            id = 'submitbutton',
            title = 'Submit',
            type = 'submit'
        })
    )

    return card:toJson()
end

---@param name string
---@param setKickReason fun(reason: string) used to set a reason message for when the event is canceled
---@param deferrals Deferrals
local function playerConnectingHandler(name, setKickReason, deferrals)
    local src = source
    local identifier = GetPlayerIdentifierByType(src, 'license')

    if exceededAttempts(identifier) then
        deferrals.done("You've previously entered an invalid password to often, your access is still denied.")
        return
    end

    deferrals.defer()

    Wait(100)

    local function handleSubmission(data)
        local enteredPassword = data.password

        if enteredPassword == PASSWORD then
            deferrals.done()
        else
            addFailedAttempt(name, identifier)

            if exceededAttempts(identifier) then
                deferrals.done("You've entered an invalid password to often, your access is denied.")
            else
                deferrals.presentCard(passwordCard(identifier, true), handleSubmission)
            end
        end
    end

    deferrals.presentCard(passwordCard(identifier), handleSubmission)
end

return playerConnectingHandler
