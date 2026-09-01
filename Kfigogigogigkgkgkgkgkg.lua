--[[
    ═══════════════════════════════════════════════════════
    🐧 JV HUB ADM - 300 COMANDOS ÚNICOS
    📌 by jotinha12hr2
    📌 Brookhaven + Antena de Chat
    📌 Cada comando = 1 função diferente
    ═══════════════════════════════════════════════════════
]]

-- ============================================
-- SERVIÇOS
-- ============================================
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local Workspace = workspace
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ============================================
-- CONFIGURAÇÕES
-- ============================================
local ANTENA = {Prefixo = "/jv ", Ativo = true, Canal = "RBXGeneral"}
local Processados = {}

-- ============================================
-- FUNÇÕES AUXILIARES
-- ============================================
local function GetPlayer(name)
    if not name or name == "" then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if string.lower(p.Name) == string.lower(name) then return p end
    end
    return nil
end

local function GetRoot(p) return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") end
local function GetHum(p) return p and p.Character and p.Character:FindFirstChildOfClass("Humanoid") end
local function GetHead(p) return p and p.Character and p.Character:FindFirstChild("Head") end
local function GetTorso(p) return p and p.Character and (p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("UpperTorso")) end

-- ============================================
-- ENVIA COMANDO PELO CHAT
-- ============================================
function EnviarComandoChat(comando, alvo, valor)
    if not ANTENA.Ativo then return end
    local mensagem = string.format("%s%s %s %s", ANTENA.Prefixo, comando, alvo or "", valor or "")
    pcall(function()
        local channel = TextChatService.TextChannels:FindFirstChild(ANTENA.Canal)
        if channel then channel:SendAsync(mensagem)
        else
            local channels = TextChatService.TextChannels:GetChildren()
            if #channels > 0 then channels[1]:SendAsync(mensagem)
        end
    end)
end

-- ============================================
-- 300 COMANDOS ÚNICOS
-- ============================================
local function ExecutarComando(comando, alvo, valor, remetente)
    if alvo ~= "" and alvo ~= "todos" and alvo ~= "all" and alvo ~= "me" and alvo ~= LocalPlayer.Name then return end
    
    local chave = string.format("%s_%s_%s_%s", comando, alvo, valor, remetente)
    if Processados[chave] then return end
    Processados[chave] = true
    task.delay(1, function() Processados[chave] = nil end)
    
    local p = GetPlayer(valor)
    local pAlvo = p or GetPlayer(alvo)
    local r = pAlvo and GetRoot(pAlvo)
    local h = pAlvo and GetHum(pAlvo)
    local head = pAlvo and GetHead(pAlvo)
    local torso = pAlvo and GetTorso(pAlvo)

-- ============================================
-- 1-50: COMANDOS DE ATAQUE E DANO
-- ============================================

-- 1. KILL - Mata instantaneamente
if comando == "kill" then if h then h.Health = 0 end return end

-- 2. KILLALL - Mata todos os jogadores
if comando == "killall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local h2 = GetHum(pl) if h2 then h2.Health = 0 end end end return end

-- 3. KILLME - Suicídio
if comando == "killme" then if h then h.Health = 0 end return end

-- 4. KILLNEARBY - Mata jogadores próximos
if comando == "killnearby" then local ar = GetRoot(LocalPlayer) if not ar then return end for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr and (pr.Position - ar.Position).Magnitude < 50 then local h2 = GetHum(pl) if h2 then h2.Health = 0 end end end return end

-- 5. KILLFAR - Mata jogadores distantes
if comando == "killfar" then local ar = GetRoot(LocalPlayer) if not ar then return end for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr and (pr.Position - ar.Position).Magnitude > 100 then local h2 = GetHum(pl) if h2 then h2.Health = 0 end end end return end

-- 6. KILLRANDOM - Mata um jogador aleatório
if comando == "killrandom" then local list = {} for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then table.insert(list, pl) end end if #list > 0 then local h2 = GetHum(list[math.random(1, #list)]) if h2 then h2.Health = 0 end end return end

-- 7. HEADSHOT - Tiro na cabeça com explosão
if comando == "headshot" then if head then local e = Instance.new("Explosion") e.Position = head.Position e.BlastRadius = 3 e.Parent = Workspace end if h then h.Health = 0 end return end

-- 8. EXPLODEKILL - Mata com explosão
if comando == "explodekill" then if h then h.Health = 0 end if r then local e = Instance.new("Explosion") e.Position = r.Position e.BlastRadius = 20 e.BlastPressure = 500000 e.Parent = Workspace end return end

-- 9. SILENTKILL - Mata silenciosamente
if comando == "silentkill" then if h then h.Health = 0 h.Parent = nil task.wait(0.1) if pAlvo and pAlvo.Character then h.Parent = pAlvo.Character end end return end

-- 10. INSTANTKILL - Mata instantaneamente com explosão
if comando == "instantkill" then if h then h.Health = 0 if r then local e = Instance.new("Explosion") e.Position = r.Position e.BlastRadius = 5 e.Parent = Workspace end end return end

-- 11. SLOWKILL - Mata lentamente
if comando == "slowkill" then if h then for i = 1, 10 do h:TakeDamage(10) task.wait(0.5) end end return end

-- 12. FREEZEKILL - Congela e mata
if comando == "freezekill" then if h then h.WalkSpeed = 0 h.JumpHeight = 0 end task.delay(2, function() if h then h.Health = 0 h.WalkSpeed = 16 h.JumpHeight = 50 end end) return end

-- 13. CRUSH - Esmaga o jogador
if comando == "crush" then if r then local part = Instance.new("Part") part.Size = Vector3.new(10,1,10) part.Position = r.Position + Vector3.new(0,5,0) part.Anchored = true part.CanCollide = true part.Material = Enum.Material.Neon part.Color = Color3.fromRGB(255,0,0) part.Parent = Workspace TweenService:Create(part, TweenInfo.new(0.5), {Position = r.Position + Vector3.new(0,-1,0)}):Play() task.delay(0.6, function() if h then h.Health = 0 end part:Destroy() end) end return end

-- 14. GUILLOTINE - Guilhotina
if comando == "guillotine" then if head then TweenService:Create(head, TweenInfo.new(0.3), {Position = head.Position - Vector3.new(0,10,0)}):Play() task.delay(0.4, function() if h then h.Health = 0 end end) end return end

-- 15. THANOS - Apaga o jogador
if comando == "thanos" then if r then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then TweenService:Create(part, TweenInfo.new(1), {Size = Vector3.new(0,0,0)}):Play() end end task.delay(1.2, function() if h then h.Health = 0 end end) end return end

-- 16. SUFFOCATE - Sufoca o jogador
if comando == "suffocate" then if r then local box = Instance.new("Part") box.Size = Vector3.new(3,3,3) box.Position = r.Position box.Anchored = true box.CanCollide = true box.Transparency = 0.5 box.Material = Enum.Material.Neon box.Color = Color3.fromRGB(0,0,255) box.Parent = Workspace for i = 1, 10 do box.Size = box.Size + Vector3.new(0.5,0.5,0.5) task.wait(0.3) end box:Destroy() if h then h.Health = 0 end end return end

-- 17. BLEED - Sangra o jogador (dano contínuo)
if comando == "bleed" then if h then for i = 1, 5 do h:TakeDamage(20) task.wait(0.5) end end return end

-- 18. POISON - Envenena o jogador
if comando == "poison" then if h then for i = 1, 8 do h:TakeDamage(12) task.wait(0.3) end end return end

-- 19. BURN - Queima o jogador
if comando == "burn" then if h then for i = 1, 6 do h:TakeDamage(15) local fire = Instance.new("Fire") fire.Parent = r or torso fire.Size = 10 Debris:AddItem(fire,0.5) task.wait(0.5) end end return end

-- 20. ELECTROCUTE - Eletrocuta o jogador
if comando == "electrocute" then if h then for i = 1, 10 do h:TakeDamage(10) if r then local lightning = Instance.new("Part") lightning.Size = Vector3.new(0.2,5,0.2) lightning.Position = r.Position + Vector3.new(math.random(-3,3),0,math.random(-3,3)) lightning.Material = Enum.Material.Neon lightning.Color = Color3.fromRGB(0,200,255) lightning.Anchored = true lightning.Parent = Workspace Debris:AddItem(lightning,0.2) end task.wait(0.1) end end return end

-- 21. FREEZE - Congela o jogador
if comando == "freeze" then if h then h.WalkSpeed = 0 h.JumpHeight = 0 h.PlatformStand = true end return end

-- 22. UNFREEZE - Descongela
if comando == "unfreeze" then if h then h.WalkSpeed = 16 h.JumpHeight = 50 h.PlatformStand = false end return end

-- 23. FREEZEALL - Congela todos
if comando == "freezeall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local h2 = GetHum(pl) if h2 then h2.WalkSpeed = 0 h2.JumpHeight = 0 end end end return end

-- 24. UNFREEZEALL - Descongela todos
if comando == "unfreezeall" then for _, pl in pairs(Players:GetPlayers()) do local h2 = GetHum(pl) if h2 then h2.WalkSpeed = 16 h2.JumpHeight = 50 end end return end

-- 25. SLOWMOTION - Deixa o jogador lento
if comando == "slowmotion" then if h then h.WalkSpeed = 3 h.JumpHeight = 10 end return end

-- 26. SUPERSPEED - Deixa o jogador super rápido
if comando == "superspeed" then if h then h.WalkSpeed = 100 h.JumpHeight = 200 end return end

-- 27. NORMALSPEED - Velocidade normal
if comando == "normalspeed" then if h then h.WalkSpeed = 16 h.JumpHeight = 50 end return end

-- 28. REVERSESPEED - Velocidade reversa
if comando == "reversespeed" then if h then h.WalkSpeed = -h.WalkSpeed end return end

-- 29. STUN - Atordoa o jogador
if comando == "stun" then if h then h.WalkSpeed = 0 h.JumpHeight = 0 h.PlatformStand = true task.delay(3, function() if h and h.Parent then h.WalkSpeed = 16 h.JumpHeight = 50 h.PlatformStand = false end end) end return end

-- 30. STUNALL - Atordoa todos
if comando == "stunall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local h2 = GetHum(pl) if h2 then h2.WalkSpeed = 0 h2.JumpHeight = 0 h2.PlatformStand = true task.delay(3, function() if h2 and h2.Parent then h2.WalkSpeed = 16 h2.JumpHeight = 50 h2.PlatformStand = false end end) end end return end

-- 31. ICEBLOCK - Bloco de gelo
if comando == "iceblock" then if r then local ice = Instance.new("Part") ice.Size = Vector3.new(4,6,4) ice.Position = r.Position ice.Anchored = true ice.CanCollide = true ice.Transparency = 0.3 ice.Material = Enum.Material.Neon ice.Color = Color3.fromRGB(0,200,255) ice.Parent = Workspace if h then h.WalkSpeed = 0 h.JumpHeight = 0 end task.delay(5, function() ice:Destroy() if h then h.WalkSpeed = 16 h.JumpHeight = 50 end end) end return end

