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
            npc = enemy;
            break;
        end
    end
    if not npc then
        Log.e("SimulacrumCore-TurnAction", "Inimigo não encontrado: " .. npcName);
        return;
    end
end
return turnAction;