local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RUN = game:GetService("RunService")
local PLRS = game:GetService("Players")
local LP = PLRS.LocalPlayer

local FLUENT = loadstring(game:HttpGet("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()

setclipboard("https://discord.gg/mH6kQAYn")

-- ── WINDOW ────────────────────────────────────────────────────────────────────

local WIN = FLUENT:CreateWindow({
    Title = "Blessed Hub by beraatwr",
    SubTitle = "Key system",
    Theme = "Darker",
    Acrylic = false,
    Resize = true,
    Size = UDim2.fromOffset(600, 350),
    TabWidth = 160,
    MinimizeKey = Enum.KeyCode.RightControl,
    MinSize = Vector2.new(500, 300),
})

-- ── KEY TAB ───────────────────────────────────────────────────────────────────

local VALID_KEYS = { "Lasius" }
local KEY_TAB = WIN:CreateTab({ Title = "key", Icon = "phosphor-key-bold" })

local INPUT_VAL = ""
KEY_TAB:CreateInput("KeyInput", {
    Title = "Enter key",
    Placeholder = "Enter your key here",
    Callback = function(v) INPUT_VAL = v end,
})

KEY_TAB:CreateButton({
    Title = "Copy discord link",
    Callback = function()
        setclipboard("https://discord.gg/mH6kQAYn")
        FLUENT:Notify({ Title = "Copied!", Content = "Discord link copied to clipboard.", Duration = 3 })
    end,
})

KEY_TAB:CreateButton({
    Title = "Confirm",
    Callback = function()
        local valid = false
        for _, k in VALID_KEYS do
            if INPUT_VAL == k then valid = true break end
        end

        if not valid then
            FLUENT:Notify({ Title = "Invalid Key!", Content = "The key you entered is incorrect.", Duration = 3 })
            return
        end

        -- ── MAIN TABS ─────────────────────────────────────────────────────────

        local CHAR = LP.Character or LP.CharacterAdded:Wait()
        local HUM  = CHAR:WaitForChild("Humanoid")

        LP.CharacterAdded:Connect(function(c)
            CHAR = c
            HUM  = c:WaitForChild("Humanoid")
        end)

        local SPAWNER = WIN:CreateTab({ Title = "spawner", Icon = "phosphor-cube-bold" })
        local MISC    = WIN:CreateTab({ Title = "misc",    Icon = "phosphor-person-bold" })

        -- ── SPAWNER ───────────────────────────────────────────────────────────

        local function autoSpawn(flag, remote)
            local REM = RS:WaitForChild(remote)
            task.spawn(function()
                while flag[1] do REM:FireServer() task.wait(1) end
            end)
        end

        local FLAGS = {
            lucky   = {false},
            rainbow = {false},
            galaxy  = {false},
            diamond = {false},
            all     = {false},
        }

        SPAWNER:CreateToggle("LuckyToggle",   { Title = "lucky block",   Default = false, Callback = function(v) FLAGS.lucky[1]   = v if v then autoSpawn(FLAGS.lucky,   "SpawnLuckyBlock")   end end })
        SPAWNER:CreateToggle("RainbowToggle", { Title = "rainbow block", Default = false, Callback = function(v) FLAGS.rainbow[1] = v if v then autoSpawn(FLAGS.rainbow, "SpawnRainbowBlock") end end })
        SPAWNER:CreateToggle("GalaxyToggle",  { Title = "galaxy block",  Default = false, Callback = function(v) FLAGS.galaxy[1]  = v if v then autoSpawn(FLAGS.galaxy,  "SpawnGalaxyBlock")  end end })
        SPAWNER:CreateToggle("DiamondToggle", { Title = "diamond block", Default = false, Callback = function(v) FLAGS.diamond[1] = v if v then autoSpawn(FLAGS.diamond, "SpawnDiamondBlock") end end })
        SPAWNER:CreateToggle("AllToggle", {
            Title = "all blocks",
            Default = false,
            Callback = function(v)
                FLAGS.all[1] = v
                if not v then return end
                task.spawn(function()
                    local REMOTES = {
                        RS:WaitForChild("SpawnLuckyBlock"),
                        RS:WaitForChild("SpawnRainbowBlock"),
                        RS:WaitForChild("SpawnGalaxyBlock"),
                        RS:WaitForChild("SpawnDiamondBlock"),
                    }
                    while FLAGS.all[1] do
                        for _, rem in REMOTES do rem:FireServer() end
                        task.wait(1)
                    end
                end)
            end,
        })

        -- ── MISC ──────────────────────────────────────────────────────────────

        MISC:CreateSlider("WSSlider", {
            Title = "walkspeed",
            Min = 16, Max = 250, Default = 16, Rounding = 0,
            Callback = function(v) if HUM then HUM.WalkSpeed = v end end,
        })

        MISC:CreateSlider("JPSlider", {
            Title = "jump power",
            Min = 50, Max = 300, Default = 50, Rounding = 0,
            Callback = function(v) if HUM then HUM.JumpPower = v end end,
        })

        local DEFAULT_FOV = workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70
        local CURRENT_FOV = DEFAULT_FOV

        MISC:CreateSlider("FOVSlider", {
            Title = "field of view",
            Min = 30, Max = 120, Default = DEFAULT_FOV, Rounding = 0,
            Callback = function(v)
                CURRENT_FOV = v
                if workspace.CurrentCamera then
                    workspace.CurrentCamera.FieldOfView = v
                end
            end,
        })

        workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            local cam = workspace.CurrentCamera
            if cam then task.wait() cam.FieldOfView = CURRENT_FOV end
        end)

        local INF_JUMP = false
        MISC:CreateToggle("InfJump", {
            Title = "infinite jump",
            Default = false,
            Callback = function(v) INF_JUMP = v end,
        })
        UIS.JumpRequest:Connect(function()
            if INF_JUMP and HUM then HUM:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)

        local NOCLIP_CONN = nil
        MISC:CreateToggle("Noclip", {
            Title = "noclip",
            Default = false,
            Callback = function(v)
                if v then
                    NOCLIP_CONN = RUN.Stepped:Connect(function()
                        if not CHAR then return end
                        for _, p in CHAR:GetDescendants() do
                            if p:IsA("BasePart") then p.CanCollide = false end
                        end
                    end)
                else
                    if NOCLIP_CONN then NOCLIP_CONN:Disconnect() NOCLIP_CONN = nil end
                    if CHAR then
                        for _, p in CHAR:GetDescendants() do
                            if p:IsA("BasePart") then p.CanCollide = true end
                        end
                    end
                end
            end,
        })

        MISC:CreateButton({
            Title = "inf yield",
            Callback = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            end,
        })

        WIN:SelectTab(2)

        -- hide key tab
        task.spawn(function()
            task.wait(0.1)
            for _, v in game.CoreGui:GetDescendants() do
                if v:IsA("TextButton") and v.Text == "key" then
                    v.Visible = false
                    break
                end
            end
        end)

        FLUENT:Notify({
            Title = "Blessed Hub",
            Content = "welcome!",
            Duration = 4,
        })
    end,
})

WIN:SelectTab(1)
