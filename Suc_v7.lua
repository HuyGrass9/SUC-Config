repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
local S = {
    P = game:GetService("Players"), W = game:GetService("Workspace"),
    RS = game:GetService("RunService"), V = game:GetService("VirtualInputManager"),
    L = game:GetService("Lighting"), ST = game:GetService("Stats"),
    GS = game:GetService("GuiService"), TS = game:GetService("TeleportService"),
    HTTP = game:GetService("HttpService"), CG = game:GetService("CoreGui")
}
local LP = S.P.LocalPlayer
local t_wait, t_spawn = task.wait, task.spawn
local m_random, m_floor, m_huge = math.random, math.floor, math.huge
local v3_new, cf_new = Vector3.new, CFrame.new
t_spawn(function()
    pcall(function()
        S.GS.ErrorMessageChanged:Connect(function()
            t_wait(2)
            S.TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end)
    end)
end)
local TargetUI = pcall(gethui) and gethui() or S.CG
pcall(function()
    for _, v in ipairs(TargetUI:GetChildren()) do if v.Name:match("QuantumV7") then v:Destroy() end end
end)
local function Create(cls, props, parent)
    local ins = Instance.new(cls)
    for k, v in pairs(props) do ins[k] = v end
    if parent then ins.Parent = parent end
    return ins
