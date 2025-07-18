local endCombat = require("combat/endCombat.lua");

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

local function removeEnemy(iniciativas, nome)
    for i, entidade in ipairs(iniciativas) do
        if entidade.nome and entidade.nome == nome then
            table.remove(iniciativas, i);
        end
    end
end

local function killEnemy(battleid, enemy)
    local battleinfo = Battleinfo[battleid];
    if not battleinfo or not battleinfo.started then
        Log.e("SimulacrumCore-KillEnemy", "Batalha não iniciada ou não encontrada: " .. battleid);
        return;
    end
    if not enemy or not enemy.nome then
        Log.e("SimulacrumCore-KillEnemy", "Inimigo inválido ou não encontrado: " .. tostring(enemy));
        return;
    end
    -- Remove o inimigo da lista de inimigos
    for i, e in ipairs(battleinfo.enemies) do
        if e.nome == enemy.nome then
            Battleinfo[battleid].xpAcumulado = battleinfo.xpAcumulado + (e.xpDrop or 0);
            Battleinfo[battleid].money = Battleinfo[battleid].money + (e.moneyDrop or 0);
            for j, item in ipairs(e.itemDrop or {}) do
                if item then
                    table.insert(battleinfo.itens, item);
                end
            end
            if #battleinfo.enemies == 1 then
                endCombat(battleid, true);
                return;
            else
                local turno = battleinfo.turno;
                local entity = battleinfo.iniciativas[turno]
                if entity.nome then
                    if entity.nome == e.nome then
                        removeEnemy(battleinfo.iniciativas, e.nome);
                    else
                        removeEnemy(battleinfo.iniciativas, e.nome);
                        turno = recalcturn(battleinfo.iniciativas, entity.nome, false);
                    end
                else
                    removeEnemy(battleinfo.iniciativas, e.nome);
                    turno = recalcturn(battleinfo.iniciativas, entity.login, true);
                end
                table.remove(battleinfo.enemies, i);
                battleinfo.turno = turno;
            end
        end
    end
end
return killEnemy;
