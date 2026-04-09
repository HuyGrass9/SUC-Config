if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LP = Players.LocalPlayer

local MCXC_Egg = {
    Config = {
        PlaceID = game.PlaceId,
        MaxPing = 150,
        MaxPlayers = 8,
        Speed = 300,
        HitboxRadius = 120,
        HopTimeLimit = 120,
        TaskTimeout = 10,
        PriorityEggs = {
            "Eggcited Egg", "Rocket Egg", "Shockwave Egg", "Treasured Egg",
            "Thirsty Egg", "Falling Sky Egg", "Firefly Egg"
        },
        IgnoreEggs = {
            "Duelist Egg", "Sealed Showdown Egg", "Night Hunter Egg", "Full Moon Egg", "Indra Egg", "Wood Egg"
        }
    },
    State = {
        Collected = {},
        EggCount = 0,
        StartTime = tick(),
        LastEggTime = tick(),
        LoopCount = 0,
        VisitedServers = {}
    }
}

local Routes = {
    {name="Jungle", pos=Vector3.new(-1200,20,1800)},
    {name="Desert", pos=Vector3.new(900,15,4300)},
    {name="PirateVillage", pos=Vector3.new(-1100,15,3500)},
    {name="Starter", pos=Vector3.new(-950,15,1550)},
    {name="Frozen", pos=Vector3.new(1100,15,-1400)},
    {name="MarineFortress", pos=Vector3.new(-4500,20,4300)},
    {name="SkyIsland", pos=Vector3.new(-5000,300,-2000)}
}

local Portals = {
    Vector3.new(-1000,20,1600),
    Vector3.new(-1200,25,1800),
    Vector3.new(-1100,20,3500),
    Vector3.new(900,20,4300),
    Vector3.new(1100,20,-1400),
    Vector3.new(-4500,25,4300)
}

local Utils = {}

function Utils.TweenTo(targetPos)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (hrp.Position - targetPos).Magnitude
    local time = dist / MCXC_Egg.Config.Speed
    local tw = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
    tw:Play()
    tw.Completed:Wait()
end

function Utils.GetServer()
    local servers = {}
    local req = request or http_request or (syn and syn.request)
    if req then
        local res = req({Url = "https://games.roblox.com/v1/games/"..MCXC_Egg.Config.PlaceID.."/servers/Public?sortOrder=Asc&limit=100"})
        if res and res.Body then
            local body = HttpService:JSONDecode(res.Body)
            if body and body.data then
                for _, v in ipairs(body.data) do
                    if v.playing < MCXC_Egg.Config.MaxPlayers and v.ping < MCXC_Egg.Config.MaxPing and not table.find(MCXC_Egg.State.VisitedServers, v.id) then
                        table.insert(servers, v.id)
                    end
                end
            end
        end
    end
    if #servers > 0 then return servers[math.random(1, #servers)] end
    return nil
end

function Utils.ServerHop()
    local s = Utils.GetServer()
    if s then
        table.insert(MCXC_Egg.State.VisitedServers, s)
        task.wait(math.random(2, 5))
        TeleportService:TeleportToPlaceInstance(MCXC_Egg.Config.PlaceID, s, LP)
    end
end

function Utils.ExecuteTask(eggName, targetPart)
    local tStart = tick()
    Utils.TweenTo(targetPart.Position)
    
    local function IsTimeout() return (tick() - tStart) > MCXC_Egg.Config.TaskTimeout end
    local prompt = targetPart:FindFirstChildWhichIsA("ProximityPrompt", true)
    
    if eggName == "Eggcited Egg" or eggName == "Golden Egg" or eggName == "Rocket Egg" or eggName == "Shockwave Egg" then
        if prompt and not IsTimeout() then fireproximityprompt(prompt) end
    elseif eggName == "Treasured Egg" then
        if prompt and not IsTimeout() then fireproximityprompt(prompt) end
    elseif eggName == "Thirsty Egg" then
        if prompt and not IsTimeout() then fireproximityprompt(prompt) end
        if not IsTimeout() then Utils.TweenTo(targetPart.Position + Vector3.new(0, -10, 0)) end
    elseif eggName == "Falling Sky Egg" then
        if not IsTimeout() then Utils.TweenTo(targetPart.Position + Vector3.new(0, 100, 0)) end
        if not IsTimeout() then Utils.TweenTo(targetPart.Position) end
        if prompt and not IsTimeout() then fireproximityprompt(prompt) end
    end
end

local function SmartTravel(target)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if (hrp.Position - target).Magnitude > 3000 then
        local nearestP, minD = nil, math.huge
        for _, p in ipairs(Portals) do
            local d = (hrp.Position - p).Magnitude
            if d < minD then minD = d; nearestP = p end
        end
        if nearestP then Utils.TweenTo(nearestP) end
        hrp.CFrame = CFrame.new(target)
        task.wait(1)
    else
        Utils.TweenTo(target)
    end
end

local function ScanAndCollect()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    task.wait(math.random(30, 60) / 100)
    
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and string.find(string.lower(v.Name), "egg") then
            if table.find(MCXC_Egg.Config.IgnoreEggs, v.Name) then continue end
            
            if table.find(MCXC_Egg.Config.PriorityEggs, v.Name) then
                local part = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
                if part and (hrp.Position - part.Position).Magnitude <= MCXC_Egg.Config.HitboxRadius then
                    if not MCXC_Egg.State.Collected[v.Name] then
                        Utils.ExecuteTask(v.Name, part)
                        MCXC_Egg.State.Collected[v.Name] = true
                        MCXC_Egg.State.EggCount = MCXC_Egg.State.EggCount + 1
                        MCXC_Egg.State.LastEggTime = tick()
                    end
                end
            end
        end
    end
end

local function GetSpawnPoints(center)
    return {
        center + Vector3.new(60, 0, 60),
        center + Vector3.new(-60, 0, 60),
        center + Vector3.new(60, 0, -60),
        center + Vector3.new(-60, 0, -60),
        center + Vector3.new(0, 40, 0)
    }
end

task.spawn(function()
    while task.wait(1) do
        for _, island in ipairs(Routes) do
            SmartTravel(island.pos)
            local points = GetSpawnPoints(island.pos)
            
            for _, pt in ipairs(points) do
                Utils.TweenTo(pt)
                ScanAndCollect()
            end
            
            local timeSince = tick() - MCXC_Egg.State.LastEggTime
            local runtime = tick() - MCXC_Egg.State.StartTime
            
            if timeSince >= 90 or MCXC_Egg.State.LoopCount >= 2 or (MCXC_Egg.State.EggCount <= 1 and runtime >= MCXC_Egg.Config.HopTimeLimit) then
                Utils.ServerHop()
            end
        end
        MCXC_Egg.State.LoopCount = MCXC_Egg.State.LoopCount + 1
    end
end)
