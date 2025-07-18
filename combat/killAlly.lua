local endCombat = require("combat/endCombat.lua");
local function getPlayer(chat, login)
    local mesa = chat.room;
    local player = mesa:findJogador(login);
    if not player then
        return nil;
    end
    return player;
end
local function recalcturn(iniciativas, nome, isPlayer)
    if isPlayer then
        for i, entidade in ipairs(iniciativas) do
            if entidade.login and entidade.login == nome then
                return i;
            end
        end
    else
        for i, entidade in ipairs(iniciativas) do
            if entidade.nome and entidade.nome == nome then
                return i;
            end
        end
    end
    return 1; -- Default to first turn if not found
end

local function removeAlly(iniciativas, login)
    for i, entidade in ipairs(iniciativas) do
        if entidade.login and entidade.login == login then
            table.remove(iniciativas, i);
        end
    end
end

local function killEnemy(battleid, ally)
    local battleinfo = Battleinfo[battleid];
    if not battleinfo or not battleinfo.started then
        Log.e("SimulacrumCore-KillAlly", "Batalha não iniciada ou não encontrada: " .. battleid);
        return;
    end
    if not ally or not ally.login then
        Log.e("SimulacrumCore-KillAlly", "Aliado inválido ou não encontrado: " .. tostring(ally));
        return;
    end
    -- Remove o inimigo da lista de inimigos
    for i, e in ipairs(battleinfo.players) do
        if e.login == ally.login then
            local player = getPlayer(battleinfo.chat, e.login);
            if not player then
                Log.e("SimulacrumCore-KillAlly", "Jogador não encontrado: " .. e.login);
                return;
            end
            local xpGained = Battleinfo[battleid].xpAcumulado or 0;
            for j, enemy in ipairs(Battleinfo[battleid].enemies) do
                if enemy.xpDrop then
                    xpGained = xpGained - math.floor(enemy.xpDrop/2);
                end
            end
            Log.i("SimulacrumCore-KillAlly", "XP ganho: " .. xpGained);
            local xpAtual, xpMax = player:getBarValue(4);
            local xp = xpAtual + xpGained;
            player:requestSetBarValue(4, xp, xpMax);

            if #battleinfo.players == 1 then
                endCombat(battleid, false);
                return;
            else
                local turno = battleinfo.turno;
                local entity = battleinfo.iniciativas[turno]
                if entity.login then
                    if entity.login == e.login then
                        removeAlly(battleinfo.iniciativas, e.login);
                    else
                        removeAlly(battleinfo.iniciativas, e.login);
                        turno = recalcturn(battleinfo.iniciativas, entity.login, false);
                    end
                else
                    removeAlly(battleinfo.iniciativas, e.login);
                    turno = recalcturn(battleinfo.iniciativas, entity.login, true);
                end
                table.remove(battleinfo.players, i);
                battleinfo.turno = turno;
            end
        end
    end
end
return killEnemy;
