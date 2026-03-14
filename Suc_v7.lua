pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then return end
        return oldNamecall(self, ...)
    end)
end)

repeat task.wait() until game:IsLoaded()
local P_Serv = game:GetService("Players")
local LP = P_Serv.LocalPlayer or P_Serv:GetPropertyChangedSignal("LocalPlayer"):Wait()
repeat task.wait() until LP and LP.Character and LP:FindFirstChild("PlayerGui")

local S = {
    P = P_Serv, W = game:GetService("Workspace"),
    RS = game:GetService("RunService"), V = game:GetService("VirtualInputManager"),
    L = game:GetService("Lighting"), ST = game:GetService("Stats"),
    GS = game:GetService("GuiService"), TS = game:GetService("TeleportService"),
    HTTP = game:GetService("HttpService"), CG = game:GetService("CoreGui")
}

local t_wait, t_spawn = task.wait, task.spawn
local m_random, m_floor, m_rad = math.random, math.floor, math.rad
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

local UI = Create("ScreenGui", {Name = "QuantumVOmni", ResetOnSpawn = false}, TargetUI)
local BlackBG = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 0, 0), Visible = false, ZIndex = 0, Active = true}, UI)
local Main = Create("Frame", {Size = UDim2.new(0, 300, 0, 180), Position = UDim2.new(0.015, 0, 0.3, 0), BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.1, Active = true, Draggable = true, ClipsDescendants = true, ZIndex = 1}, UI)
Create("UICorner", {CornerRadius = UDim.new(0, 6)}, Main)
Create("UIStroke", {Color = Color3.fromRGB(255, 0, 85), Thickness = 1.5, Transparency = 0.1}, Main)

local Header = Create("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Color3.fromRGB(22, 22, 26), BorderSizePixel = 0, ZIndex = 1}, Main)
Create("UICorner", {CornerRadius = UDim.new(0, 6)}, Header)
Create("TextLabel", {Size = UDim2.new(1, -110, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "SUC_CORE :: OMNI MODULE", TextColor3 = Color3.fromRGB(255, 0, 85), Font = Enum.Font.GothamBlack, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 1}, Header)

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

local T_Timeout = Create("TextLabel", {Size = UDim2.new(0.45, 0, 0, 25), Position = UDim2.new(0, 10, 0, 32), BackgroundTransparency = 1, Text = "T/O: STANDBY", TextColor3 = Color3.fromRGB(255, 80, 80), Font = Enum.Font.GothamBlack, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 1}, Main)
local T_BPH = Create("TextLabel", {Size = UDim2.new(0.55, -20, 0, 25), Position = UDim2.new(0.45, 10, 0, 32), BackgroundTransparency = 1, Text = "EARN: 0 | BT/1h: 0", TextColor3 = Color3.fromRGB(50, 255, 50), Font = Enum.Font.GothamBlack, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 1}, Main)

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
        local lbl = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, Text = string.format(">[%s] %s", os.date("%H:%M:%S"), txt), TextColor3 = col or Color3.fromRGB(200, 200, 200), Font = Enum.Font.Code, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = LogC}, LogBox)
        LogBox.CanvasPosition = Vector2.new(0, 99999)
        task.delay(5, function() pcall(function() if lbl then lbl:Destroy() end end) end)
    end)
end

S.RS.RenderStepped:Connect(function() Engine.FC = Engine.FC + 1 end)

local B_Data = {StartTime = os.time(), Earned = 0, Kills = 0, History = {}, LastBPH = 0}
pcall(function()
    if isfile and readfile and isfile("Suc_BountyTrack.json") then
        local d = S.HTTP:JSONDecode(readfile("Suc_BountyTrack.json"))
        if d and d.StartTime and (os.time() - d.StartTime < 43200) then
            B_Data = d
            if not B_Data.History then B_Data.History = {} end
            if not B_Data.LastBPH then B_Data.LastBPH = 0 end
        end
    end
end)

local function formatNumber(n)
    local sign = ""
    if n < 0 then sign = "-"; n = math.abs(n) end
    if n >= 1000000 then return sign .. string.format("%.1fM", n / 1000000)
    elseif n >= 1000 then return sign .. string.format("%.1fK", n / 1000)
    else return sign .. tostring(n) end
end

local function updateBPH()
    local now = os.time()
    local k10m = 0
    local vHist = {}
    B_Data.History = B_Data.History or {}
    
    for _, item in ipairs(B_Data.History) do
        if now - item.t <= 600 then
            if item.v > 0 then
                k10m = k10m + 1
            end
            table.insert(vHist, item)
        end
    end
    B_Data.History = vHist
    
    if B_Data.Kills and B_Data.Kills > 0 then
        if k10m > 0 then
            local avgBountyPerKill = B_Data.Earned / B_Data.Kills
            local killsPerHour = k10m * 6
            B_Data.LastBPH = m_floor(avgBountyPerKill * killsPerHour)
        end
    else
        B_Data.LastBPH = 0
    end
    
    pcall(function() T_BPH.Text = string.format("EARN: %s | BT/1h: %s", formatNumber(B_Data.Earned), formatNumber(B_Data.LastBPH or 0)) end)
