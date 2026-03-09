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
local m_random, m_floor = math.random, math.floor
local v3_new, cf_new = Vector3.new, CFrame.new

t_spawn(function()
    pcall(function()
        S.GS.ErrorMessageChanged:Connect(function()
            t_wait(2); S.TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
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

local UI = Create("ScreenGui", {Name = "QuantumV111", ResetOnSpawn = false}, TargetUI)
local BlackBG = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 0, 0), Visible = false, ZIndex = 0, Active = true}, UI)
local Main = Create("Frame", {Size = UDim2.new(0, 300, 0, 180), Position = UDim2.new(0.015, 0, 0.3, 0), BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.1, Active = true, Draggable = true, ClipsDescendants = true, ZIndex = 1}, UI)
Create("UICorner", {CornerRadius = UDim.new(0, 6)}, Main)
Create("UIStroke", {Color = Color3.fromRGB(255, 0, 85), Thickness = 1.5, Transparency = 0.1}, Main)

local Header = Create("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Color3.fromRGB(22, 22, 26), BorderSizePixel = 0, ZIndex = 1}, Main)
Create("UICorner", {CornerRadius = UDim.new(0, 6)}, Header)
Create("TextLabel", {Size = UDim2.new(1, -110, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "SUC_CORE :: V11.1 SOLID HITBOX", TextColor3 = Color3.fromRGB(255, 0, 85), Font = Enum.Font.GothamBlack, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 1}, Header)

local BtnBlack = Create("TextButton", {Size = UDim2.new(0, 95, 0, 20), Position = UDim2.new(1, -100, 0, 4), BackgroundColor3 = Color3.fromRGB(35, 35, 40), Text = "BLACK SCREEN", TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.GothamBold, TextSize = 10, ZIndex = 2}, Header)
Create("UICorner", {CornerRadius = UDim.new(0, 4)}, BtnBlack)

local isBlack = false
pcall(function()
    if isfile and readfile and isfile("Suc_Blackout.txt") then isBlack = readfile("Suc_Blackout.txt") == "true" end
end)
BlackBG.Visible = isBlack
BtnBlack.TextColor3 = isBlack and Color3.fromRGB(255, 0, 85) or Color3.fromRGB(200, 200, 200)
pcall(function() S.RS:Set3dRenderingEnabled(not isBlack) end)

BtnBlack.MouseButton1Click:Connect(function()
    isBlack = not isBlack; BlackBG.Visible = isBlack
    BtnBlack.TextColor3 = isBlack and Color3.fromRGB(255, 0, 85) or Color3.fromRGB(200, 200, 200)
    pcall(function() S.RS:Set3dRenderingEnabled(not isBlack) end)
    pcall(function() if writefile then writefile("Suc_Blackout.txt", tostring(isBlack)) end end)
end)

local T_Timeout = Create("TextLabel", {Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 32), BackgroundTransparency = 1, Text = "T/O: STANDBY", TextColor3 = Color3.fromRGB(255, 80, 80), Font = Enum.Font.GothamBlack, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 1}, Main)
local LogBox = Create("ScrollingFrame", {Size = UDim2.new(1, -20, 0, 85), Position = UDim2.new(0, 10, 0, 60), BackgroundTransparency = 1, ScrollBarThickness = 1, CanvasSize = UDim2.new(), ScrollBarImageColor3 = Color3.fromRGB(255, 0, 85), ZIndex = 1}, Main)
Create("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, LogBox)
local Foot = Create("Frame", {Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 1, -28), BackgroundTransparency = 1, ZIndex = 1}, Main)
local T_Ping = Create("TextLabel", {Size = UDim2.new(0.33, 0, 1, 0), BackgroundTransparency = 1, Text = "PING: 0", TextColor3 = Color3.fromRGB(150, 150, 160), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 1}, Foot)
local T_FPS = Create("TextLabel", {Size = UDim2.new(0.33, 0, 1, 0), Position = UDim2.new(0.33, 0, 0, 0), BackgroundTransparency = 1, Text = "FPS: 0", TextColor3 = Color3.fromRGB(150, 150, 160), Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 1}, Foot)
local T_Hop = Create("TextLabel", {Size = UDim2.new(0.34, 0, 1, 0), Position = UDim2.new(0.66, 0, 0, 0), BackgroundTransparency = 1, Text = "HOP: 600s", TextColor3 = Color3.fromRGB(255, 100, 100), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 1}, Foot)

local LogC, Engine = 0, {FC = 0}
local function Log(txt, col)
    pcall(function()
        LogC = LogC + 1
        Create("TextLabel", {Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, Text = string.format(">[%s] %s", os.date("%H:%M:%S"), txt), TextColor3 = col or Color3.fromRGB(200, 200, 200), Font = Enum.Font.Code, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = LogC}, LogBox)
        LogBox.CanvasPosition = Vector2.new(0, 99999)
    end)
end

S.RS.RenderStepped:Connect(function() Engine.FC = Engine.FC + 1 end)

t_spawn(function()
    pcall(function()
        settings().Rendering.QualityLevel = 1; S.L.GlobalShadows, S.L.FogEnd = false, 9e9
        for _, v in ipairs(S.L:GetDescendants()) do if v:IsA("PostEffect") then v.Enabled = false end end
        if getgenv().Setting and getgenv().Setting.DeleteMap then
            for _, v in ipairs(S.W:GetDescendants()) do if v:IsA("Part") and v.Transparency < 1 then v.CanCollide = false end end
        end
        Log("enable anti sus module", Color3.fromRGB(255, 0, 85))
    end)
end)

local Blacklist, bLabel = {}, nil
getgenv().Retreating = false
getgenv().LockedTarget = nil
getgenv().RetreatTracker = getgenv().RetreatTracker or {}
getgenv().LastTargetName = nil

local function SyncBananaTarget()
    if bLabel and bLabel.Parent and bLabel.Text then
        local n = string.match(bLabel.Text, "Target %([%s]*([%w_]+)")
        if n then local p = S.P:FindFirstChild(n); return p and p.Character or nil end
        return nil
    end
    for _, v in ipairs(S.CG:GetDescendants()) do if v:IsA("TextLabel") and v.Text and string.find(v.Text, "Target %(") then bLabel = v; break end end
    if not bLabel then
         for _, v in ipairs(LP.PlayerGui:GetDescendants()) do if v:IsA("TextLabel") and v.Text and string.find(v.Text, "Target %(") then bLabel = v; break end end
    end
    return nil
end

local function SmartEquipFruit()
    if not LP.Character then return nil end
    local tip = "Blox Fruit"
    for _, v in ipairs(LP.Backpack:GetChildren()) do if v:IsA("Tool") and (v.ToolTip == tip or v.Name:match(tip)) then return v end end
    for _, v in ipairs(LP.Character:GetChildren()) do if v:IsA("Tool") and (v.ToolTip == tip or v.Name:match(tip)) then return v end end
    return nil
end

local function ExecuteHop()
    pcall(function()
        local r = game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Desc&limit=100")
        local d = S.HTTP:JSONDecode(r)
        if d and d.data then
            local vld = {}
            for _, v in ipairs(d.data) do
                if v.playing and v.playing < v.maxPlayers and v.id ~= game.JobId then table.insert(vld, v.id) end
            end
            if #vld > 0 then S.TS:TeleportToPlaceInstance(game.PlaceId, vld[m_random(1, #vld)], LP) end
        end
    end)
end

t_spawn(function()
    local tmr, last, tJ, keys = {}, tick(), tick(), {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
    while t_wait(0.1) do
        local now, dt = tick(), tick() - last; last = now
        
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health > 0 then
                if getgenv().Setting and getgenv().Setting.Misc and getgenv().Setting.Misc["Auto Jump"] then
                    if tick() - tJ >= 3.5 then
                        S.V:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                        task.delay(0.05, function() S.V:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end)
                        tJ = tick()
                    end
                end
                local k = keys[m_random(1, 4)]
                S.V:SendKeyEvent(true, k, false, game)
                task.delay(0.1, function() S.V:SendKeyEvent(false, k, false, game) end)
            end
        end)

        pcall(function()
            local hp = LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health or 0
            local t = SyncBananaTarget()
            
            if t then getgenv().LastTargetName = t.Name end
            
            if hp >= 7000 and getgenv().Retreating then
                getgenv().Retreating = false
            end

            if hp > 0 and hp < 4000 and not getgenv().Retreating then
                getgenv().Retreating = true
                local eName = getgenv().LastTargetName
                if eName then
                    getgenv().RetreatTracker[eName] = (getgenv().RetreatTracker[eName] or 0) + 1
                    Log("WARNING: RETREAT " .. getgenv().RetreatTracker[eName] .. "/3", Color3.fromRGB(255, 150, 0))
                    
                    if getgenv().RetreatTracker[eName] >= 3 then
                        Blacklist[eName] = tick()
                        local bGuy = S.P:FindFirstChild(eName)
                        if bGuy and bGuy.Character and bGuy.Character:FindFirstChild("Humanoid") then
                            pcall(function() bGuy.Character.Humanoid:Destroy() end)
                        end
                        Log("DANGER: 3 STRIKES! SKIPPED.", Color3.fromRGB(255, 50, 50))
                        getgenv().LockedTarget = nil
                        return
                    end
                end
            end

            if t and t:FindFirstChild("HumanoidRootPart") and t:FindFirstChild("Humanoid") and t.Humanoid.Health > 0 and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                if Blacklist[t.Name] and tick() - Blacklist[t.Name] < 300 then
                    getgenv().LockedTarget = nil
                    T_Timeout.Text = "T/O: STANDBY"
                    return
                end

                local d = (LP.Character.HumanoidRootPart.Position - t.HumanoidRootPart.Position).Magnitude
                if d <= 300 and not getgenv().Retreating then
                    getgenv().LockedTarget = t
                else
                    getgenv().LockedTarget = nil
                end

                if getgenv().LockedTarget == t then
                    tmr[t.Name] = (tmr[t.Name] or 0) + dt
                    local left = m_floor(25 - tmr[t.Name])
                    T_Timeout.Text = string.upper(string.sub(t.Name, 1, 10)) .. " | T/O: " .. (left > 0 and left or 0) .. "s"
                    
                    if tmr[t.Name] >= 25 then
                        Blacklist[t.Name] = tick()
                        pcall(function() t.Humanoid:Destroy() end)
                        Log("TIMEOUT (25s): SKIPPED!", Color3.fromRGB(255, 80, 80))
                        getgenv().LockedTarget, tmr[t.Name] = nil, nil
                        T_Timeout.Text = "T/O: STANDBY"
                    end
                elseif getgenv().Retreating then
                    T_Timeout.Text = "RETREATING..."
                else
                    tmr[t.Name] = 0
                    T_Timeout.Text = "FLYING..."
                end
            else
                getgenv().LockedTarget = nil
                if getgenv().Retreating then
                    T_Timeout.Text = "RETREATING..."
                else
                    T_Timeout.Text = "T/O: STANDBY"
                end
            end
        end)
        
        pcall(function()
            if getgenv().LockedTarget and LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health > 0 then
                local eT = SmartEquipFruit()
                if eT and eT.Parent ~= LP.Character then LP.Character.Humanoid:EquipTool(eT) end
            end
        end)
    end
end)

t_spawn(function()
    local dead, dC = false, 0
    while t_wait(0.5) do
        pcall(function()
            if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
            local h = LP.Character:FindFirstChild("Humanoid")
            if h and h.Health <= 0 then
                if not dead then
                    dead, dC = true, dC + 1
                    if dC < 2 then Log("WE DIED! 1ST WARNING.", Color3.fromRGB(255, 150, 0)); getgenv().LockedTarget = nil
                    else
                        t_spawn(function()
                            Log("DIED TWICE! HOPPING...", Color3.fromRGB(255, 50, 50)); T_Hop.Text = "EMERGENCY 2s"; getgenv().LockedTarget = nil
                            t_wait(1); T_Hop.Text = "EMERGENCY 1s"; t_wait(1); T_Hop.Text = "HOPPING NOW!"
                            while t_wait(3) do ExecuteHop() end
                        end)
                    end
                end
            elseif h and h.Health > 0 then dead = false end
        end)
    end
end)

t_spawn(function()
    local ht = 600
    local epicenter = v3_new(-366.44, 73.03, 285.39)
    while t_wait(1) do
        pcall(function() T_FPS.Text = "FPS: " .. Engine.FC; Engine.FC = 0 end)
        pcall(function() local p = LP:GetNetworkPing(); T_Ping.Text = p and ("PING: " .. m_floor(p * 1000)) or "PING: N/A" end)
        ht = ht - 1
        pcall(function()
            if ht > 0 then T_Hop.Text = "HOP: " .. ht .. "s" else
                T_Hop.Text = "HOPPING..."
                if ht == 0 then Log("HOPPING SERVER...", Color3.fromRGB(255, 50, 50)); ht = -1 end
                ExecuteHop()
            end
        end)
        pcall(function()
            for _, v in ipairs(S.P:GetPlayers()) do
                if v.Name == "ZBaltQne" then continue end
                if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                    if v.Character:FindFirstChildOfClass("ForceField") then
                        v.Character.Humanoid:Destroy(); Log("SNAPPED: SAFEZONE", Color3.fromRGB(255, 100, 0))
                    elseif (v.Character.HumanoidRootPart.Position - epicenter).Magnitude > 15000 then
                        v.Character.Humanoid:Destroy(); Log("SNAPPED: OUT OF ZONE", Color3.fromRGB(255, 50, 50))
                    end
                end
            end
        end)
    end
end)

S.RS.Heartbeat:Connect(function()
    pcall(function()
        local t = getgenv().LockedTarget
        if t and t:FindFirstChild("HumanoidRootPart") then
            if getgenv().Setting and getgenv().Setting.Hitbox and getgenv().Setting.Hitbox.Enabled then
                local sz = getgenv().Setting.Hitbox.Size or 60
                t.HumanoidRootPart.Size = v3_new(sz, sz, sz)
                t.HumanoidRootPart.Transparency = getgenv().Setting.Hitbox.Transparency or 0.7
                t.HumanoidRootPart.CanCollide = false
            end
            
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LP.Character.HumanoidRootPart
                hrp.CFrame = t.HumanoidRootPart.CFrame * cf_new(0, 3, 3)
                hrp.AssemblyLinearVelocity = v3_new(0, 0, 0)
                hrp.AssemblyAngularVelocity = v3_new(0, 0, 0)
            end
        end
    end)
end)
