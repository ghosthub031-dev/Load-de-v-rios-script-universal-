--============================================================
-- ghost Scripts - Natural Disaster Survival
-- by @ghost.scripts.01
-- Versão reescrita e organizada: 1.2.0
--============================================================

-- ============================================================
-- [0] VERIFICAÇÃO DE JOGO
-- ============================================================
local NATURAL_DISASTER_PLACEID = 189707
if game.PlaceId ~= NATURAL_DISASTER_PLACEID then
    game:GetService("Players").LocalPlayer:Kick("ghost Scripts: jogo não suportado (apenas Natural Disaster Survival).")
    return
end

-- ============================================================
-- [1] SERVIÇOS E REFERÊNCIAS GLOBAIS
-- ============================================================
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UIS                = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TextChatService    = game:GetService("TextChatService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local Camera    = workspace.CurrentCamera

-- ============================================================
-- [2] CARREGAR A LIB
-- ============================================================
local redzlib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/nombrehumilde-cyber/Library/refs/heads/main/testee3"
))()

redzlib:SetTheme({
    Main         = Color3.fromRGB(211, 211, 211),
    Second       = Color3.fromRGB(10, 20, 40),
    Stroke       = Color3.fromRGB(160, 160, 160),
    Divider      = Color3.fromRGB(130, 130, 130),
    Text         = Color3.fromRGB(255, 255, 255),
    TextDark     = Color3.fromRGB(200, 200, 200),
    Object       = Color3.fromRGB(0, 0, 0),
    ObjectStroke = Color3.fromRGB(30, 30, 30),
    Hover        = Color3.fromRGB(20, 20, 20),
    Pressed      = Color3.fromRGB(40, 40, 40),
})