end

local processedLabels = setmetatable({}, {__mode = "k"})
local recentTexts = {}

local function checkBountyText(lbl)
    if processedLabels[lbl] then return end
    local rawText = lbl.Text
    if not rawText or rawText == "" then return end
    
    local c = lbl.TextColor3
    local isLoss = (c.R > 0.8 and c.G < 0.2 and c.B < 0.2)
    
    local valStr = string.match(rawText, "<font[^>]*>%s*(%d+)")
    
    if not valStr then
        local pt = string.gsub(rawText, "<[^>]+>", "")
        if string.match(pt, "nhận") or string.match(pt, "Earned") or isLoss then
            valStr = string.match(pt, "(%d+)%s*Tiền Thưởng") or string.match(pt, "(%d+)%s*Danh Dự") or string.match(pt, "(%d+)%s*Bounty") or string.match(pt, "(%d+)%s*Honor")
        end
    end
    
    if valStr then
        processedLabels[lbl] = true
        if recentTexts[rawText] and (tick() - recentTexts[rawText] < 1.5) then return end
        recentTexts[rawText] = tick()
        
        local val = tonumber(valStr)
        if val and val > 0 and val < 50000 then
            B_Data.History = B_Data.History or {}
            if isLoss then
                B_Data.Earned = B_Data.Earned - val
                table.insert(B_Data.History, {v = -val, t = os.time()})
            else
                B_Data.Earned = B_Data.Earned + val
                B_Data.Kills = B_Data.Kills + 1
                table.insert(B_Data.History, {v = val, t = os.time()})
            end
            pcall(function() if writefile then writefile("Suc_BountyTrack.json", S.HTTP:JSONEncode(B_Data)) end end)
            updateBPH()
        end
    end
end

