local sendMessage = require("firecast/sendMessage");
local function getPlayer(chat, login)
    local mesa = chat.room;
    local player = mesa:findJogador(login);
    if not player then
        return nil;
    end
    return player;
end

local function endCombat(battleid, isVictory)
    local battleinfo = Battleinfo[battleid];
    if isVictory then
        sendMessage("Batalha vencida!", battleinfo.chat, "friend");
        for i, player in ipairs(battleinfo.players) do
            local jogador = getPlayer(battleinfo.chat, player.login);
            if jogador then
                local xp, xpMax = jogador:getBarValue(4);
                local xpGained = Battleinfo[battleid].xpAcumulado;
                local newXp = xp + xpGained;
                jogador:requestSetBarValue(4, newXp, xpMax);
            end
        end
        sendMessage("Experiência acumulada: " .. Battleinfo[battleid].xpAcumulado, battleinfo.chat, "friend");
        sendMessage("Dinheiro acumulado: " .. (Battleinfo[battleid].money or 0) .. " Créditos-S", battleinfo.chat, "friend");
        sendMessage("Itens:", battleinfo.chat, "friend");
        for i, item in ipairs(Battleinfo[battleid].itens) do
            if item then
                local itemString = [[
                Nome: ]] .. item.nome .."\n".. 
                [[Rank: ]] .. item.rank .. "\n"..
                [[Tipo: ]] .. item.tipo .. "\n";
                if item.preco then
                    itemString = itemString .. 
                    [[Preço: ]] .. item.preco .. "\n";
                end
                if item.slot then
                    itemString = itemString .. 
                    [[Slot: ]] .. item.slot .. "\n";
                end
                if item.craft then
                    itemString = itemString .. 
                    [[Craft: ]] .. item.craft .. "\n";
                end
                if item.custo then
                    itemString = itemString .. 
                    [[Custo: ]] .. item.custo .. "\n";
                end
                itemString = itemString .. 
                [[Descrição: ]] .. (item.descricao or "Nenhuma descrição fornecida.") .. "\n";
                sendMessage(itemString, battleinfo.chat, "friend");
            end
        end
    else
        sendMessage("Batalha perdida!", battleinfo.chat, "friend");
    end
    battleinfo.players = {};
    battleinfo.turno = 0;
    battleinfo.encounterTheme = nil;
    battleinfo.iniciativas = {};
    battleinfo.enemies = {};
    battleinfo.xpAcumulado = 0;
    battleinfo.items = {};
    battleinfo.rodada = 1;
    battleinfo.started = false;
    for _, participant in ipairs(battleinfo.chat.participants) do
        if participant.login ~= battleinfo.chat.room.me.login then
            table.insert(battleinfo.players, participant);
        end
    end
end
return endCombat;
