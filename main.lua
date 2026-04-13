--[[ 
    NYXBLOKZ BOOMBOX SYSTEM - CORE
    VINCULATED TO GITHUB: Focxi/playlist.json
    FIXED BY GEMINI (Final Stability Update)
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- [ REFERÊNCIA DO EVENTO ]
-- Usamos pcall para evitar que o script quebre se o mapa demorar a carregar os módulos
local RemoteEvent
local successEvent = pcall(function()
    RemoteEvent = ReplicatedStorage:WaitForChild("Modules", 5):WaitForChild("Events", 5):WaitForChild("RemoteEvent", 5)
end)

-- [ CONFIGURAÇÃO DA PLAYLIST ]
local GITHUB_PLAYLIST_URL = "https://raw.githubusercontent.com/Focxi/playlist.json/main/playlist.json?t=" .. tick()

local function carregarPlaylist()
    local sucesso, resultado = pcall(function()
        return game:HttpGet(GITHUB_PLAYLIST_URL)
    end)
    
    if sucesso and not resultado:find("<!DOCTYPE html>") then
        local ok, dados = pcall(function() return HttpService:JSONDecode(resultado) end)
        if ok then return dados end
    end
    warn("BOXFY: Falha ao carregar playlist externa.")
    return {{n = "ERRO AO CARREGAR LISTA", id = "0"}}
end

local playlist = carregarPlaylist()
local currentIndex = 1
local isShuffle = false
local isPlaying = false

-- [ UI - CRIAÇÃO ]
if PlayerGui:FindFirstChild("BoxfyUltra") then PlayerGui.BoxfyUltra:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "BoxfyUltra"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 310, 0, 420)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BackgroundTransparency = 0.05
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 24)

-- [ FUNÇÕES DE CONTROLE ]
local function play(idx)
    if not playlist[idx] or playlist[idx].id == "0" then return end
    currentIndex = idx
    
    local songId = tonumber(playlist[idx].id)
    
    if RemoteEvent then
        -- Tenta tocar via Servidor
        RemoteEvent:FireServer("PlaySongSuccess", songId)
        currentName.Text = "CARREGANDO: " .. playlist[idx].n:upper()
        
        -- Pequeno delay para atualizar o texto (esperando o carregamento do rádio)
        task.delay(0.5, function()
            currentName.Text = playlist[idx].n:upper()
            bPlay.Text = "Ⅱ"
            isPlaying = true
        end)
    else
        currentName.Text = "ERRO: EVENTO NÃO ENCONTRADO"
    end
end

local function stop()
    if RemoteEvent then
        RemoteEvent:FireServer("StopSongSuccess")
    end
    bPlay.Text = "▶"
    isPlaying = false
    currentName.Text = "PARADO"
end

-- [ ELEMENTOS VISUAIS ]
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

local footer = Instance.new("Frame", main)
footer.Size = UDim2.new(1, 0, 0, 100)
footer.Position = UDim2.new(0, 0, 1, -100)
footer.BackgroundTransparency = 1

currentName = Instance.new("TextLabel", footer)
currentName.Size = UDim2.new(1, -20, 0, 20)
currentName.Position = UDim2.new(0.5, 0, 0, 5)
currentName.AnchorPoint = Vector2.new(0.5, 0)
currentName.Text = "PRONTO"
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
bPlay          = createBtn("▶", 0.5, 45)
local bNext    = createBtn("»", 0.62)
local bClose   = createBtn("X", 0.78)

-- [ EVENTOS ]
bPlay.MouseButton1Click:Connect(function()
    if isPlaying then stop() else play(currentIndex) end
end)

bNext.MouseButton1Click:Connect(function()
    play(isShuffle and math.random(1, #playlist) or (currentIndex % #playlist + 1))
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
            b.Size = UDim2.new(1, -10, 0, 38)
            b.Text = "      " .. s.n
            b.TextColor3 = Color3.fromRGB(160, 160, 160)
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.BackgroundColor3 = Color3.new(1, 1, 1)
            b.BackgroundTransparency = 0.97
            b.Font = Enum.Font.Gotham
            b.TextSize = 11
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
            b.MouseButton1Click:Connect(function() play(i) end)
        end
    end
    sc.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

search:GetPropertyChangedSignal("Text"):Connect(function() refresh(search.Text) end)
refresh("")

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.J then main.Visible = not main.Visible end
end)

-- Arrastar UI
local d, sp, mp
top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true sp = i.Position mp = main.Position end end)
UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then 
    local delta = i.Position - sp
    main.Position = UDim2.new(mp.X.Scale, mp.X.Offset + delta.X, mp.Y.Scale, mp.Y.Offset + delta.Y) 
end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
