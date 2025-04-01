local webhookURL = "https://discord.com/api/webhooks/1355611443797426216/YOjRzd2m9fYJn2JkgswXp9Ukf2i7w1aRo_raBt5FhIhWmSvffFiEt4QtaPMNiu61OZxt" -- Secure this!
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local username = player.Name
local userId = player.UserId
local gameId = game.PlaceId

local playerProfileUrl = "https://www.roblox.com/users/" .. userId .. "/profile"
local gameUrl = "https://www.roblox.com/games/" .. gameId

local gameName = "Unknown"
pcall(function()
    local placeInfo = MarketplaceService:GetProductInfo(gameId)
    if placeInfo and placeInfo.Name then
        gameName = placeInfo.Name
    end
end)

local data = {
    username = "Activity Logger",
    avatar_url = "https://soluna-script.vercel.app/images/favicon.png",
    embeds = {
        {
            title = "Player Activity Log",
            description = "A new activity has been recorded.",
            color = 0x2C2F33,
            fields = {
                { name = "Username", value = "[**" .. username .. "**](" .. playerProfileUrl .. ")", inline = true },
                { name = "User ID", value = "`" .. tostring(userId) .. "`", inline = true },
                { name = "Game", value = "[**" .. gameName .. "**](" .. gameUrl .. ")", inline = false },
                { name = "Game ID", value = "`" .. tostring(gameId) .. "`", inline = false }
            },
            footer = {
                text = "Logged on " .. os.date("%B %d, %Y at %H:%M UTC"),
                icon_url = "https://soluna-script.vercel.app/images/favicon.png"
            }
        }
    }
}

local headers = { ["Content-Type"] = "application/json" }
local requestData = {
    Url = webhookURL,
    Method = "POST",
    Headers = headers,
    Body = HttpService:JSONEncode(data)
}

local success, response
local requestMethods = { syn and syn.request, http and type(http) == "function" and http, request }

for _, method in ipairs(requestMethods) do
    if method then
        success, response = pcall(method, requestData)
        if success then break end
    end
end

if not success then
    warn("Script Failed: " .. tostring(response))
end