-- ==========================================================
-- GHOST LOAD GLOBAL V1.4 - VISUAL MELHORADO
-- ==========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Remove UI antiga
for _, obj in pairs(CoreGui:GetChildren()) do
    if obj.Name == "GhostLoadHub" then obj:Destroy() end
end
if LocalPlayer:FindFirstChild("PlayerGui") then
    local old = LocalPlayer.PlayerGui:FindFirstChild("GhostLoadHub")
    if old then old:Destroy() end
end

-- ==========================================================
-- PALETA DE CORES
-- ==========================================================
local Colors = {
    Background   = Color3.fromRGB(12, 12, 18),
    Panel        = Color3.fromRGB(20, 20, 30),
    PanelLight   = Color3.fromRGB(28, 28, 42),
    ButtonIdle   = Color3.fromRGB(32, 32, 48),
    ButtonHover  = Color3.fromRGB(48, 48, 72),
    Text         = Color3.fromRGB(240, 240, 255),
    TextDim      = Color3.fromRGB(140, 140, 170),
    Accent       = Color3.fromRGB(120, 90, 220),
    AccentLight  = Color3.fromRGB(160, 130, 255),
    LoadingBar   = Color3.fromRGB(140, 110, 255),
    LoadingDone  = Color3.fromRGB(100, 255, 180),
    Green        = Color3.fromRGB(100, 255, 180),
    Yellow       = Color3.fromRGB(255, 200, 100),
    Red          = Color3.fromRGB(255, 80, 100),
    Float        = Color3.fromRGB(20, 20, 30),
    LogoColor    = Color3.fromRGB(160, 130, 255),
    Divider      = Color3.fromRGB(45, 45, 65),
}

-- ==========================================================
-- SCREENGUI
-- ==========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GhostLoadHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ==========================================================
-- BOTÃO FLUTUANTE COM LOGO
-- ==========================================================
local FloatBtn = Instance.new("ImageButton")
FloatBtn.Name = "FloatBtn"
FloatBtn.Size = UDim2.new(0, 60, 0, 60)
FloatBtn.Position = UDim2.new(0, 15, 0, 15)
FloatBtn.BackgroundColor3 = Colors.Float
FloatBtn.BorderSizePixel = 0
FloatBtn.Image = "rbxassetid://139984424145579"
FloatBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
FloatBtn.ScaleType = Enum.ScaleType.Crop
FloatBtn.Visible = false
FloatBtn.Active = true
FloatBtn.Draggable = true
FloatBtn.ZIndex = 1000
FloatBtn.Parent = ScreenGui

Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Colors.LogoColor
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatBtn

local FloatGlow = Instance.new("ImageLabel")
FloatGlow.Size = UDim2.new(1, 20, 1, 20)
FloatGlow.Position = UDim2.new(0, -10, 0, -10)
FloatGlow.BackgroundTransparency = 1
FloatGlow.Image = "rbxassetid://5028857084"
FloatGlow.ImageColor3 = Colors.Accent
FloatGlow.ImageTransparency = 0.6
FloatGlow.ZIndex = -1
FloatGlow.Parent = FloatBtn

FloatBtn.MouseEnter:Connect(function()
    TweenService:Create(FloatBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ButtonHover}):Play()
    TweenService:Create(FloatStroke, TweenInfo.new(0.2), {Color = Colors.AccentLight, Thickness = 3}):Play()
end)
FloatBtn.MouseLeave:Connect(function()
    TweenService:Create(FloatBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Float}):Play()
    TweenService:Create(FloatStroke, TweenInfo.new(0.2), {Color = Colors.LogoColor, Thickness = 2}):Play()
end)

-- ==========================================================
-- JANELA PRINCIPAL
-- ==========================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 400)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ZIndex = 1
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2
MainStroke.Parent = MainFrame

-- Sombras suaves para profundidade
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5028857084"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.4
Shadow.ZIndex = -1
Shadow.Parent = MainFrame

-- ==========================================================
-- CABEÇALHO
-- ==========================================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Colors.Panel
Header.BorderSizePixel = 0
Header.Parent = MainFrame

Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

-- Máscara para arredondar apenas o topo
local HeaderMask = Instance.new("Frame")
HeaderMask.Size = UDim2.new(1, 0, 0, 30)
HeaderMask.Position = UDim2.new(0, 0, 0, 25)
HeaderMask.BackgroundColor3 = Colors.Panel
HeaderMask.BorderSizePixel = 0
HeaderMask.Parent = Header

