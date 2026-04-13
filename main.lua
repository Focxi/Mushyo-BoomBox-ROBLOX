--[[ 
    NYXBLOKZ BOOMBOX SYSTEM - CORE
    VINCULATED TO GITHUB: Focxi/playlist.json
    FIXED BY GEMINI
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
    if sucesso and not resultado:find("<!DOCTYPE html>") then
        local ok, dados = pcall(function() return HttpService:JSONDecode(resultado) end)
        if ok then return dados end
    end
    return {{n = "ERRO DE CONEXAO", id = "0"}}
end

local playlist = carregarPlaylist()

-- [ LIMPEZA ]
if PlayerGui:FindFirstChild("BoxfyUltra") then PlayerGui.BoxfyUltra:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "BoxfyUltra"
sg.ResetOnSpawn = false

-- [ NOTIFICAÇÃO EXTERNA (EMBAIXO DA TELA) ]
local notify = Instance.new("Frame", sg)
notify.Size = UDim2.new(0, 380, 0, 65)
notify.Position = UDim2.new(0.5, -190, 1, 100) -- Começa escondido embaixo
notify.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
notify.BorderSizePixel = 0
Instance.new("UICorner", notify).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", notify)
stroke.Color = Color3.fromRGB(45, 45, 45)
stroke.Thickness = 1

local av = Instance.new("ImageLabel", notify)
av.Size = UDim2.new(0, 45, 0, 45)
av.Position = UDim2.new(0, 10, 0.5, 0)
av.AnchorPoint = Vector2.new(0, 0.5)
av.Image = "rbxthumb://type=AvatarHeadShot&id=10386373014&w=150&h=150"
av.BackgroundTransparency = 1
Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)

local t1 = Instance.new("TextLabel", notify)
t1.Size = UDim2.new(1, -70, 0, 20)
t1.Position = UDim2.new(0, 65, 0, 12)
t1.Text = "BOXFY: Criado por HRJ_DEV"
t1.TextColor3 = Color3.new(1, 1, 1)
t1.Font = Enum.Font.GothamBold
t1.TextSize = 13
t1.BackgroundTransparency = 1
t1.TextXAlignment = Enum.TextXAlignment.Left

local t2 = Instance.new("TextLabel", notify)
t2.Size = UDim2.new(1, -70, 0, 30)
t2.Position = UDim2.new(0, 65, 0, 28)
t2.Text = "Aperte J para abrir. Equipe o radio e toque algo antes de usar o Boxfy!"
t2.TextColor3 = Color3.fromRGB(180, 180, 180)
t2.Font = Enum.Font.Gotham
t2.TextSize = 10
t2.TextWrapped = true
t2.BackgroundTransparency = 1
t2.TextXAlignment = Enum.TextXAlignment.Left

-- Animação da Notificação (Estilo solicitação)
task.spawn(function()
    notify:TweenPosition(UDim2.new(0.5, -190, 1, -90), "Out", "Back", 0.6, true)
    task.wait(40) -- Fica visível por 40 segundos
    notify:TweenPosition(UDim2.new(0.5, -190, 1, 100), "In", "Quad", 0.5, true)
    task.wait(0.6)
    notify:Destroy()
end)

-- [ HUB PRINCIPAL (MENU) ]
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 310, 0, 420)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Visible = false -- Menu começa fechado
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 24)

-- [ SISTEMA DE ARRASTAR ]
local d, sp, mp
main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true sp = i.Position mp = main.Position end end)
UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then 
    local delta = i.Position - sp
    main.Position = UDim2.new(mp.X.Scale, mp.X.Offset + delta.X, mp.Y.Scale, mp.Y.Offset + delta.Y) 
end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

-- Atalho de Teclado
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.J then main.Visible = not main.Visible end
end)

-- [ COMPONENTES INTERNOS DO MENU ]
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 50)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "BOXFY CLOUD"
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

-- [ CONTROLES ]
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

local function play(idx)
    if not playlist[idx] then return end
    local snd = getSnd()
    if snd then
        snd:Stop()
        snd.SoundId = "rbxassetid://"..playlist[idx].id
        snd:Play()
        main.Footer.Current.Text = playlist[idx].n:upper()
    end
end

-- Botões e Refresh (Lógica simplificada para manter o foco na UI)
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
            b.TextSize = 12
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
            b.MouseButton1Click:Connect(function() play(i) end)
        end
    end
    sc.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

search:GetPropertyChangedSignal("Text"):Connect(function() refresh(search.Text) end)
refresh("")
