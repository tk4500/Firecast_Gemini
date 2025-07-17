local sendMessage = require("firecast/sendMessage");
local iniciativa = require("combat/iniciativa");
local turnAction = require("combat/turnAction");

local function start(battleid)
            if not Battleinfo[battleid].started then
            sendMessage(" Combate não iniciado. Use 'Combat: generate <Nível>' primeiro.", Battleinfo[battleid].chat, "friend");
            return;
        end
        local iniciativas = {}
        local players = Battleinfo[battleid].players;
        local enemies = Battleinfo[battleid].enemies;
        for i, player in ipairs(players) do
            if not player.iniciativa then
                player.iniciativa = iniciativa(Battleinfo[battleid].chat, player.nick, 0);
                if not player.iniciativa then
                    player.iniciativa = 0; -- Default to 0 if initiative roll fails
                end                
            end
            table.insert(iniciativas, {login = player.login, iniciativa = player.iniciativa});
        end
        for i, enemy in ipairs(enemies) do
            enemy.iniciativa = iniciativa(Battleinfo[battleid].chat, enemy.nome, enemy.iniciativaMod or 0);
            if not enemy.iniciativa then
                enemy.iniciativa = 0; -- Default to 0 if initiative roll fails
            end
            table.insert(iniciativas, {nome = enemy.nome, iniciativa = enemy.iniciativa});
        end
        table.sort(iniciativas, function(a, b)
            return a.iniciativa > b.iniciativa;
        end);
        Battleinfo[battleid].iniciativas = iniciativas;
        Battleinfo[battleid].turno = 1;
        Battleinfo[battleid].rodada = 1;
        if Battleinfo[battleid].iniciativas[1].nome then
            sendMessage("Turno de".. Battleinfo[battleid].iniciativas[1].nome, Battleinfo[battleid].chat, "friend");
            turnAction(Battleinfo[battleid].iniciativas[1].nome, battleid);
        else
            for i, player in ipairs(Battleinfo[battleid].players) do
                if player.login == Battleinfo[battleid].iniciativas[1].login then
                    sendMessage("Turno de".. player.nick, Battleinfo[battleid].chat, "friend");
                    break;
                end
            end
        end
end
return start;