local Window = redzlib:MakeWindow({
    Title      = "ghost Scripts | natural desastrer",
    SubTitle   = "by @ghost.scripts.01",
    SaveFolder = "GhostScripts_NDS",
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://139984424145579", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

-- ============================================================
-- [3] HELPERS GLOBAIS
-- ============================================================
local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function getPlayerNames(excludeSelf)
    local t = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if not excludeSelf or plr ~= player then
            table.insert(t, plr.Name)
        end
    end
    return t
end

-- ============================================================
-- [4] ABA: INFORMAÇÕES
-- ============================================================
local Tab1 = Window:MakeTab({ "Informações do hub e do player", "info" })
Tab1:AddSection("Aviso")
Tab1:AddParagraph("ghost Scripts AVISO",
    "Novidades: novas opções na aba Universais e menu mais organizado.")

Tab1:AddSection("Criadores")
Tab1:AddParagraph("Informações do Hub",
    "Criador: @ghost.scripts.01\nCanal: https://youtube.com/@ghost.scripts.01")

Tab1:AddDiscordInvite({
    Name        = "ghost Scripts | YouTube",
    Description = "Inscreva-se",
    Logo        = "rbxassetid://139984424145579",
    Invite      = "https://youtube.com/@ghost.scripts.01?si=XZF3V5G0aKXoqmtR",
    Color       = Color3.fromRGB(211, 211, 211),
})
Tab1:AddParagraph("Versão", "1.2.0")

local gameName = "Desconhecido"
pcall(function()
    gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

local executorName = "Desconhecido"
pcall(function()
    if getexecutorname then
        executorName = getexecutorname()
    elseif identifyexecutor then
        executorName = identifyexecutor()
    end
end)

Tab1:AddSection("Informações do Player")
Tab1:AddParagraph("Player",
    "Nick: "       .. player.Name        ..
    "\nID: "       .. player.UserId      ..
    "\nGame: "     .. gameName           ..
    "\nExecutor: " .. executorName)

Tab1:AddSection("Atualizações")
Tab1:AddButton({
    Name = "Ver Atualizações",
    Callback = function()
        Window:Dialog({
            Title = "Atualizações",
            Text =
                "[+] Organização nas abas\n" ..
                "[+] Opções na aba Universais\n" ..
                "[+] Opções exclusivas Natural Disaster\n" ..
                "[+] Tag do hub no chat\n" ..
                "[+] Mais estilo no menu",
            Options = { { "OK", function() print("Atualizações visualizadas") end } },
        })
    end,
})

Tab1:AddButton({
    Name = "Canal do Criador",
    Callback = function()
        setclipboard("https://youtube.com/@ghost.scripts.01?si=XZF3V5G0aKXoqmtR")
        Window:Dialog({
            Title = "Canal do Criador",
            Text  = "Link copiado para a área de transferência!",
            Options = { { "OK", function() end } },
        })
    end,
})

Tab1:AddButton({
    Name = "YouTube do Criador",
    Callback = function()
        setclipboard("https://youtube.com/@ghost.scripts.01?si=XZF3V5G0aKXoqmtR")
        Window:Dialog({
            Title = "YouTube do Criador",
            Text  = "Link copiado para a área de transferência!",
            Options = { { "OK", function() end } },
        })
    end,
})

-- ============================================================
-- [5] ABA: BÁSICOS
-- ============================================================
local Tab2 = Window:MakeTab({ "Básicos", "settings" })

local humanoid
local infJumpConn
local noclipConn
local noclipState = false

local function refreshHumanoid()
    humanoid = getHumanoid()
end
refreshHumanoid()
player.CharacterAdded:Connect(refreshHumanoid)

-- ---- Noclip Unificado ----
local function setNoclip(state)
    noclipState = state
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            local char = player.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

Tab2:AddSection("Básicos")

Tab2:AddSlider({
    Name = "Speed", Min = 0, Max = 200, Default = 16,
    Callback = function(v) if humanoid then humanoid.WalkSpeed = v end end,
})

Tab2:AddSlider({
    Name = "JumpPower", Min = 0, Max = 200, Default = 50,
    Callback = function(v)
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = v
        end
    end,
})

Tab2:AddToggle({
    Name = "Infinite Jump", Default = false,
    Callback = function(state)
        if state then
            infJumpConn = UIS.JumpRequest:Connect(function()
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
        end
    end,
})

Tab2:AddButton({
    Name = "TP Tool",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.Name = "TP Tool"
        tool.RequiresHandle = false
        tool.Parent = player.Backpack
        tool.Activated:Connect(function()
            local mouse = player:GetMouse()
            if mouse and mouse.Hit then
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
                end
            end
        end)
    end,
})

Tab2:AddToggle({
    Name = "Noclip", Default = false,
    Callback = function(state) setNoclip(state) end,
})

Tab2:AddTextBox({
    Name = "Spin",
    Placeholder = "Digite a velocidade de spin",
    Callback = function(value)
        local speed = tonumber(value)
        if not speed then return end
        local char = player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if hrp:FindFirstChild("SpinBody") then hrp.SpinBody:Destroy() end
        local spin = Instance.new("BodyAngularVelocity")
        spin.Name           = "SpinBody"
        spin.MaxTorque      = Vector3.new(math.huge, math.huge, math.huge)
        spin.AngularVelocity = Vector3.new(0, speed, 0)
        spin.Parent         = hrp
    end,
})

Tab2:AddSection("Resetar")
Tab2:AddButton({
    Name = "Reset Speed",
    Callback = function() if humanoid then humanoid.WalkSpeed = 16 end end,
})
Tab2:AddButton({
    Name = "Reset JumpPower",
    Callback = function()
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
        end
    end,
})
Tab2:AddButton({
    Name = "Reset All",
    Callback = function()
        if humanoid then
            humanoid.WalkSpeed  = 16
            humanoid.UseJumpPower = true
            humanoid.JumpPower  = 50
        end
    end,
})

-- ============================================================
-- [6] ABA: TROLL
-- ============================================================
local TabTroll = Window:MakeTab({ "Troll", "skull" })

local SelectedPlayer
local LoopFling       = false
local FlingSpin
local ClickFlingTool
local ClickFlingSpin
local Flinging        = false
local MAX_DISTANCE    = 25

local PlayerDropdown = TabTroll:AddDropdown({
    Name    = "Lista de Players",
    Options = getPlayerNames(true),
    Callback = function(v) SelectedPlayer = v end,
})

TabTroll:AddButton({
    Name = "Atualizar lista",
    Callback = function() PlayerDropdown:Set(getPlayerNames(true)) end,
})

-- ---- ClickFling (original) ----
TabTroll:AddSection("Flings Normais")

TabTroll:AddButton({
    Name = "ClickFling",
    Callback = function()
        if ClickFlingTool then ClickFlingTool:Destroy(); ClickFlingTool = nil end

        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        ClickFlingTool = Instance.new("Tool")
        ClickFlingTool.Name = "fling"
        ClickFlingTool.RequiresHandle = false
        ClickFlingTool.Parent = player.Backpack

        ClickFlingTool.Activated:Connect(function()
            if Flinging then return end
            local mouse = player:GetMouse()
            if not mouse.Target then return end
            local model = mouse.Target:FindFirstAncestorOfClass("Model")
            if not model or model == char then return end
            local targetHRP = model:FindFirstChild("HumanoidRootPart")
            local targetHum = model:FindFirstChildOfClass("Humanoid")
            if not targetHRP or not targetHum then return end

            Flinging = true
            setNoclip(true)

            ClickFlingSpin = Instance.new("BodyAngularVelocity")
            ClickFlingSpin.AngularVelocity = Vector3.new(0, 99999, 0)
            ClickFlingSpin.MaxTorque       = Vector3.new(0, math.huge, 0)
            ClickFlingSpin.Parent          = hrp
            Camera.CameraSubject = targetHum

            task.spawn(function()
                while Flinging do
                    if hum.FloorMaterial == Enum.Material.Air then break end
                    if not targetHRP.Parent then break end
                    if (hrp.Position - targetHRP.Position).Magnitude > MAX_DISTANCE then break end
                    hrp.CFrame = targetHRP.CFrame
                    task.wait(0.1)
                end
                Flinging = false
                setNoclip(false)
                if ClickFlingSpin then ClickFlingSpin:Destroy(); ClickFlingSpin = nil end
                Camera.CameraSubject = hum
            end)
        end)

        hum.Seated:Connect(function(active)
            if active then
                Flinging = false
                setNoclip(false)
                if ClickFlingSpin then ClickFlingSpin:Destroy(); ClickFlingSpin = nil end
                if ClickFlingTool then ClickFlingTool.Parent = workspace; ClickFlingTool = nil end
            end
        end)
    end,
})

TabTroll:AddToggle({
    Name = "Fling",
    SubTitle = "Empurre jogadores para fora do mapa!",
    Default = false,
    Callback = function(state)
        local char = player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if state then
            setNoclip(true)
            FlingSpin = Instance.new("BodyAngularVelocity")
            FlingSpin.AngularVelocity = Vector3.new(0, 200000, 0)
            FlingSpin.MaxTorque       = Vector3.new(0, math.huge, 0)
            FlingSpin.Parent          = hrp
        else
            if FlingSpin then FlingSpin:Destroy(); FlingSpin = nil end
            setNoclip(false)
        end
    end,
})

-- ---- Fling em jogador selecionado ----
local function flingSelected(looped)
    if not SelectedPlayer then return end
    local target = Players:FindFirstChild(SelectedPlayer)
    if not target or not target.Character then return end
    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local thrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not thrp then return end

    setNoclip(true)
    if not FlingSpin then
        FlingSpin = Instance.new("BodyAngularVelocity")
        FlingSpin.AngularVelocity = Vector3.new(0, 200000, 0)
        FlingSpin.MaxTorque       = Vector3.new(0, math.huge, 0)
        FlingSpin.Parent          = hrp
    end

    if looped then
        task.spawn(function()
            while LoopFling do
                if not thrp.Parent then break end
                hrp.CFrame = thrp.CFrame
                task.wait(0.1)
            end
        end)
    else
        hrp.CFrame = thrp.CFrame
    end
end

TabTroll:AddSection("Opções de Jogador Selecionado")

TabTroll:AddButton({
    Name = "Fling player selecionado",
    Callback = function() flingSelected(false) end,
})

TabTroll:AddToggle({
    Name = "LoopFling (player selecionado)",
    Default = false,
    Callback = function(state)
        LoopFling = state
        if state then
            flingSelected(true)
        else
            if FlingSpin then FlingSpin:Destroy(); FlingSpin = nil end
            setNoclip(false)
        end
    end,
})

TabTroll:AddToggle({
    Name = "View Player",
    Default = false,
    Callback = function(state)
        if state then
            if not SelectedPlayer then return end
            local target = Players:FindFirstChild(SelectedPlayer)
            local hum = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
            if hum then Camera.CameraSubject = hum end
        else
            local char = player.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hum then Camera.CameraSubject = hum end
        end
    end,
})

-- ---- Drone Camera (CORRIGIDO) ----
TabTroll:AddSection("Drone")
local DroneEnabled = false
local DroneSpeed   = 50
local droneMoveDir = Vector3.new(0, 0, 0)
local droneConn
local droneGui

TabTroll:AddToggle({
    Name = "Drone Camera",
    Default = false,
    Callback = function(state)
        DroneEnabled = state
        local char = player.Character

        if state then
            -- Ativar
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Anchored = true
            end
            Camera.CameraType = Enum.CameraType.Scriptable
            local startPos = (char and char:FindFirstChild("HumanoidRootPart")
                              and char.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
                              or Vector3.new(0, 5, 0)
            Camera.CFrame = CFrame.new(startPos)

            -- GUI de botões
            droneGui = Instance.new("ScreenGui")
            droneGui.Name = "DroneGui"
            droneGui.Parent = player:WaitForChild("PlayerGui")

            local function createButton(pos, text)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0, 50, 0, 50)
                btn.Position = pos
                btn.Text = text
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Parent = droneGui
                return btn
            end

            local btnLeft  = createButton(UDim2.new(0, 10,  0.9, 0), "<")
            local btnRight = createButton(UDim2.new(0, 70,  0.9, 0), ">")
            local btnUp    = createButton(UDim2.new(0, 130, 0.9, 0), "^")
            local btnDown  = createButton(UDim2.new(0, 190, 0.9, 0), "v")

            btnLeft.MouseButton1Down:Connect(function()  droneMoveDir = Vector3.new(-1, 0, 0) end)
            btnLeft.MouseButton1Up:Connect(function()    droneMoveDir = Vector3.new(0, 0, 0) end)
            btnRight.MouseButton1Down:Connect(function() droneMoveDir = Vector3.new(1, 0, 0) end)
            btnRight.MouseButton1Up:Connect(function()   droneMoveDir = Vector3.new(0, 0, 0) end)
            btnUp.MouseButton1Down:Connect(function()    droneMoveDir = Vector3.new(0, 0, 1) end)
            btnUp.MouseButton1Up:Connect(function()      droneMoveDir = Vector3.new(0, 0, 0) end)
            btnDown.MouseButton1Down:Connect(function()  droneMoveDir = Vector3.new(0, 0, -1) end)
            btnDown.MouseButton1Up:Connect(function()    droneMoveDir = Vector3.new(0, 0, 0) end)

            -- Loop de movimento (FIX: dt único)
            if droneConn then droneConn:Disconnect() end
            droneConn = RunService.RenderStepped:Connect(function(dt)
                if not DroneEnabled then return end
                local cf = Camera.CFrame
                local forward = cf.LookVector
                local right   = cf.RightVector
                Camera.CFrame = cf + (forward * droneMoveDir.Z + right * droneMoveDir.X) * DroneSpeed * dt
            end)
        else
            -- Desativar
            if droneConn then droneConn:Disconnect(); droneConn = nil end
            Camera.CameraType = Enum.CameraType.Custom
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Anchored = false
            end
            if droneGui then droneGui:Destroy(); droneGui = nil end
        end
    end,
})

-- ---- Diversão ----
TabTroll:AddSection("Diversão")
TabTroll:AddButton({
    Name = "Infecção Noob (Todos viram Noob)",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet(
                "https://rawscripts.net/raw/Natural-Disaster-Survival-Fe-Noob-lnfecIon-102967"
            ))()
        end)
    end,
})

-- ---- Fling v2 (melhorado) ----
TabTroll:AddSection("Opções Melhoradas")
TabTroll:AddButton({
    Name = "Fling player selecionado v2 (melhorado)",
    Callback = function()
        if not SelectedPlayer then return end
        local target = Players:FindFirstChild(SelectedPlayer)
        if not target or not target.Character then return end
        local char = player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local thrp = target.Character:FindFirstChild("HumanoidRootPart")
        if not hrp or not thrp then return end

        setNoclip(true)
        if not FlingSpin then
            FlingSpin = Instance.new("BodyAngularVelocity")
            FlingSpin.AngularVelocity = Vector3.new(0, 200000, 0)
            FlingSpin.MaxTorque       = Vector3.new(0, math.huge, 0)
            FlingSpin.Parent          = hrp
        end
        hrp.CFrame = thrp.CFrame + Vector3.new(0, 3, 0)

        task.delay(2, function()
            if FlingSpin then FlingSpin:Destroy(); FlingSpin = nil end
            setNoclip(false)
        end)
    end,
})

-- ---- LoopFling V2 ----
local LoopFlingV2 = false
local OriginalCFrame
local TargetRespawnConn
local ReturnLoop
local V2Spin

local function stopLoopFlingV2()
    LoopFlingV2 = false
    if TargetRespawnConn then TargetRespawnConn:Disconnect(); TargetRespawnConn = nil end
    if ReturnLoop then task.cancel(ReturnLoop); ReturnLoop = nil end
    if V2Spin then V2Spin:Destroy(); V2Spin = nil end
    setNoclip(false)
end

local function startLoopFlingV2()
    if not SelectedPlayer then return end
    local target = Players:FindFirstChild(SelectedPlayer)
    if not target then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    OriginalCFrame = hrp.CFrame
    setNoclip(true)

    V2Spin = Instance.new("BodyAngularVelocity")
    V2Spin.AngularVelocity = Vector3.new(0, 200000, 0)
    V2Spin.MaxTorque       = Vector3.new(0, math.huge, 0)
    V2Spin.Parent          = hrp

    local function tpToTarget()
        if not LoopFlingV2 then return end
        if not target.Character then return end
        local thrp = target.Character:FindFirstChild("HumanoidRootPart")
        if thrp then hrp.CFrame = thrp.CFrame end
    end

    task.wait(0.2)
    tpToTarget()

    if TargetRespawnConn then TargetRespawnConn:Disconnect() end
    TargetRespawnConn = target.CharacterAdded:Connect(function()
        task.wait(0.4)
        tpToTarget()
    end)

    ReturnLoop = task.spawn(function()
        while LoopFlingV2 do
            task.wait(2)
            if hrp and OriginalCFrame then hrp.CFrame = OriginalCFrame end
        end
    end)
end

TabTroll:AddToggle({
    Name = "LoopFling player selecionado v2",
    Default = false,
    Callback = function(state)
        if state then
            LoopFlingV2 = true
            startLoopFlingV2()
        else
            stopLoopFlingV2()
        end
    end,
})

-- ============================================================
-- [7] ABA: AVANÇADOS
-- ============================================================
local TabAvancados = Window:MakeTab({ "Avançados", "monitor" })
TabAvancados:AddSection("Outros")

TabAvancados:AddButton({
    Name = "Fly",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-HD-Admin-Fly-60269"))()
        end)
    end,
})
TabAvancados:AddButton({
    Name = "FE Emote",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024"))()
        end)
    end,
})
TabAvancados:AddButton({
    Name = "Telekineses",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-telekineses-14126"))()
        end)
    end,
})
TabAvancados:AddButton({
    Name = "Fly Gui V3",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-Gui-V3-59173"))()
        end)
    end,
})

