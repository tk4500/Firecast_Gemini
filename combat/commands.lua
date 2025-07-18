local sendCombatMessage = require("combat/sendCombatMessage.lua");
local sendMessage = require("firecast/sendMessage.lua");
local calcInitiative = require("combat/calcInitiative.lua");
local killEnemy = require("combat/killEnemy.lua");
local killAlly = require("combat/killAlly.lua");
local function printblocks(chat, blocks, name, color)
    if blocks < 0 or blocks > 100 then
        Log.e("SimulacrumCore-Commands", "Número de blocos inválido: " .. blocks);
        return;
    end
    local main = math.floor(blocks / 10);
    local blockString = string.rep("█", main);
    if main ~= 10 then
    local dif = blocks - main*10;
    if dif == 0 then
        blockString = blockString .. "░";
    elseif dif <=5 then
        blockString = blockString .. "▒";
    else
        blockString = blockString .. "▓";
    end
    local emptyString = string.rep("░", 9 - main);
    blockString = blockString .. emptyString;
    end
    local message = "[§K" .. color .. "]" .. blockString;
    sendCombatMessage(chat, message, name);
end

local function getInfoFromPlayer(jogador)
    local player = {
        login = jogador.login,
        nick = jogador.nick or "N/A",
    }
    local _
    player.vidaAtual, player.vidaMax, _ = jogador:getBarValue(1);
    player.energiaAtual, player.energiaMax, _ = jogador:getBarValue(2);
    _, _, player.sync = jogador:getBarValue(3);
    player.nivel, player.tokens, player.raca, player.classe = jogador:getEditableLine(1):match(
        "(%d+)%s*|%s*(%d+)%s*|%s*([^|]+)%s*|%s*([^|]+)");
    return player;
end
local function getBattlePlayer(battleid, login)
    local battleinfo = Battleinfo[battleid];
    for i, player in ipairs(battleinfo.players) do
        if player.login == login then
            return player;
        end
    end
    return nil;
end

local function getPlayer(chat, login)
    local mesa = chat.room;
    local player = mesa:findJogador(login);
    if not player then
        return nil;
    end
    return player;
end

