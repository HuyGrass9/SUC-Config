repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local t_wait, t_spawn = task.wait, task.spawn
local m_random, m_floor, m_huge = math.random, math.floor, math.huge
local s_format = string.format
local v3_new = Vector3.new

local S = {
    P = game:GetService("Players"),
    W = game:GetService("Workspace"),
    RS = game:GetService("RunService"),
    V = game:GetService("VirtualInputManager"),
    L = game:GetService("Lighting"),
    ST = game:GetService("Stats"),
    GS = game:GetService("GuiService"),
    TS = game:GetService("TeleportService"),
    HTTP = game:GetService("HttpService")
}
local LP = S.P.LocalPlayer

t_spawn(function()
    pcall(function()
        S.GS.ErrorMessageChanged:Connect(function()
            t_wait(3)
            pcall(function() S.TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) end)
        end)
    end)
end)

local TargetUI = nil
pcall(function() TargetUI = gethui() end)
if not TargetUI then pcall(function() TargetUI = game:GetService("CoreGui") end) end
if not TargetUI then TargetUI = LP:WaitForChild("PlayerGui") end

pcall(function()
    for _, v in ipairs(TargetUI:GetChildren()) do if v.Name:match("MayChemXeoCan") then v:Destroy() end end
end)

local function CreateNode(className, props, parent)
    local node = Instance.new(className)
    for k, v in pairs(props) do node[k] = v end
    if parent then node.Parent = parent end
    return node
end

local UI = CreateNode("ScreenGui", {Name = "MayChemXeoCan_UI", ResetOnSpawn = false}, TargetUI)

local Core = {
    FpsBox = CreateNode("Frame", {Size = UDim2.new(0, 120, 0, 30), Position = UDim2.new(0.02, 0, 0.05, 0), BackgroundColor3 = Color3.fromRGB(15, 15, 20), BackgroundTransparency = 0.2, BorderSizePixel = 2, BorderColor3 = Color3.fromRGB(0, 255, 100), Active = true, Draggable = true}, UI),
    MainBox = CreateNode("Frame", {Size = UDim2.new(0, 300, 0, 200), Position = UDim2.new(0.02, 0, 0.3, 30), BackgroundColor3 = Color3.fromRGB(10, 10, 15), BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(0, 255, 100), Active = true, Draggable = true}, UI)
}
CreateNode("UICorner", {CornerRadius = UDim.new(0, 6)}, Core.FpsBox)
CreateNode("UICorner", {CornerRadius = UDim.new(0, 4)}, Core.MainBox)