-- ============================================================
-- [8] ABA: EXCLUSIVOS NATURAL DISASTER
-- ============================================================
local TabScripts = Window:MakeTab({ "Exclusivos NDS", "script" })
TabScripts:AddSection("Scripts exclusivos para Natural Disaster")

TabScripts:AddButton({
    Name = "Super Ring V4",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet(
                "https://rawscripts.net/raw/Natural-Disaster-Survival-Super-ring-V4-24296"
            ))()
        end)
    end,
})
TabScripts:AddButton({
    Name = "Axomic",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet(
                "https://rawscripts.net/raw/Natural-Disaster-Survival-Axomic-Natural-Disasters-Script-112924"
            ))()
        end)
    end,
})
TabScripts:AddButton({
    Name = "Saturn Hub",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet(
                "https://rawscripts.net/raw/Natural-Disaster-Survival-Sarturn-hub-NDS-116064"
            ))()
        end)
    end,
})

-- ============================================================
-- [9] ABA: UNIVERSAIS
-- ============================================================
local TabUniversais = Window:MakeTab({ "Universais", "globe" })
TabUniversais:AddSection("Scripts Universais")

local universalScripts = {
    { "Infinite Yield",  "https://rawscripts.net/raw/Universal-Script-inf-yeld-61578" },
    { "Nameless Admin",  "https://rawscripts.net/raw/Universal-Script-Nameless-admin-111753" },
    { "Tiger X",         "https://rawscripts.net/raw/Universal-Script-Tiger-X-78475" },
    { "System Broken",   "https://rawscripts.net/raw/Universal-Script-System-Broken-94677" },
    { "Coquette Hub Chat","https://rawscripts.net/raw/Universal-Script-Chat-Coquette-106124" },
}
for _, s in ipairs(universalScripts) do
    TabUniversais:AddButton({
        Name = s[1],
        Callback = function()
            pcall(function() loadstring(game:HttpGet(s[2]))() end)
        end,
    })
