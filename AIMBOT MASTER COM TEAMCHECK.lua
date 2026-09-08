-- AIMBOT MASTER (FEITO POR JOSUÉ) - COM TEAMCHECK
-- Agora com verificação de time: NÃO MIRA EM ALIADOS!

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- CONFIGURAÇÕES
-- ============================================
local DISTANCIA = 300
local AIMBOT_ATIVO = false
local ESP_ATIVO = false
local espObjects = {}

-- ============================================
-- FUNÇÃO DE TEAMCHECK (NOVO!)
-- ============================================
local function isEnemy(player)
    -- Verifica se tem time
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team ~= player.Team
    end
    
    -- Verifica por tags alternativas
    local char = player.Character
    if char then
        if char:FindFirstChild("Ally") or char:FindFirstChild("Friend") then
            return false
        end
        if char:FindFirstChild("Enemy") or char:FindFirstChild("Hostile") then
            return true
        end
    end
    
    -- Se não conseguir determinar, considera inimigo (evita erro)
    return true
end

-- ============================================
-- FUNÇÃO PARA CRIAR EFEITO RGB
-- ============================================
local function criarRGBsuave(obj, intensidade, velocidade)
    intensidade = intensidade or 0.8
    velocidade = velocidade or 0.3
    coroutine.wrap(function()
        while true do
            wait(0.05)
            local hue = tick() % 1
            local cor = Color3.fromHSV(hue, 1, intensidade)
            pcall(function()
                TweenService:Create(obj, TweenInfo.new(velocidade), {Color3 = cor}):Play()
            end)
        end
    end)()
end

local function criarRGBfundo(obj, intensidade)
    intensidade = intensidade or 0.8
    coroutine.wrap(function()
        while true do
            wait(0.03)
            local hue = tick() % 1
            local cor = Color3.fromHSV(hue, 1, intensidade)
            pcall(function()
                TweenService:Create(obj, TweenInfo.new(0.2), {BackgroundColor3 = cor}):Play()
            end)
        end
    end)()
end

-- ============================================
-- CRIAR A INTERFACE
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "AimbotMaster"
ScreenGui.ResetOnSpawn = false

-- ============================================
-- BOTÃO FLUTUANTE COM "J"
-- ============================================
local botaoFlutuante = Instance.new("Frame")
botaoFlutuante.Name = "BotaoFlutuante"
botaoFlutuante.Parent = ScreenGui
botaoFlutuante.Size = UDim2.new(0, 55, 0, 55)
botaoFlutuante.Position = UDim2.new(0, 20, 0, 200)
botaoFlutuante.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
botaoFlutuante.BackgroundTransparency = 0
botaoFlutuante.BorderSizePixel = 2
botaoFlutuante.BorderColor3 = Color3.fromRGB(255, 255, 255)
botaoFlutuante.ClipsDescendants = true
botaoFlutuante.Active = true
botaoFlutuante.Draggable = true
botaoFlutuante.Selectable = true
botaoFlutuante.ZIndex = 10

local UICornerFlutuante = Instance.new("UICorner")
UICornerFlutuante.Parent = botaoFlutuante
UICornerFlutuante.CornerRadius = UDim.new(1, 0)

local brilhoBotao = Instance.new("Frame")
brilhoBotao.Parent = botaoFlutuante
brilhoBotao.Size = UDim2.new(1.4, 0, 1.4, 0)
brilhoBotao.Position = UDim2.new(-0.2, 0, -0.2, 0)
brilhoBotao.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
brilhoBotao.BackgroundTransparency = 0.5
brilhoBotao.ZIndex = -1
brilhoBotao.BorderSizePixel = 2
brilhoBotao.BorderColor3 = Color3.fromRGB(255, 255, 255)

local UICornerBrilho = Instance.new("UICorner")
UICornerBrilho.Parent = brilhoBotao
UICornerBrilho.CornerRadius = UDim.new(1, 0)

criarRGBfundo(botaoFlutuante, 1)
criarRGBfundo(brilhoBotao, 0.5)

local letraJ = Instance.new("TextLabel")
letraJ.Parent = botaoFlutuante
letraJ.Size = UDim2.new(1, 0, 1, 0)
letraJ.BackgroundTransparency = 1
letraJ.Text = "J"
letraJ.TextColor3 = Color3.fromRGB(255, 255, 255)
letraJ.TextSize = 30
letraJ.Font = Enum.Font.GothamBold
letraJ.TextScaled = true
letraJ.ZIndex = 11