-- Logo no cabeçalho (pequena)
local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Size = UDim2.new(0, 32, 0, 32)
HeaderLogo.Position = UDim2.new(0, 15, 0, 11)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Image = "rbxassetid://139984424145579"
HeaderLogo.Parent = Header

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 0, 22)
Title.Position = UDim2.new(0, 55, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "Ghost Load"
Title.TextColor3 = Colors.Text
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0, 250, 0, 16)
Subtitle.Position = UDim2.new(0, 55, 0, 28)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Global V1.4"
Subtitle.TextColor3 = Colors.AccentLight
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

-- Botão X (fechar/minimizar)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0, 11)
CloseBtn.BackgroundColor3 = Colors.ButtonIdle
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Colors.TextDim
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 10
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    local hideTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -280, -1, -220)
    })
    hideTween:Play()
    hideTween.Completed:Connect(function()
        MainFrame.Visible = false
        MainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
        FloatBtn.Visible = true
    end)
end)
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Red, TextColor3 = Colors.Text}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ButtonIdle, TextColor3 = Colors.TextDim}):Play()
end)

-- Restaurar pelo flutuante
FloatBtn.MouseButton1Click:Connect(function()
    FloatBtn.Visible = false
    MainFrame.Visible = true
    MainFrame.Position = UDim2.new(0.5, -280, -1, -220)
    MainFrame.Size = UDim2.new(0, 560, 0, 400)
    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -280, 0.5, -200)
    }):Play()
end)

-- ==========================================================
-- MENU LATERAL
-- ==========================================================
local SideMenu = Instance.new("Frame")
SideMenu.Size = UDim2.new(0, 160, 0, 320)
SideMenu.Position = UDim2.new(0, 12, 0, 68)
SideMenu.BackgroundTransparency = 1
SideMenu.Parent = MainFrame

local function CreateSideButton(text, icon, yOffset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Position = UDim2.new(0, 0, 0, yOffset)
    btn.BackgroundColor3 = Colors.Panel
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = SideMenu
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 22, 0, 22)
    iconLbl.Position = UDim2.new(0, 12, 0.5, -11)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon or "•"
    iconLbl.TextColor3 = Colors.AccentLight
    iconLbl.TextSize = 15
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = btn

    local textLbl = Instance.new("TextLabel")
    textLbl.Size = UDim2.new(1, -42, 1, 0)
    textLbl.Position = UDim2.new(0, 40, 0, 0)
    textLbl.BackgroundTransparency = 1
    textLbl.Text = text
    textLbl.TextColor3 = Colors.Text
    textLbl.TextSize = 13
    textLbl.Font = Enum.Font.GothamMedium
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.Parent = btn

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 0.6, 0)
    accentBar.Position = UDim2.new(0, 0, 0.2, 0)
    accentBar.BackgroundColor3 = Colors.AccentLight
    accentBar.BorderSizePixel = 0
    accentBar.Visible = false
    accentBar.Parent = btn
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ButtonHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= Colors.Accent then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Panel}):Play()
        end
    end)
    return btn, accentBar
end

local ScriptsGratisBtn, ScriptsAccent = CreateSideButton("Scripts grátis", "◆", 0)
local InfBtn, InfAccent = CreateSideButton("Informações", "ℹ", 52)

-- ==========================================================
-- ÁREA DE CONTEÚDO (Scripts) - ScrollingFrame
-- ==========================================================
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(0, 360, 0, 320)
ContentFrame.Position = UDim2.new(0, 184, 0, 68)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 5
ContentFrame.ScrollBarImageColor3 = Colors.Accent
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.Parent = MainFrame

-- Área de Informações (Inf)
local InfoFrame = Instance.new("ScrollingFrame")
InfoFrame.Size = UDim2.new(0, 360, 0, 320)
InfoFrame.Position = UDim2.new(0, 184, 0, 68)
InfoFrame.BackgroundTransparency = 1
InfoFrame.BorderSizePixel = 0
InfoFrame.ScrollBarThickness = 5
InfoFrame.ScrollBarImageColor3 = Colors.Accent
InfoFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
InfoFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
InfoFrame.Visible = false
InfoFrame.Parent = MainFrame