-- 32. TIMEFREEZE - Congela o tempo do jogador
if comando == "timefreeze" then if r then local glow = Instance.new("PointLight", r) glow.Color = Color3.fromRGB(0,255,255) glow.Brightness = 5 glow.Range = 20 if h then h.WalkSpeed = 0 h.JumpHeight = 0 end for i = 1, 5 do r.Size = r.Size + Vector3.new(0.1,0.1,0.1) task.wait(0.1) end task.delay(3, function() glow:Destroy() if h then h.WalkSpeed = 16 h.JumpHeight = 50 end end) end return end

-- 33. FLING - Arremessa o jogador
if comando == "fling" then if r then TweenService:Create(r, TweenInfo.new(0.5), {CFrame = CFrame.new(0,100000,0)}):Play() end return end

-- 34. FLINGALL - Arremessa todos
if comando == "flingall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr then TweenService:Create(pr, TweenInfo.new(0.5), {CFrame = CFrame.new(0,100000,0)}):Play() end end end return end

-- 35. FLINGUP - Arremessa para cima
if comando == "flingup" then if r then TweenService:Create(r, TweenInfo.new(1), {CFrame = CFrame.new(r.Position + Vector3.new(0,1000,0))}):Play() end return end

-- 36. FLINGDOWN - Arremessa para baixo
if comando == "flingdown" then if r then TweenService:Create(r, TweenInfo.new(0.5), {CFrame = CFrame.new(r.Position - Vector3.new(0,1000,0))}):Play() end return end

-- 37. FLINGSIDE - Arremessa para o lado
if comando == "flingside" then if r then local dir = Vector3.new(math.random(-1,1),0,math.random(-1,1)).Unit TweenService:Create(r, TweenInfo.new(0.5), {CFrame = CFrame.new(r.Position + dir * 500)}):Play() end return end

-- 38. FLINGRANDOM - Arremessa aleatoriamente
if comando == "flingrandom" then if r then local dir = Vector3.new(math.random(-100,100), math.random(0,200), math.random(-100,100)) TweenService:Create(r, TweenInfo.new(0.5), {CFrame = CFrame.new(r.Position + dir)}):Play() end return end

-- 39. FLINGTOSKY - Arremessa para o céu
if comando == "flingtosky" then if r then TweenService:Create(r, TweenInfo.new(0.5), {CFrame = CFrame.new(0,10000,0)}):Play() end return end

-- 40. FLINGTOVOID - Arremessa para o vazio
if comando == "flingtovoid" then if r then TweenService:Create(r, TweenInfo.new(0.5), {CFrame = CFrame.new(0,-10000,0)}):Play() end return end

-- 41. FLINGTOSPAWN - Arremessa para o spawn
if comando == "flingtospawn" then local s = Workspace:FindFirstChild("SpawnLocation") if r and s then TweenService:Create(r, TweenInfo.new(0.5), {CFrame = CFrame.new(s.Position)}):Play() end return end

-- 42. FLINGTOBEACH - Arremessa para a praia
if comando == "flingtobeach" then if r then TweenService:Create(r, TweenInfo.new(0.5), {CFrame = CFrame.new(200,0,-200)}):Play() end return end

-- 43. FLINGTOMOUNTAIN - Arremessa para a montanha
if comando == "flingtomountain" then if r then TweenService:Create(r, TweenInfo.new(0.5), {CFrame = CFrame.new(0,500,0)}):Play() end return end

-- 44. FLINGTOUNDERWATER - Arremessa para debaixo d'água
if comando == "flingtounderwater" then if r then TweenService:Create(r, TweenInfo.new(0.5), {CFrame = CFrame.new(0,-50,0)}):Play() end return end

-- 45. FLINGTOSTORE - Arremessa para a loja
if comando == "flingtostore" then if r then TweenService:Create(r, TweenInfo.new(0.5), {CFrame = CFrame.new(100,0,0)}):Play() end return end

-- 46. FLINGTOPARK - Arremessa para o parque
if comando == "flingtopark" then if r then TweenService:Create(r, TweenInfo.new(0.5), {CFrame = CFrame.new(-100,0,100)}):Play() end return end

-- 47. FLINGTOME - Arremessa o jogador até você
if comando == "flingtome" then local ar = GetRoot(LocalPlayer) if r and ar then TweenService:Create(r, TweenInfo.new(0.5), {CFrame = ar.CFrame * CFrame.new(0,2,3)}):Play() end return end

-- 48. BRING - Traz o jogador até você
if comando == "bring" then local ar = GetRoot(LocalPlayer) if r and ar then r.CFrame = ar.CFrame * CFrame.new(0,2,3) end return end

-- 49. BRINGALL - Traz todos os jogadores
if comando == "bringall" then local ar = GetRoot(LocalPlayer) if not ar then return end for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr then pr.CFrame = ar.CFrame * CFrame.new(0,2,3) end end end return end

-- 50. BRINGNEARBY - Traz jogadores próximos
if comando == "bringnearby" then local ar = GetRoot(LocalPlayer) if not ar then return end for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr and (pr.Position - ar.Position).Magnitude < 50 then pr.CFrame = ar.CFrame * CFrame.new(0,2,3) end end end return end

-- ============================================
-- 51-100: TELEPORTE E POSIÇÃO
-- ============================================

-- 51. BRINGFAR - Traz jogadores distantes
if comando == "bringfar" then local ar = GetRoot(LocalPlayer) if not ar then return end for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr and (pr.Position - ar.Position).Magnitude > 100 then pr.CFrame = ar.CFrame * CFrame.new(0,2,3) end end end return end

-- 52. BRINGME - Traz você até o jogador
if comando == "bringme" then local ar = GetRoot(LocalPlayer) if r and ar then ar.CFrame = r.CFrame * CFrame.new(0,2,3) end return end

-- 53. BRINGTOME - Traz o jogador até você (alias)
if comando == "bringtome" then local ar = GetRoot(LocalPlayer) if r and ar then r.CFrame = ar.CFrame * CFrame.new(0,2,3) end return end

-- 54. BRINGTOSPAWN - Traz o jogador para o spawn
if comando == "bringtospawn" then local s = Workspace:FindFirstChild("SpawnLocation") if r and s then r.CFrame = CFrame.new(s.Position) end return end

-- 55. BRINGTOSKY - Traz o jogador para o céu
if comando == "bringtosky" then if r then r.CFrame = CFrame.new(0,10000,0) end return end

-- 56. BRINGTOVOID - Traz o jogador para o vazio
if comando == "bringtovoid" then if r then r.CFrame = CFrame.new(0,-10000,0) end return end

-- 57. BRINGTOBEACH - Traz o jogador para a praia
if comando == "bringtobeach" then if r then r.CFrame = CFrame.new(200,0,-200) end return end

-- 58. BRINGTOMOUNTAIN - Traz para a montanha
if comando == "bringtomountain" then if r then r.CFrame = CFrame.new(0,500,0) end return end

-- 59. BRINGTOUNDERWATER - Traz para debaixo d'água
if comando == "bringtounderwater" then if r then r.CFrame = CFrame.new(0,-50,0) end return end

-- 60. BRINGTOSTORE - Traz para a loja
if comando == "bringtostore" then if r then r.CFrame = CFrame.new(100,0,0) end return end

-- 61. BRINGTOPARK - Traz para o parque
if comando == "bringtopark" then if r then r.CFrame = CFrame.new(-100,0,100) end return end

-- 62. BRINGTOHOME - Traz para casa
if comando == "bringtohome" then if r then r.CFrame = CFrame.new(0,100,0) end return end

-- 63. BRINGTORANDOM - Traz para um local aleatório
if comando == "bringtorandom" then if r then r.CFrame = CFrame.new(math.random(-1000,1000), math.random(0,500), math.random(-1000,1000)) end return end

-- 64. TPSPAWN - Teleporta para o spawn
if comando == "tpspawn" then local s = Workspace:FindFirstChild("SpawnLocation") if r and s then r.CFrame = CFrame.new(s.Position) end return end

-- 65. TPSKY - Teleporta para o céu
if comando == "tpsky" then if r then r.CFrame = CFrame.new(0,10000,0) end return end

-- 66. TPVOID - Teleporta para o vazio
if comando == "tpvoid" then if r then r.CFrame = CFrame.new(0,-10000,0) end return end

-- 67. TPRANDOM - Teleporta aleatoriamente
if comando == "tprandom" then if r then r.CFrame = CFrame.new(math.random(-1000,1000), math.random(0,500), math.random(-1000,1000)) end return end

-- 68. TPTROLL - Trolleia com teleporte
if comando == "tptroll" then if r then local pos = r.Position local dests = {Vector3.new(799,-9,482), Vector3.new(-500,100,-500), Vector3.new(500,500,500)} r.CFrame = CFrame.new(dests[math.random(1,3)]) task.delay(2, function() if pAlvo and pAlvo.Character then local cr = GetRoot(pAlvo) if cr then cr.CFrame = CFrame.new(pos) end end end) end return end

-- 69. TPME - Teleporta você até o jogador
if comando == "tpme" then local ar = GetRoot(LocalPlayer) if r and ar then ar.CFrame = r.CFrame * CFrame.new(0,2,3) end return end

-- 70. BACKROOMS - Manda para as Backrooms
if comando == "backrooms" then if r then r.CFrame = CFrame.new(59,9996,19) end return end

-- 71. BACKROOMSALL - Manda todos para as Backrooms
if comando == "backroomsall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr then pr.CFrame = CFrame.new(59,9996,19) end end end return end

-- 72. BACKROOMSME - Manda você para as Backrooms
if comando == "backroomsme" then local ar = GetRoot(LocalPlayer) if ar then ar.CFrame = CFrame.new(59,9996,19) end return end

-- 73. RETURN - Retorna o jogador à posição original
if comando == "return" then if r then r.CFrame = CFrame.new(0,100,0) end return end

-- 74. DASH - Dash rápido
if comando == "dash" then if r then local dir = r.CFrame.LookVector TweenService:Create(r, TweenInfo.new(0.2), {CFrame = CFrame.new(r.Position + dir * 50)}):Play() end return end

-- 75. DASHALL - Dash em todos
if comando == "dashall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr then local dir = pr.CFrame.LookVector TweenService:Create(pr, TweenInfo.new(0.2), {CFrame = CFrame.new(pr.Position + dir * 50)}):Play() end end end return end

-- 76. LAUNCH - Lança o jogador
if comando == "launch" then if r then local bv = Instance.new("BodyVelocity", r) bv.Velocity = Vector3.new(math.random(-200,200), 300, math.random(-200,200)) bv.MaxForce = Vector3.new(1e6,1e6,1e6) Debris:AddItem(bv,2) end return end

-- 77. LAUNCHALL - Lança todos
if comando == "launchall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr then local bv = Instance.new("BodyVelocity", pr) bv.Velocity = Vector3.new(math.random(-200,200), 300, math.random(-200,200)) bv.MaxForce = Vector3.new(1e6,1e6,1e6) Debris:AddItem(bv,2) end end end return end

