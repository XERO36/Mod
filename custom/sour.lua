local esp = {}

esp.Settings = {
    TeamCheck = false,
    ColorInTeam = Color3.fromRGB(255, 255, 255),
    EnemyColor = Color3.fromRGB(255, 0, 0)
}

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local HIGHLIGHT_NAME = "ESP_Highlight"

-- FIXED: correct parameter = player
local function getColor(player)
    if esp.Settings.TeamCheck and lp.Team and player.Team then
        if player.Team == lp.Team then
            return esp.Settings.ColorInTeam
        else
            return esp.Settings.EnemyColor
        end
    end

    return esp.Settings.ColorInTeam
end

local function addHighlight(player, character)
    if not character then return end

    local existing = character:FindFirstChild(HIGHLIGHT_NAME)
    if existing then existing:Destroy() end

    local highlight = Instance.new("Highlight")
    highlight.Name = HIGHLIGHT_NAME

    highlight.FillColor = getColor(player)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)

    highlight.FillTransparency = 0.55
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    highlight.Parent = character
end

local function trackPlayer(player)
    local function onCharacterAdded(character)
        task.wait(0.1)
        addHighlight(player, character)
    end

    player.CharacterAdded:Connect(onCharacterAdded)

    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- existing players
for _, player in ipairs(Players:GetPlayers()) do
    trackPlayer(player)
end

-- new players
Players.PlayerAdded:Connect(trackPlayer)

return esp