-- ==========================================================
-- LINHAS DE INFORMAÇÃO
-- ==========================================================
local function CreateInfoRow(parent, labelText, valueText, yOffset, valueColor)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 38)
    row.Position = UDim2.new(0, 0, 0, yOffset)
    row.BackgroundColor3 = Colors.Panel
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 130, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Colors.TextDim
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(0, 200, 1, 0)
    val.Position = UDim2.new(1, -212, 0, 0)
    val.BackgroundTransparency = 1
    val.Text = valueText
    val.TextColor3 = valueColor or Colors.Text
    val.TextSize = 12
    val.Font = Enum.Font.GothamBold
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.Parent = row
    return val
end

CreateInfoRow(InfoFrame, "Jogador", LocalPlayer.Name, 0)
CreateInfoRow(InfoFrame, "User ID", tostring(LocalPlayer.UserId), 44)
local executorName = "Desconhecido"
pcall(function() if identifyexecutor then executorName = identifyexecutor() end end)
CreateInfoRow(InfoFrame, "Executor", executorName, 88, Colors.Green)
CreateInfoRow(InfoFrame, "Versão", "Ghost Load V1.4", 132, Colors.Yellow)
CreateInfoRow(InfoFrame, "Status", "Online", 176, Colors.Green)
local fpsValue = CreateInfoRow(InfoFrame, "FPS", "0", 220)
local pingValue = CreateInfoRow(InfoFrame, "Ping", "0 ms", 264)

-- ==========================================================
-- BOTÕES DE SCRIPT
-- ==========================================================
local function CreateScriptButton(text, yOffset, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 52)
    btn.Position = UDim2.new(0, 0, 0, yOffset)
    btn.BackgroundColor3 = Colors.Panel
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = ContentFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    -- Barra de destaque lateral
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 0.5, 0)
    accentBar.Position = UDim2.new(0, 0, 0.25, 0)
    accentBar.BackgroundColor3 = Colors.Accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = btn
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

    -- Texto principal
    local textLbl = Instance.new("TextLabel")
    textLbl.Size = UDim2.new(1, -80, 0, 20)
    textLbl.Position = UDim2.new(0, 18, 0, 8)
    textLbl.BackgroundTransparency = 1
    textLbl.Text = text
    textLbl.TextColor3 = Colors.Text
    textLbl.TextSize = 14
    textLbl.Font = Enum.Font.GothamBold
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.Parent = btn

    -- Subtítulo
    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -80, 0, 16)
    subLbl.Position = UDim2.new(0, 18, 0, 28)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "Clique para carregar"
    subLbl.TextColor3 = Colors.TextDim
    subLbl.TextSize = 11
    subLbl.Font = Enum.Font.GothamMedium
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.Parent = btn

    -- Ícone de seta
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 24, 0, 24)
    arrow.Position = UDim2.new(1, -38, 0.5, -12)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▶"
    arrow.TextColor3 = Colors.AccentLight
    arrow.TextSize = 14
    arrow.Font = Enum.Font.GothamBold
    arrow.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ButtonHover}):Play()
        TweenService:Create(accentBar, TweenInfo.new(0.2), {Size = UDim2.new(0, 4, 0.8, 0), Position = UDim2.new(0, 0, 0.1, 0)}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.2), {TextColor3 = Colors.AccentLight, Position = UDim2.new(1, -34, 0.5, -12)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Panel}):Play()
        TweenService:Create(accentBar, TweenInfo.new(0.2), {Size = UDim2.new(0, 4, 0.5, 0), Position = UDim2.new(0, 0, 0.25, 0)}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.2), {TextColor3 = Colors.AccentLight, Position = UDim2.new(1, -38, 0.5, -12)}):Play()
    end)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    return btn
end

-- ==========================================================
-- LÓGICA DE ABAS
-- ==========================================================
local function SwitchTab(tabName)
    if tabName == "ScriptsGratis" then
        ContentFrame.Visible = true
        InfoFrame.Visible = false
        ScriptsGratisBtn.BackgroundColor3 = Colors.Accent
        ScriptsAccent.Visible = true
        InfBtn.BackgroundColor3 = Colors.Panel
        InfAccent.Visible = false
    elseif tabName == "Inf" then
        ContentFrame.Visible = false
        InfoFrame.Visible = true
        InfBtn.BackgroundColor3 = Colors.Accent
        InfAccent.Visible = true
        ScriptsGratisBtn.BackgroundColor3 = Colors.Panel
        ScriptsAccent.Visible = false
    end