-- ============================================
-- INTERFACE PRINCIPAL
-- ============================================
local interfacePrincipal = Instance.new("Frame")
interfacePrincipal.Name = "InterfacePrincipal"
interfacePrincipal.Parent = ScreenGui
interfacePrincipal.Size = UDim2.new(0, 340, 0, 320)
interfacePrincipal.Position = UDim2.new(0.5, -170, 0.5, -160)
interfacePrincipal.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
interfacePrincipal.BackgroundTransparency = 0
interfacePrincipal.BorderSizePixel = 0
interfacePrincipal.Visible = false
interfacePrincipal.Active = true
interfacePrincipal.Draggable = true
interfacePrincipal.Selectable = true
interfacePrincipal.ZIndex = 5

local UICornerInterface = Instance.new("UICorner")
UICornerInterface.Parent = interfacePrincipal
UICornerInterface.CornerRadius = UDim.new(0, 15)

local brilhoInterface = Instance.new("Frame")
brilhoInterface.Parent = interfacePrincipal
brilhoInterface.Size = UDim2.new(1.08, 0, 1.08, 0)
brilhoInterface.Position = UDim2.new(-0.04, 0, -0.04, 0)
brilhoInterface.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
brilhoInterface.BackgroundTransparency = 0.3
brilhoInterface.ZIndex = -1
brilhoInterface.BorderSizePixel = 0

local UICornerBrilhoInt = Instance.new("UICorner")
UICornerBrilhoInt.Parent = brilhoInterface
UICornerBrilhoInt.CornerRadius = UDim.new(0, 18)

criarRGBfundo(brilhoInterface, 0.5)

local titulo = Instance.new("TextLabel")
titulo.Parent = interfacePrincipal
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.Position = UDim2.new(0, 0, 0, 8)
titulo.BackgroundTransparency = 1
titulo.Text = "🎯 AIMBOT MASTER"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.TextSize = 22
titulo.Font = Enum.Font.GothamBold
titulo.ZIndex = 6

local subtitulo = Instance.new("TextLabel")
subtitulo.Parent = interfacePrincipal
subtitulo.Size = UDim2.new(1, 0, 0, 20)
subtitulo.Position = UDim2.new(0, 0, 0, 48)
subtitulo.BackgroundTransparency = 1
subtitulo.Text = "⚡ FEITO POR JOSUÉ ⚡"
subtitulo.TextColor3 = Color3.fromRGB(150, 150, 200)
subtitulo.TextSize = 12
subtitulo.Font = Enum.Font.Gotham
subtitulo.ZIndex = 6

local linha = Instance.new("Frame")
linha.Parent = interfacePrincipal
linha.Size = UDim2.new(0.85, 0, 0, 2)
linha.Position = UDim2.new(0.075, 0, 0, 70)
linha.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
linha.BorderSizePixel = 0
linha.ZIndex = 6
criarRGBfundo(linha, 0.8)

local statusESP = Instance.new("TextLabel")
statusESP.Parent = interfacePrincipal
statusESP.Size = UDim2.new(1, 0, 0, 20)
statusESP.Position = UDim2.new(0, 0, 0, 78)
statusESP.BackgroundTransparency = 1
statusESP.Text = "Inimigos: 0"
statusESP.TextColor3 = Color3.fromRGB(200, 200, 200)
statusESP.TextSize = 13
statusESP.Font = Enum.Font.Gotham
statusESP.ZIndex = 6

-- ============================================
-- TOGGLES
-- ============================================
local botaoToggle = Instance.new("Frame")
botaoToggle.Name = "BotaoToggle"
botaoToggle.Parent = interfacePrincipal
botaoToggle.Size = UDim2.new(0, 120, 0, 38)
botaoToggle.Position = UDim2.new(0.1, 0, 0, 105)
botaoToggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
botaoToggle.BackgroundTransparency = 0
botaoToggle.BorderSizePixel = 2
botaoToggle.BorderColor3 = Color3.fromRGB(255, 255, 255)
botaoToggle.ZIndex = 6

local UICornerToggle = Instance.new("UICorner")
UICornerToggle.Parent = botaoToggle
UICornerToggle.CornerRadius = UDim.new(0, 8)

local textoToggle = Instance.new("TextLabel")
textoToggle.Parent = botaoToggle
textoToggle.Size = UDim2.new(1, 0, 1, 0)
textoToggle.BackgroundTransparency = 1
textoToggle.Text = "AIMBOT OFF"
textoToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
textoToggle.TextSize = 16
textoToggle.Font = Enum.Font.GothamBold
textoToggle.ZIndex = 7