local T_Fps = CreateNode("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "FPS: --", TextColor3 = Color3.fromRGB(0, 255, 100), Font = Enum.Font.GothamBold, TextSize = 14}, Core.FpsBox)
CreateNode("TextLabel", {Size = UDim2.new(1, 0, 0, 25), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = "> MayChemXeoCan_Core_V7.1", TextColor3 = Color3.fromRGB(0, 255, 100), Font = Enum.Font.Code, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left}, Core.MainBox)

local LogScroll = CreateNode("ScrollingFrame", {Size = UDim2.new(1, -10, 0.55, 0), Position = UDim2.new(0, 5, 0, 25), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100), AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new()}, Core.MainBox)
CreateNode("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, LogScroll)

local StatContainer = CreateNode("Frame", {Size = UDim2.new(1, -10, 0.3, 0), Position = UDim2.new(0, 5, 0.55, 25), BackgroundTransparency = 1}, Core.MainBox)
CreateNode("UIListLayout", {Padding = UDim.new(0, 4)}, StatContainer)

local function MakeStat(name, default)
    local row = CreateNode("Frame", {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1}, StatContainer)
    CreateNode("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, Text = name, TextColor3 = Color3.fromRGB(180, 180, 180), Font = Enum.Font.Code, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, row)
    return CreateNode("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1, Text = default, TextColor3 = Color3.fromRGB(0, 255, 100), Font = Enum.Font.Code, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right}, row)
end
local T_Ram = MakeStat("[SYS] RAM Load:", "0 MB")
local T_Ping = MakeStat("[NET] Ping:", "0 ms")

local Logger = {Count = 0}
function Logger.Write(module, status, color)
    pcall(function()
        Logger.Count = Logger.Count + 1
        CreateNode("TextLabel", {Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, TextColor3 = color or Color3.fromRGB(0, 255, 100), Font = Enum.Font.Code, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = Logger.Count, Text = s_format("[%s] %s -> %s", os.date("%H:%M:%S"), module, status)}, LogScroll)
        LogScroll.CanvasPosition = Vector2.new(0, 99999)
    end)
end

local Engine = {FC = 0}
S.RS.RenderStepped:Connect(function() Engine.FC = Engine.FC + 1 end)

t_spawn(function()
    while t_wait(1) do
        pcall(function()
            local fps = Engine.FC
            Engine.FC = 0
            T_Fps.Text = "FPS: " .. fps
            T_Fps.TextColor3 = fps >= 40 and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 80, 80)
            if Core.MainBox.Visible then
                local ram = m_floor(S.ST:GetTotalMemoryUsageMb())
                T_Ram.Text = ram .. " MB"
                T_Ram.TextColor3 = ram < 1000 and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 150, 0)
                local s, r = pcall(function() return LP:GetNetworkPing() * 1000 end)
                T_Ping.Text = (s and m_floor(r) or "N/A") .. " ms"
            end
        end)
    end
end)

Logger.Write("System", "Init Modules...", Color3.fromRGB(200, 200, 200))

t_spawn(function()
    pcall(function()
        settings().Rendering.QualityLevel = 1
        S.L.GlobalShadows = false
        S.L.FogEnd = 9e9
        for _, v in ipairs(S.L:GetDescendants()) do if v:IsA("PostEffect") then v.Enabled = false end end
        Logger.Write("RenderEngine", "FPS Boosted", Color3.fromRGB(0, 255, 100))
    end)
end)

if getgenv().Setting and getgenv().Setting.DeleteMap then
    t_spawn(function()
        pcall(function()
            for _, v in ipairs(S.W:GetDescendants()) do if v:IsA("Part") and v.Transparency < 1 then v.CanCollide = false end end
            Logger.Write("MapOptimizer", "Map wiped", Color3.fromRGB(0, 255, 100))
        end)
    end)
end

local function GetTarget()
    if not LP.Character then return nil end
    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local cfg = getgenv().Setting.Targeting_Advanced
    local pos = hrp.Position
    local best, minH, maxD = nil, m_huge, 15000
    for _, v in ipairs(S.P:GetPlayers()) do
        if v ~= LP and v.Team ~= LP.Team and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and not (cfg.Ignore_Friends and LP:IsFriendsWith(v.UserId)) and not (cfg.Ignore_ForceField and v.Character:FindFirstChildOfClass("ForceField")) then
            local e_hrp = v.Character:FindFirstChild("HumanoidRootPart")
            if e_hrp then
                local d = (e_hrp.Position - pos).Magnitude
                if d <= maxD then
                    if cfg.Priority_Mode == "Lowest Health" then
                        if v.Character.Humanoid.Health < minH then minH = v.Character.Humanoid.Health; best = v.Character end
                    elseif d < maxD then
                        maxD = d; best = v.Character
                    end
                end
            end
        end
    end
    return best
end

t_spawn(function()
    Logger.Write("Prediction_Engine", "Loaded", Color3.fromRGB(0, 255, 100))
    while t_wait(0.1) do
        pcall(function()
            getgenv().CurrentTarget = GetTarget()
            if LP.Character and getgenv().CurrentTarget and getgenv().Setting.Hitbox.Enabled then
                local e_hrp = getgenv().CurrentTarget:FindFirstChild("HumanoidRootPart")
                if e_hrp then
                    local s = getgenv().Setting.Hitbox.Size
                    local p_time = getgenv().Setting["Aim Prediction"] or 0.185
                    local pred_offset = e_hrp.AssemblyLinearVelocity * p_time
                    
                    e_hrp.Size = v3_new(s, s, s)
                    e_hrp.Transparency = getgenv().Setting.Hitbox.Transparency
                    e_hrp.CanCollide = false
                    
                    if pred_offset.Magnitude > 1 then
                        e_hrp.CFrame = e_hrp.CFrame + v3_new(pred_offset.X, 0, pred_offset.Z)
                    end
                end
            end
        end)
    end
end)

t_spawn(function()
    Logger.Write("Anti_Sus_System", "Loaded", Color3.fromRGB(0, 255, 100))
    local t_jump, keys = tick(), {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
    while t_wait(m_random(1, 3) / 10) do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health > 0 then
                if getgenv().Setting.Misc["Auto Jump"] and tick() - t_jump >= 4 then
                    S.V:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    t_wait(0.05)
                    S.V:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    t_jump = tick()
                end
                if getgenv().CurrentTarget then
                    local k = keys[m_random(1, #keys)]
                    S.V:SendKeyEvent(true, k, false, game)
                    t_wait(m_random(5, 15) / 100)
                    S.V:SendKeyEvent(false, k, false, game)
                end
            end
        end)
    end
end)

t_spawn(function()
    while t_wait(0.5) do
        pcall(function()
            if getgenv().CurrentTarget and LP.Character and getgenv().Setting["Method Click"]["Click Fruit"] then
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if not (tool and (tool.ToolTip == "Blox Fruit" or tool.Name:match("Fruit"))) then
                    for _, t in ipairs(LP.Backpack:GetChildren()) do
                        if t:IsA("Tool") and (t.ToolTip == "Blox Fruit" or t.Name:match("Fruit")) then
                            LP.Character.Humanoid:EquipTool(t)
                            break
                        end
                    end
                end
            end
        end)
    end
end)

t_spawn(function()
    t_wait(15)
    pcall(function()
        if Core.MainBox then Core.MainBox.Visible = false end
    end)
end)

t_spawn(function()
    t_wait(600)
    pcall(function()
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Desc&limit=100")
        if req then
            local data = S.HTTP:JSONDecode(req)
            if data and data.data then
                for _, v in ipairs(data.data) do
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                        S.TS:TeleportToPlaceInstance(game.PlaceId, v.id, LP)
                        t_wait(1)
                    end
                end
            end
        end
    end)
end)