-- 78. ROCKET - Foguete
if comando == "rocket" then if r then local bv = Instance.new("BodyVelocity", r) bv.Velocity = r.CFrame.LookVector * 200 bv.MaxForce = Vector3.new(1e6,1e6,1e6) Debris:AddItem(bv,2) local trail = Instance.new("Trail", r) trail.Lifetime = 0.2 trail.Color = ColorSequence.new(Color3.fromRGB(255,100,0)) Debris:AddItem(trail,2) end return end

-- 79. SPIN - Gira o jogador
if comando == "spin" then if r then for i = 1, 36 do r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(10), 0) task.wait(0.05) end end return end

-- 80. SPINALL - Gira todos os jogadores
if comando == "spinall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr then for i = 1, 36 do pr.CFrame = pr.CFrame * CFrame.Angles(0, math.rad(10), 0) task.wait(0.05) end end end end return end

-- 81. FLIP - Flip do jogador
if comando == "flip" then if r then for i = 1, 18 do r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(20), 0) task.wait(0.05) end end return end

-- 82. TILT - Inclina o jogador
if comando == "tilt" then if r then for i = 1, 10 do r.CFrame = r.CFrame * CFrame.Angles(math.rad(5), 0, 0) task.wait(0.05) end end return end

-- 83. ROLL - Rola o jogador
if comando == "roll" then if r then for i = 1, 10 do r.CFrame = r.CFrame * CFrame.Angles(0, 0, math.rad(5)) task.wait(0.05) end end return end

-- 84. ROTATE - Rotaciona o jogador
if comando == "rotate" then if r then for i = 1, 36 do r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(10), 0) task.wait(0.05) end end return end

-- 85. JUMPBOOST - Aumenta o pulo
if comando == "jumpboost" then if h then h.JumpHeight = 300 end return end

-- 86. SUPERJUMP - Pulo super alto
if comando == "superjump" then if h then h.JumpHeight = 500 end return end

-- 87. NOJUMP - Remove o pulo
if comando == "nojump" then if h then h.JumpHeight = 0 end return end

-- 88. WALLJUMP - Pulo na parede
if comando == "walljump" then if h then h.JumpHeight = 200 h.WalkSpeed = 50 end return end

-- 89. SPEEDBOOST - Aumenta a velocidade
if comando == "speedboost" then if h then h.WalkSpeed = 80 end return end

-- 90. MOONJUMP - Pulo da lua
if comando == "moonjump" then if h then h.JumpHeight = 200 h.WalkSpeed = 30 end return end

-- 91. LOWGRAVITY - Gravidade baixa
if comando == "lowgravity" then if h then h.JumpHeight = 20 end return end

-- 92. HIGHGRAVITY - Gravidade alta
if comando == "highgravity" then if h then h.JumpHeight = 5 h.WalkSpeed = 8 end return end

-- 93. ANTIGRAVITY - Antigravidade
if comando == "antigravity" then if r then local bv = Instance.new("BodyVelocity", r) bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge) bv.Velocity = Vector3.new(0,-5,0) Debris:AddItem(bv,3) end return end

-- 94. ZEROGRAVITY - Zero gravidade
if comando == "zerogravity" then if r then local bv = Instance.new("BodyVelocity", r) bv.MaxForce = Vector3.new(0,math.huge,0) bv.Velocity = Vector3.new(0,0,0) Debris:AddItem(bv,5) end return end

-- 95. FLOAT - Flutua o jogador
if comando == "float" then if r and h then local pos = r.Position h.WalkSpeed = 0 h.JumpHeight = 0 local bv = Instance.new("BodyVelocity", r) bv.MaxForce = Vector3.new(0,math.huge,0) bv.Velocity = Vector3.new(0,15,0) local maxY = pos.Y + 60 task.spawn(function() while pAlvo.Character and pAlvo.Character.Parent and r.Parent and h.Parent do if r.Position.Y >= maxY then if bv and bv.Parent then bv:Destroy() end h.Health = 0 break end task.wait(0.2) end if bv and bv.Parent then bv:Destroy() end end) end return end

-- 96. FLOATALL - Flutua todos
if comando == "floatall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) local h2 = GetHum(pl) if pr and h2 then local bv = Instance.new("BodyVelocity", pr) bv.MaxForce = Vector3.new(0,math.huge,0) bv.Velocity = Vector3.new(0,15,0) Debris:AddItem(bv,5) end end end return end

-- 97. FLOATNEARBY - Flutua jogadores próximos
if comando == "floatnearby" then local ar = GetRoot(LocalPlayer) if not ar then return end for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) local h2 = GetHum(pl) if pr and h2 and (pr.Position - ar.Position).Magnitude < 30 then h2.WalkSpeed = 0 h2.JumpHeight = 0 local bv = Instance.new("BodyVelocity", pr) bv.MaxForce = Vector3.new(0,math.huge,0) bv.Velocity = Vector3.new(0,5,0) Debris:AddItem(bv,5) end end end return end

-- 98. LEVITATE - Levita o jogador
if comando == "levitate" then if r then local bv = Instance.new("BodyVelocity", r) bv.MaxForce = Vector3.new(0,math.huge,0) bv.Velocity = Vector3.new(0,5,0) Debris:AddItem(bv,5) end return end

-- 99. FLOATUP - Flutua para cima
if comando == "floatup" then if r then TweenService:Create(r, TweenInfo.new(2), {CFrame = CFrame.new(r.Position + Vector3.new(0,50,0))}):Play() end return end

-- 100. FLOATDOWN - Flutua para baixo
if comando == "floatdown" then if r then TweenService:Create(r, TweenInfo.new(2), {CFrame = CFrame.new(r.Position - Vector3.new(0,50,0))}):Play() end return end

-- ============================================
-- 101-150: JAIL E PRISÃO
-- ============================================

-- 101. JAIL - Prende o jogador
if comando == "jail" then if r then local pos = r.Position for i = 1, 6 do local part = Instance.new("Part") part.Anchored = true part.CanCollide = true part.Material = Enum.Material.ForceField part.Transparency = 0.3 part.Color = Color3.fromRGB(255,0,0) part.Size = i % 2 == 0 and Vector3.new(1,10,10) or Vector3.new(10,10,1) part.CFrame = CFrame.new(pos + Vector3.new( (i % 2 == 0) and (i == 2 and 5 or -5) or 0, 0, (i % 2 == 1) and (i == 1 and 5 or -5) or 0 )) part.Parent = Workspace Debris:AddItem(part,10) end end return end

-- 102. UNJAIL - Solta o jogador
if comando == "unjail" then for _, part in pairs(Workspace:GetChildren()) do if part:IsA("Part") and part.Material == Enum.Material.ForceField then part:Destroy() end end return end

-- 103. JAILALL - Prende todos
if comando == "jailall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr then local pos = pr.Position for i = 1, 6 do local part = Instance.new("Part") part.Anchored = true part.CanCollide = true part.Material = Enum.Material.ForceField part.Transparency = 0.3 part.Color = Color3.fromRGB(255,0,0) part.Size = i % 2 == 0 and Vector3.new(1,10,10) or Vector3.new(10,10,1) part.CFrame = CFrame.new(pos + Vector3.new( (i % 2 == 0) and (i == 2 and 5 or -5) or 0, 0, (i % 2 == 1) and (i == 1 and 5 or -5) or 0 )) part.Parent = Workspace Debris:AddItem(part,10) end end end end return end

-- 104. UNJAILALL - Solta todos
if comando == "unjailall" then for _, part in pairs(Workspace:GetChildren()) do if part:IsA("Part") and part.Material == Enum.Material.ForceField then part:Destroy() end end return end

-- 105. INVISIBLEJAIL - Prende invisivelmente
if comando == "invisiblejail" then if r then local pos = r.Position local size = 8 local model = Instance.new("Model", Workspace) model.Name = "InvisJail_" .. (pAlvo and pAlvo.Name or "") local parts = {} parts.Base = Instance.new("Part", model) parts.Roof = Instance.new("Part", model) parts.W1 = Instance.new("Part", model) parts.W2 = Instance.new("Part", model) parts.W3 = Instance.new("Part", model) parts.W4 = Instance.new("Part", model) parts.Base.Size = Vector3.new(size,0.5,size) parts.Base.Position = pos - Vector3.new(0,3,0) parts.Base.Anchored = true parts.Base.CanCollide = true parts.Base.Transparency = 1 parts.Roof.Size = Vector3.new(size,0.5,size) parts.Roof.Position = parts.Base.Position + Vector3.new(0,size,0) parts.Roof.Anchored = true parts.Roof.CanCollide = true parts.Roof.Transparency = 1 local walls = { {size = Vector3.new(0.5,size,size), pos = parts.Base.Position + Vector3.new(size/2,size/2,0)}, {size = Vector3.new(0.5,size,size), pos = parts.Base.Position + Vector3.new(-size/2,size/2,0)}, {size = Vector3.new(size,size,0.5), pos = parts.Base.Position + Vector3.new(0,size/2,size/2)}, {size = Vector3.new(size,size,0.5), pos = parts.Base.Position + Vector3.new(0,size/2,-size/2)} } for i, w in pairs(walls) do local wall = parts["W" .. i] wall.Size = w.size wall.Position = w.pos wall.Anchored = true wall.CanCollide = true wall.Transparency = 1 end local center = parts.Base.Position + Vector3.new(0,size/2,0) r.CFrame = CFrame.new(center) task.spawn(function() while model and model.Parent do local cr = GetRoot(pAlvo) if cr and (cr.Position - center).Magnitude > (size/2) - 1 then cr.CFrame = CFrame.new(center) end task.wait(0.2) end end) end return end

-- 106. INVISIBLEUNJAIL - Solta da prisão invisível
if comando == "invisibleunjail" then for _, model in pairs(Workspace:GetChildren()) do if model:IsA("Model") and string.sub(model.Name, 1, 9) == "InvisJail_" then model:Destroy() end end return end

-- 107. CASTIGO - Manda para o castigo
if comando == "castigo" then if r then local pos = r.Position local jailPos = Vector3.new(1159,1727,421) local size = 12 local model = Instance.new("Model", Workspace) model.Name = "Castigo_" .. (pAlvo and pAlvo.Name or "") local parts = {} parts.Base = Instance.new("Part", model) parts.Roof = Instance.new("Part", model) parts.W1 = Instance.new("Part", model) parts.W2 = Instance.new("Part", model) parts.W3 = Instance.new("Part", model) parts.W4 = Instance.new("Part", model) parts.Base.Size = Vector3.new(size,0.5,size) parts.Base.Position = jailPos - Vector3.new(0,3,0) parts.Base.Anchored = true parts.Base.CanCollide = true parts.Roof.Size = Vector3.new(size,0.5,size) parts.Roof.Position = parts.Base.Position + Vector3.new(0,size,0) parts.Roof.Anchored = true parts.Roof.CanCollide = true local walls = { {size = Vector3.new(0.5,size,size), pos = parts.Base.Position + Vector3.new(size/2,size/2,0)}, {size = Vector3.new(0.5,size,size), pos = parts.Base.Position + Vector3.new(-size/2,size/2,0)}, {size = Vector3.new(size,size,0.5), pos = parts.Base.Position + Vector3.new(0,size/2,size/2)}, {size = Vector3.new(size,size,0.5), pos = parts.Base.Position + Vector3.new(0,size/2,-size/2)} } for i, w in pairs(walls) do local wall = parts["W" .. i] wall.Size = w.size wall.Position = w.pos wall.Anchored = true wall.CanCollide = true end for _, part in pairs(parts) do part.Material = Enum.Material.Plastic part.Color = Color3.fromRGB(255,255,255) for _, face in pairs({Enum.NormalId.Front, Enum.NormalId.Back, Enum.NormalId.Left, Enum.NormalId.Right, Enum.NormalId.Top, Enum.NormalId.Bottom}) do local decal = Instance.new("Decal", part) decal.Face = face decal.Texture = "rbxassetid://7409940017" decal.Transparency = 0.1 end end local center = parts.Base.Position + Vector3.new(0,size/2,0) r.CFrame = CFrame.new(center) task.spawn(function() while model and model.Parent do local cr = GetRoot(pAlvo) if cr and (cr.Position - center).Magnitude > (size/2) - 1 then cr.CFrame = CFrame.new(center) end task.wait(0.2) end end) end return end