local botaoESP = Instance.new("Frame")
botaoESP.Name = "BotaoESP"
botaoESP.Parent = interfacePrincipal
botaoESP.Size = UDim2.new(0, 120, 0, 38)
botaoESP.Position = UDim2.new(0.55, 0, 0, 105)
botaoESP.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
botaoESP.BackgroundTransparency = 0
botaoESP.BorderSizePixel = 2
botaoESP.BorderColor3 = Color3.fromRGB(255, 255, 255)
botaoESP.ZIndex = 6

local UICornerESP = Instance.new("UICorner")
UICornerESP.Parent = botaoESP
UICornerESP.CornerRadius = UDim.new(0, 8)

local textoESP = Instance.new("TextLabel")
textoESP.Parent = botaoESP
textoESP.Size = UDim2.new(1, 0, 1, 0)
textoESP.BackgroundTransparency = 1
textoESP.Text = "ESP OFF"
textoESP.TextColor3 = Color3.fromRGB(255, 255, 255)
textoESP.TextSize = 16
textoESP.Font = Enum.Font.GothamBold
textoESP.ZIndex = 7

local botaoFechar = Instance.new("TextButton")
botaoFechar.Name = "BotaoFechar"
botaoFechar.Parent = interfacePrincipal
botaoFechar.Size = UDim2.new(0, 32, 0, 32)
botaoFechar.Position = UDim2.new(1, -38, 0, 8)
botaoFechar.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
botaoFechar.BackgroundTransparency = 0
botaoFechar.BorderSizePixel = 0
botaoFechar.Text = "✕"
botaoFechar.TextColor3 = Color3.fromRGB(255, 255, 255)
botaoFechar.TextSize = 18
botaoFechar.Font = Enum.Font.GothamBold
botaoFechar.ZIndex = 7

local UICornerFechar = Instance.new("UICorner")
UICornerFechar.Parent = botaoFechar
UICornerFechar.CornerRadius = UDim.new(0, 8)

-- ============================================
-- FUNÇÕES (COM TEAMCHECK)
-- ============================================

local function isVisible(targetPart)
    if not targetPart then return false end
    local origin = Camera.CFrame.Position
    local targetPos = targetPart.Position
    local direction = (targetPos - origin)
    local distance = direction.Magnitude
    if distance < 1 then return false end
    direction = direction.Unit
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local ignoreList = {}
    if LocalPlayer.Character then
        table.insert(ignoreList, LocalPlayer.Character)
    end
    table.insert(ignoreList, Camera)
    raycastParams.FilterDescendantsInstances = ignoreList
    
    local result = workspace:Raycast(origin, direction * distance, raycastParams)
    if result then
        local hit = result.Instance
        local targetParent = targetPart.Parent
        if hit:IsDescendantOf(targetParent) then return true end
        local character = targetParent
        if character and character:IsA("Model") then
            if hit:IsDescendantOf(character) then return true end
        end
        return false
    end
    return true
end

-- ============================================
-- getEnemies() COM TEAMCHECK (NOVO!)
-- ============================================
local function getEnemies()
    local enemies = {}
    local character = LocalPlayer.Character
    if not character then return enemies end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return enemies end
    
    local rootPos = rootPart.Position
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- ========== TEAMCHECK: PULA ALIADOS ==========
            if not isEnemy(player) then
                continue -- PULA PARA O PRÓXIMO JOGADOR
            end
            
            if player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local dist = (head.Position - rootPos).Magnitude
                        if dist <= DISTANCIA then
                            table.insert(enemies, {
                                player = player,
                                head = head,
                                humanoid = humanoid,
                                distance = dist,
                                visible = isVisible(head),
                                character = player.Character
                            })
                        end
                    end
                end
            end
        end
    end
    
    table.sort(enemies, function(a, b)
        return a.distance < b.distance
    end)
    
    return enemies
end

-- ============================================
-- AIMBOT (COM TEAMCHECK AUTOMÁTICO)
-- ============================================
local function aimbot()
    if not AIMBOT_ATIVO then return end
    local enemies = getEnemies() -- Já vem filtrado pelo TeamCheck
    if #enemies > 0 then
        local target = enemies[1]
        if target and target.visible then
            local targetPos = target.head.Position
            local cameraPos = Camera.CFrame.Position
            Camera.CFrame = CFrame.lookAt(cameraPos, targetPos)
        end
    end
end