end
ScriptsGratisBtn.MouseButton1Click:Connect(function() SwitchTab("ScriptsGratis") end)
InfBtn.MouseButton1Click:Connect(function() SwitchTab("Inf") end)
SwitchTab("ScriptsGratis")

-- ==========================================================
-- ATUALIZADOR FPS/PING
-- ==========================================================
local frameCount, lastTime = 0, tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTime >= 0.5 then
        local fps = frameCount / (now - lastTime)
        frameCount = 0
        lastTime = now
        if fpsValue and fpsValue.Parent then
            local c = fps >= 50 and Colors.Green or (fps >= 30 and Colors.Yellow or Colors.Red)
            fpsValue.Text = string.format("%.0f", fps)
            fpsValue.TextColor3 = c
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(1)
        if pingValue and pingValue.Parent then
            local ok, p = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if ok and type(p) == "number" then
                local c = p <= 100 and Colors.Green or (p <= 200 and Colors.Yellow or Colors.Red)
                pingValue.Text = string.format("%.0f ms", p)
                pingValue.TextColor3 = c
            end
        end
    end
end)

-- ==========================================================
-- TELA DE LOADING (MELHORADA)
-- ==========================================================
local function CreateLoadingScreen(subtitleText)
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Size = UDim2.new(0, 420, 0, 220)
    LoadingFrame.Position = UDim2.new(0.5, -210, 0.5, -110)
    LoadingFrame.BackgroundColor3 = Colors.Background
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Active = true
    LoadingFrame.Draggable = true
    LoadingFrame.ZIndex = 500
    LoadingFrame.Parent = ScreenGui
    Instance.new("UICorner", LoadingFrame).CornerRadius = UDim.new(0, 14)

    local ls = Instance.new("UIStroke")
    ls.Color = Colors.Accent
    ls.Thickness = 1.5
    ls.Transparency = 0.2
    ls.Parent = LoadingFrame

    local loadingShadow = Instance.new("ImageLabel")
    loadingShadow.Size = UDim2.new(1, 30, 1, 30)
    loadingShadow.Position = UDim2.new(0, -15, 0, -15)
    loadingShadow.BackgroundTransparency = 1
    loadingShadow.Image = "rbxassetid://5028857084"
    loadingShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    loadingShadow.ImageTransparency = 0.4
    loadingShadow.ZIndex = -1
    loadingShadow.Parent = LoadingFrame

    -- Barra superior decorativa
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 3)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Colors.Accent
    topBar.BorderSizePixel = 0
    topBar.Parent = LoadingFrame
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 3)

    -- Logo no loading
    local loadingLogo = Instance.new("ImageLabel")
    loadingLogo.Size = UDim2.new(0, 48, 0, 48)
    loadingLogo.Position = UDim2.new(0.5, -24, 0, 25)
    loadingLogo.BackgroundTransparency = 1
    loadingLogo.Image = "rbxassetid://139984424145579"
    loadingLogo.Parent = LoadingFrame

    -- Título
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 26)
    t.Position = UDim2.new(0, 0, 0, 80)
    t.BackgroundTransparency = 1
    t.Text = "Ghost Load"
    t.TextColor3 = Colors.Text
    t.TextSize = 22
    t.Font = Enum.Font.GothamBold
    t.Parent = LoadingFrame

    -- Subtítulo
    local st = Instance.new("TextLabel")
    st.Size = UDim2.new(1, 0, 0, 18)
    st.Position = UDim2.new(0, 0, 0, 108)
    st.BackgroundTransparency = 1
    st.Text = subtitleText or "Carregando..."
    st.TextColor3 = Colors.TextDim
    st.TextSize = 12
    st.Font = Enum.Font.GothamMedium
    st.Parent = LoadingFrame

    -- Fundo da barra de progresso
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 320, 0, 10)
    bg.Position = UDim2.new(0.5, -160, 0, 145)
    bg.BackgroundColor3 = Colors.Panel
    bg.BorderSizePixel = 0
    bg.Parent = LoadingFrame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    -- Preenchimento da barra
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Colors.LoadingBar
    fill.BorderSizePixel = 0
    fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    -- Texto de porcentagem
    local pt = Instance.new("TextLabel")
    pt.Size = UDim2.new(1, 0, 0, 20)
    pt.Position = UDim2.new(0, 0, 0, 168)
    pt.BackgroundTransparency = 1
    pt.Text = "0%"
    pt.TextColor3 = Colors.TextDim
    pt.TextSize = 12
    pt.Font = Enum.Font.GothamBold
    pt.Parent = LoadingFrame

    return LoadingFrame, fill, pt, loadingLogo
