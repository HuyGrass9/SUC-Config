-- // SILENT AIM INDEPENDENT TEST MODULE
if not game:IsLoaded() then game.Loaded:Wait() end
local Players, RunService, UserInputService, StarterGui, Workspace, Camera, Drawing = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("StarterGui"), game:GetService("Workspace"), game:GetService("Workspace").CurrentCamera, Drawing
local LocalPlayer = Players.LocalPlayer
local LP_Character, LP_HRP, Mouse = nil, nil, LocalPlayer:GetMouse()
local Vector3_new, Vector2_new, CFrame_new, CFrame_Angles, math_huge, math_floor, math_clamp, math_abs, math_atan2, math_pi, math_rad, math_cos, math_sin, table_find, table_clear, table_remove, s_format, s_find, t_wait, t_spawn, t_tick = Vector3.new, Vector2.new, CFrame.new, CFrame.Angles, math.huge, math.floor, math.clamp, math.abs, math.atan2, math.pi, math.rad, math.cos, math.sin, table.find, table.clear, table.remove, string.format, string.find, task.wait, task.spawn, tick

--[[ CONFIG ]]--
local Config = {
    SilentAim = { Enabled = false, AimKey = Enum.UserInputType.MouseButton2, AimPart = "Head", Prediction = 0.1, TeamCheck = true, WallCheck = true, VisibleCheck = true },
    FOV = { Enabled = true, Radius = 150, CircleColor = Color3.fromRGB(0, 170, 255), LockedColor = Color3.fromRGB(255, 50, 70) },
    Smoothness = { Enabled = true, Value = 0.15 },
    Visuals = { ShowFOV = true, ShowStatus = true },
    UI = { Color = Color3.fromRGB(15, 15, 18), Accent = Color3.fromRGB(0, 170, 255), Danger = Color3.fromRGB(255, 50, 70) }
}

--[[ STATE ]]--
local State = { Target = nil, TargetPart = nil, IsLocking = false, SmoothCFrame = nil }
local Cache = { Players = {}, FOVCircle = nil, StatusText = nil, Hook = nil }

--[[ UTILS ]]--
local function IsAlive(Char) return Char and Char.Parent and Char:FindFirstChild("Humanoid") and Char.Humanoid.Health > 0 end
local function IsTeammate(Plr) return Config.SilentAim.TeamCheck and Plr and Plr.Team == LocalPlayer.Team end
local function GetCharacter(Plr) return Plr and Plr.Character end
local function GetPart(Char, PartName) return Char and Char:FindFirstChild(PartName) end

local function IsVisible(TargetPart)
    if not Config.SilentAim.VisibleCheck then return true end
    local Origin = Camera.CFrame.Position
    local Direction = (TargetPart.Position - Origin).Unit * (TargetPart.Position - Origin).Magnitude
    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    RaycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    local RaycastResult = Workspace:Raycast(Origin, Direction, RaycastParams)
    return not RaycastResult or RaycastResult.Instance:IsDescendantOf(TargetPart.Parent)
end

local function WorldToScreen(Pos)
    local Point = Camera:WorldToViewportPoint(Pos)
    return Vector2_new(Point.X, Point.Y), Point.Z > 0
end

local function GetClosestPlayerInFOV()
    local Nearest, NearestPart, MinAngle = nil, nil, Config.FOV.Radius / 10
    local CamPos, CamDir = Camera.CFrame.Position, Camera.CFrame.LookVector
    for _, Plr in ipairs(Players:GetPlayers()) do
        if Plr ~= LocalPlayer and not IsTeammate(Plr) then
            local Char = GetCharacter(Plr)
            if IsAlive(Char) then
                local Part = GetPart(Char, Config.SilentAim.AimPart) or GetPart(Char, "HumanoidRootPart")
                if Part and IsVisible(Part) then
                    local Dir = (Part.Position - CamPos).Unit
                    local Angle = math_acos(math_clamp(CamDir:Dot(Dir), -1, 1))
                    if Angle < MinAngle then MinAngle, Nearest, NearestPart = Angle, Plr, Part end
                end
            end
        end
    end
    return Nearest, NearestPart
end

local function PredictPosition(TargetPart, DeltaTime)
    if Config.SilentAim.Prediction <= 0 then return TargetPart.Position end
    local Velocity = TargetPart.Velocity or TargetPart.AssemblyLinearVelocity or Vector3_new(0,0,0)
    return TargetPart.Position + (Velocity * Config.SilentAim.Prediction * DeltaTime)
end

--[[ HOOKING ]]--
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args, Method = {...}, getnamecallmethod()
    if Method == "FireServer" and Config.SilentAim.Enabled and State.TargetPart and State.IsLocking then
        local Remote = Self
        if s_find(Remote.Name, "Shoot") or s_find(Remote.Name, "Fire") then
            local DeltaTime = t_tick() - (State.LastTick or 0)
            State.LastTick = t_tick()
            local TargetPos = PredictPosition(State.TargetPart, DeltaTime)
            if Args[2] and typeof(Args[2]) == "Vector3" then
                Args[2] = TargetPos
            elseif Args[3] and typeof(Args[3]) == "Vector3" then
                Args[3] = TargetPos
            elseif Args[1] and typeof(Args[1]) == "Vector3" then
                Args[1] = TargetPos
            end
            return OldNamecall(Self, unpack(Args))
        end
    end
    return OldNamecall(Self, ...)