-- 108. DESCASTIGO - Tira do castigo
if comando == "descastigo" then for _, model in pairs(Workspace:GetChildren()) do if model:IsA("Model") and string.sub(model.Name, 1, 8) == "Castigo_" then model:Destroy() end end return end

-- 109. SIT - Senta o jogador
if comando == "sit" then if h then h.Sit = true end return end

-- 110. UNSIT - Levanta o jogador
if comando == "unsit" then if h then h.Sit = false end return end

-- 111. SITALL - Senta todos
if comando == "sitall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local h2 = GetHum(pl) if h2 then h2.Sit = true end end end return end

-- 112. UNSITALL - Levanta todos
if comando == "unsitall" then for _, pl in pairs(Players:GetPlayers()) do local h2 = GetHum(pl) if h2 then h2.Sit = false end end return end

-- 113. SITLOCK - Trava sentado
if comando == "sitlock" then if h then h.Sit = true h.PlatformStand = true end return end

-- 114. UNSITLOCK - Destrava sentado
if comando == "unsitlock" then if h then h.PlatformStand = false h.Sit = false end return end

-- 115. SITFLY - Senta e voa
if comando == "sitfly" then if h then h.Sit = true end if r then local bv = Instance.new("BodyVelocity", r) bv.Velocity = Vector3.new(0,20,0) bv.MaxForce = Vector3.new(0,math.huge,0) Debris:AddItem(bv,5) end return end

-- 116. SITSPIN - Senta e gira
if comando == "sitspin" then if h then h.Sit = true end if r then for i = 1, 36 do r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(10), 0) task.wait(0.05) end end return end

-- 117. SITTILT - Senta e inclina
if comando == "sittilt" then if h then h.Sit = true end if r then for i = 1, 10 do r.CFrame = r.CFrame * CFrame.Angles(math.rad(5), 0, 0) task.wait(0.05) end end return end

-- 118. SITFALL - Senta e cai
if comando == "sitfall" then if h then h.Sit = true end if r then TweenService:Create(r, TweenInfo.new(0.3), {CFrame = CFrame.new(r.Position - Vector3.new(0,10,0))}):Play() end return end

-- ============================================
-- 119-170: FOGO E EXPLOSÕES
-- ============================================

-- 119. FIRE - Coloca fogo
if comando == "fire" then if r then local fire = Instance.new("Fire") fire.Parent = r fire.Size = 15 fire.Heat = 20 if h then h:TakeDamage(20) end Debris:AddItem(fire,3) end return end

-- 120. FIREALL - Fogo em todos
if comando == "fireall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr then local fire = Instance.new("Fire") fire.Parent = pr fire.Size = 15 fire.Heat = 20 Debris:AddItem(fire,3) end end end return end

-- 121. FIRENEARBY - Fogo em jogadores próximos
if comando == "firenearby" then local ar = GetRoot(LocalPlayer) if not ar then return end for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr and (pr.Position - ar.Position).Magnitude < 30 then local fire = Instance.new("Fire") fire.Parent = pr fire.Size = 15 fire.Heat = 20 Debris:AddItem(fire,3) end end end return end

-- 122. EXTINGUISH - Apaga fogo
if comando == "extinguish" then if r then for _, child in pairs(r:GetChildren()) do if child:IsA("Fire") then child:Destroy() end end end return end

-- 123. EXTINGUISHALL - Apaga fogo de todos
if comando == "extinguishall" then for _, pl in pairs(Players:GetPlayers()) do local pr = GetRoot(pl) if pr then for _, child in pairs(pr:GetChildren()) do if child:IsA("Fire") then child:Destroy() end end end end return end

-- 124. INFERNO - Fogo intenso
if comando == "inferno" then if r then for i = 1, 5 do local fire = Instance.new("Fire") fire.Parent = r fire.Size = 15 fire.Heat = 20 Debris:AddItem(fire,3) task.wait(0.2) end end return end

-- 125. BLUEFIRE - Fogo azul
if comando == "bluefire" then if r then local fire = Instance.new("Fire") fire.Parent = r fire.Color = Color3.fromRGB(0,100,255) fire.SecondaryColor = Color3.fromRGB(0,0,255) fire.Size = 20 fire.Heat = 30 Debris:AddItem(fire,4) end return end

-- 126. GREENFIRE - Fogo verde
if comando == "greenfire" then if r then local fire = Instance.new("Fire") fire.Parent = r fire.Color = Color3.fromRGB(0,255,0) fire.SecondaryColor = Color3.fromRGB(0,200,0) fire.Size = 20 fire.Heat = 30 Debris:AddItem(fire,4) end return end

-- 127. RAINFIRE - Chuva de fogo
if comando == "rainfire" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr then local fire = Instance.new("Fire") fire.Parent = pr fire.Size = 15 fire.Heat = 20 Debris:AddItem(fire,3) end task.wait(0.1) end end return end

-- 128. FIREWORK - Fogos de artifício
if comando == "firework" then if r then for i = 1, 10 do local fire = Instance.new("Fire") fire.Parent = r fire.Size = math.random(5,20) fire.Color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)) Debris:AddItem(fire,2) task.wait(0.1) end end return end

-- 129. EXPLODE - Explode o jogador
if comando == "explode" then if r then local e = Instance.new("Explosion") e.Position = r.Position e.BlastRadius = 15 e.BlastPressure = 500000 e.Parent = Workspace if h then h.Health = 0 end end return end

-- 130. EXPLODEALL - Explode todos
if comando == "explodeall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr then local e = Instance.new("Explosion") e.Position = pr.Position e.BlastRadius = 15 e.BlastPressure = 500000 e.Parent = Workspace end end end return end

-- 131. EXPLODENEARBY - Explode jogadores próximos
if comando == "explodenearby" then local ar = GetRoot(LocalPlayer) if not ar then return end for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr and (pr.Position - ar.Position).Magnitude < 30 then local e = Instance.new("Explosion") e.Position = pr.Position e.BlastRadius = 15 e.BlastPressure = 500000 e.Parent = Workspace end end end return end

-- 132. NUKE - Explosão nuclear
if comando == "nuke" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr then local e = Instance.new("Explosion") e.Position = pr.Position e.BlastRadius = 50 e.BlastPressure = 1000000 e.Parent = Workspace end end end return end

-- 133. MEGAEXPLODE - Mega explosão
if comando == "megaexplode" then if r then local e = Instance.new("Explosion") e.Position = r.Position e.BlastRadius = 100 e.BlastPressure = 5000000 e.Parent = Workspace if h then h.Health = 0 end end return end

-- 134. NUCLEAR - Explosão nuclear com efeitos
if comando == "nuclear" then if r then Lighting.Brightness = 10 Lighting.Ambient = Color3.fromRGB(255,200,100) task.delay(1, function() Lighting.Brightness = 0.3 Lighting.Ambient = Color3.fromRGB(0,0,0) end) local e = Instance.new("Explosion") e.Position = r.Position e.BlastRadius = 200 e.BlastPressure = 10000000 e.Parent = Workspace for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local h2 = GetHum(pl) if h2 then h2.Health = 0 end end end return end

-- 135. CLUSTERBOMB - Bomba cluster
if comando == "clusterbomb" then if r then for i = 1, 8 do local e = Instance.new("Explosion") e.Position = r.Position + Vector3.new(math.random(-30,30), math.random(0,10), math.random(-30,30)) e.BlastRadius = 10 e.BlastPressure = 100000 e.Parent = Workspace task.wait(0.1) end if h then h.Health = 0 end end return end

