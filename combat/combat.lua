local sendMessage = require("firecast/sendMessage.lua")
local enemyGenerator = require("combat/enemyGenerator.lua")
local rUtils = require("token_utils.lua")
local iniciativa = require("combat/iniciativa.lua")
local start = require("combat/start.lua")
local group = {}

group.handleCombatCommand = function(battleid, content, entity)
    if not Battleinfo[battleid] then
        Log.e("SimulacrumCore-Combat", "Grupo de combate não encontrado: " .. battleid);
        return;
    end
    if content == "close" then
        sendMessage(" Grupo de combate fechado.", Battleinfo[battleid].chat, "friend");
        Battleinfo[battleid] = nil;
    end

    if (rUtils.startsWith(content, "generate")) then
        if Battleinfo[battleid].started then
            sendMessage(" Combate já iniciado.", Battleinfo[battleid].chat, "friend");
            return;
        end
        enemyGenerator(battleid, content);
    end
    if (rUtils.startsWith(content, "initiative")) then
        if not Battleinfo[battleid].started then
            sendMessage(" Combate não iniciado. Use 'Combat: generate <Nível>' primeiro.", Battleinfo[battleid].chat,
                "friend");
            return;
        end
        local modificador = content:sub(12):match("^%s*(.-)%s*$") -- Remove "initiative" prefix
        if not tonumber(modificador) then
            sendMessage(" Modificador de iniciativa inválido. Use 'Combat: initiative <modificador>'",
            Battleinfo[battleid].chat, "friend");
            return;
        end
        local iniciativa = iniciativa(Battleinfo[battleid].chat, entity.nick, modificador);
        if not iniciativa then
            sendMessage(" Erro ao rolar iniciativa.", Battleinfo[battleid].chat, "friend");
            return;
        end
        for i, player in ipairs(Battleinfo[battleid].players) do
            if player.login == entity.login then
                player.iniciativa = iniciativa;
                sendMessage(" Sua iniciativa é: " .. iniciativa, Battleinfo[battleid].chat, "friend");
                break;
            end
        end
    end
    if (rUtils.startsWith(content, "start")) then
        start(battleid);
    end
end

return group