-- ============================================
-- ESP COM TEAMCHECK (NOVO!)
-- ============================================
local function updateESP()
    for _, obj in ipairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
    
    if not ESP_ATIVO then 
        statusESP.Text = "ESP DESLIGADO"
        return 
    end
    
    local enemies = getEnemies() -- Já vem filtrado pelo TeamCheck
    statusESP.Text = "Inimigos detectados: " .. #enemies
    
    for _, data in ipairs(enemies) do
        local head = data.head
        local humanoid = data.humanoid
        local player = data.player
        local character = data.character
        
        if head and humanoid and humanoid.Health > 0 and character then
            local cor = data.visible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            
            -- CORPO
            local highlight = Instance.new("Highlight")
            highlight.Parent = character
            highlight.FillColor = cor
            highlight.FillTransparency = 0.2
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            table.insert(espObjects, highlight)
            criarRGBsuave(highlight, 0.9, 0.3)
            
            -- NOME
            local nameGui = Instance.new("BillboardGui")
            nameGui.Parent = head
            nameGui.Size = UDim2.new(0, 120, 0, 22)
            nameGui.Adornee = head
            nameGui.AlwaysOnTop = true
            nameGui.ResetOnSpawn = false
            nameGui.StudsOffset = Vector3.new(0, 2.8, 0)
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = nameGui
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name .. " ❤️" .. math.floor(humanoid.Health)
            nameLabel.TextColor3 = cor
            nameLabel.TextSize = 10
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextScaled = true
            nameLabel.TextStrokeTransparency = 0.2
            nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            table.insert(espObjects, nameGui)
            criarRGBsuave(nameLabel, 0.9, 0.3)
            
            -- DISTÂNCIA
            local distGui = Instance.new("BillboardGui")
            distGui.Parent = head
            distGui.Size = UDim2.new(0, 80, 0, 16)
            distGui.Adornee = head
            distGui.AlwaysOnTop = true
            distGui.ResetOnSpawn = false
            distGui.StudsOffset = Vector3.new(0, 2.0, 0)
            
            local distLabel = Instance.new("TextLabel")
            distLabel.Parent = distGui
            distLabel.Size = UDim2.new(1, 0, 1, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = math.floor(data.distance) .. "m"
            distLabel.TextColor3 = cor
            distLabel.TextSize = 9
            distLabel.Font = Enum.Font.GothamBold
            distLabel.TextScaled = true
            distLabel.TextStrokeTransparency = 0.3
            distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            table.insert(espObjects, distGui)
            criarRGBsuave(distLabel, 0.7, 0.3)
        end
    end
end

-- ============================================
-- ATUALIZAR TOGGLES
-- ============================================
local function atualizarToggles()
    if AIMBOT_ATIVO then
        botaoToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        textoToggle.Text = "AIMBOT ON"
    else
        botaoToggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        textoToggle.Text = "AIMBOT OFF"
    end
    
    if ESP_ATIVO then
        botaoESP.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        textoESP.Text = "ESP ON"
    else
        botaoESP.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        textoESP.Text = "ESP OFF"
    end
end

-- ============================================
-- EVENTOS
-- ============================================

botaoFlutuante.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        interfacePrincipal.Visible = not interfacePrincipal.Visible
    end
end)

botaoFechar.MouseButton1Click:Connect(function()
    interfacePrincipal.Visible = false
end)

botaoToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        AIMBOT_ATIVO = not AIMBOT_ATIVO
        atualizarToggles()
    end
end)

botaoESP.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        ESP_ATIVO = not ESP_ATIVO
        atualizarToggles()
        if not ESP_ATIVO then
            for _, obj in ipairs(espObjects) do
                pcall(function() obj:Destroy() end)
            end
            espObjects = {}
            statusESP.Text = "ESP DESLIGADO"
        end
    end
end)

-- ============================================
-- LOOPS
-- ============================================

RunService.Heartbeat:Connect(function()
    aimbot()
end)

coroutine.wrap(function()
    while true do
        task.wait(0.3)
        updateESP()
    end
end)()

-- ============================================
-- BLOQUEAR TOQUE
-- ============================================
UserInputService.TouchStarted:Connect(function()
    task.wait(0.01)
end)

UserInputService.TouchMoved:Connect(function()
    task.wait(0.01)
end)

print("✅ AIMBOT MASTER COM TEAMCHECK CARREGADO!")
print("📌 FEITO POR JOSUÉ")
print("👥 NÃO mira em aliados!")
print("🌈 RGB SEM DELAY (usando Heartbeat)")