local function enemyCommand(command, enemy, battleid)
    local chat = Battleinfo[battleid].chat;
    if command.type == "vidaAtual" then
        if not tonumber(command.value) then
            Log.e("SimulacrumCore-Commands", "Valor inválido para comando: " .. command.value)
            return
        end
        enemy.vidaAtual = enemy.vidaAtual + command.value;
        if enemy.vidaAtual <= 0 then
            killEnemy(battleid, enemy);
            sendMessage("Inimigo " .. enemy.nome .. " derrotado.", chat, "friend");
            return;
        end
        local blocks = enemy.vidaAtual / enemy.vidaMax * 100;
        blocks = math.floor(blocks + 0.5);
        printblocks(chat, blocks, enemy.nome, 4);
        if tonumber(command.value) < 0 then
            local sync = -command.value / enemy.vidaMax * 100;
            sync = math.floor(sync + 0.5);
            enemy.sync = enemy.sync + sync;
            if enemy.sync > 100 then
                enemy.sync = 100; -- Limita o sync a 100
            end
            local syncblocks = enemy.sync;
            printblocks(chat, syncblocks, enemy.nome, 12);
        end
    elseif command.type == "vidaMax" then
        if not tonumber(command.value) then
            Log.e("SimulacrumCore-Commands", "Valor inválido para comando: " .. command.value)
            return
        end
        enemy.vidaMax = enemy.vidaMax + command.value;
        local blocks = enemy.vidaAtual / enemy.vidaMax * 100;
        blocks = math.floor(blocks + 0.5);
        printblocks(chat, blocks, enemy.nome, 4);
    elseif command.type == "energiaAtual" then
        if not tonumber(command.value) then
            Log.e("SimulacrumCore-Commands", "Valor inválido para comando: " .. command.value)
            return
        end
        enemy.energiaAtual = enemy.energiaAtual + command.value;
        local blocks = enemy.energiaAtual / enemy.energiaMax * 100;
        blocks = math.floor(blocks + 0.5);
        printblocks(chat, blocks, enemy.nome, 8);
        if tonumber(command.value) < 0 then
            local sync = -command.value / enemy.energiaMax * 100;
            sync = math.floor(sync + 0.5);
            enemy.sync = enemy.sync + sync;
            if enemy.sync > 100 then
                enemy.sync = 100; -- Limita o sync a 100
            end
            local syncblocks = enemy.sync;
            printblocks(chat, syncblocks, enemy.nome, 12);
        end
    elseif command.type == "energiaMax" then
        if not tonumber(command.value) then
            Log.e("SimulacrumCore-Commands", "Valor inválido para comando: " .. command.value)
            return
        end
        enemy.energiaMax = enemy.energiaMax + command.value;
        local blocks = enemy.energiaAtual / enemy.energiaMax * 100;
        blocks = math.floor(blocks + 0.5);
        printblocks(chat, blocks, enemy.nome, 8);
    elseif command.type == "defesa" then
        if not tonumber(command.value) then
            Log.e("SimulacrumCore-Commands", "Valor inválido para comando: " .. command.value)
            return
        end
        enemy.defesa = enemy.defesa + command.value;
    elseif command.type == "danoBase" then
        if not tonumber(command.value) then
            Log.e("SimulacrumCore-Commands", "Valor inválido para comando: " .. command.value)
            return
        end
        enemy.danoBase = enemy.danoBase + command.value;
    elseif command.type == "roll" then
        local promise = chat:asyncRoll(command.roll, "valor mudado:" .. command.value, {
            impersonation = {
                mode = "character",
                name = enemy.nome or "Inimigo",
            }
        })
        local roll, a, b = await(promise);
        if not roll then
            Log.e("SimulacrumCore-Commands", "Erro ao rolar: " .. a .. b);
            return;
        end
        return roll;
    elseif command.type == "effect" then
        if enemy.effects == nil then
            enemy.effects = {};
        end
        enemy.effects[#enemy.effects + 1] = {
            descricao = command.value,
            turns = command.turns or 1,
        };
    elseif command.type == "sync" then
        enemy.sync = enemy.sync + command.value;
        local blocks = enemy.sync;
        printblocks(chat, blocks, enemy.nome, 12);
    elseif command.type == "iniciativa" then
        enemy.iniciativa = enemy.iniciativa + command.value;
        for i, entity in ipairs(Battleinfo[battleid].iniciativas) do
            if entity.nome and entity.nome == enemy.nome then
                Battleinfo[battleid].iniciativas[i].iniciativa = enemy.iniciativa;
                break;
            end
        end
        calcInitiative(battleid);
    else
        Log.e("SimulacrumCore-Commands", "Tipo de comando inválido: " .. command.type);
    end
    for i, inimigo in ipairs(Battleinfo[battleid].enemies) do
        if inimigo.nome == enemy.nome then
            Battleinfo[battleid].enemies[i] = enemy;
            break;
        end
    end
end

