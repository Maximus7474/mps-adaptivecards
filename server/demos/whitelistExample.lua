local Card = require 'server.lib.card'
local CardElement = require 'server.lib.cardElement'
local CardContainer = require 'server.lib.cardContainer'
local CardAction = require 'server.lib.cardActions'
local CardInput = require 'server.lib.cardInput'
local CardColumnClasses = require 'server.lib.cardColumnSet'
local CardColumnSet, CardColumn = CardColumnClasses.CardColumnSet, CardColumnClasses.CardColumn

local DISCORD_TOKEN = 'INSERT_TOKEN'
local GUILD_ID = 'GUILD_ID'
local WHITELISTED_ROLES --[[ @as string[] | false ]] = false -- { 'role_id' }
local GUILD_INVITE = 'https://social.mtdv.me/BGaUHUw2SM'

if #DISCORD_TOKEN < 70 then
    error('An invalid DISCORD_TOKEN was set.')
end

if string.match(GUILD_ID, "^%d+$") then
    error('An invalid GUILD_ID was set.')
end

---checks if a discord id is a guild member and has at least one whitelisted role
---@param discordId string
---@return boolean isMember
---@return boolean hasRole defaults to true if no WHITELISTED_ROLES are specified 
local function isUserWhitelisted(discordId)
    local isMemberPromise = promise.new()
    local hasWhitelistRolePromise = promise.new()

    if type(WHITELISTED_ROLES) ~= 'table' or #WHITELISTED_ROLES == 0 then
        hasWhitelistRolePromise:resolve(true)
    end

    PerformHttpRequest(
        string.format(
            'https://discord.com/api/v10/guilds/%s/members/%s',
            GUILD_ID, discordId
        ),
        function(statusCode, resultData, resultHeaders)
            local hasRequiredRole = false

            -- if status is 200, the user is a guild member
            local isMember = statusCode == 200
            isMemberPromise:resolve(isMember)

            if isMember then
                local memberData = json.decode(resultData)

                if type(WHITELISTED_ROLES) == 'table' and #WHITELISTED_ROLES > 0 then
                    if memberData and memberData.roles and type(memberData.roles) == 'table' then
                        for _, memberRole in ipairs(memberData.roles) do
                            for _, whitelistRole in ipairs(WHITELISTED_ROLES) do
                                if memberRole == whitelistRole then
                                    hasRequiredRole = true
                                    break
                                end
                            end
                            if hasRequiredRole then break end
                        end
                    end

                    hasWhitelistRolePromise:resolve(hasRequiredRole)
                end

            else
                hasWhitelistRolePromise:resolve(false)
            end
        end, {
            ['Authorization'] = string.format('Bot %s', DISCORD_TOKEN),
            ['Content-Type'] = 'application/json'
        }, 'GET', ''
    )

    return Citizen.Await(isMemberPromise), Citizen.Await(hasWhitelistRolePromise)
end

---generate the not linked card to guide the user on how to link his discord account
---@param src string
---@param name string
---@return string cardJson payload to display the adaptive card
local function discordNotLinkedCard(src, name)
    local card = Card:new({},
        CardColumnSet:new(
            {
                alignement = {
                    vertical = 'Top',
                    horizontal = 'Left',
                    rightToLeft = false,
                },
                spacing = 'Large',
                separator = true,
            },
            CardColumn:new({},
                CardElement.Image({
                    url = 'https://static.vecteezy.com/system/resources/previews/006/892/625/non_2x/discord-logo-icon-editorial-free-vector.jpg',
                    alignment = 'Center',
                    size = 'medium',
                })
            ),
            CardColumn:new({},
                CardElement.TextBlock({
                    text = ('Hello, %s!'):format(name),
                    style = 'heading',
                }),
                CardElement.TextBlock({
                    text = "It seems like haven't linked your discord account to fivem, you'll need to do so before connecting to this server.\n" ..
                        "Once this is done, you'll be able to connect to the server.",
                    style = 'default',
                })
            )
        )
    )

    card:addAction(
        CardAction:new({
            id = 'forum_post_url',
            title = 'How to link your discord account',
            type = 'url',
            url = 'https://forum.cfx.re/t/1013225/3',
        })
    )

    return card:toJson()