end

-- ============================================================
-- [10] ABA: FUN
-- ============================================================
local TabFun = Window:MakeTab({ "Fun", "smile" })
local SelectedFunPlayer
local SitConnection

local FunDropdown = TabFun:AddDropdown({
    Name    = "Lista de Players",
    Options = getPlayerNames(true),
    Callback = function(v) SelectedFunPlayer = v end,
})
TabFun:AddButton({
    Name = "Atualizar lista",
    Callback = function() FunDropdown:Set(getPlayerNames(true)) end,
})

local function startSit(mode)
    if SitConnection then SitConnection:Disconnect(); SitConnection = nil end
    SitConnection = RunService.Heartbeat:Connect(function()
        if not SelectedFunPlayer then return end
        local target = Players:FindFirstChild(SelectedFunPlayer)
        if not target or not target.Character then return end
        local char = player.Character
        if not char then return end

        local hrp  = char:FindFirstChild("HumanoidRootPart")
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local thrp = target.Character:FindFirstChild("HumanoidRootPart")
        local head = target.Character:FindFirstChild("Head")
        if not hrp or not thrp or not hum then return end

        hum.Sit = true
        if mode == "head" and head then
            hrp.CFrame = head.CFrame * CFrame.new(0, 1.5, 0)
        elseif mode == "back" then
            hrp.CFrame = thrp.CFrame * CFrame.new(0, 0, -1)
        end
    end)
