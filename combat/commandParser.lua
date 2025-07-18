
local commands = require("combat/commands.lua");
local sendMessage = require("firecast/sendMessage.lua");
local function playerCommand(tipo, entity, valor, valoraux, battleid)
    local comando = {
        playerLogin = entity.login,
        type = tipo,

    }
    if tipo == "roll" then
        comando.roll = valor;
        comando.value = valoraux;
        commands(comando, battleid);
    elseif tipo == "effect" then
        comando.value = valor;
        comando.turns = tonumber(valoraux) or 1;
        commands(comando, battleid);
    else
        comando.value = valor;
        commands(comando, battleid);
    end
end
local function enemyCommand(tipo, entity, valor, valoraux, battleid)
    local comando = {
        enemyName = entity.nome,
        type = tipo,
    }
    if tipo == "roll" then
        comando.roll = valor;
        comando.value = valoraux;
        commands(comando, battleid);
    elseif tipo == "effect" then
        comando.value = valor;
        comando.turns = tonumber(valoraux) or 1;
        commands(comando, battleid);
    else
        comando.value = valor;
        commands(comando, battleid);
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
        playerCommand(tipo, entity, valor, valoraux, battleid);
    else
        for i, enemy in ipairs(Battleinfo[battleid].enemies) do
            if enemy.nome == entidade then
                entity = enemy;
                break;
            end
        end
        if entity then
            if tipo == "attack" then
                local defesa = entity.defesa or 0;
                local chat = Battleinfo[battleid].chat;
                local promise = chat:asyncRoll(valor, "Ataque de " .. msgsender.nick .. " contra " .. entidade, {
                    impersonation = {
                        mode = "character",
                        name = msgsender.nick or "jogador",
                    }
                });
                local roll, a, b = await(promise);
                if not roll then
                    Log.e("SimulacrumCore-CommandParser", "Erro ao rolar ataque: " .. a .. b);
                    return;
                end
                if roll > defesa then
                    local dano = valoraux or 0;
                    enemyCommand("vidaAtual", entity, -dano, 0, battleid);
                else
                    sendMessage(" Ataque falhou contra " .. entidade .. ". Defesa: " .. defesa, Battleinfo[battleid].chat, "friend");
                end
            else
            enemyCommand(tipo, entity, valor, valoraux, battleid);
            end
        else
            Log.e("SimulacrumCore-CommandParser", "Entidade não encontrada: " .. entidade);
            return;
        end
    end

end
return commandParser;