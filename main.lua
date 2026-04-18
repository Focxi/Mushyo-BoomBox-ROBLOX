--[[ 
    NYXBLOKZ BOOMBOX SYSTEM - FIX V3
    FIXED BY HRJ_DEV // ANTI-CRASH & GLOBAL SYNC
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local GITHUB_PLAYLIST_URL = "https://raw.githubusercontent.com/Focxi/playlist.json/main/playlist.json?t=" .. tick()

local function carregarPlaylist()
    local sucesso, resultado = pcall(function()
        return game:HttpGet(GITHUB_PLAYLIST_URL)
    end)
    if sucesso and not resultado:find("<!DOCTYPE html>") then
        local ok, dados = pcall(function() return HttpService:JSONDecode(resultado) end)
        return ok and dados or {{n = "ERRO NO JSON", id = "0"}}
    end
    return {{n = "ERRO DE CONEXAO", id = "0"}}
end

local playlist = carregarPlaylist()
local currentIndex = 1
local isShuffle = false

-- [ LIMPEZA DA UI ANTIGA ]
if PlayerGui:FindFirstChild("BoxfyUltra") then PlayerGui.BoxfyUltra:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "BoxfyUltra"
sg.ResetOnSpawn = false

-- [ HUB PRINCIPAL ]
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 310, 0, 420)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Visible = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 24)

-- Elementos da UI que o erro "nil with Text" estava atacando:
local footer = Instance.new("Frame", main)
footer.Size = UDim2.new(1, 0, 0, 100)
footer.Position = UDim2.new(0, 0, 1, -100)
footer.BackgroundTransparency = 1

local currentName = Instance.new("TextLabel", footer)
currentName.Name = "CurrentTrackName" -- Nome fixo para evitar erro de index
currentName.Size = UDim2.new(1, -20, 0, 20)
currentName.Position = UDim2.new(0.5, 0, 0, 5)
currentName.AnchorPoint = Vector2.new(0.5, 0)
currentName.Text = "AGUARDANDO..."
currentName.TextColor3 = Color3.fromRGB(180, 180, 180)
currentName.Font = Enum.Font.GothamMedium
currentName.TextSize = 10
currentName.BackgroundTransparency = 1

-- [ LÓGICA DE REPLICAÇÃO MELHORADA ]
local function play(idx)
    if not playlist[idx] or not currentName then return end
    currentIndex = idx
    local songId = tostring(playlist[idx].id)
    local char = Player.Character
    local tool = char and char:FindFirstChildWhichIsA("Tool")

    if tool then
        local remote = tool:FindFirstChild("PlaySong") or 
                       tool:FindFirstChild("ServerSound") or 
                       tool:FindFirstChild("SetSound") or
                       tool:FindFirstChildWhichIsA("RemoteEvent")

        if remote then
            remote:FireServer(songId)
            currentName.Text = "GLOBAL: " .. playlist[idx].n:upper()
        else
            local snd = tool:FindFirstChildWhichIsA("Sound", true)
            if snd then
                snd.SoundId = "rbxassetid://"..songId
                snd:Play()
                currentName.Text = "LOCAL: " .. playlist[idx].n:upper()
            end
        end
    else
        currentName.Text = "ERRO: SEGURE O RÁDIO!"
    end
end

-- [ OS BOTÕES E RESTO DO CÓDIGO PERMANECEM IGUAIS ]
-- (Apenas garanta que o play() seja chamado corretamente)
