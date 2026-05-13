local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- UI container
local gui = Instance.new("ScreenGui")
gui.Name = "OffscreenArrows"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local arrows = {}

local function createArrow(player)
    local img = Instance.new("ImageLabel")
    img.Name = "Arrow"
    img.Size = UDim2.fromOffset(24, 24)
    img.AnchorPoint = Vector2.new(0.5, 0.5)
    img.BackgroundTransparency = 1

    -- YOUR ASSET
    img.Image = "rbxassetid://15000587389"

    img.Visible = false
    img.Parent = gui

    arrows[player] = img
end

local function removeArrow(player)
    if arrows[player] then
        arrows[player]:Destroy()
        arrows[player] = nil
    end
end

local function trackPlayer(player)
    createArrow(player)
end

-- existing players
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= lp then
        trackPlayer(p)
    end
end

-- new players
Players.PlayerAdded:Connect(function(p)
    if p ~= lp then
        trackPlayer(p)
    end
end)

Players.PlayerRemoving:Connect(removeArrow)

-- update loop (single, optimized)
RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    for player, arrow in pairs(arrows) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if hrp then
            local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)

            if not onScreen then
                arrow.Visible = true

                local dir = (Vector2.new(pos.X, pos.Y) - screenCenter)
                if dir.Magnitude > 0 then
                    dir = dir.Unit
                end

                local angle = math.deg(math.atan2(dir.Y, dir.X))

                -- position arrow near screen edge
                local distanceFromCenter = 180
                arrow.Position = UDim2.fromOffset(
                    screenCenter.X + dir.X * distanceFromCenter,
                    screenCenter.Y + dir.Y * distanceFromCenter
                )

                arrow.Rotation = angle + 90
            else
                arrow.Visible = false
            end
        else
            arrow.Visible = false
        end
    end
end)