t_spawn(function()
    pcall(function()
        for _, v in ipairs(LP.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") then
                checkBountyText(v)
                v:GetPropertyChangedSignal("Text"):Connect(function() checkBountyText(v) end)
            end
        end
        LP.PlayerGui.DescendantAdded:Connect(function(v)
            if v:IsA("TextLabel") then
                checkBountyText(v)
                v:GetPropertyChangedSignal("Text"):Connect(function() checkBountyText(v) end)
            end
        end)
    end)
end)

t_spawn(function()
    t_wait(3)
    pcall(function()
        settings().Rendering.QualityLevel = 1; S.L.GlobalShadows, S.L.FogEnd = false, 9e9
        for _, v in ipairs(S.L:GetDescendants()) do if v:IsA("PostEffect") then v.Enabled = false end end
        if getgenv().Setting and getgenv().Setting.DeleteMap then
            for _, v in ipairs(S.W:GetDescendants()) do if v:IsA("Part") and v.Transparency < 1 then v.CanCollide = false end end
        end
        Log("aegis protection active", Color3.fromRGB(0, 255, 100))
    end)
end)

local Blacklist, bLabel, lastUISearch = {}, nil, 0
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
    if tick() - lastUISearch > 2 then
        lastUISearch = tick()
        for _, v in ipairs(S.CG:GetDescendants()) do if v:IsA("TextLabel") and v.Text and string.find(v.Text, "Target %(") then bLabel = v; break end end
        if not bLabel then
             for _, v in ipairs(LP.PlayerGui:GetDescendants()) do if v:IsA("TextLabel") and v.Text and string.find(v.Text, "Target %(") then bLabel = v; break end end
        end
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

local isHopping = false
local function ExecuteHop()
    if isHopping then return end
    isHopping = true
    Log("HOPPING SERVER...", Color3.fromRGB(255, 50, 50))
    t_spawn(function()
        while t_wait(4) do
            pcall(function()
                local r = game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Desc&limit=100")
                local d = S.HTTP:JSONDecode(r)
                if d and d.data then
                    local vld = {}
                    for _, v in ipairs(d.data) do
                        if type(v) == "table" and v.playing and v.playing < (v.maxPlayers - 1) and v.id ~= game.JobId then 
                            table.insert(vld, v.id) 
                        end
                    end
                    if #vld > 0 then S.TS:TeleportToPlaceInstance(game.PlaceId, vld[m_random(1, #vld)], LP) end
                end
            end)
        end
    end)
end

t_spawn(function()
    local tJ, tD, keys = tick(), tick(), {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
    while t_wait(0.1) do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health > 0 then
                if getgenv().Setting and getgenv().Setting.Misc and getgenv().Setting.Misc["Auto Jump"] then
                    if tick() - tJ >= 3.5 then
                        S.V:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                        task.delay(0.05, function() S.V:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end)
                        tJ = tick()
                    end
                end
                if tick() - tD >= 0.3 then
                    local k = keys[m_random(1, 4)]
                    S.V:SendKeyEvent(true, k, false, game)
                    task.delay(0.1, function() S.V:SendKeyEvent(false, k, false, game) end)
                    tD = tick()
                end
            end
        end)
    end
end)

t_spawn(function()
    local tmr, last = {}, tick()
    while t_wait(0.1) do
        local now, dt = tick(), tick() - last; last = now

        pcall(function()
            local hp = LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health or 0
            local t = SyncBananaTarget()
            
            if t then getgenv().LastTargetName = t.Name end
            
            if hp >= 7000 and getgenv().Retreating then getgenv().Retreating = false end

            if hp > 0 and hp < 4000 and not getgenv().Retreating then
                getgenv().Retreating = true
                local eName = getgenv().LastTargetName
                if eName then
                    getgenv().RetreatTracker[eName] = (getgenv().RetreatTracker[eName] or 0) + 1
                    Log("WARNING: RETREAT " .. getgenv().RetreatTracker[eName] .. "/3", Color3.fromRGB(255, 150, 0))
                    if getgenv().RetreatTracker[eName] >= 3 then
                        Blacklist[eName] = tick()
                        local bGuy = S.P:FindFirstChild(eName)
                        if bGuy and bGuy.Character and bGuy.Character:FindFirstChild("HumanoidRootPart") then
                            pcall(function() bGuy.Character.HumanoidRootPart.CFrame = cf_new(0, 50000, 0) end)
                        end
                        Log("DANGER: 3 STRIKES! SKIPPED.", Color3.fromRGB(255, 50, 50))
                        getgenv().LockedTarget = nil
                        return
                    end
                end
            end

            if t and t:FindFirstChild("HumanoidRootPart") and t:FindFirstChild("Humanoid") and t.Humanoid.Health > 0 and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                if Blacklist[t.Name] and tick() - Blacklist[t.Name] < 300 then
                    getgenv().LockedTarget = nil; T_Timeout.Text = "T/O: STANDBY"; return
                end

                local d = (LP.Character.HumanoidRootPart.Position - t.HumanoidRootPart.Position).Magnitude
                getgenv().LockedTarget = (d <= 300 and not getgenv().Retreating) and t or nil

                if getgenv().LockedTarget == t then
                    tmr[t.Name] = (tmr[t.Name] or 0) + dt
                    local left = m_floor(25 - tmr[t.Name])
                    T_Timeout.Text = string.upper(string.sub(t.Name, 1, 10)) .. " | T/O: " .. (left > 0 and left or 0) .. "s"
                    
                    if getgenv().Setting and getgenv().Setting.Hitbox and getgenv().Setting.Hitbox.Enabled then
                        local sz = getgenv().Setting.Hitbox.Size or 60
                        if t.HumanoidRootPart.Size.X ~= sz then
                            t.HumanoidRootPart.Size = v3_new(sz, sz, sz)
                            t.HumanoidRootPart.Transparency = getgenv().Setting.Hitbox.Transparency or 0.7
                            t.HumanoidRootPart.CanCollide = false
                        end
                    end
                    
                    if tmr[t.Name] >= 25 then
                        Blacklist[t.Name] = tick()
                        pcall(function() t.HumanoidRootPart.CFrame = cf_new(0, 50000, 0) end)
                        Log("TIMEOUT (25s): SKIPPED!", Color3.fromRGB(255, 80, 80))
                        getgenv().LockedTarget, tmr[t.Name] = nil, nil
                        T_Timeout.Text = "T/O: STANDBY"
                    end
                elseif getgenv().Retreating then
                    T_Timeout.Text = "RETREATING..."
                else
                    tmr[t.Name] = 0; T_Timeout.Text = "FLYING..."
                end
            else
                getgenv().LockedTarget = nil
                T_Timeout.Text = getgenv().Retreating and "RETREATING..." or "T/O: STANDBY"
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
    local ht = 600
    while t_wait(1) do
        pcall(function() T_FPS.Text = "FPS: " .. Engine.FC; Engine.FC = 0 end)
        pcall(function() local p = LP:GetNetworkPing(); T_Ping.Text = p and ("PING: " .. m_floor(p * 1000)) or "PING: N/A" end)
        updateBPH()
        
        if not isHopping then
            if ht > 0 then ht = ht - 1; T_Hop.Text = "HOP: " .. ht .. "s"
            else T_Hop.Text = "HOPPING..."; ExecuteHop() end
        end
    end
end)

local lastRandTick, rX, rY, rZ = 0, 0, 5, 5
S.RS.Heartbeat:Connect(function()
    pcall(function()
        local t = getgenv().LockedTarget
        if t and t:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LP.Character.HumanoidRootPart
            local tHrp = t.HumanoidRootPart
            
            local d = (hrp.Position - tHrp.Position).Magnitude
            if d <= 50 then
                local now = tick()
                if now - lastRandTick > 0.1 then
                    rX = m_random(-10, 10)
                    rY = m_random(2, 10)
                    rZ = m_random(-10, 10)
                    lastRandTick = now
                end
                hrp.CFrame = tHrp.CFrame * cf_new(rX, rY, rZ)
                hrp.AssemblyLinearVelocity = v3_new(0, 0, 0)
                hrp.AssemblyAngularVelocity = v3_new(0, 0, 0)
            end
        end
    end)
end)
