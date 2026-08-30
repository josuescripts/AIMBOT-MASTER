-- SCRIPT DE ENVIO DE MENSAGEM - FEITO POR JOSUÉ
-- Interface preta com botão "S" arrastável

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ============================================
-- CRIAR A INTERFACE PRINCIPAL
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "SendMessageGUI"
ScreenGui.ResetOnSpawn = false

-- ============================================
-- VARIÁVEIS
-- ============================================
local interfaceVisivel = false
local textoDigitado = ""

-- ============================================
-- BOTÃO FLUTUANTE "S" (ARRÁSTAVEL)
-- ============================================
local botaoFlutuante = Instance.new("Frame")
botaoFlutuante.Name = "BotaoFlutuante"
botaoFlutuante.Parent = ScreenGui
botaoFlutuante.Size = UDim2.new(0, 50, 0, 50)
botaoFlutuante.Position = UDim2.new(0, 30, 0, 200)
botaoFlutuante.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
botaoFlutuante.BackgroundTransparency = 0
botaoFlutuante.BorderSizePixel = 2
botaoFlutuante.BorderColor3 = Color3.fromRGB(255, 255, 255)
botaoFlutuante.ClipsDescendants = true
botaoFlutuante.Active = true
botaoFlutuante.Draggable = true
botaoFlutuante.Selectable = true
botaoFlutuante.ZIndex = 10

-- Arredondar (100% redondo)
local UICornerFlutuante = Instance.new("UICorner")
UICornerFlutuante.Parent = botaoFlutuante
UICornerFlutuante.CornerRadius = UDim.new(1, 0)

-- Letra "S"
local letraS = Instance.new("TextLabel")
letraS.Parent = botaoFlutuante
letraS.Size = UDim2.new(1, 0, 1, 0)
letraS.BackgroundTransparency = 1
letraS.Text = "S"
letraS.TextColor3 = Color3.fromRGB(255, 255, 255)
letraS.TextSize = 28
letraS.Font = Enum.Font.GothamBold
letraS.TextScaled = true
letraS.ZIndex = 11

-- ============================================
-- INTERFACE PRINCIPAL (PRETA)
-- ============================================
local interfacePrincipal = Instance.new("Frame")
interfacePrincipal.Name = "InterfacePrincipal"
interfacePrincipal.Parent = ScreenGui
interfacePrincipal.Size = UDim2.new(0, 320, 0, 200)
interfacePrincipal.Position = UDim2.new(0.5, -160, 0.5, -100)
interfacePrincipal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
interfacePrincipal.BackgroundTransparency = 0
interfacePrincipal.BorderSizePixel = 2
interfacePrincipal.BorderColor3 = Color3.fromRGB(255, 255, 255)
interfacePrincipal.Visible = false
interfacePrincipal.Active = true
interfacePrincipal.Draggable = true
interfacePrincipal.Selectable = true
interfacePrincipal.ZIndex = 5

-- Arredondar
local UICornerInterface = Instance.new("UICorner")
UICornerInterface.Parent = interfacePrincipal
UICornerInterface.CornerRadius = UDim.new(0, 10)

-- ============================================
-- FUNDO VERMELHO PARA MINIMIZAR/MAXIMIZAR
-- ============================================
local fundoVermelho = Instance.new("Frame")
fundoVermelho.Parent = interfacePrincipal
fundoVermelho.Size = UDim2.new(1, 0, 0, 35)
fundoVermelho.Position = UDim2.new(0, 0, 0, 0)
fundoVermelho.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
fundoVermelho.BackgroundTransparency = 0
fundoVermelho.BorderSizePixel = 0
fundoVermelho.ZIndex = 6

local UICornerFundoVermelho = Instance.new("UICorner")
UICornerFundoVermelho.Parent = fundoVermelho
UICornerFundoVermelho.CornerRadius = UDim.new(0, 10)

-- ============================================
-- BOTÃO QUADRADO PEQUENO (MINIMIZAR/MAXIMIZAR)
-- ============================================
local botaoMinimizar = Instance.new("Frame")
botaoMinimizar.Name = "BotaoMinimizar"
botaoMinimizar.Parent = fundoVermelho
botaoMinimizar.Size = UDim2.new(0, 25, 0, 25)
botaoMinimizar.Position = UDim2.new(1, -30, 0.5, -12.5)
botaoMinimizar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
botaoMinimizar.BackgroundTransparency = 0
botaoMinimizar.BorderSizePixel = 1
botaoMinimizar.BorderColor3 = Color3.fromRGB(0, 0, 0)
botaoMinimizar.ZIndex = 7

-- Arredondar levemente
local UICornerMinimizar = Instance.new("UICorner")
UICornerMinimizar.Parent = botaoMinimizar
UICornerMinimizar.CornerRadius = UDim.new(0, 3)

-- Símbolo "-" ou "_"
local simboloMinimizar = Instance.new("TextLabel")
simboloMinimizar.Parent = botaoMinimizar
simboloMinimizar.Size = UDim2.new(1, 0, 1, 0)
simboloMinimizar.BackgroundTransparency = 1
simboloMinimizar.Text = "-"
simboloMinimizar.TextColor3 = Color3.fromRGB(0, 0, 0)
simboloMinimizar.TextSize = 18
simboloMinimizar.Font = Enum.Font.GothamBold
simboloMinimizar.ZIndex = 8
simboloMinimizar.TextScaled = true

-- ============================================
-- TÍTULO DA INTERFACE
-- ============================================
local titulo = Instance.new("TextLabel")
titulo.Parent = fundoVermelho
titulo.Size = UDim2.new(1, -40, 1, 0)
titulo.Position = UDim2.new(0, 10, 0, 0)
titulo.BackgroundTransparency = 1
titulo.Text = "📝 ENVIAR MENSAGEM"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.TextSize = 16
titulo.Font = Enum.Font.GothamBold
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.ZIndex = 7