local function playerCommand(command, player, battleid)
    local chat = Battleinfo[battleid].chat;
    local battlePlayer = getBattlePlayer(battleid, player.login);
    if not battlePlayer then
        Log.e("SimulacrumCore-Commands", "Jogador não encontrado na batalha: " .. player.login);
        return;
    end
    local attPlayer = getPlayer(chat, player.login);
    if not attPlayer then
        Log.e("SimulacrumCore-Commands", "Jogador não encontrado no chat: " .. player.login);
        return;
    end
    local jogador = getInfoFromPlayer(player);
    if command.type == "vidaAtual" then
        jogador.vidaAtual = jogador.vidaAtual + command.value;
        if jogador.vidaAtual <= 0 then
            killAlly(battleid, player);
            sendMessage("Jogador " .. jogador.nick .. " derrotado.", chat, "friend");
            return;
        end
        local blocks = jogador.vidaAtual / jogador.vidaMax * 100;
        blocks = math.floor(blocks + 0.5);
        printblocks(chat, blocks, jogador.nick, 4);
        attPlayer:requestSetBarValue(1, jogador.vidaAtual, jogador.vidaMax);
        if tonumber(command.value) < 0 then
            local sync = -command.value / jogador.vidaMax * 100;
            sync = math.floor(sync + 0.5);
            jogador.sync = jogador.sync + sync;
            if jogador.sync > 100 then
                jogador.sync = 100; -- Limita o sync a 100
            end
            local syncblocks = jogador.sync;
            printblocks(chat, syncblocks, jogador.nick, 12);
            attPlayer:requestSetBarValue(3, jogador.sync, 100);
        end
    elseif command.type == "vidaMax" then
        jogador.vidaMax = jogador.vidaMax + command.value;
        local blocks = jogador.vidaAtual / jogador.vidaMax * 100;
        blocks = math.floor(blocks + 0.5);
        printblocks(chat, blocks, jogador.nick, 4);
        attPlayer:requestSetBarValue(1, jogador.vidaAtual, jogador.vidaMax);
    elseif command.type == "energiaAtual" then
        jogador.energiaAtual = jogador.energiaAtual + command.value;
        local blocks = jogador.energiaAtual / jogador.energiaMax * 100;
        blocks = math.floor(blocks + 0.5);
        printblocks(chat, blocks, jogador.nick, 8);
        attPlayer:requestSetBarValue(2, jogador.energiaAtual, jogador.energiaMax);
        if tonumber(command.value) < 0 then
            local sync = -command.value / jogador.energiaMax * 100;
            sync = math.floor(sync + 0.5);
            jogador.sync = jogador.sync + sync;
            if jogador.sync > 100 then
                jogador.sync = 100; -- Limita o sync a 100
            end
            local syncblocks = jogador.sync;
            printblocks(chat, syncblocks, jogador.nick, 12);
            attPlayer:requestSetBarValue(3, jogador.sync, 100);
        end
    elseif command.type == "energiaMax" then
        jogador.energiaMax = jogador.energiaMax + command.value;
        local blocks = jogador.energiaAtual / jogador.energiaMax * 100;
        blocks = math.floor(blocks + 0.5);
        printblocks(chat, blocks, jogador.nick, 8);
        attPlayer:requestSetBarValue(2, jogador.energiaAtual, jogador.energiaMax);
    elseif command.type == "defesa" then
        sendMessage("Defesa de" .. jogador.nick .. " modificada em " .. command.value, chat, "friend");
    elseif command.type == "danoBase" then
        sendMessage("danoBase de" .. jogador.nick .. " modificada em " .. command.value, chat, "friend");
    elseif command.type == "roll" then
        sendMessage(jogador.nick .. ", role" .. command.roll .. " com valor: " .. command.value, chat, "friend");
    elseif command.type == "effect" then
        command.turns = command.turns or 1;
        sendMessage("Efeito aplicado a " .. jogador.nick .. " por " .. command.turns .. " turnos: " .. command.value,
            chat, "friend");
    elseif command.type == "sync" then
        jogador.sync = jogador.sync + command.value;
        local blocks = jogador.sync;
        printblocks(chat, blocks, jogador.nick, 12);
        attPlayer:requestSetBarValue(3, jogador.sync, 100);
    elseif command.type == "iniciativa" then
        battlePlayer.iniciativa = battlePlayer.iniciativa + command.value;
        for i, entity in ipairs(Battleinfo[battleid].iniciativas) do
            if entity.login and entity.login == battlePlayer.login then
                Battleinfo[battleid].iniciativas[i].iniciativa = battlePlayer.iniciativa;
                break;
            end
        end
        calcInitiative(battleid);
    else
        Log.e("SimulacrumCore-Commands", "Tipo de comando inválido: " .. command.type);
    end
end


local function commandInterpreter(command, battleid)
    if command.playerLogin then
        local battleinfo = Battleinfo[battleid];
        local player = getPlayer(battleinfo.chat, command.playerLogin);
        if not player then
            Log.e("SimulacrumCore-Commands", "Jogador não encontrado: " .. command.playerLogin);
            return;
        end
        playerCommand(command, player, battleid);
    elseif command.enemyName then
        local battleinfo = Battleinfo[battleid];
        local enemy = nil;
        for i, e in ipairs(battleinfo.enemies) do
            if e.nome == command.enemyName then
                enemy = e;
                break;
            end
        end
        if not enemy then
            Log.e("SimulacrumCore-Commands", "Inimigo não encontrado: " .. command.enemyName);
            return;
        end
        return enemyCommand(command, enemy, battleid);
    else
        Log.e("SimulacrumCore-Commands", "Comando inválido: " .. tostring(command));
    end
end
return commandInterpreter;