end
local UI = Create("ScreenGui", {Name = "QuantumV712", ResetOnSpawn = false}, TargetUI)
local Main = Create("Frame", {Size = UDim2.new(0, 300, 0, 180), Position = UDim2.new(0.015, 0, 0.3, 0), BackgroundColor3 = Color3.fromRGB(12, 12, 12), BackgroundTransparency = 0.1, Active = true, Draggable = true, ClipsDescendants = true}, UI)
Create("UICorner", {CornerRadius = UDim.new(0, 6)}, Main)
Create("UIStroke", {Color = Color3.fromRGB(0, 170, 255), Thickness = 1.5, Transparency = 0.2}, Main)
local Header = Create("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Color3.fromRGB(20, 20, 20), BorderSizePixel = 0}, Main)
Create("UICorner", {CornerRadius = UDim.new(0, 6)}, Header)
Create("TextLabel", {Size = UDim2.new(1, -15, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = "SUC_CORE :: V7.12 FINAL", TextColor3 = Color3.fromRGB(0, 170, 255), Font = Enum.Font.GothamBlack, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Header)
local T_Wep = Create("TextLabel", {Size = UDim2.new(0.35, 0, 0, 25), Position = UDim2.new(0, 10, 0, 32), BackgroundTransparency = 1, Text = "WEAPON: SYNC", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left}, Main)
local T_Timeout = Create("TextLabel", {Size = UDim2.new(0.65, -20, 0, 25), Position = UDim2.new(0.35, 0, 0, 32), BackgroundTransparency = 1, Text = "T/O: --", TextColor3 = Color3.fromRGB(255, 80, 80), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right}, Main)
local LogBox = Create("ScrollingFrame", {Size = UDim2.new(1, -20, 0, 85), Position = UDim2.new(0, 10, 0, 60), BackgroundTransparency = 1, ScrollBarThickness = 1, CanvasSize = UDim2.new(), ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)}, Main)
Create("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, LogBox)
local Foot = Create("Frame", {Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 1, -28), BackgroundTransparency = 1}, Main)
local T_Ping = Create("TextLabel", {Size = UDim2.new(0.33, 0, 1, 0), BackgroundTransparency = 1, Text = "PING: 0", TextColor3 = Color3.fromRGB(150, 150, 150), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left}, Foot)
local T_FPS = Create("TextLabel", {Size = UDim2.new(0.33, 0, 1, 0), Position = UDim2.new(0.33, 0, 0, 0), BackgroundTransparency = 1, Text = "FPS: 0", TextColor3 = Color3.fromRGB(150, 150, 150), Font = Enum.Font.GothamBold, TextSize = 11}, Foot)
local T_Hop = Create("TextLabel", {Size = UDim2.new(0.34, 0, 1, 0), Position = UDim2.new(0.66, 0, 0, 0), BackgroundTransparency = 1, Text = "HOP: 600s", TextColor3 = Color3.fromRGB(255, 100, 100), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right}, Foot)
local LogC = 0
local function Log(txt, col)
    pcall(function()
        LogC = LogC + 1
        Create("TextLabel", {Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, Text = string.format(">[%s] %s", os.date("%H:%M:%S"), txt), TextColor3 = col or Color3.fromRGB(200, 200, 200), Font = Enum.Font.Code, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = LogC}, LogBox)
        LogBox.CanvasPosition = Vector2.new(0, 99999)
    end)
end
local Engine = {FC = 0, HopTime = 600}
S.RS.RenderStepped:Connect(function() Engine.FC = Engine.FC + 1 end)
t_spawn(function()
    while t_wait(1) do
        pcall(function()
            T_FPS.Text = "FPS: " .. Engine.FC
            Engine.FC = 0
            T_Ping.Text = "PING: " .. m_floor((LP:GetNetworkPing() or 0) * 1000)
            Engine.HopTime = Engine.HopTime - 1
            if Engine.HopTime >= 0 then T_Hop.Text = "HOP: " .. Engine.HopTime .. "s" end
        end)
    end
end)
t_spawn(function()
    pcall(function()
        settings().Rendering.QualityLevel = 1
        S.L.GlobalShadows = false
        S.L.FogEnd = 9e9
        for _, v in ipairs(S.L:GetDescendants()) do if v:IsA("PostEffect") then v.Enabled = false end end
        if getgenv().Setting and getgenv().Setting.DeleteMap then
            for _, v in ipairs(S.W:GetDescendants()) do if v:IsA("Part") and v.Transparency < 1 then v.CanCollide = false end end
        end
        Log("V7.12 Loaded. Displaying Target Name.", Color3.fromRGB(0, 170, 255))
    end)
end)
local Blacklist = {}
local function GetTarget()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local pos = LP.Character.HumanoidRootPart.Position
    local best, minH, maxD = nil, m_huge, 15000
    local cfg = getgenv().Setting.Targeting_Advanced or {}
    for _, v in ipairs(S.P:GetPlayers()) do
        if Blacklist[v.Name] and tick() - Blacklist[v.Name] < 300 then
            pcall(function() if v.Character and v.Character:FindFirstChild("Humanoid") then v.Character.Humanoid:Destroy() end end)
            continue
        end
        if v ~= LP and v.Team ~= LP.Team and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if cfg.Ignore_Friends and LP:IsFriendsWith(v.UserId) then continue end
            if cfg.Ignore_ForceField and v.Character:FindFirstChildOfClass("ForceField") then continue end
            local e_hrp = v.Character:FindFirstChild("HumanoidRootPart")
            if e_hrp then
                local d = (e_hrp.Position - pos).Magnitude
                if d <= maxD then
                    if cfg.Priority_Mode == "Lowest Health" then
                        if v.Character.Humanoid.Health < minH then minH = v.Character.Humanoid.Health; best = v.Character end
                    else maxD = d; best = v.Character end
                end
            end
        end
    end
    return best
end
local cTargName, tStart = nil, 0
t_spawn(function()
    while t_wait(0.1) do
        pcall(function()
            getgenv().CurrentTarget = GetTarget()
            local t = getgenv().CurrentTarget
            if t and t:FindFirstChild("Humanoid") and t:FindFirstChild("HumanoidRootPart") then
                if t.Name ~= cTargName then
                    cTargName = t.Name
                    tStart = tick()
                    T_Timeout.Text = string.upper(t.Name) .. " | T/O: 120s"
                else
                    local elapsed = tick() - tStart
                    local timeLeft = m_floor(120 - elapsed)
                    if timeLeft < 0 then timeLeft = 0 end
                    T_Timeout.Text = string.upper(t.Name) .. " | T/O: " .. timeLeft .. "s"
                    if elapsed >= 120 then
                        Blacklist[t.Name] = tick()
                        pcall(function() t.Humanoid:Destroy() end)
                        Log("TIMEOUT: TARGET ERASED!", Color3.fromRGB(255, 80, 80))
                        getgenv().CurrentTarget = nil
                        cTargName = nil
                        T_Timeout.Text = "T/O: --"
                    end
                end
            else
                cTargName = nil
                T_Timeout.Text = "T/O: --"
            end
        end)
    end
end)
t_spawn(function()
    local stuckTimer = 0
    while t_wait(1) do
        pcall(function()
            if not getgenv().CurrentTarget and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                stuckTimer = stuckTimer + 1
                if stuckTimer >= 6 then
                    Log("STUCK! FINDING PORTAL...", Color3.fromRGB(255, 255, 0))
                    local escaped = false
                    local myHRP = LP.Character.HumanoidRootPart
                    if S.W:FindFirstChild("Map") and S.W.Map:FindFirstChild("Portals") then
                        for _, portal in ipairs(S.W.Map.Portals:GetChildren()) do
                            if portal:IsA("BasePart") then
                                myHRP.CFrame = portal.CFrame * cf_new(0, 0, 10)
                                escaped = true
                                break
                            end
                        end
                    end
                    if not escaped and S.W:FindFirstChild("_WorldOrigin") and S.W._WorldOrigin:FindFirstChild("PlayerSpawns") then
                        local teamSpawns = S.W._WorldOrigin.PlayerSpawns:FindFirstChild(tostring(LP.Team)) or S.W._WorldOrigin.PlayerSpawns:FindFirstChild("Pirates")
                        if teamSpawns then
                            for _, spawnPt in ipairs(teamSpawns:GetChildren()) do
                                if spawnPt:IsA("BasePart") then
                                    myHRP.CFrame = spawnPt.CFrame + v3_new(0, 10, 0)
                                    escaped = true
                                    break
                                end
                            end
                        end
                    end
                    if not escaped then
                        myHRP.CFrame = cf_new(0, 50, 0) 
                    end
                    stuckTimer = 0
                    Log("ESCAPED TO PORTAL!", Color3.fromRGB(0, 255, 100))
                end
            else
                stuckTimer = 0
            end
        end)
    end
end)
local function GetWeaponByToolTip(tip)
    if not LP.Character then return nil end
    for _, v in ipairs(LP.Backpack:GetChildren()) do
        if v:IsA("Tool") and (v.ToolTip == tip or v.Name:match(tip)) then return v end
    end
    for _, v in ipairs(LP.Character:GetChildren()) do
        if v:IsA("Tool") and (v.ToolTip == tip or v.Name:match(tip)) then return v end
    end
    return nil
end
t_spawn(function()
    while t_wait(0.05) do
        pcall(function()
            if not LP.Character or not LP.Character:FindFirstChild("Humanoid") or not getgenv().Setting then return end
            local swTool = GetWeaponByToolTip("Sword")
            local mlTool = GetWeaponByToolTip("Melee")
            local frTool = GetWeaponByToolTip("Blox Fruit")
            local gunTool = GetWeaponByToolTip("Gun")
            local cfg = getgenv().Setting["Method Click"]
            local equipTarget = nil
            local wepStr = "NONE"
            if cfg["Click Sword"] and swTool then
                equipTarget = swTool
                wepStr = "SWORD"
            elseif cfg["Click Melee"] and mlTool then
                equipTarget = mlTool
                wepStr = "MELEE"
            elseif cfg["Click Fruit"] and frTool then
                equipTarget = frTool
                wepStr = "FRUIT"
            elseif cfg["Click Gun"] and gunTool then
                equipTarget = gunTool
                wepStr = "GUN"
            end
            if equipTarget then
                if equipTarget.Parent ~= LP.Character then
                    LP.Character.Humanoid:EquipTool(equipTarget)
                end
            end
            T_Wep.Text = "WEAPON: " .. wepStr
        end)
    end
end)
S.RS.Heartbeat:Connect(function()
    pcall(function()
        local t = getgenv().CurrentTarget
        if not t or not t:FindFirstChild("HumanoidRootPart") then return end
        local eH = t.HumanoidRootPart
        local pTime = getgenv().Setting["Aim Prediction"] or 0.185
        local eVel = eH.AssemblyLinearVelocity
        local pPos = eH.Position + (eVel * pTime)
        if getgenv().Setting.Hitbox.Enabled then
            local sz = getgenv().Setting.Hitbox.Size
            eH.Size = v3_new(sz, sz, sz)
            eH.Transparency = getgenv().Setting.Hitbox.Transparency
            eH.CanCollide = false
            if eVel.Magnitude > 1 then eH.CFrame = cf_new(pPos) end
        end
    end)
end)
t_spawn(function()
    local tJ, keys = tick(), {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
    while t_wait(0.2) do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health > 0 then
                if getgenv().Setting.Misc["Auto Jump"] and tick() - tJ >= 3.5 then
                    S.V:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    t_wait(0.05)
                    S.V:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    tJ = tick()
                end
                if getgenv().CurrentTarget then
                    local k = keys[m_random(1, 4)]
                    S.V:SendKeyEvent(true, k, false, game)
                    t_wait(0.1)
                    S.V:SendKeyEvent(false, k, false, game)
                end
            end
        end)
    end
end)
t_spawn(function()
    t_wait(600)
    pcall(function()
        Log("HOPPING SERVER...", Color3.fromRGB(255, 50, 50))
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Desc&limit=100")
        if req then
            local d = S.HTTP:JSONDecode(req)
            if d and d.data then
                for _, v in ipairs(d.data) do
                    if type(v) == "table" and v.playing and v.maxPlayers and v.playing < v.maxPlayers and v.id ~= game.JobId then
                        S.TS:TeleportToPlaceInstance(game.PlaceId, v.id, LP)
                        t_wait(1)
                    end
                end
            end
        end
    end)
end)