-- ============================================
-- CAMPO DE TEXTO "ESCREVER"
-- ============================================
local textoBox = Instance.new("TextBox")
textoBox.Parent = interfacePrincipal
textoBox.Size = UDim2.new(0.9, 0, 0, 40)
textoBox.Position = UDim2.new(0.05, 0, 0, 50)
textoBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
textoBox.BackgroundTransparency = 0
textoBox.BorderSizePixel = 2
textoBox.BorderColor3 = Color3.fromRGB(100, 100, 100)
textoBox.Text = ""
textoBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textoBox.TextSize = 16
textoBox.Font = Enum.Font.Gotham
textoBox.PlaceholderText = "Escreva aqui..."
textoBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
textoBox.ClearTextOnFocus = true
textoBox.ZIndex = 6

local UICornerTextBox = Instance.new("UICorner")
UICornerTextBox.Parent = textoBox
UICornerTextBox.CornerRadius = UDim.new(0, 5)

-- ============================================
-- BOTÃO "ENVIAR NO CHAT"
-- ============================================
local botaoEnviar = Instance.new("TextButton")
botaoEnviar.Parent = interfacePrincipal
botaoEnviar.Size = UDim2.new(0.8, 0, 0, 45)
botaoEnviar.Position = UDim2.new(0.1, 0, 0, 110)
botaoEnviar.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
botaoEnviar.BackgroundTransparency = 0
botaoEnviar.BorderSizePixel = 2
botaoEnviar.BorderColor3 = Color3.fromRGB(255, 255, 255)
botaoEnviar.Text = "📤 ENVIAR NO CHAT"
botaoEnviar.TextColor3 = Color3.fromRGB(255, 255, 255)
botaoEnviar.TextSize = 18
botaoEnviar.Font = Enum.Font.GothamBold
botaoEnviar.ZIndex = 6

local UICornerEnviar = Instance.new("UICorner")
UICornerEnviar.Parent = botaoEnviar
UICornerEnviar.CornerRadius = UDim.new(0, 8)

-- ============================================
-- STATUS DO ENVIO
-- ============================================
local statusEnvio = Instance.new("TextLabel")
statusEnvio.Parent = interfacePrincipal
statusEnvio.Size = UDim2.new(1, 0, 0, 20)
statusEnvio.Position = UDim2.new(0, 0, 0, 165)
statusEnvio.BackgroundTransparency = 1
statusEnvio.Text = "Aguardando..."
statusEnvio.TextColor3 = Color3.fromRGB(150, 150, 150)
statusEnvio.TextSize = 12
statusEnvio.Font = Enum.Font.Gotham
statusEnvio.ZIndex = 6

-- ============================================
-- FUNÇÃO PARA ENVIAR MENSAGEM
-- ============================================
local function enviarMensagem()
    local mensagem = textoBox.Text
    if mensagem == "" or mensagem == "Escreva aqui..." then
        statusEnvio.Text = "⚠️ Digite uma mensagem primeiro!"
        statusEnvio.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    
    -- Tenta enviar a mensagem
    local sucesso, erro = pcall(function()
        -- Método 1: Chat padrão da Roblox
        if game:GetService("Chat"):FindFirstChild("Chat") then
            game:GetService("Chat").Chat:FireServer(mensagem)
        end
        
        -- Método 2: Remote de chat (alternativo)
        local remotes = game:GetService("ReplicatedStorage"):GetDescendants()
        for _, obj in ipairs(remotes) do
            if obj:IsA("RemoteEvent") and (string.lower(obj.Name):find("chat") or string.lower(obj.Name):find("message")) then
                obj:FireServer(mensagem)
                break
            end
        end
        
        -- Método 3: Usar o chat padrão (tecla Enter)
        local chatBar = game:GetService("CoreGui"):FindFirstChild("Chat")
        if chatBar then
            local chatInput = chatBar:FindFirstChild("ChatBar")
            if chatInput then
                chatInput:FindFirstChild("TextBox").Text = mensagem
                chatInput:FindFirstChild("TextBox").FocusLost:Fire(true)
            end
        end
    end)
    
    if sucesso then
        statusEnvio.Text = "✅ Mensagem enviada: " .. mensagem
        statusEnvio.TextColor3 = Color3.fromRGB(0, 255, 0)
        textoBox.Text = ""
    else
        statusEnvio.Text = "❌ Erro ao enviar: " .. tostring(erro)
        statusEnvio.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

-- ============================================
-- EVENTOS
-- ============================================

-- Abrir/fechar interface com o botão "S"
botaoFlutuante.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        interfaceVisivel = not interfaceVisivel
        interfacePrincipal.Visible = interfaceVisivel
        if interfaceVisivel then
            textoBox:CaptureFocus()
        end
    end
end)

-- Botão minimizar (fecha a interface)
botaoMinimizar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        interfacePrincipal.Visible = false
        interfaceVisivel = false
    end
end)

-- Botão enviar
botaoEnviar.MouseButton1Click:Connect(function()
    enviarMensagem()
end)

-- Tecla Enter no campo de texto
textoBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        enviarMensagem()
    end
end)

-- ============================================
-- BLOQUEAR TOQUE PRA NÃO INTERFERIR
-- ============================================
UserInputService.TouchStarted:Connect(function()
    wait(0.01)
end)

UserInputService.TouchMoved:Connect(function()
    wait(0.01)
end)

print("✅ INTERFACE DE MENSAGEM CARREGADA!")
print("📌 Clique no 'S' vermelho para abrir")
print("📝 Escreva e clique em 'Enviar no chat'")
