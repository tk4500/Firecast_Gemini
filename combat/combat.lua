local sendMessage = require("firecast/sendMessage.lua")
local enemyGenerator = require("combat/enemyGenerator.lua")
local rUtils = require("token_utils.lua")
local init = require("combat/iniciativa.lua")
local start = require("combat/start.lua")
local commandParser = require("combat/commandParser.lua")
local group = {}

group.handleCombatCommand = function(battleid, content, entity)
    if not Battleinfo[battleid] then
        Log.e("SimulacrumCore-Combat", "Grupo de combate não encontrado: " .. battleid);
        return;
    end
    if content == "close" then
        sendMessage(" Grupo de combate fechado.", Battleinfo[battleid].chat, "friend");
        Battleinfo[battleid] = nil;
    elseif (rUtils.startsWith(content, "generate")) then
        if Battleinfo[battleid].started then
            sendMessage(" Combate já iniciado.", Battleinfo[battleid].chat, "friend");
            return;
        end
        enemyGenerator(battleid, content);
    elseif (rUtils.startsWith(content, "initiative")) then
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
        local iniciativa = init(Battleinfo[battleid].chat, entity.nick, modificador);
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
    elseif (rUtils.startsWith(content, "start")) then
        start(battleid);
    else
        local tipo, entidade, valor, valoraux = content:match("^%s*(.-)%s*|%s*(.-)%s*|%s*(.-)%s*|%s*(.-)%s*$")
        if tipo and entidade and valor and valoraux then
            commandParser(battleid, tipo, entidade, valor, valoraux, entity);
        else
            sendMessage(" Comando inválido. Formato esperado: Combat: tipo|entidade|valor|valoraux", Battleinfo[battleid].chat, "friend")
        end
    end
end

return group