end)
--[[ CORE LOGIC ]]--
local function UpdateAim(DeltaTime)
    if not Config.SilentAim.Enabled then State.IsLocking, State.Target, State.TargetPart = false, nil, nil; return end
    local IsKeyDown = Config.SilentAim.AimKey == Enum.UserInputType.MouseButton2 and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or (Config.SilentAim.AimKey ~= Enum.UserInputType.MouseButton2 and UserInputService:IsKeyDown(Config.SilentAim.AimKey))
    if not IsKeyDown then State.IsLocking, State.Target, State.TargetPart = false, nil, nil; return end
    State.Target, State.TargetPart = GetClosestPlayerInFOV()
    State.IsLocking = State.Target ~= nil
end

--[[ UI SETUP ]]--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = (syn and syn.protect_gui and syn.protect_gui(ScreenGui)) or gethui() or game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size, MainFrame.Position, MainFrame.BackgroundColor3, MainFrame.BorderSizePixel = UDim2.new(0, 200, 0, 180), UDim2.new(0, 20, 0, 100), Config.UI.Color, 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color, Instance.new("UIStroke", MainFrame).Thickness = Color3.fromRGB(40,40,45), 1.5

local TitleBar = Instance.new("TextButton")
TitleBar.Size, TitleBar.Position, TitleBar.BackgroundColor3, TitleBar.Text, TitleBar.TextColor3, TitleBar.Font, TitleBar.TextSize = UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 0), Config.UI.Accent, "SILENT AIM", Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 14
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

local function CreateToggle(Parent, Y, Text, Callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size, ToggleFrame.Position, ToggleFrame.BackgroundTransparency = UDim2.new(1, -16, 0, 30), UDim2.new(0, 8, 0, Y), 1
    ToggleFrame.Parent = Parent
    local Label = Instance.new("TextLabel")
    Label.Size, Label.Position, Label.BackgroundTransparency, Label.Text, Label.TextColor3, Label.Font, Label.TextSize, Label.TextXAlignment = UDim2.new(0.6, 0, 1, 0), UDim2.new(0, 0, 0, 0), 1, Text, Color3.fromRGB(255,255,255), Enum.Font.Gotham, 12, Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size, ToggleBtn.Position, ToggleBtn.BackgroundColor3, ToggleBtn.Text = UDim2.new(0, 34, 0, 18), UDim2.new(1, -34, 0.5, -9), Config.UI.Accent, ""
    ToggleBtn.Parent = ToggleFrame
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    local Dot = Instance.new("Frame")
    Dot.Size, Dot.Position, Dot.BackgroundColor3 = UDim2.new(0, 14, 0, 14), UDim2.new(0, 3, 0.5, -7), Color3.fromRGB(255,255,255)
    Dot.Parent = ToggleBtn
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    ToggleBtn.MouseButton1Click:Connect(function()
        Callback()
        ToggleBtn.BackgroundColor3 = Config.SilentAim.Enabled and Config.UI.Accent or Color3.fromRGB(50,50,55)
        Dot.Position = Config.SilentAim.Enabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    end)
    return ToggleFrame
end

local YPos = 40
CreateToggle(MainFrame, YPos, "Enable Silent Aim", function() Config.SilentAim.Enabled = not Config.SilentAim.Enabled end)
YPos = YPos + 35
CreateToggle(MainFrame, YPos, "Show FOV Circle", function() Config.Visuals.ShowFOV = not Config.Visuals.ShowFOV end)
YPos = YPos + 35
CreateToggle(MainFrame, YPos, "Team Check", function() Config.SilentAim.TeamCheck = not Config.SilentAim.TeamCheck end)
YPos = YPos + 35
CreateToggle(MainFrame, YPos, "Wall Check", function() Config.SilentAim.WallCheck = not Config.SilentAim.WallCheck end)

local function MakeDraggable(Object, Handle)
    local Dragging, DragStart, StartPos
    Handle.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging, DragStart, StartPos = true, Input.Position, Object.Position
        end
    end)
    Handle.InputEnded:Connect(function(Input) if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = Input.Position - DragStart
            Object.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
end
MakeDraggable(MainFrame, TitleBar)

--[[ DRAWING SETUP ]]--
Cache.FOVCircle = Drawing.new("Circle")
Cache.FOVCircle.Visible, Cache.FOVCircle.Thickness, Cache.FOVCircle.NumSides, Cache.FOVCircle.Radius, Cache.FOVCircle.Color, Cache.FOVCircle.Position = false, 1.5, 100, Config.FOV.Radius, Config.FOV.CircleColor, Vector2_new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
Cache.StatusText = Drawing.new("Text")
Cache.StatusText.Visible, Cache.StatusText.Text, Cache.StatusText.Size, Cache.StatusText.Color, Cache.StatusText.Center, Cache.StatusText.Outline, Cache.StatusText.Font = false, "LOCKING TARGET", 20, Color3.fromRGB(0,255,120), true, true, 2

--[[ MAIN LOOP ]]--
RunService.RenderStepped:Connect(function(DeltaTime)
    UpdateAim(DeltaTime)
    if Config.Visuals.ShowFOV then
        Cache.FOVCircle.Visible, Cache.FOVCircle.Radius, Cache.FOVCircle.Position = true, Config.FOV.Radius, Vector2_new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        Cache.FOVCircle.Color = State.IsLocking and Config.FOV.LockedColor or Config.FOV.CircleColor
    else Cache.FOVCircle.Visible = false end
    if Config.Visuals.ShowStatus then
        Cache.StatusText.Visible, Cache.StatusText.Position = State.IsLocking, Vector2_new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2 + Config.FOV.Radius + 25)
        if State.Target then Cache.StatusText.Text = "LOCKING: " .. State.Target.Name else Cache.StatusText.Visible = false end
    else Cache.StatusText.Visible = false end
end)

StarterGui:SetCore("SendNotification", { Title = "Silent Aim", Text = "Test module loaded. Use GUI to configure.", Duration = 5 })