end

TabFun:AddToggle({
    Name = "Sentar na cabeça do alvo", Default = false,
    Callback = function(state)
        if state then startSit("head")
        else if SitConnection then SitConnection:Disconnect(); SitConnection = nil end end
    end,
})
TabFun:AddToggle({
    Name = "Modo mochila", Default = false,
    Callback = function(state)
        if state then startSit("back")
        else if SitConnection then SitConnection:Disconnect(); SitConnection = nil end end
    end,
})

-- ============================================================
-- [11] ABA: GAMEPASS
-- ============================================================
local tabGamepass = Window:MakeTab({ "Gamepass", "flame" })
tabGamepass:AddSection("Visuais")

tabGamepass:AddButton({
    Name = "Maçã vermelha",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet(
                "https://raw.githubusercontent.com/losaztecas859-commits/HironDrigonHub-Medr0so_0Owner-NaturalDisaster-Arthurfelipe_blox2Moderator/refs/heads/main/red%20apple"
            ))()
        end)
    end,
})

tabGamepass:AddButton({
    Name = "Bússola",
    Callback = function()
        pcall(function()
            local toolName = "Compass"
            local alreadyCloned = false
            for _, other in ipairs(Players:GetPlayers()) do
                if other ~= player and not alreadyCloned then
                    local backpack = other:FindFirstChild("Backpack")
                    local character = other.Character
                    local tool = backpack and backpack:FindFirstChild(toolName)
                    if not tool and character then
                        tool = character:FindFirstChild(toolName)
                    end
                    if tool then
                        local clone = tool:Clone()
                        clone.Parent = player.Backpack
                        alreadyCloned = true
                        print("Compass clonada de:", other.Name)
                    end
                end
            end
        end)
    end,
})