-- 136. LANDMINE - Mina terrestre
if comando == "landmine" then if r then local mine = Instance.new("Part") mine.Size = Vector3.new(1,0.5,1) mine.Position = r.Position mine.Anchored = true mine.CanCollide = true mine.Material = Enum.Material.Neon mine.Color = Color3.fromRGB(255,0,0) mine.Parent = Workspace mine.Touched:Connect(function(hit) if hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid") then local e = Instance.new("Explosion") e.Position = mine.Position e.BlastRadius = 20 e.BlastPressure = 500000 e.Parent = Workspace mine:Destroy() end end) Debris:AddItem(mine,10) end return end

-- 137. GRENADE - Granada
if comando == "grenade" then if r then local g = Instance.new("Part") g.Shape = Enum.PartType.Ball g.Size = Vector3.new(1,1,1) g.Position = r.Position + Vector3.new(0,3,0) g.Anchored = false g.CanCollide = true g.Material = Enum.Material.Neon g.Color = Color3.fromRGB(0,255,0) g.Parent = Workspace local bv = Instance.new("BodyVelocity", g) bv.Velocity = Vector3.new(math.random(-50,50), 30, math.random(-50,50)) bv.MaxForce = Vector3.new(1e5,1e5,1e5) task.delay(2, function() local e = Instance.new("Explosion") e.Position = g.Position e.BlastRadius = 25 e.BlastPressure = 500000 e.Parent = Workspace g:Destroy() end) end return end

-- 138. C4 - C4 explosivo
if comando == "c4" then if r then for i = 1, 3 do local e = Instance.new("Explosion") e.Position = r.Position e.BlastRadius = 5 e.Parent = Workspace task.wait(1) end if h then h.Health = 0 end end return end

-- 139. CHAINEXPLODE - Explosão em cadeia
if comando == "chainexplode" then if r then for i = 1, 5 do local e = Instance.new("Explosion") e.Position = r.Position + Vector3.new(math.random(-20,20), math.random(-5,5), math.random(-20,20)) e.BlastRadius = 10 e.BlastPressure = 100000 e.Parent = Workspace task.wait(0.2) end if h then h.Health = 0 end end return end

-- 140. LAG - Causa lag
if comando == "lag" then if r then for i = 1, 30 do task.spawn(function() local e = Instance.new("Explosion") e.Position = r.Position + Vector3.new(math.random(-10,10), math.random(0,5), math.random(-10,10)) e.BlastRadius = 20 e.BlastPressure = 1000000 e.Parent = Workspace end) end end return end

-- 141. LAGALL - Lag em todos
if comando == "lagall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then for i = 1, 20 do task.spawn(function() local pr = GetRoot(pl) if pr then local e = Instance.new("Explosion") e.Position = pr.Position + Vector3.new(math.random(-10,10), math.random(0,5), math.random(-10,10)) e.BlastRadius = 20 e.BlastPressure = 1000000 e.Parent = Workspace end end) end end end return end

-- 142. LAGNEARBY - Lag em jogadores próximos
if comando == "lagnearby" then local ar = GetRoot(LocalPlayer) if not ar then return end for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr and (pr.Position - ar.Position).Magnitude < 50 then for i = 1, 20 do task.spawn(function() local e = Instance.new("Explosion") e.Position = pr.Position + Vector3.new(math.random(-10,10), math.random(0,5), math.random(-10,10)) e.BlastRadius = 20 e.BlastPressure = 1000000 e.Parent = Workspace end) end end end end return end

-- 143. LAGFAR - Lag em jogadores distantes
if comando == "lagfar" then local ar = GetRoot(LocalPlayer) if not ar then return end for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr and (pr.Position - ar.Position).Magnitude > 100 then for i = 1, 20 do task.spawn(function() local e = Instance.new("Explosion") e.Position = pr.Position + Vector3.new(math.random(-10,10), math.random(0,5), math.random(-10,10)) e.BlastRadius = 20 e.BlastPressure = 1000000 e.Parent = Workspace end) end end end end return end

-- 144. MEGLAG - Lag intenso
if comando == "meglag" then if r then for i = 1, 100 do task.spawn(function() local e = Instance.new("Explosion") e.Position = r.Position + Vector3.new(math.random(-20,20), math.random(0,10), math.random(-20,20)) e.BlastRadius = 30 e.BlastPressure = 5000000 e.Parent = Workspace end) end end return end

-- 145. LAGSPAM - Spam de lag
if comando == "lagspam" then if r then for i = 1, 50 do local e = Instance.new("Explosion") e.Position = r.Position + Vector3.new(math.random(-10,10), math.random(0,5), math.random(-10,10)) e.BlastRadius = 20 e.BlastPressure = 1000000 e.Parent = Workspace task.wait(0.05) end end return end

-- 146. LAGCRASH - Lag crash
if comando == "lagcrash" then if r then for i = 1, 50 do task.spawn(function() pcall(function() local e = Instance.new("Explosion") e.Position = r.Position e.BlastRadius = 1 e.BlastPressure = 1 e.Parent = Workspace for j = 1, 10 do local part = Instance.new("Part") part.Size = Vector3.new(5,5,5) part.Position = r.Position + Vector3.new(math.random(-10,10), math.random(0,5), math.random(-10,10)) part.Anchored = false part.CanCollide = true part.Material = Enum.Material.Neon part.Parent = Workspace Debris:AddItem(part,2) end end) end) end end return end

-- 147. SPAMPARTS - Spam de partes
if comando == "spamparts" then if r then for i = 1, 50 do local part = Instance.new("Part") part.Size = Vector3.new(1,1,1) part.Position = r.Position + Vector3.new(math.random(-20,20), math.random(0,10), math.random(-20,20)) part.Anchored = false part.CanCollide = true part.Material = Enum.Material.Neon part.Color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)) part.Parent = Workspace local bv = Instance.new("BodyVelocity", part) bv.Velocity = Vector3.new(math.random(-100,100), math.random(50,200), math.random(-100,100)) bv.MaxForce = Vector3.new(1e6,1e6,1e6) Debris:AddItem(part,5) end end return end

-- 148. SPAMEXPLOSIONS - Spam de explosões
if comando == "spamexplosions" then if r then for i = 1, 20 do task.spawn(function() local e = Instance.new("Explosion") e.Position = r.Position + Vector3.new(math.random(-15,15), math.random(-5,5), math.random(-15,15)) e.BlastRadius = 5 e.Parent = Workspace end) task.wait(0.05) end end return end

-- 149. FREEZELAG - Congela e lag
if comando == "freezelag" then if h then h.WalkSpeed = 0 h.JumpHeight = 0 end if r then for i = 1, 30 do task.spawn(function() local e = Instance.new("Explosion") e.Position = r.Position + Vector3.new(math.random(-10,10), math.random(0,5), math.random(-10,10)) e.BlastRadius = 20 e.BlastPressure = 1000000 e.Parent = Workspace end) end end task.delay(3, function() if h then h.WalkSpeed = 16 h.JumpHeight = 50 end end) return end

-- 150. LIGHTSHOW - Show de luzes
if comando == "lightshow" then if r then for i = 1, 30 do local light = Instance.new("PointLight", r) light.Color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)) light.Brightness = 10 light.Range = 30 Debris:AddItem(light,0.2) task.wait(0.1) end end return end

-- ============================================
-- 151-200: MORPHS E APARÊNCIA
-- ============================================

-- 151. GONER - Morph Goner
if comando == "goner" then pcall(function() ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer(unpack({{116253341067642,110703630520331,119263803737569,99234191703566,99948897896884,0}})) end) return end

-- 152. RESETMORPH - Reset morph
if comando == "resetmorph" then pcall(function() ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ResetCharacterAppearance"):FireServer() end) return end

-- 153. RESPAWN - Respawn
if comando == "respawn" then if h then h.Health = 0 end task.delay(1, function() if pAlvo and pAlvo.Character then local h2 = GetHum(pAlvo) if h2 then h2.Health = 100 end end end) return end

-- 154. RESPAWNALL - Respawn todos
if comando == "respawnall" then for _, pl in pairs(Players:GetPlayers()) do local h2 = GetHum(pl) if h2 then h2.Health = 0 end task.delay(1, function() if pl and pl.Character then local h3 = GetHum(pl) if h3 then h3.Health = 100 end end end) end return end

-- 155. GIANT - Fica gigante
if comando == "giant" then if r then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then part.Size = part.Size * 2 end end r.Size = Vector3.new(4,4,4) end return end

-- 156. SMALL - Fica pequeno
if comando == "small" then if r then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then part.Size = part.Size * 0.5 end end r.Size = Vector3.new(0.5,0.5,0.5) end return end

-- 157. TINY - Fica minúsculo
if comando == "tiny" then if r then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then part.Size = part.Size * 0.2 end end r.Size = Vector3.new(0.2,0.2,0.2) end return end

-- 158. INVISIBLE - Fica invisível
if comando == "invisible" then if pAlvo then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then part.Transparency = 1 end end end return end

-- 159. VISIBLE - Fica visível
if comando == "visible" then if pAlvo then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then part.Transparency = 0 end end end return end

-- 160. GLOW - Brilha
if comando == "glow" then if r then local glow = Instance.new("PointLight", r) glow.Color = Color3.fromRGB(0,255,255) glow.Brightness = 20 glow.Range = 50 Debris:AddItem(glow,5) end return end

-- 161. DARK - Escurece
if comando == "dark" then if r then local glow = Instance.new("PointLight", r) glow.Color = Color3.fromRGB(0,0,0) glow.Brightness = -10 glow.Range = 30 Debris:AddItem(glow,3) end return end

-- 162. RAINBOW - Arco-íris
if comando == "rainbow" then if r then for i = 1, 30 do local glow = Instance.new("PointLight", r) glow.Color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)) glow.Brightness = 10 glow.Range = 30 Debris:AddItem(glow,0.3) task.wait(0.1) end end return end

-- 163. DISCO - Disco
if comando == "disco" then if r then for i = 1, 50 do local glow = Instance.new("PointLight", r) glow.Color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)) glow.Brightness = 20 glow.Range = 40 Debris:AddItem(glow,0.2) for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then local pr = GetRoot(pl) if pr then local g2 = Instance.new("PointLight", pr) g2.Color = glow.Color g2.Brightness = 10 g2.Range = 30 Debris:AddItem(g2,0.2) end end end task.wait(0.05) end end return end

-- 164. NEON - Neon
if comando == "neon" then if pAlvo then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then part.Material = Enum.Material.Neon part.Color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)) end end end return end

-- 165. METAL - Metal
if comando == "metal" then if pAlvo then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then part.Material = Enum.Material.Metal end end end return end

-- 166. PLASTIC - Plástico
if comando == "plastic" then if pAlvo then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then part.Material = Enum.Material.Plastic end end end return end

-- 167. GLASS - Vidro
if comando == "glass" then if pAlvo then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then part.Material = Enum.Material.Glass end end end return end

-- 168. WOOD - Madeira
if comando == "wood" then if pAlvo then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then part.Material = Enum.Material.Wood end end end return end

-- 169. BRICK - Tijolo
if comando == "brick" then if pAlvo then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then part.Material = Enum.Material.Brick end end end return end

-- 170. FORCEFIELD - Campo de força
if comando == "forcefield" then if pAlvo then for _, part in pairs(pAlvo.Character:GetChildren()) do if part:IsA("BasePart") then part.Material = Enum.Material.ForceField end end end return end

-- ============================================
-- 171-220: EFEITOS VISUAIS
-- ============================================

-- 171. PARTICLE - Partículas
if comando == "particle" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/sparkles_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(0,255,255)) pe.Size = NumberSequence.new(1) pe.Rate = 50 pe.Lifetime = NumberRange.new(1) pe.Speed = NumberRange.new(10) Debris:AddItem(pe,5) end return end

-- 172. SMOKE - Fumaça
if comando == "smoke" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/smoke_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(100,100,100)) pe.Size = NumberSequence.new(5) pe.Rate = 30 pe.Lifetime = NumberRange.new(3) pe.Speed = NumberRange.new(5) Debris:AddItem(pe,5) end return end

-- 173. FIREWORKSPART - Fogos de artifício em partículas
if comando == "fireworkspart" then if r then for i = 1, 10 do local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/sparkles_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))) pe.Size = NumberSequence.new(2) pe.Rate = 100 pe.Lifetime = NumberRange.new(0.5) pe.Speed = NumberRange.new(20) Debris:AddItem(pe,0.5) task.wait(0.1) end end return end

-- 174. SPARK - Faíscas
if comando == "spark" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/sparkles_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(255,200,100)) pe.Size = NumberSequence.new(0.5) pe.Rate = 80 pe.Lifetime = NumberRange.new(0.5) pe.Speed = NumberRange.new(15) Debris:AddItem(pe,3) end return end

-- 175. STARS - Estrelas
if comando == "stars" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/star_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(255,255,255)) pe.Size = NumberSequence.new(1) pe.Rate = 40 pe.Lifetime = NumberRange.new(2) pe.Speed = NumberRange.new(5) Debris:AddItem(pe,5) end return end

-- 176. EXPLOSIONFX - Efeito de explosão
if comando == "explosionfx" then if r then local e = Instance.new("Explosion") e.Position = r.Position e.BlastRadius = 20 e.BlastPressure = 0 e.Parent = Workspace for i = 1, 20 do local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/sparkles_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(math.random(200,255), math.random(0,100), math.random(0,50))) pe.Size = NumberSequence.new(3) pe.Rate = 200 pe.Lifetime = NumberRange.new(0.5) pe.Speed = NumberRange.new(30) Debris:AddItem(pe,0.3) end end return end

