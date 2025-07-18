local sendMessage = require("firecast/sendMessage.lua")
local turnAction = require("combat/turnAction.lua")
local function turnEnd(message, battleid)
    local battleinfo = Battleinfo[battleid];
    local logrec = message.logRec;
    if not battleinfo or not battleinfo.started then
        Log.e("SimulacrumCore-TurnEnd", "Batalha não iniciada ou não encontrada: " .. battleid);
        return;
    end
    local turno = battleinfo.turno;
    if turno == 0 then
        Log.e("SimulacrumCore-TurnEnd", "Nenhum turno iniciado para a batalha: " .. battleid);
        return;
    end
    if message.mine then
        local nome = logrec.msg.impersonation.name;
        if nome then
            if battleinfo.iniciativas[turno].nome and battleinfo.iniciativas[turno].nome == nome then
                Battleinfo[battleid].turno = Battleinfo[battleid].turno + 1;
                if Battleinfo[battleid].turno > #Battleinfo[battleid].iniciativas then
                    Battleinfo[battleid].turno = 1;                                -- Volta ao primeiro turno se ultrapassar o número de iniciativas
                    Battleinfo[battleid].rodada = Battleinfo[battleid].rodada + 1; -- Incrementa a rodada
                end
                local nextEntity = Battleinfo[battleid].iniciativas[Battleinfo[battleid].turno];
                if nextEntity.nome then
                    sendMessage("Turno de " .. nextEntity.nome, Battleinfo[battleid].chat, "friend");
                    turnAction(nextEntity.nome, battleid);
                else
                    local player = Battleinfo[battleid].chat.room:findJogador(nextEntity.login);
                    if player then
                        sendMessage("Turno de " .. player.nick, Battleinfo[battleid].chat, "friend");
                    else
                        sendMessage("Turno de " .. nextEntity.login, Battleinfo[battleid].chat, "friend");
                    end
                end
            end
        end
    else
        local login = logrec.entity.login;
        if login then
            if battleinfo.iniciativas[turno].login and battleinfo.iniciativas[turno].login == login then
                Battleinfo[battleid].turno = Battleinfo[battleid].turno + 1;
                if Battleinfo[battleid].turno > #Battleinfo[battleid].iniciativas then
                    Battleinfo[battleid].turno = 1;                                -- Volta ao primeiro turno se ultrapassar o número de iniciativas
                    Battleinfo[battleid].rodada = Battleinfo[battleid].rodada + 1; -- Incrementa a rodada
                end
                local nextEntity = Battleinfo[battleid].iniciativas[Battleinfo[battleid].turno];
                if nextEntity.nome then
                    sendMessage("Turno de " .. nextEntity.nome, Battleinfo[battleid].chat, "friend");
                    turnAction(nextEntity.nome, battleid);
                else
                    local player = Battleinfo[battleid].chat.room:findJogador(nextEntity.login);
                    if player then
                        sendMessage("Turno de " .. player.nick, Battleinfo[battleid].chat, "friend");
                    else
                        sendMessage("Turno de " .. nextEntity.login, Battleinfo[battleid].chat, "friend");
                    end
                end
            end
        end
    end
end
return turnEnd;