tabGamepass:AddSection("FE")
tabGamepass:AddButton({
    Name = "Balão verde",
    Callback = function()
        pcall(function()
            local function notify(title, text)
                game.StarterGui:SetCore("SendNotification", {
                    Title = title, Text = text, Duration = 5,
                })
            end
            local balloon = workspace:FindFirstChild("GreenBalloon", true)
            if balloon then
                local clone = balloon:Clone()
                clone.Parent = player.Backpack
                notify("by @ghost.scripts.01", "🎈 Balão roubado com sucesso!")
            else
                notify("ghost Scripts", "🎈 Não há balões no servidor.")
            end
        end)
    end,
})
tabGamepass:AddParagraph("Aviso",
    "Se não houver ninguém com a gamepass no servidor, a opção Bússola não irá funcionar.")

-- ============================================================
-- [12] ABA: PROTEÇÃO
-- ============================================================
local tabProtecao = Window:MakeTab({ "Proteção", "shield" })

local antiTP       = false
local antiFling    = false
local antiVoid     = false
local savedCFrame
local antiTPConn, antiFlingConn, antiVoidConn

local function getCharHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Anti-TP
local function startAntiTP()
    local hrp = getCharHRP()
    if not hrp then return end
    savedCFrame = hrp.CFrame
    if antiTPConn then antiTPConn:Disconnect() end
    antiTPConn = RunService.Heartbeat:Connect(function()
        if not antiTP then return end
        local h = getCharHRP()
        if not h then return end
        if (h.Position - savedCFrame.Position).Magnitude > 30 then
            h.CFrame = savedCFrame
        end
    end)