end

local function AnimateLoading(LoadingFrame, BarFill, PercentText, duration, onComplete)
    duration = duration or 2
    local progress, startTime = 0, tick()
    task.spawn(function()
        while progress < 1 do
            task.wait(0.05)
            progress = math.min((tick() - startTime) / duration, 1)
            if BarFill and BarFill.Parent then
                BarFill.Size = UDim2.new(progress, 0, 1, 0)
                PercentText.Text = math.floor(progress * 100) .. "%"
                if progress > 0.8 then
                    BarFill.BackgroundColor3 = Colors.LoadingDone
                end
            else
                break
            end
        end
        task.wait(0.2)
        if LoadingFrame and LoadingFrame.Parent then LoadingFrame:Destroy() end
        if onComplete then onComplete() end
    end)
end

-- Loading inicial
local IL, IB, IP, ILOGO = CreateLoadingScreen("Carregando recursos...")
AnimateLoading(IL, IB, IP, 2, function()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 560, 0, 400)}):Play()
end)

-- Execução com loading
local function ExecuteWithLoading(scriptName, url)
    MainFrame.Visible = false
    FloatBtn.Visible = false
    local LF, BF, PT, LLOGO = CreateLoadingScreen("Baixando: " .. scriptName .. "...")
    AnimateLoading(LF, BF, PT, 2, function()
        local ok, err = pcall(function() loadstring(game:HttpGet(url))() end)
        if ok then
            print("[Ghost Load] " .. scriptName .. " carregado!")
        else
            warn("[Ghost Load] Erro em " .. scriptName .. ": " .. tostring(err))
        end
        task.wait(0.5)
        ScreenGui:Destroy()
    end)
end

-- ==========================================================
-- LISTA DE SCRIPTS
-- ==========================================================

-- 1. MM2
CreateScriptButton("MM2", 0, function()
    ExecuteWithLoading("MM2", "https://raw.githubusercontent.com/ghosthub031-dev/Load-de-v-rios-script-universal-/refs/heads/main/ghost_scripts_v1.0.lua")
end)

-- 2. Dead Rails
CreateScriptButton("Dead Rails", 58, function()
    ExecuteWithLoading("Dead Rails", "https://raw.githubusercontent.com/ghosthub031-dev/Load-de-v-rios-script-universal-/main/ghost-scripts-deadrail-v4.txt")
end)

-- 3. Doors
CreateScriptButton("Doors", 116, function()
    ExecuteWithLoading("Doors", "https://raw.githubusercontent.com/ghosthub031-dev/Load-de-v-rios-script-universal-/refs/heads/main/ghost_scripts_doors.lua")
end)

-- 4. Forsaken
CreateScriptButton("Forsaken", 174, function()
    ExecuteWithLoading("Forsaken", "https://raw.githubusercontent.com/ghosthub031-dev/Ghost-Scripts-forseken-/refs/heads/main/Ghost_Scripts_forseken.lua")
end)

-- 5. Brookhaven RP
CreateScriptButton("Brookhaven RP", 232, function()
    ExecuteWithLoading("Brookhaven RP", "https://raw.githubusercontent.com/ghosthub031-dev/Load-de-v-rios-script-universal-/refs/heads/main/ghost_scripts_redz_melhorado.lua")
end)

-- 6. Sintonia RP
CreateScriptButton("Sintonia RP", 290, function()
    ExecuteWithLoading("Sintonia RP", "https://raw.githubusercontent.com/ghosthub031-dev/Load-de-v-rios-script-universal-/refs/heads/main/ghost-scripts.lua")
end)

-- 7. Natural Disaster
CreateScriptButton("Natural Disaster", 348, function()
    ExecuteWithLoading("Natural Disaster", "https://raw.githubusercontent.com/ghosthub031-dev/Load-de-v-rios-script-universal-/refs/heads/main/ghost%20Scripts.lua")
end)

print("[Ghost Load Global V1.4] Pronto!")