-- 177. SPARKLE - Brilho
if comando == "sparkle" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/sparkles_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(0,255,200)) pe.Size = NumberSequence.new(0.5) pe.Rate = 60 pe.Lifetime = NumberRange.new(0.5) pe.Speed = NumberRange.new(8) Debris:AddItem(pe,4) end return end

-- 178. RAIN - Chuva
if comando == "rain" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/rain_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(100,150,255)) pe.Size = NumberSequence.new(0.3) pe.Rate = 200 pe.Lifetime = NumberRange.new(1) pe.Speed = NumberRange.new(20) Debris:AddItem(pe,5) end return end

-- 179. SNOW - Neve
if comando == "snow" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/snow_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(255,255,255)) pe.Size = NumberSequence.new(0.5) pe.Rate = 100 pe.Lifetime = NumberRange.new(2) pe.Speed = NumberRange.new(3) Debris:AddItem(pe,5) end return end

-- 180. WATER - Água
if comando == "water" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/water_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(0,100,255)) pe.Size = NumberSequence.new(0.5) pe.Rate = 80 pe.Lifetime = NumberRange.new(1) pe.Speed = NumberRange.new(5) Debris:AddItem(pe,5) end return end

-- 181. FIREPART - Partículas de fogo
if comando == "firepart" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/fire_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(255,100,0)) pe.Size = NumberSequence.new(2) pe.Rate = 100 pe.Lifetime = NumberRange.new(1) pe.Speed = NumberRange.new(10) Debris:AddItem(pe,3) end return end

-- 182. SHADOW - Sombra
if comando == "shadow" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/shadow_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(0,0,0)) pe.Size = NumberSequence.new(3) pe.Rate = 40 pe.Lifetime = NumberRange.new(2) pe.Speed = NumberRange.new(2) Debris:AddItem(pe,5) end return end

-- 183. LIGHT - Luz
if comando == "light" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/light_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(255,255,255)) pe.Size = NumberSequence.new(1) pe.Rate = 60 pe.Lifetime = NumberRange.new(1) pe.Speed = NumberRange.new(5) Debris:AddItem(pe,5) end return end

-- 184. DARKPART - Partículas escuras
if comando == "darkpart" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/dark_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(50,0,100)) pe.Size = NumberSequence.new(2) pe.Rate = 50 pe.Lifetime = NumberRange.new(2) pe.Speed = NumberRange.new(3) Debris:AddItem(pe,5) end return end

-- 185. MAGIC - Mágica
if comando == "magic" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/sparkles_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(255,0,255)) pe.Size = NumberSequence.new(1) pe.Rate = 80 pe.Lifetime = NumberRange.new(1) pe.Speed = NumberRange.new(10) Debris:AddItem(pe,5) end return end

-- 186. HEART - Corações
if comando == "heart" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/heart_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(255,0,100)) pe.Size = NumberSequence.new(1) pe.Rate = 40 pe.Lifetime = NumberRange.new(2) pe.Speed = NumberRange.new(5) Debris:AddItem(pe,5) end return end

-- 187. COIN - Moedas
if comando == "coin" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/coin_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(255,200,50)) pe.Size = NumberSequence.new(0.5) pe.Rate = 30 pe.Lifetime = NumberRange.new(2) pe.Speed = NumberRange.new(3) Debris:AddItem(pe,5) end return end

-- 188. GEM - Gemas
if comando == "gem" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/gem_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(0,255,200)) pe.Size = NumberSequence.new(0.5) pe.Rate = 30 pe.Lifetime = NumberRange.new(2) pe.Speed = NumberRange.new(3) Debris:AddItem(pe,5) end return end

-- 189. STAR - Estrela
if comando == "star" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/star_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(255,255,100)) pe.Size = NumberSequence.new(0.5) pe.Rate = 40 pe.Lifetime = NumberRange.new(2) pe.Speed = NumberRange.new(3) Debris:AddItem(pe,5) end return end

-- 190. FLOWER - Flores
if comando == "flower" then if r then local pe = Instance.new("ParticleEmitter", r) pe.Texture = "rbxasset://textures/particles/flower_main.dds" pe.Color = ColorSequence.new(Color3.fromRGB(255,100,200)) pe.Size = NumberSequence.new(0.5) pe.Rate = 30 pe.Lifetime = NumberRange.new(2) pe.Speed = NumberRange.new(3) Debris:AddItem(pe,5) end return end

-- ============================================
-- 191-220: SOM E ÁUDIO
-- ============================================

-- 191. SOUND - Toca som
if comando == "sound" then local s = Instance.new("Sound") s.SoundId = "rbxassetid://9120389265" s.Volume = 1 s.Parent = Workspace s:Play() Debris:AddItem(s,3) return end

-- 192. SCARY - Som assustador
if comando == "scary" then local s = Instance.new("Sound") s.SoundId = "rbxassetid://138873214826309" s.Volume = 2 s.Parent = Workspace s:Play() Debris:AddItem(s,3) return end

-- 193. LAUGH - Risada
if comando == "laugh" then local s = Instance.new("Sound") s.SoundId = "rbxassetid://143942090" s.Volume = 1 s.Parent = Workspace s:Play() Debris:AddItem(s,3) return end

-- 194. BELL - Sino
if comando == "bell" then local s = Instance.new("Sound") s.SoundId = "rbxassetid://9120389265" s.Volume = 0.5 s.Pitch = 2 s.Parent = Workspace s:Play() Debris:AddItem(s,2) return end

-- 195. BASS - Grave
if comando == "bass" then local s = Instance.new("Sound") s.SoundId = "rbxassetid://9120389265" s.Volume = 2 s.Pitch = 0.5 s.Parent = Workspace s:Play() Debris:AddItem(s,3) return end

-- 196. ECHO - Eco
if comando == "echo" then local s = Instance.new("Sound") s.SoundId = "rbxassetid://9120389265" s.Volume = 1 s.Pitch = 1 s.Parent = Workspace s:Play() local s2 = s:Clone() s2.Pitch = 0.8 s2.Parent = Workspace s2:Play() local s3 = s:Clone() s3.Pitch = 1.2 s3.Parent = Workspace s3:Play() Debris:AddItem(s,3) Debris:AddItem(s2,3) Debris:AddItem(s3,3) return end

-- 197. ALARM - Alarme
if comando == "alarm" then local s = Instance.new("Sound") s.SoundId = "rbxassetid://9120389265" s.Volume = 2 s.Looped = true s.Parent = Workspace s:Play() task.delay(5, function() s:Stop() s:Destroy() end) return end

-- 198. MUSIC - Música
if comando == "music" then local s = Instance.new("Sound") s.SoundId = "rbxassetid://9120389265" s.Volume = 0.5 s.Looped = true s.Parent = Workspace s:Play() task.delay(10, function() s:Stop() s:Destroy() end) return end

-- 199. SIREN - Sirene
if comando == "siren" then local s = Instance.new("Sound") s.SoundId = "rbxassetid://9120389265" s.Volume = 1 s.Pitch = 1.5 s.Parent = Workspace s:Play() task.delay(0.5, function() local s2 = s:Clone() s2.Pitch = 0.8 s2.Parent = Workspace s2:Play() end) Debris:AddItem(s,2) return end

-- 200. EXPLOSIONSOUND - Som de explosão
if comando == "explosionsound" then local s = Instance.new("Sound") s.SoundId = "rbxassetid://9120389265" s.Volume = 3 s.Parent = Workspace s:Play() Debris:AddItem(s,2) if r then local e = Instance.new("Explosion") e.Position = r.Position e.BlastRadius = 1 e.BlastPressure = 1 e.Parent = Workspace end return end

-- ============================================
-- 201-250: FLOPPA E JUMPSCARE
-- ============================================

-- 201. FLOPPARAIN - Chuva de Floppas
local FloppaRunning = false
if comando == "flopparain" then
    FloppaRunning = true
    local sky = Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://123446364161879"
    sky.SkyboxDn = "rbxassetid://123446364161879"
    sky.SkyboxFt = "rbxassetid://123446364161879"
    sky.SkyboxLf = "rbxassetid://123446364161879"
    sky.SkyboxRt = "rbxassetid://123446364161879"
    sky.SkyboxUp = "rbxassetid://123446364161879"
    sky.Parent = Lighting
    local template = Instance.new("Part")
    template.Size = Vector3.new(2,2,2)
    template.Anchored = false
    template.CanCollide = true
    local textureId = "rbxassetid://123446364161879"
    local function applyTexture(part)
        for _, face in pairs({"Front","Back","Left","Right","Top","Bottom"}) do
            local decal = Instance.new("Decal")
            decal.Texture = textureId
            decal.Face = Enum.NormalId[face]
            decal.Parent = part
        end
    end
    local count = 0
    task.spawn(function()
        while FloppaRunning do
            if count < 80 then
                for i = 1, 5 do
                    local floppa = template:Clone()
                    floppa.Position = Vector3.new(math.random(-250,250), 100, math.random(-250,250))
                    applyTexture(floppa)
                    floppa.Touched:Connect(function(hit)
                        local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
                        if hum then hum:TakeDamage(10) end
                    end)
                    floppa.Parent = Workspace
                    Debris:AddItem(floppa,8)
                    count = count + 1
                end
            end
            task.wait(0.5)
        end
    end)
    return
end

-- 202. STOPFLOPPA - Para a chuva de Floppas
if comando == "stopfloppa" then
    FloppaRunning = false
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Size == Vector3.new(2,2,2) then
            local hasTexture = false
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("Decal") then hasTexture = true break end
            end
            if hasTexture then pcall(function() obj:Destroy() end) end
        end
    end
    local flopSky = Lighting:FindFirstChildOfClass("Sky")
    if flopSky then flopSky:Destroy() end
    return
end