end

---generate the card if user hasn't joined the discord guild
---@param src string
---@param name string
---@return string cardJson payload to display the adaptive card
local function notAGuildMemberCard(src, name)
    local card = Card:new({},
        CardColumnSet:new(
            {
                alignement = {
                    vertical = 'Top',
                    horizontal = 'Left',
                    rightToLeft = false,
                },
                spacing = 'Large',
                separator = true,
            },
            CardColumn:new({},
                CardElement.Image({
                    url = 'https://static.vecteezy.com/system/resources/previews/006/892/625/non_2x/discord-logo-icon-editorial-free-vector.jpg',
                    alignment = 'Center',
                    size = 'medium',
                })
            ),
            CardColumn:new({},
                CardElement.TextBlock({
                    text = ('Hello, %s!'):format(name),
                    style = 'heading',
                }),
                CardElement.TextBlock({
                    text = "You have not yet joined our discord guild, this is a required step to join our server.\nYou can join by clicking the button below.",
                    style = 'default',
                })
            )
        )
    )

    card:addAction(
        CardAction:new({
            id = 'guild_invite',
            title = 'Discord Invite',
            type = 'url',
            url = GUILD_INVITE,
        })
    )

    return card:toJson()
end

---generate the not whitelisted card
---@param src string
---@param name string
---@return string cardJson payload to display the adaptive card
local function notWhitelistedCard(src, name)
    local card = Card:new({},
        CardColumnSet:new(
            {
                alignement = {
                    vertical = 'Top',
                    horizontal = 'Left',
                    rightToLeft = false,
                },
                spacing = 'Large',
                separator = true,
            },
            CardColumn:new({},
                CardElement.Image({
                    url = 'https://static.vecteezy.com/system/resources/previews/006/892/625/non_2x/discord-logo-icon-editorial-free-vector.jpg',
                    alignment = 'Center',
                    size = 'medium',
                })
            ),
            CardColumn:new({},
                CardElement.TextBlock({
                    text = ('Hello, %s!'):format(name),
                    style = 'heading',
                }),
                CardElement.TextBlock({
                    text = "It seems like you are not yet whitelisted on our discord server, the whitelist is required to be able to join our server.",
                    style = 'default',
                }),
                CardElement.TextBlock({
                    text = "To become whitelisted, please follow the steps listed in {discord_channel}",
                    style = 'default',
                })
            )
        )
    )

    return card:toJson()
end

---@param name string
---@param setKickReason fun(reason: string) used to set a reason message for when the event is canceled
---@param deferrals Deferrals
return function (name, setKickReason, deferrals)
    local src = source
    local identifier = GetPlayerIdentifierByType(source, 'discord')

    deferrals.defer()

    -- You have to wait a minimum before displaying the card
    -- else you'll have a wail of a time debugging
    Wait(100)

    if not identifier then
        setKickReason('No linked discord account.')

        local card = discordNotLinkedCard(src, name)
        deferrals.presentCard(card)
        return
    end

    local discordId = string.sub(identifier, 9)

    local isGuildMember, isWhitelisted = isUserWhitelisted(discordId)

    if isGuildMember and isWhitelisted then
        deferrals.done()
    elseif isGuildMember and not isWhitelisted then
        setKickReason('Not whitelisted.')

        local card = notWhitelistedCard(src, name)
        deferrals.presentCard(card)
    elseif not isGuildMember then
        setKickReason('Not in the discord guild.')

        local card = notAGuildMemberCard(src, name)
        deferrals.presentCard(card)
    end
end
