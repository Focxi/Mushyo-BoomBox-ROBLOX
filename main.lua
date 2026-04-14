--[[ 
    NYXBLOKZ BOOMBOX SYSTEM - CORE
    VINCULATED TO GITHUB: Focxi/playlist.json
    FIXED BY GEMINI (V2 - BARRA REDUZIDA)
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- [ CONFIGURAÇÃO DA PLAYLIST ]
local GITHUB_PLAYLIST_URL = "https://raw.githubusercontent.com/Focxi/playlist.json/main/playlist.json?t=" .. tick()

local function carregarPlaylist()
    local sucesso, resultado = pcall(function()
        return game:HttpGet(GITHUB_PLAYLIST_URL)
    end)
    
    if sucesso then
        if resultado:find("<!DOCTYPE html>") then
            warn("BOXFY: Erro! O link retornou HTML.")
            return {{n = "ERRO: LINK INVALIDO", id = "0"}}
        end

        local ok, dados = pcall(function() return HttpService:JSONDecode(resultado) end)
        if ok then
            print("BOXFY: " .. #dados .. " musicas carregadas!")
            return dados
        else
            warn("BOXFY: Erro no JSON.")
            return {{n = "ERRO NO JSON", id = "0"}}
        end
    else
        warn("BOXFY: Erro de conexao.")
        return {{n = "ERRO DE CONEXAO", id = "0"}}
    end
end

local playlist = carregarPlaylist()
local currentIndex = 1
local isShuffle = false

-- [ LIMPEZA E CRIAÇÃO DA UI ]
if PlayerGui:FindFirstChild("BoxfyUltra") then PlayerGui.BoxfyUltra:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "BoxfyUltra"
sg.ResetOnSpawn = false

-- [ BARRA INFERIOR COMPACTA ]
local footerBar = Instance.new("Frame", sg)
footerBar.Size = UDim2.new(1, 0, 0, 40) -- Altura levemente menor
footerBar.Position = UDim2.new(0, 0, 1, -40)
footerBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
footerBar.BackgroundTransparency = 0.3
footerBar.BorderSizePixel = 0

local footerContent = Instance.new("Frame", footerBar)
footerContent.Size = UDim2.new(0, 600, 1, 0) -- Largura reduzida de 800 para 600
footerContent.Position = UDim2.new(0.5, 0, 0.5, 0)
footerContent.AnchorPoint = Vector2.new(0.5, 0.5)
footerContent.BackgroundTransparency = 1

-- Avatar
local avatarImg = Instance.new("ImageLabel", footerContent)
avatarImg.Size = UDim2.new(0, 30, 0, 30)
avatarImg.Position = UDim2.new(0, 5, 0.5, 0)
avatarImg.AnchorPoint = Vector2.new(0, 0.5)
avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=10386373014&w=150&h=150"
avatarImg.BackgroundTransparency = 1
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

-- Crédito
local credText = Instance.new("TextLabel", footerContent)
credText.Size = UDim2.new(0, 100, 1, 0)
credText.Position = UDim2.new(0, 40, 0, 0)
credText.Text = "BY HRJ_DEV"
credText.TextColor3 = Color3.new(1, 1, 1)
credText.Font = Enum.Font.GothamBold
credText.TextSize = 10
credText.BackgroundTransparency = 1
credText.TextXAlignment = Enum.TextXAlignment.Left

-- Tutorial
local tutorialTxt = Instance.new("TextLabel", footerContent)
tutorialTxt.Size = UDim2.new(1, -150, 1, 0)
tutorialTxt.Position = UDim2.new(0, 150, 0, 0)
tutorialTxt.Text = "Aperte J para abrir. Equipe o rádio e toque algo antes de usar."
tutorialTxt.TextColor3 = Color3.fromRGB(200, 200, 200)
tutorialTxt.Font = Enum.Font.Gotham
tutorialTxt.TextSize = 10
tutorialTxt.BackgroundTransparency = 1
tutorialTxt.TextXAlignment = Enum.TextXAlignment.Left

-- [ TIMER: SOME TUDO EM 30 SEGUNDOS ]
task.delay(30, function()
    if footerBar then
        -- Animação de descida suave
        footerBar:TweenPosition(UDim2.new(0, 0, 1, 10), "In", "Quad", 0.5, true)
        task.wait(0.6)
        footerBar:Destroy() -- Deleta completamente da memória
    end
end)

-- [ HUB PRINCIPAL ]
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 310, 0, 420)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BackgroundTransparency = 0.05
main.Visible = false -- Inicia invisível para não poluir a tela
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 24)

-- [ FUNÇÕES DE SOM E CONTROLE ]
local function getSnd()
    local char = Player.Character
    if not char then return nil end
    local tool = char:FindFirstChildWhichIsA("Tool")
    if tool then
        local s = tool:FindFirstChildWhichIsA("Sound", true)
        if s then return s end
    end
    return nil
end

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.J then main.Visible = not main.Visible end
end)

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 50)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "BOXFY CLOUD - HRJ_DEV"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextTransparency = 0.6
title.BackgroundTransparency = 1

