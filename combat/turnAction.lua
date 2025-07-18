local stringfy = require("combat/stringfy.lua");
local logRead = require("combat/logRead.lua");
local combatCall = require("gemini/combatGemini.lua");
local aiPrompt = require("aiPrompt.lua");
local sendCombatMessage = require("combat/sendCombatMessage.lua");
local commands = require("combat/commands.lua");
local function getPlayer(chat, login)
    local mesa = chat.room;
    local player = mesa:findJogador(login);
    if not player then
        return nil;
    end
    return player;
end

local function turnAction(npcName, battleid)
    local battleinfo = Battleinfo[battleid];
    if not battleinfo then
        Log.e("SimulacrumCore-TurnAction", "Batalha não encontrada: " .. battleid);
        return;
    end
    if not battleinfo.started then
        Log.e("SimulacrumCore-TurnAction", "Batalha não iniciada: " .. battleid);
        return;
    end
    local npc = nil;
    for i, enemy in ipairs(battleinfo.enemies) do
        if enemy.nome == npcName then
            if enemy.effects then
                for j, effect in ipairs(enemy.effects) do
                    if effect.turns then
                        effect.turns = effect.turns - 1;
                        if effect.turns <= 0 then
                            table.remove(enemy.effects, j);
                        end
                    end
                end
            end
            npc = enemy;
            break;
        end
    end
    if not npc then
        Log.e("SimulacrumCore-TurnAction", "Inimigo não encontrado: " .. npcName);
        return;
    end
    local iniciativas = "";
    for i = 1, #battleinfo.iniciativas do
        if i < #battleinfo.iniciativas then
            if battleinfo.iniciativas[i].nome then
                iniciativas = iniciativas .. battleinfo.iniciativas[i].nome .. ", ";
            else
                iniciativas = iniciativas .. battleinfo.iniciativas[i].login .. ", ";
            end
        else
            if battleinfo.iniciativas[i].nome then
                iniciativas = iniciativas .. battleinfo.iniciativas[i].nome;
            else
                iniciativas = iniciativas .. battleinfo.iniciativas[i].login;
            end
        end
    end
    local this = stringfy(npc, true);
    local jogadores = "";
    for i, player in pairs(battleinfo.players) do
        local jogador = getPlayer(battleinfo.chat, player.login);
        if jogador then
            jogadores = jogadores .. stringfy(jogador, false) .. "\n";
        end
    end
    local inimigos = "";
    for i, enemy in pairs(battleinfo.enemies) do
        inimigos = inimigos .. stringfy(enemy, true) .. "\n";
    end

    local turnData = {
        iniciativas = iniciativas,
        rodada = battleinfo.rodada,
        this = this,
        players = jogadores,
        enemies = inimigos,
        log = logRead(battleinfo.chat),
    }
    local prompt = aiPrompt.getTurnPrompt(turnData);
    Log.i("SimulacrumCore-TurnAction", "Turno de " .. npcName);
    local response = combatCall(prompt, battleinfo.chat);
    if not response then
        Log.e("SimulacrumCore-TurnAction", "Erro ao processar ação do turno: " .. npcName);
        return;
    end
    if response.description then
        sendCombatMessage(battleinfo.chat, response.description, npcName);
    end
    if response.commands then
        for _, command in ipairs(response.commands) do
            commands(command, battleid);
        end
    end
    sendCombatMessage(battleinfo.chat, ">>", npcName);
end
return turnAction;
