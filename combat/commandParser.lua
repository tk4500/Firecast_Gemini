
local commands = require("combat/commands.lua");
local sendMessage = require("firecast/sendMessage.lua");
local function playerCommand(tipo, entity, valor, valoraux, battleid, msgsender)
    local comando = {
        playerLogin = entity.login,
        type = tipo,

    }
    if tipo == "roll" or tipo == "attack" then
        comando.roll = valor;
        comando.value = valoraux;
        commands(comando, battleid, msgsender);
    elseif tipo == "effect" then
        comando.value = valor;
        comando.turns = tonumber(valoraux) or 1;
        commands(comando, battleid, msgsender);
    else
        comando.value = valor;
        commands(comando, battleid, msgsender);
    end
end
local function enemyCommand(tipo, entity, valor, valoraux, battleid, msgsender)
    local comando = {
        enemyName = entity.nome,
        type = tipo,
    }
    if tipo == "roll" or tipo == "attack" then
        comando.roll = valor;
        comando.value = valoraux;
        commands(comando, battleid, msgsender);
    elseif tipo == "effect" then
        comando.value = valor;
        comando.turns = tonumber(valoraux) or 1;
        commands(comando, battleid, msgsender);
    else
        comando.value = valor;
        commands(comando, battleid, msgsender);
    end

end


local function commandParser(battleid, tipo, entidade, valor, valoraux, msgsender)
    local part = Battleinfo[battleid].chat.participants
    local entity = nil
    for i, player in ipairs(part) do
        if player.login == entidade then
            entity = player;
            break;
        end
    end
    if entity then
        playerCommand(tipo, entity, valor, valoraux, battleid, msgsender);
    else
        for i, enemy in ipairs(Battleinfo[battleid].enemies) do
            if enemy.nome == entidade then
                entity = enemy;
                break;
            end
        end
        if entity then
            enemyCommand(tipo, entity, valor, valoraux, battleid, msgsender);
        else
            Log.e("SimulacrumCore-CommandParser", "Entidade não encontrada: " .. entidade);
            return;
        end
    end

end
return commandParser;