local sContainer = Instance.new("Frame", main)
sContainer.Size = UDim2.new(1, -40, 0, 34)
sContainer.Position = UDim2.new(0.5, 0, 0, 60)
sContainer.AnchorPoint = Vector2.new(0.5, 0)
sContainer.BackgroundColor3 = Color3.new(1, 1, 1)
sContainer.BackgroundTransparency = 0.96
Instance.new("UICorner", sContainer).CornerRadius = UDim.new(0, 10)

local search = Instance.new("TextBox", sContainer)
search.Size = UDim2.new(1, -20, 1, 0)
search.Position = UDim2.new(0.5, 0, 0, 0)
search.AnchorPoint = Vector2.new(0.5, 0)
search.PlaceholderText = "Pesquisar musicas..."
search.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
search.BackgroundTransparency = 1
search.TextColor3 = Color3.new(1, 1, 1)
search.Font = Enum.Font.Gotham
search.TextSize = 13

local sc = Instance.new("ScrollingFrame", main)
sc.Size = UDim2.new(1, -20, 1, -210)
sc.Position = UDim2.new(0.5, 0, 0, 105)
sc.AnchorPoint = Vector2.new(0.5, 0)
sc.BackgroundTransparency = 1
sc.ScrollBarThickness = 0
local listLayout = Instance.new("UIListLayout", sc)
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local footer = Instance.new("Frame", main)
footer.Size = UDim2.new(1, 0, 0, 100)
footer.Position = UDim2.new(0, 0, 1, -100)
footer.BackgroundTransparency = 1

local currentName = Instance.new("TextLabel", footer)
currentName.Size = UDim2.new(1, -20, 0, 20)
currentName.Position = UDim2.new(0.5, 0, 0, 5)
currentName.AnchorPoint = Vector2.new(0.5, 0)
currentName.Text = "PARADO"
currentName.TextColor3 = Color3.fromRGB(180, 180, 180)
currentName.Font = Enum.Font.GothamMedium
currentName.TextSize = 10
currentName.BackgroundTransparency = 1

local ctrlFrame = Instance.new("Frame", footer)
ctrlFrame.Size = UDim2.new(1, 0, 0, 60)
ctrlFrame.Position = UDim2.new(0.5, 0, 0, 30)
ctrlFrame.AnchorPoint = Vector2.new(0.5, 0)
ctrlFrame.BackgroundTransparency = 1

local function createBtn(txt, posX, size)
    local b = Instance.new("TextButton", ctrlFrame)
    b.Size = UDim2.new(0, size or 35, 0, size or 35)
    b.Position = UDim2.new(posX, 0, 0.5, 0)
    b.AnchorPoint = Vector2.new(0.5, 0.5)
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = (size and size > 35) and 24 or 18
    b.BackgroundTransparency = 1
    return b
end

local bShuffle = createBtn("⤨", 0.22)
local bBack    = createBtn("«", 0.38)
local bPlay    = createBtn("▶", 0.5, 45)
local bNext    = createBtn("»", 0.62)
local bClose   = createBtn("X", 0.78)

local function play(idx)
    if not playlist[idx] then return end
    currentIndex = idx
    local snd = getSnd()
    if snd then
        snd:Stop()
        snd.SoundId = "rbxassetid://"..playlist[idx].id
        snd:Play()
        currentName.Text = playlist[idx].n:upper()
        bPlay.Text = "Ⅱ"
    else
        currentName.Text = "EQUIPE O RÁDIO!"
    end
end

bPlay.MouseButton1Click:Connect(function()
    local snd = getSnd()
    if snd then
        if snd.IsPlaying then snd:Pause() bPlay.Text = "▶" else snd:Resume() bPlay.Text = "Ⅱ" end
    end
end)

bNext.MouseButton1Click:Connect(function()
    local n = isShuffle and math.random(1, #playlist) or (currentIndex % #playlist + 1)
    play(n)
end)

bBack.MouseButton1Click:Connect(function()
    local p = currentIndex - 1
    if p < 1 then p = #playlist end
    play(p)
end)

bShuffle.MouseButton1Click:Connect(function()
    isShuffle = not isShuffle
    bShuffle.TextColor3 = isShuffle and Color3.fromRGB(30, 215, 96) or Color3.new(1, 1, 1)
end)

bClose.MouseButton1Click:Connect(function() main.Visible = false end)

local function refresh(txt)
    for _, v in pairs(sc:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for i, s in pairs(playlist) do
        if txt == "" or s.n:lower():find(txt:lower()) then
            local b = Instance.new("TextButton", sc)
            b.Name = tostring(i)
            b.Size = UDim2.new(1, -10, 0, 38)
            b.Text = "      " .. s.n
            b.TextColor3 = Color3.fromRGB(160, 160, 160)
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.BackgroundColor3 = Color3.new(1, 1, 1)
            b.BackgroundTransparency = 0.97
            b.Font = Enum.Font.Gotham
            b.TextSize = 12
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
            b.MouseButton1Click:Connect(function() play(i) end)
        end
    end
    sc.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

search:GetPropertyChangedSignal("Text"):Connect(function() refresh(search.Text) end)
refresh("")

local d, sp, mp
top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true sp = i.Position mp = main.Position end end)
UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then 
    local delta = i.Position - sp
    main.Position = UDim2.new(mp.X.Scale, mp.X.Offset + delta.X, mp.Y.Scale, mp.Y.Offset + delta.Y) 
end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
