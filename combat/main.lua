
local rUtils = require("token_utils.lua")
local sendMessage = require("firecast/sendMessage.lua")
local group = require("combat/combat.lua")


local function combat(message)
    local content = message.logRec.msg.content;
    content = content:sub(8):gsub("^%s+", "") -- Remove "Combat:" prefix and only trim spaces immediately after it  local medium = message.logRec.medium;
    local medium = message.logRec.medium;
    if medium.kind == "room" then
        if(rUtils.startsWith(content, "start")) then
            local mesa = message.chat.room;
            local playerString = content:sub(6):match("^%s*(.-)%s*$") -- Remove "start" prefix
            local logins = {}
            local players = {}
            for login in playerString:gmatch("%S+") do
                for _, participant in ipairs(message.chat.participants) do
                    if participant.login == login then
                        table.insert(logins, login);
                        table.insert(players, participant);
                        break;
                    end
                end
            end
            local promise = mesa:asyncCreateGroupPVT(logins);
            local chat = await(promise);
            if not chat then
                sendMessage(" Erro ao criar grupo privado.", message.chat, "friend");
                return;
            end
            Log.i("SimulacrumCore-Combat", "Grupo privado criado com sucesso: " .. chat.medium.groupId);
            Battleinfo[chat.medium.groupId] = {
                players = players,
                chat = chat,
                started = false,
            }
            sendMessage(" Grupo privado criado com sucesso. Iniciando combate.", chat, "friend");
            sendMessage(
                " Você entrou no grupo privado de combate. Use 'Combat: <comando>' para interagir.",
                chat, "friend");
            sendMessage("Envie Combat: generate <Nivel de Ameaça> para iniciar o combate.", chat, "friend");
        end
    end

    if medium.kind == "groupPvtOnRoom" then
        local battleid = medium.groupId;
        if not Battleinfo[battleid] then
            sendMessage(" Erro: Grupo de combate não encontrado.", message.chat, "friend");
            return;
        end
        group.handleCombatCommand(battleid, content, message.logRec.entity);
    end
end
return combat;