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
local m_clamp = math.clamp
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
    for _, v in ipairs(TargetUI:GetChildren()) do if v.Name:match("QuantumV") then v:Destroy() end end
end)

local function Create(cls, props, parent)
    local ins = Instance.new(cls)
    for k, v in pairs(props) do ins[k] = v end
    if parent then ins.Parent = parent end
    return ins
end

-- UI NEON MINT THEME
local UI = Create("ScreenGui", {Name = "MayChemXeoCan", ResetOnSpawn = false}, TargetUI)
local BlackBG = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 0, 0), Visible = false, ZIndex = 0, Active = true}, UI)
local Main = Create("Frame", {Size = UDim2.new(0, 300, 0, 180), Position = UDim2.new(0.015, 0, 0.3, 0), BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.1, Active = true, Draggable = true, ClipsDescendants = true, ZIndex = 1}, UI)
Create("UICorner", {CornerRadius = UDim.new(0, 6)}, Main)
Create("UIStroke", {Color = Color3.fromRGB(0, 255, 170), Thickness = 1.5, Transparency = 0.1}, Main)

local Header = Create("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Color3.fromRGB(22, 22, 26), BorderSizePixel = 0, ZIndex = 1}, Main)
Create("UICorner", {CornerRadius = UDim.new(0, 6)}, Header)
Create("TextLabel", {Size = UDim2.new(1, -110, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "SUC_CORE :: V8.9 OPTIMIZED", TextColor3 = Color3.fromRGB(0, 255, 170), Font = Enum.Font.GothamBlack, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 1}, Header)

local BtnBlack = Create("TextButton", {Size = UDim2.new(0, 95, 0, 20), Position = UDim2.new(1, -100, 0, 4), BackgroundColor3 = Color3.fromRGB(35, 35, 40), Text = "BLACK SCREEN", TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.GothamBold, TextSize = 10, ZIndex = 2}, Header)
Create("UICorner", {CornerRadius = UDim.new(0, 4)}, BtnBlack)

local isBlack = false
pcall(function()
    if isfile and readfile and isfile("Suc_Blackout.txt") then isBlack = readfile("Suc_Blackout.txt") == "true" end
end)
BlackBG.Visible = isBlack
BtnBlack.TextColor3 = isBlack and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(200, 200, 200)
pcall(function() S.RS:Set3dRenderingEnabled(not isBlack) end)

BtnBlack.MouseButton1Click:Connect(function()
    isBlack = not isBlack
    BlackBG.Visible = isBlack
    BtnBlack.TextColor3 = isBlack and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(200, 200, 200)
    pcall(function() S.RS:Set3dRenderingEnabled(not isBlack) end)
    pcall(function() if writefile then writefile("Suc_Blackout.txt", tostring(isBlack)) end end)
end)

local T_Wep = Create("TextLabel", {Size = UDim2.new(0.6, 0, 0, 25), Position = UDim2.new(0, 10, 0, 32), BackgroundTransparency = 1, Text = "WEAPON: SYNC...", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 1}, Main)
local T_Timeout = Create("TextLabel", {Size = UDim2.new(0.4, -20, 0, 25), Position = UDim2.new(0.6, 0, 0, 32), BackgroundTransparency = 1, Text = "T/O: --", TextColor3 = Color3.fromRGB(255, 80, 80), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 1}, Main)
local LogBox = Create("ScrollingFrame", {Size = UDim2.new(1, -20, 0, 85), Position = UDim2.new(0, 10, 0, 60), BackgroundTransparency = 1, ScrollBarThickness = 1, CanvasSize = UDim2.new(), ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170), ZIndex = 1}, Main)
Create("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, LogBox)
local Foot = Create("Frame", {Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 1, -28), BackgroundTransparency = 1, ZIndex = 1}, Main)
local T_Ping = Create("TextLabel", {Size = UDim2.new(0.33, 0, 1, 0), BackgroundTransparency = 1, Text = "PING: 0", TextColor3 = Color3.fromRGB(150, 150, 160), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 1}, Foot)
local T_FPS = Create("TextLabel", {Size = UDim2.new(0.33, 0, 1, 0), Position = UDim2.new(0.33, 0, 0, 0), BackgroundTransparency = 1, Text = "FPS: 0", TextColor3 = Color3.fromRGB(150, 150, 160), Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 1}, Foot)
local T_Hop = Create("TextLabel", {Size = UDim2.new(0.34, 0, 1, 0), Position = UDim2.new(0.66, 0, 0, 0), BackgroundTransparency = 1, Text = "HOP: 600s", TextColor3 = Color3.fromRGB(255, 100, 100), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 1}, Foot)

local LogC = 0
local function Log(txt, col)
    pcall(function()
        LogC = LogC + 1
        Create("TextLabel", {Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, Text = string.format(">[%s] %s", os.date("%H:%M:%S"), txt), TextColor3 = col or Color3.fromRGB(200, 200, 200), Font = Enum.Font.Code, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = LogC}, LogBox)
        LogBox.CanvasPosition = Vector2.new(0, 99999)
    end)
end

local Engine = {FC = 0}
S.RS.RenderStepped:Connect(function() Engine.FC = Engine.FC + 1 end)

t_spawn(function()
    pcall(function()
        settings().Rendering.QualityLevel = 1
        S.L.GlobalShadows = false
        S.L.FogEnd = 9e9
        for _, v in ipairs(S.L:GetDescendants()) do if v:IsA("PostEffect") then v.Enabled = false end end
        if getgenv().Setting and getgenv().Setting.DeleteMap then
            for _, v in ipairs(S.W:GetDescendants()) do if v:IsA("Part") and v.Transparency < 1 then v.CanCollide = false end end
        end
        Log("V8.9 Loaded. Loops Consolidated.", Color3.fromRGB(0, 255, 170))
        Log("Anti Sus Module Enabled.", Color3.fromRGB(0, 255, 170))
    end)
end)

local Blacklist = {}
local bananaLabel = nil
local function SyncBananaTarget()
    if bananaLabel and bananaLabel.Parent then
        local name = string.match(bananaLabel.Text, "Target %([%s]*([%w_]+)")
        if name then
            local p = S.P:FindFirstChild(name)
            return p and p.Character or nil
        end
    else
        for _, v in ipairs(S.CG:GetDescendants()) do
            if v:IsA("TextLabel") and v.Text and string.find(v.Text, "Target %(") then bananaLabel = v; break end
        end
        if not bananaLabel then
             for _, v in ipairs(LP.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Text and string.find(v.Text, "Target %(") then bananaLabel = v; break end
            end
        end
    end
    return nil
end

local function GetTarget()
    local bTarg = SyncBananaTarget()
    if bTarg then return bTarg end
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local pos = LP.Character.HumanoidRootPart.Position
    local best, minH, maxD = nil, m_huge, 15000
    local cfg = getgenv().Setting.Targeting_Advanced or {}
    for _, v in ipairs(S.P:GetPlayers()) do
        if v.Name == "ZBaltQne" then continue end
        if Blacklist[v.Name] and tick() - Blacklist[v.Name] < 300 then
            pcall(function() if v.Character and v.Character:FindFirstChild("Humanoid") then v.Character.Humanoid:Destroy() end end)
            continue
        end
        if v ~= LP and v.Team ~= LP.Team and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if cfg.Ignore_Friends and LP:IsFriendsWith(v.UserId) then continue end
            if v.Character:FindFirstChildOfClass("ForceField") then continue end
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

local function GetWeaponByToolTip(tip)
    if not LP.Character then return nil end
    for _, v in ipairs(LP.Backpack:GetChildren()) do if v:IsA("Tool") and (v.ToolTip == tip or v.Name:match(tip)) then return v end end
    for _, v in ipairs(LP.Character:GetChildren()) do if v:IsA("Tool") and (v.ToolTip == tip or v.Name:match(tip)) then return v end end
    return nil
end

-- ================= LOOPS =================

-- [LOOP 1] THE FAST LOOP (0.1s) - Target Sync, Auto-Equip, Auto-Jump, T/O
t_spawn(function()
    local cTargName, tStart = nil, 0
    local tJ, keys = tick(), {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
    
    while t_wait(0.1) do
        -- 1. Sync & T/O (30s)
        pcall(function()
            getgenv().CurrentTarget = GetTarget()
            local t = getgenv().CurrentTarget
            if t and t:FindFirstChild("Humanoid") and t:FindFirstChild("HumanoidRootPart") then
                if t.Name ~= cTargName then
                    cTargName = t.Name; tStart = tick(); T_Timeout.Text = "T/O: 30s"
                else
                    local elapsed = tick() - tStart
                    local timeLeft = m_floor(30 - elapsed)
                    if timeLeft < 0 then timeLeft = 0 end
                    T_Timeout.Text = "T/O: " .. timeLeft .. "s"
                    if elapsed >= 30 then
                        Blacklist[t.Name] = tick()
                        pcall(function() t.Humanoid:Destroy() end)
                        Log("TIMEOUT: " .. t.Name .. " ERASED!", Color3.fromRGB(255, 80, 80))
                        getgenv().CurrentTarget = nil; cTargName = nil; T_Timeout.Text = "T/O: --"
                    end
                end
            else
                cTargName = nil; T_Timeout.Text = "T/O: --"
            end
        end)

        -- 2. Display Weapon & Smart Equip
        pcall(function()
            if not LP.Character then return end
            local curTool = LP.Character:FindFirstChildOfClass("Tool")
            T_Wep.Text = "WEAPON: " .. (curTool and string.upper(curTool.Name) or "NONE")
            
            if getgenv().Setting and getgenv().CurrentTarget and LP.Character:FindFirstChild("Humanoid") then
                local cfg = getgenv().Setting["Method Click"]
                local equipTarget = nil
                if cfg["Click Sword"] then equipTarget = GetWeaponByToolTip("Sword")
                elseif cfg["Click Melee"] then equipTarget = GetWeaponByToolTip("Melee")
                elseif cfg["Click Fruit"] then equipTarget = GetWeaponByToolTip("Blox Fruit")
                elseif cfg["Click Gun"] then equipTarget = GetWeaponByToolTip("Gun") end
                
                if equipTarget and equipTarget.Parent ~= LP.Character then 
                    LP.Character.Humanoid:EquipTool(equipTarget) 
                end
            end
        end)

        -- 3. Auto Jump / Dash
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health > 0 then
                if getgenv().Setting and getgenv().Setting.Misc and getgenv().Setting.Misc["Auto Jump"] and tick() - tJ >= 3.5 then
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

-- [LOOP 2] THE MEDIUM LOOP (0.5s) - 2nd Chance Death & Trap Escape
t_spawn(function()
    local wasDead, deathCount = false, 0
    local trapZone, safeZone = v3_new(917.61, 125.25, 32842.07), cf_new(2284.80, 15.34, 911.49)
    
    while t_wait(0.5) do
        pcall(function()
            if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
            local hum = LP.Character:FindFirstChild("Humanoid")
            local myPos = LP.Character.HumanoidRootPart.Position
            
            -- Death Logic
            if hum and hum.Health <= 0 then
                if not wasDead then
                    wasDead = true
                    deathCount = deathCount + 1
                    if deathCount < 2 then
                        Log("WE DIED! 1ST WARNING. NO HOP.", Color3.fromRGB(255, 150, 0))
                        getgenv().CurrentTarget = nil
                    else
                        t_spawn(function()
                            Log("DIED TWICE! HOPPING IN 2 SECONDS...", Color3.fromRGB(255, 50, 50))
                            T_Hop.Text = "EMERGENCY 2s"
                            getgenv().CurrentTarget = nil
                            t_wait(1)
                            T_Hop.Text = "EMERGENCY 1s"
                            t_wait(1)
                            T_Hop.Text = "HOPPING NOW!"
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
                    end
                end
            elseif hum and hum.Health > 0 then
                wasDead = false
            end
            
            -- Trap Escape
            if (myPos - trapZone).Magnitude <= 500 then
                Log("TRAP ZONE DETECTED! ESCAPING...", Color3.fromRGB(0, 255, 170))
                LP.Character.HumanoidRootPart.CFrame = safeZone
            end
        end)
    end
end)

-- [LOOP 3] THE SLOW LOOP (1s) - Ping/FPS, Hop Timer, Snap Logic
t_spawn(function()
    local hopTimeRemaining = 600
    while t_wait(1) do
        -- Stats
        pcall(function() T_FPS.Text = "FPS: " .. Engine.FC; Engine.FC = 0 end)
        pcall(function() local p = LP:GetNetworkPing(); T_Ping.Text = p and ("PING: " .. m_floor(p * 1000)) or "PING: N/A" end)
        
        -- Hop Timer
        hopTimeRemaining = hopTimeRemaining - 1
        pcall(function()
            if hopTimeRemaining > 0 then
                T_Hop.Text = "HOP: " .. hopTimeRemaining .. "s"
            else
                T_Hop.Text = "HOPPING..."
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
                hopTimeRemaining = 600 
            end
        end)

        -- Snap Logic
        pcall(function()
            if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
            local myPos = LP.Character.HumanoidRootPart.Position
            for _, v in ipairs(S.P:GetPlayers()) do
                if v.Name == "ZBaltQne" then continue end
                if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                    if v.Character:FindFirstChildOfClass("ForceField") then
                        v.Character.Humanoid:Destroy()
                        Log("SNAPPED: " .. v.Name .. " (SAFEZONE)", Color3.fromRGB(255, 100, 0))
                    else
                        local dist = (v.Character.HumanoidRootPart.Position - myPos).Magnitude
                        if dist > 15000 then
                            v.Character.Humanoid:Destroy()
                            Log("SNAPPED: " .. v.Name .. " (OUT OF BOUNDS)", Color3.fromRGB(255, 50, 50))
                        end
                    end
                end
            end
        end)
    end
end)

-- Hitbox Prediction Heartbeat
S.RS.Heartbeat:Connect(function()
    pcall(function()
        local t = getgenv().CurrentTarget
        if not t or not t:FindFirstChild("HumanoidRootPart") then return end
        local eH = t.HumanoidRootPart
        local pTime = (getgenv().Setting and getgenv().Setting["Aim Prediction"]) or 0.185
        local eVel = eH.AssemblyLinearVelocity
        local vX, vY, vZ = m_clamp(eVel.X, -120, 120), m_clamp(eVel.Y, -80, 80), m_clamp(eVel.Z, -120, 120)
        local dVel = v3_new(vX, vY, vZ)
        local pPos = eH.Position + (dVel * pTime)
        if getgenv().Setting and getgenv().Setting.Hitbox and getgenv().Setting.Hitbox.Enabled then
            local sz = getgenv().Setting.Hitbox.Size
            eH.Size = v3_new(sz, sz, sz)
            eH.Transparency = getgenv().Setting.Hitbox.Transparency
            eH.CanCollide = false
            if dVel.Magnitude > 1 then eH.CFrame = cf_new(pPos) end
        end
    end)
end)
