require("log.lua")
local aiPrompt = require("aiPrompt.lua")
local combatCall = require("gemini/combatGemini.lua")
local sendMessage = require("firecast/sendMessage.lua")

local function getPlayer(chat, login)
    local mesa = chat.room;
    local player = mesa:findJogador(login);
    if not player then
        return nil;
    end
    return player;
end

local function enemyGenerator(battleid, content)
    local battleinfo = Battleinfo[battleid];
    local nivelAmeaca = content:sub(9):match("^%s*(.-)%s*$") -- Remove "generate" prefix
    if not tonumber(nivelAmeaca) or tonumber(nivelAmeaca) <= 0 then
        sendMessage(" Nível de Ameaça inválido. Use 'Combat: generate <Nível>'", Battleinfo[battleid].chat, "friend");
        return;
    end
    Log.i("SimulacrumCore-EnemyGenerator", "Gerando inimigos para o combate com nível de ameaça: " .. nivelAmeaca);
    local encouterData = {
        difficulty = nivelAmeaca
    }
    local numEnemies = math.random(20);
    if numEnemies > 10 then
        numEnemies = 1;
    end
    if numEnemies > 15 then
        numEnemies = 2;
    end
    if numEnemies > 18 then
        numEnemies = 3;
    end
    if numEnemies > 19 then
        numEnemies = 4;
    end
    if numEnemies == 20 then
        numEnemies = 5;
    end
    encouterData.numEnemies = numEnemies;
    local players = "";
    local totalLevels = 0;
    for i, player in ipairs(battleinfo.players) do
        local jogador = getPlayer(battleinfo.chat, player.login);
        if jogador then
            local linha = jogador:getEditableLine(1);
            local nivel, raca, classe, tokens = 1, "Raça", "Classe", 1
            if linha then
                local lvl, tk, rc, cl = linha:match("(%d+)%s*|%s*(%d+)%s*|%s*([^|]+)%s*|%s*([^|]+)")
                if lvl and rc and cl and tk then
                    nivel = tonumber(lvl) or 1
                    raca = rc:match("^%s*(.-)%s*$")
                    classe = cl:match("^%s*(.-)%s*$")
                    tokens = tonumber(tk) or 1
                end
            end
            totalLevels = totalLevels + nivel;
            players = players .. string.format(
                '- { nick: "%s", nivel: %d, classe: "%s", raça: "%s" , tokens: %d}\n',
                player.nick or "N/A",
                nivel or 1,
                classe or "N/A",
                raca or "N/A",
                tokens or 1
            )
        end
    end
    encouterData.players = players;
    local apl = math.floor(totalLevels / #battleinfo.players);
    if apl < 1 then
        apl = 1;
    end
    encouterData.apl = apl;
    local prompt = aiPrompt.getEncounterPrompt(encouterData);
    local encounter = combatCall(prompt, battleinfo.chat);
    Log.i("SimulacrumCore-EnemyGenerator", "Inimigos gerados: " .. #encounter.enemies);
    Battleinfo[battleid].encounterTheme = encounter.encounterTheme;
    Battleinfo[battleid].chat:enviarMensagem("/cls");
    sendMessage(" Tema do Combate: " .. encounter.encounterTheme, Battleinfo[battleid].chat, "friend");
    Battleinfo[battleid].enemies = encounter.enemies;
    Battleinfo[battleid].xpAcumulado = 0;
    Battleinfo[battleid].money = 0;
    Battleinfo[battleid].itens = {};
    Battleinfo[battleid].started = true;
    Log.i("SimulacrumCore-Combat", "Tema do Combate: " .. Battleinfo[battleid].encounterTheme);
    sendMessage(" Combate iniciado com nível de ameaça: " .. nivelAmeaca, Battleinfo[battleid].chat, "friend");
    for i, enemy in ipairs(Battleinfo[battleid].enemies) do
        local enemyInfo = string.format(
            "Inimigo %d: %s, Nível: %d, Vida: %d/%d, Dano: %d, Defesa: %d",
            i,
            enemy.nome,
            enemy.nivel,
            enemy.vidaAtual,
            enemy.vidaMax,
            enemy.danoBase,
            enemy.defesa
        );
        Log.i("SimulacrumCore-Combat", "Inimigo gerado: " .. enemyInfo);
    end
end

return enemyGenerator;