-- 203. JUMPSCARE - Jumpscare
if comando == "jumpscare" then
    local sg = Instance.new("ScreenGui")
    sg.Name = "Jumpscare"
    sg.DisplayOrder = 999999
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    sg.Parent = CoreGui
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundColor3 = Color3.new(0,0,0)
    frame.BorderSizePixel = 0
    local img = Instance.new("ImageLabel", frame)
    img.Size = UDim2.new(1,0,1,0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://126754882337711"
    img.ScaleType = Enum.ScaleType.Fit
    local sound = Instance.new("Sound", frame)
    sound.SoundId = "rbxassetid://138873214826309"
    sound.Volume = 2
    sound:Play()
    task.delay(3, function() sg:Destroy() end)
    return
end

-- 204. JUMPSCARE2 - Jumpscare 2
if comando == "jumpscare2" then
    local sg = Instance.new("ScreenGui")
    sg.Name = "Jumpscare2"
    sg.DisplayOrder = 999999
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    sg.Parent = CoreGui
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundColor3 = Color3.new(0,0,0)
    frame.BorderSizePixel = 0
    local img = Instance.new("ImageLabel", frame)
    img.Size = UDim2.new(1,0,1,0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://86379969987314"
    img.ScaleType = Enum.ScaleType.Fit
    local sound = Instance.new("Sound", frame)
    sound.SoundId = "rbxassetid://143942090"
    sound.Volume = 2
    sound:Play()
    task.delay(3, function() sg:Destroy() end)
    return
end

-- 205. JUMPSCARE3 - Jumpscare 3
if comando == "jumpscare3" then
    local sg = Instance.new("ScreenGui")
    sg.Name = "Jumpscare3"
    sg.DisplayOrder = 999999
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    sg.Parent = CoreGui
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundColor3 = Color3.new(0,0,0)
    frame.BorderSizePixel = 0
    local img = Instance.new("ImageLabel", frame)
    img.Size = UDim2.new(1,0,1,0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://127382022168206"
    img.ScaleType = Enum.ScaleType.Fit
    local sound = Instance.new("Sound", frame)
    sound.SoundId = "rbxassetid://143942090"
    sound.Volume = 2
    sound:Play()
    task.delay(3, function() sg:Destroy() end)
    return
end

-- 206. JUMPSCARE4 - Jumpscare 4
if comando == "jumpscare4" then
    local sg = Instance.new("ScreenGui")
    sg.Name = "Jumpscare4"
    sg.DisplayOrder = 999999
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    sg.Parent = CoreGui
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundColor3 = Color3.new(0,0,0)
    frame.BorderSizePixel = 0
    local img = Instance.new("ImageLabel", frame)
    img.Size = UDim2.new(1,0,1,0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://95973611964555"
    img.ScaleType = Enum.ScaleType.Fit
    local sound = Instance.new("Sound", frame)
    sound.SoundId = "rbxassetid://138873214826309"
    sound.Volume = 2
    sound:Play()
    task.delay(3, function() sg:Destroy() end)
    return
end

-- 207. STOPJUMPSCARE - Para todos os jumpscares
if comando == "stopjumpscare" then
    pcall(function()
        local gui = CoreGui:FindFirstChild("Jumpscare")
        if gui then gui:Destroy() end
        local gui2 = CoreGui:FindFirstChild("Jumpscare2")
        if gui2 then gui2:Destroy() end
        local gui3 = CoreGui:FindFirstChild("Jumpscare3")
        if gui3 then gui3:Destroy() end
        local gui4 = CoreGui:FindFirstChild("Jumpscare4")
        if gui4 then gui4:Destroy() end
    end)
    return
end

-- ============================================
-- 251-300: ADMIN E UTILITÁRIOS
-- ============================================

-- 251. BAN - Bane o jogador
if comando == "ban" then if pAlvo then pAlvo:Kick("🚫 Banido pelo JV HUB ADMIN") end return end

-- 252. KICK - Expulsa o jogador
if comando == "kick" then if pAlvo then pAlvo:Kick("👢 Expulso pelo JV HUB ADMIN") end return end

-- 253. BANALL - Bane todos
if comando == "banall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then pl:Kick("🚫 Banido pelo JV HUB ADMIN") end end return end

-- 254. KICKALL - Expulsa todos
if comando == "kickall" then for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then pl:Kick("👢 Expulso pelo JV HUB ADMIN") end end return end

-- 255. INFO - Informações do hub
if comando == "info" then
    print("🐧 JV HUB ADM")
    print("📌 by jotinha12hr2")
    print("📡 300 COMANDOS ÚNICOS")
    print("👤 Jogadores: " .. #Players:GetPlayers())
    print("📻 Canal: " .. ANTENA.Canal)
    return
end

-- 256. HELP - Lista de comandos
if comando == "help" then
    print("🐧 JV HUB ADM - 300 COMANDOS")
    print("📌 by jotinha12hr2")
    print("")
    print("📡 COMANDOS DE ATAQUE:")
    print("  kill, killall, killme, killnearby, killfar, killrandom")
    print("  headshot, explodekill, silentkill, instantkill, slowkill")
    print("  freezekill, crush, guillotine, thanos, suffocate")
    print("  bleed, poison, burn, electrocute")
    print("")
    print("❄️ COMANDOS DE CONGELAR:")
    print("  freeze, unfreeze, freezeall, unfreezeall")
    print("  slowmotion, superspeed, normalspeed, reversespeed")
    print("  stun, stunall, iceblock, timefreeze")
    print("")
    print("🌀 COMANDOS DE ARREMESSAR:")
    print("  fling, flingall, flingup, flingdown, flingside")
    print("  flingrandom, flingtosky, flingtovoid, flingtospawn")
    print("  flingtobeach, flingtomountain, flingtounderwater")
    print("  flingtostore, flingtopark, flingtome")
    print("")
    print("🚀 COMANDOS DE TELEPORTE:")
    print("  bring, bringall, bringnearby, bringfar, bringme")
    print("  bringtome, bringtospawn, bringtosky, bringtovoid")
    print("  bringtobeach, bringtomountain, bringtounderwater")
    print("  bringtostore, bringtopark, bringtohome, bringtorandom")
    print("  tpspawn, tpsky, tpvoid, tprandom, tptroll, tpme")
    print("")
    print("🏚️ BACKROOMS:")
    print("  backrooms, backroomsall, backroomsme")
    print("")
    print("⛓️ PRISÃO:")
    print("  jail, unjail, jailall, unjailall")
    print("  invisiblejail, invisibleunjail")
    print("  castigo, descastigo")
    print("")
    print("🪑 SENTAR:")
    print("  sit, unsit, sitall, unsitall, sitlock, unsitlock")
    print("  sitfly, sitspin, sittilt, sitfall")
    print("")
    print("🔥 FOGO E EXPLOSÕES:")
    print("  fire, fireall, firenearby")
    print("  extinguish, extinguishall, inferno")
    print("  bluefire, greenfire, rainfire, firework")
    print("  explode, explodeall, explodenearby")
    print("  nuke, megaexplode, nuclear")
    print("  clusterbomb, landmine, grenade, c4, chainexplode")
    print("")
    print("📡 LAG:")
    print("  lag, lagall, lagnearby, lagfar, meglag")
    print("  lagspam, lagcrash, spamparts, spamexplosions")
    print("  freezelag, lightshow")
    print("")
    print("🎭 MORPHS:")
    print("  goner, resetmorph, respawn, respawnall")
    print("  giant, small, tiny, invisible, visible")
    print("")
    print("✨ EFEITOS VISUAIS:")
    print("  glow, dark, rainbow, disco")
    print("  neon, metal, plastic, glass, wood, brick, forcefield")
    print("  particle, smoke, fireworkspart, spark, stars")
    print("  explosionfx, sparkle, rain, snow, water")
    print("  firepart, shadow, light, darkpart, magic")
    print("  heart, coin, gem, star, flower")
    print("")
    print("🔊 SOM:")
    print("  sound, scary, laugh, bell, bass, echo")
    print("  alarm, music, siren, explosionsound")
    print("")
    print("🐱 FLOPPA:")
    print("  flopparain, stopfloppa")
    print("")
    print("👻 JUMPSCARE:")
    print("  jumpscare, jumpscare2, jumpscare3, jumpscare4")
    print("  stopjumpscare")
    print("")
    print("⚡ MOVIMENTO:")
    print("  dash, dashall, launch, launchall, rocket")
    print("  spin, spinall, flip, tilt, roll, rotate")
    print("  jumpboost, superjump, nojump, walljump")
    print("  speedboost, moonjump, lowgravity, highgravity")
    print("  antigravity, zerogravity")
    print("  float, floatall, floatnearby, levitate")
    print("  floatup, floatdown")
    print("")
    print("🛡️ ADMIN:")
    print("  ban, kick, banall, kickall")
    print("  info, help")
    return
end

-- 257. CLEAR - Limpa o Workspace
if comando == "clear" then
    for _, part in pairs(Workspace:GetChildren()) do
        if part:IsA("Part") and not part:IsA("HumanoidRootPart") and not part.Name:find("Spawn") then
            part:Destroy()
        end
    end
    return
end

-- 258. REJOIN - Reconecta
if comando == "rejoin" then
    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end)
    return
end

-- 259. RESET - Reseta o jogo
if comando == "reset" then
    game:GetService("TeleportService"):Teleport(game.PlaceId)
    return
end

-- 260. GETPLAYERS - Lista jogadores
if comando == "getplayers" then
    print("👤 Jogadores conectados:")
    for _, pl in pairs(Players:GetPlayers()) do
        print("  - " .. pl.Name)
    end
    return
end

-- 261. GETME - Mostra seu nome
if comando == "getme" then
    print("👤 Você é: " .. LocalPlayer.Name)
    return
end

-- 262. TIME - Mostra o tempo
if comando == "time" then
    print("🕐 " .. os.date("%H:%M:%S"))
    return
end

-- 263. DATE - Mostra a data
if comando == "date" then
    print("📅 " .. os.date("%d/%m/%Y"))
    return
end

-- 264. RANDOM - Número aleatório
if comando == "random" then
    print("🎲 " .. math.random(1, 100))
    return
end

-- 265. SAY - Fala no chat
if comando == "say" then
    if valor and valor ~= "" then
        pcall(function()
            local channel = TextChatService.TextChannels:FindFirstChild(ANTENA.Canal)
            if channel then channel:SendAsync(valor) end
        end)
    end
    return
end

-- 266. MESSAGE - Mensagem personalizada
if comando == "message" then
    if valor and valor ~= "" then
        pcall(function()
            local channel = TextChatService.TextChannels:FindFirstChild(ANTENA.Canal)
            if channel then channel:SendAsync("📢 " .. valor) end
        end)
    end
    return
end

-- 267. ALERT - Alerta
if comando == "alert" then
    if valor and valor ~= "" then
        pcall(function()
            local channel = TextChatService.TextChannels:FindFirstChild(ANTENA.Canal)
            if channel then channel:SendAsync("⚠️ ALERTA: " .. valor) end
        end)
    end
    return
end

-- 268. ANNOUNCE - Anúncio
if comando == "announce" then
    if valor and valor ~= "" then
        pcall(function()
            local channel = TextChatService.TextChannels:FindFirstChild(ANTENA.Canal)
            if channel then channel:SendAsync("📢 ANÚNCIO: " .. valor) end
        end)
    end
    return
end

-- 269. SERVER - Informações do servidor
if comando == "server" then
    print("🌐 Informações do servidor:")
    print("  Jogadores: " .. #Players:GetPlayers())
    print("  Lugar: " .. game.PlaceId)
    print("  Jogo: " .. game.Name)
    return
end

-- 270. PING - Ping
if comando == "ping" then
    print("🏓 Pong!")
    return
end

-- 271. ECHO - Eco
if comando == "echo" then
    if valor and valor ~= "" then
        print("🔊 " .. valor)
    end
    return
end

-- 272. WHO - Quem é o jogador
if comando == "who" then
    if pAlvo then
        print("👤 " .. pAlvo.Name)
        print("  ID: " .. pAlvo.UserId)
        print("  Está no jogo: Sim")
    else
        print("❌ Jogador não encontrado: " .. valor)
    end
    return
end

-- 273. COUNT - Contagem de jogadores
if comando == "count" then
    print("👤 Jogadores: " .. #Players:GetPlayers())
    return
end

-- 274. ONLINE - Jogadores online
if comando == "online" then
    local online = {}
    for _, pl in pairs(Players:GetPlayers()) do
        if pl and pl.Character then
            table.insert(online, pl.Name)
        end
    end
    print("🟢 Jogadores online: " .. #online)
    for _, name in pairs(online) do
        print("  - " .. name)
    end
    return
end

-- 275. OFFLINE - Jogadores offline
if comando == "offline" then
    local offline = {}
    for _, pl in pairs(Players:GetPlayers()) do
        if pl and not pl.Character then
            table.insert(offline, pl.Name)
        end
    end
    print("🔴 Jogadores offline: " .. #offline)
    for _, name in pairs(offline) do
        print("  - " .. name)
    end
    return
end

-- 276. VERSION - Versão do hub
if comando == "version" then
    print("🐧 JV HUB ADM v2.0")
    print("📌 300 COMANDOS ÚNICOS")
    print("📌 by jotinha12hr2")
    return
end

-- 277. CREDITS - Créditos
if comando == "credits" then
    print("🐧 JV HUB ADM")
    print("📌 Criado por jotinha12hr2")
    print("📌 300 comandos únicos")
    print("📌 Brookhaven + Antena de Chat")
    return
end

-- 278. STATUS - Status do hub
if comando == "status" then
    print("📡 Status do JV HUB ADM:")
    print("  Antena: " .. (ANTENA.Ativo and "🟢 Ativa" or "🔴 Desativada"))
    print("  Prefixo: " .. ANTENA.Prefixo)
    print("  Canal: " .. ANTENA.Canal)
    print("  Comandos: 300+")
    print("  by jotinha12hr2")
    return
end

-- 279. TOGGLE - Liga/Desliga a antena
if comando == "toggle" then
    ANTENA.Ativo = not ANTENA.Ativo
    print("📡 Antena " .. (ANTENA.Ativo and "🟢 ATIVADA" or "🔴 DESATIVADA"))
    return
end

-- 280. PREFIX - Muda o prefixo
if comando == "prefix" then
    if valor and valor ~= "" then
        ANTENA.Prefixo = valor
        print("📡 Prefixo alterado para: " .. valor)
    else
        print("📡 Prefixo atual: " .. ANTENA.Prefixo)
    end
    return
end

-- 281. CHANNEL - Muda o canal
if comando == "channel" then
    if valor and valor ~= "" then
        ANTENA.Canal = valor
        print("📡 Canal alterado para: " .. valor)
    else
        print("📡 Canal atual: " .. ANTENA.Canal)
    end
    return
end

-- 282. SCAN - Escaneia jogadores
if comando == "scan" then
    print("🔍 Escaneando jogadores...")
    for _, pl in pairs(Players:GetPlayers()) do
        local status = pl.Character and "🟢 Online" or "🔴 Offline"
        print("  " .. pl.Name .. " - " .. status)
    end
    return
end

-- 283. FIND - Encontra jogador
if comando == "find" then
    if pAlvo then
        print("✅ Jogador encontrado: " .. pAlvo.Name)
        print("  ID: " .. pAlvo.UserId)
        print("  Status: " .. (pAlvo.Character and "Online" or "Offline"))
    else
        print("❌ Jogador não encontrado: " .. valor)
    end
    return
end

-- 284. LIST - Lista comandos
if comando == "list" then
    print("📡 Comandos disponíveis:")
    print("  kill, freeze, fling, bring, jail, sit, fire")
    print("  explode, nuke, float, lag, stun, headshot")
    print("  crush, guillotine, thanos, suffocate, backrooms")
    print("  ban, kick, goner, respawn, giant, small, tiny")
    print("  invisible, visible, jumpscare, flopparain")
    print("  dash, launch, rocket, spin, flip, tilt, roll")
    print("  info, help, clear, rejoin, reset, ping, status")
    print("  toggle, prefix, channel, scan, find, list")
    return
end

-- 285. HELP2 - Ajuda específica
if comando == "help2" then
    print("🐧 JV HUB ADM - Ajuda")
    print("📌 Uso: /jv [comando] [alvo] [valor]")
    print("")
    print("📌 Exemplos:")
    print("  /jv kill joao - Mata o jogador joao")
    print("  /jv freeze todos - Congela todos")
    print("  /jv fling joao - Arremessa joao")
    print("  /jv bring joao - Traz joao ate voce")
    print("  /jv jail joao - Prende joao")
    print("  /jv info - Mostra informacoes")
    print("  /jv help - Lista todos os comandos")
    return
end

-- 286. KILLBOT - Mata bots (jogadores sem caracter)
if comando == "killbot" then
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and not pl.Character then
            local h2 = GetHum(pl)
            if h2 then h2.Health = 0 end
        end
    end
    return
end

-- 287. RESETBOTS - Reseta bots
if comando == "resetbots" then
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and not pl.Character then
            pl.CharacterAdded:Wait()
        end
    end
    return
end

-- 288. FINDME - Encontra sua posição
if comando == "findme" then
    local ar = GetRoot(LocalPlayer)
    if ar then
        print("📍 Sua posição: " .. tostring(ar.Position))
    end
    return
end

-- 289. FINDTARGET - Encontra a posição do alvo
if comando == "findtarget" then
    if pAlvo then
        local pr = GetRoot(pAlvo)
        if pr then
            print("📍 Posição de " .. pAlvo.Name .. ": " .. tostring(pr.Position))
        end
    end
    return
end

-- 290. DISTANCE - Distância até o alvo
if comando == "distance" then
    if pAlvo then
        local ar = GetRoot(LocalPlayer)
        local pr = GetRoot(pAlvo)
        if ar and pr then
            print("📏 Distância: " .. math.round((ar.Position - pr.Position).Magnitude) .. " studs")
        end
    end
    return
end

-- 291. NEARBY - Jogadores próximos
if comando == "nearby" then
    local ar = GetRoot(LocalPlayer)
    if not ar then return end
    print("📡 Jogadores próximos (50 studs):")
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            local pr = GetRoot(pl)
            if pr and (pr.Position - ar.Position).Magnitude < 50 then
                print("  - " .. pl.Name)
            end
        end
    end
    return
end

-- 292. FAR - Jogadores distantes
if comando == "far" then
    local ar = GetRoot(LocalPlayer)
    if not ar then return end
    print("📡 Jogadores distantes (>100 studs):")
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            local pr = GetRoot(pl)
            if pr and (pr.Position - ar.Position).Magnitude > 100 then
                print("  - " .. pl.Name)
            end
        end
    end
    return
end

-- 293. HIDE - Esconde o jogador
if comando == "hide" then
    if pAlvo then
        for _, part in pairs(pAlvo.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    end
    return
end

-- 294. SHOW - Mostra o jogador
if comando == "show" then
    if pAlvo then
        for _, part in pairs(pAlvo.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
    return
end

-- 295. FLY - Faz o jogador voar
if comando == "fly" then
    if r then
        local bv = Instance.new("BodyVelocity", r)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 10, 0)
        Debris:AddItem(bv, 10)
    end
    return
end

-- 296. SUPERFLY - Voo super rápido
if comando == "superfly" then
    if r then
        local bv = Instance.new("BodyVelocity", r)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 50, 0)
        Debris:AddItem(bv, 5)
    end
    return
end

-- 297. GROUND - Faz o jogador cair
if comando == "ground" then
    if r then
        local bv = Instance.new("BodyVelocity", r)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, -50, 0)
        Debris:AddItem(bv, 2)
    end
    return
end

-- 298. PUSH - Empurra o jogador
if comando == "push" then
    if r then
        local dir = Vector3.new(math.random(-50,50), math.random(0,20), math.random(-50,50))
        local bv = Instance.new("BodyVelocity", r)
        bv.Velocity = dir
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        Debris:AddItem(bv, 1)
    end
    return
end

-- 299. PULL - Puxa o jogador
if comando == "pull" then
    if r then
        local ar = GetRoot(LocalPlayer)
        if ar then
            local dir = (ar.Position - r.Position) * 10
            local bv = Instance.new("BodyVelocity", r)
            bv.Velocity = dir
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            Debris:AddItem(bv, 1)
        end
    end
    return
end

-- 300. CLONE - Clona o jogador (visual)
if comando == "clone" then
    if r then
        local clone = r:Clone()
        clone.Position = r.Position + Vector3.new(0, 3, 0)
        clone.Anchored = true
        clone.CanCollide = false
        clone.Transparency = 0.5
        clone.Material = Enum.Material.Neon
        clone.Color = Color3.fromRGB(0, 255, 255)
        clone.Parent = Workspace
        Debris:AddItem(clone, 5)
    end
    return
end

-- Fim dos 300 comandos
end

-- ============================================
-- RECEPTOR DO CHAT
-- ============================================
local function OnChatMessage(dados)
    if not ANTENA.Ativo then return end
    local mensagem = dados.Text
    if not mensagem or not string.find(mensagem, ANTENA.Prefixo) then return end
    if dados.FromSpeaker == LocalPlayer then return end
    local resto = string.gsub(mensagem, ANTENA.Prefixo, "")
    local partes = {}
    for palavra in string.gmatch(resto, "%S+") do
        table.insert(partes, palavra)
    end
    if #partes < 1 then return end
    local comando = partes[1]
    local alvo = partes[2] or ""
    local valor = partes[3] or ""
    ExecutarComando(comando, alvo, valor, dados.FromSpeaker.Name)
end

-- ============================================
-- INICIAR ANTENA
-- ============================================
local function IniciarAntena()
    print("═══════════════════════════════════════════════════════")
    print("🐧 JV HUB ADM - 300 COMANDOS ÚNICOS")
    print("📡 ANTENA CHAT - Brookhaven")
    print("📌 by jotinha12hr2")
    print("═══════════════════════════════════════════════════════")
    pcall(function()
        local channel = TextChatService.TextChannels:FindFirstChild(ANTENA.Canal)
        if channel then
            channel.MessageReceived:Connect(OnChatMessage)
            print("✅ Conectado ao canal: " .. ANTENA.Canal)
        else
            local channels = TextChatService.TextChannels:GetChildren()
            if #channels > 0 then
                channels[1].MessageReceived:Connect(OnChatMessage)
                print("✅ Conectado ao canal: " .. channels[1].Name)
            end
        end
    end)
    print("📡 Prefixo: " .. ANTENA.Prefixo)
    print("📡 TOTAL DE COMANDOS: 300 ÚNICOS")
    print("💡 Use: EnviarComandoChat('kill', 'joao', '')")
    print("💡 Use: EnviarComandoChat('help', '', '')")
    print("═══════════════════════════════════════════════════════")
end

-- ============================================
-- EXPORTA FUNÇÕES
-- ============================================
_G.EnviarComandoChat = EnviarComandoChat
_G.AntenaChat = {
    Enviar = EnviarComandoChat,
    Ativo = function(v) ANTENA.Ativo = v end,
    Prefixo = function(p) ANTENA.Prefixo = p end,
}

IniciarAntena()
