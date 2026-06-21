local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Settings = {Aimbot = false, Smooth = 0.1, Chams = false}

local Window = Rayfield:CreateWindow({
    Name = "verfol.cc | Prison Life",
    LoadingTitle = "Loading",
    LoadingSubtitle = "v1.0"
})

local CombatTab = Window:CreateTab("Combat", nil)
local VisualsTab = Window:CreateTab("Visuals", nil)

CombatTab:CreateToggle({Name = "Aimbot", Callback = function(V) Settings.Aimbot = V end})
CombatTab:CreateSlider({Name = "Smoothing", Range = {0.01, 0.5}, Increment = 0.01, CurrentValue = 0.1, Callback = function(V) Settings.Smooth = V end})
VisualsTab:CreateToggle({Name = "Team-Based Chams", Callback = function(V) Settings.Chams = V end})

local function getClosest()
    local c, dist = nil, 600
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Team ~= LocalPlayer.Team then
            local pos, on = Camera:WorldToViewportPoint(p.Character.Head.Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if on and mag < dist then c, dist = p, mag end
        end
    end
    return c
end

RunService.RenderStepped:Connect(function()
    local target = getClosest()
    
    if Settings.Aimbot and target and target.Character:FindFirstChild("Head") then
        local targetPos = target.Character.Head.Position
        local look = CFrame.new(Camera.CFrame.Position, targetPos)
        Camera.CFrame = Camera.CFrame:Lerp(look, Settings.Smooth)
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if Settings.Chams and p.Team and p.Team.Name ~= "Police" then
                if not p.Character:FindFirstChild("Highlight_Obj") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "Highlight_Obj"; h.FillColor = p.TeamColor.Color
                end
            elseif p.Character:FindFirstChild("Highlight_Obj") then
                p.Character.Highlight_Obj:Destroy()
            end
        end
    end
end)