end
local function stopAntiTP()
    if antiTPConn then antiTPConn:Disconnect(); antiTPConn = nil end
end

-- Anti-Fling
local function startAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect() end
    antiFlingConn = RunService.Heartbeat:Connect(function()
        if not antiFling then return end
        local h = getCharHRP()
        if not h then return end
        h.Velocity     = Vector3.zero
        h.RotVelocity  = Vector3.zero
    end)
end
local function stopAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect(); antiFlingConn = nil end
end

-- Anti-Void
local function startAntiVoid()
    if antiVoidConn then antiVoidConn:Disconnect() end
    antiVoidConn = RunService.Heartbeat:Connect(function()
        if not antiVoid then return end
        local h = getCharHRP()
        if not h then return end
        if h.Position.Y < -10 then
            h.CFrame = savedCFrame or h.CFrame + Vector3.new(0, 50, 0)
        end
    end)
end
local function stopAntiVoid()
    if antiVoidConn then antiVoidConn:Disconnect(); antiVoidConn = nil end
end

tabProtecao:AddSection("Proteções principais")
tabProtecao:AddToggle({
    Name = "Anti Teleporte", Default = false,
    Callback = function(state)
        antiTP = state
        if state then startAntiTP() else stopAntiTP() end
    end,
})
tabProtecao:AddButton({
    Name = "Atualizar posição salva",
    Callback = function()
        local hrp = getCharHRP()
        if hrp then savedCFrame = hrp.CFrame end
    end,
})
tabProtecao:AddParagraph("Aviso ⚠️",
    "Anti Teleporte pode bloquear TP Tool e alguns scripts.\nAtualize a posição após se mover.")

tabProtecao:AddButton({
    Name = "Anti Fall Damage v1",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/Fw61Cfnw"))()
        end)
    end,
})
tabProtecao:AddButton({
    Name = "Anti Fall Damage v2",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/hUufRvI4/raw"))()
        end)
    end,
})
tabProtecao:AddButton({
    Name = "Anti Fling",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Antifling-131275"))()
        end)
    end,
})

-- ============================================================
-- [13] ABA: TELEPORTES
-- ============================================================
local TabTP = Window:MakeTab({ "Teleportes", "map-pin" })
TabTP:AddSection("Teleportes principais")

TabTP:AddButton({
    Name = "Ir para Lobby",
    Callback = function()
        local char = player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(-254.5, 194.6, 299.2) end
    end,
})
TabTP:AddButton({
    Name = "Ir para Ilha",
    Callback = function()
        local char = player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(-117.2, 47.6, 7.2) end
    end,
})
TabTP:AddParagraph("Mais opções",
    "Mais teleportes serão adicionados durante as atualizações.")

-- ============================================================
-- [14] TAG NO CHAT (delay de 2s)
-- ============================================================
task.spawn(function()
    task.wait(2)
    local msg = "ghost Scripts USER"
    pcall(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if channel then channel:SendAsync(msg) end
        else
            local ev = ReplicatedStorage
                :WaitForChild("DefaultChatSystemChatEvents")
                :WaitForChild("SayMessageRequest")
            ev:FireServer(msg, "All")
        end
    end)
end)

-- ============================================================
-- [15] RESET AUTOMÁTICO (POR ÚLTIMO)
-- ============================================================
task.spawn(function()
    task.wait(1)
    local char = player.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Health = 0
        print("[ghost Scripts] Personagem resetado automaticamente.")
    end
end)

-- ============================================================
-- [16] DIALOG DE BOAS-VINDAS
-- ============================================================
Window:Dialog({
    Title = "ghost Scripts Aviso",
    Text  = "Estamos dando o máximo para o script ficar bom, ele é produzido por @ghost.scripts.01, então está com poucas funções.",
    Options = { { "OK", function() print("Aviso fechado pelo jogador") end } },
})

Window:SelectTab(Tab1)