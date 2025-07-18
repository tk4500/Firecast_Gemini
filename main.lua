require("vhd.lua");
require("firecast.lua")
require("internet.lua")
require("log.lua")
require("dialogs.lua");
local getPlayerFromChat = require("firecast/getPlayerFromChat.lua")
local sendMessage = require("firecast/sendMessage.lua")
local combat = require("combat/main.lua")
local craft = require("core/craft.lua")
local friend = require("core/friend.lua")
local fusion = require("core/fusion.lua")
local geminiCall = require("gemini/geminiCall.lua")
local aiPrompt = require("aiPrompt.lua")
local Json = require("json.lua")
local setGeminiKey = require("gemini/setGeminiKey.lua")
local rUtils = require("token_utils.lua")
local rankup = require("core/rankup.lua")
local turnEnd = require("combat/turnEnd.lua")
Log.i("SimulacrumCore-Main", "Plugin Simulacrum Core carregando.")
Battleinfo = {}
Firecast.Messaging.listen(
    "HandleChatCommand",
    function(message)
        if message.command == "geminiKey" then
            local key = message.parameter
            setGeminiKey(key, message.chat);
            message.response = { handled = true };
        end
        if message.command == "getRules" then
            rUtils.setRules(message);
            message.response = { handled = true };
        end
        if message.command == "generateCombat" then
            local groupid = message.chat.medium.groupId;
            if Battleinfo[groupid] then
                sendMessage(" Grupo de combate já existe.", message.chat, "friend");
                return;
            end
            local players = message.chat.participants;
            for _, player in ipairs(players) do
                if player.login == message.room.me.login then
                    table.remove(players, _); -- Remove o próprio jogador da lista de participantes
                    break;
                end
            end
            Battleinfo[groupid] = {
                players = players,
                chat = message.chat,
                started = false,
            }
            Log.i("SimulacrumCore-Main", "Grupo de combate criado: " .. groupid);

            message.response = { handled = true };
        end
        if message.command == "dump" then
            local groupid = message.chat.medium.groupId;
            local battleinfo = Battleinfo[groupid];
            if not Battleinfo[groupid] then
                sendMessage(" Grupo de combate não existe.", message.chat, "friend");
                return;
            end
            battleinfo.chat =  nil; -- Remove o chat do dump para evitar circular references
            local dump = Json.encode(battleinfo);
            message.chat:writeEx("Grupo de combate dump: " .. tostring(dump),{
                parseSmileys = false,
            });
            message.response = { handled = true };
        end
    end)

Firecast.Messaging.listen("ChatMessageEx",
    function(message)
        if message.logRec.msg.content then
            local content = message.logRec.msg.content;
            Log.i("SimulacrumCore-Main", "ChatMessageEx received: " .. content);
            if (rUtils.startsWith(content, "Fusion:")) then
                fusion(message);
                return;
            end
            if (rUtils.startsWith(content, "Friend:")) then
                friend(message);
                return;
            end
            if (rUtils.startsWith(content, "Friend ") or rUtils.startsWith(content, "Friend,")) then
                local prompt = content:gsub("^Friend[, ]+", "") -- Remove "Friend," or "Friend " prefix
                local jogador = getPlayerFromChat(message);
                local personagem = nil;
                if jogador.personagemPrincipal then
                    personagem = message.chat.room:findBibliotecaItem(jogador.personagemPrincipal);
                end
                geminiCall(aiPrompt.friendPrompt(prompt, personagem), "friend", message.chat);
            end
            if (rUtils.startsWith(content, "gemini ")) then
                local prompt = content:sub(8):match("^%s*(.-)%s*$") -- Remove "gemini " prefix
                geminiCall(prompt, "gemini", message.chat);
            end

            if (rUtils.startsWith(content, "Craft:")) then
                craft(message);
                return;
            end
            if (rUtils.startsWith(content, "Rankup:")) then
                rankup(message);
                return;
            end
            if (rUtils.startsWith(content, "geminiKey ") and message.mine) then
                local key = content:sub(10):match("^%s*(.-)%s*$") -- Remove "geminiKey " prefix
                setGeminiKey(key, message.chat);
            end

            if (rUtils.startsWith(content, "Combat:")) then
                combat(message);
            end
            if content == ">>" then
                local battleid = message.chat.medium.groupId;
                if Battleinfo[battleid] then
                    turnEnd(message, battleid);
                end
            end
        end
    end
);

local chat = Firecast.findMesa(251479).chat;
if chat then
    Log.i("SimulacrumCore-Main", "Resetando chat para evitar problemas de cache.");
    chat:enviarMensagem("/reset");
end


Log.i("SimulacrumCore-Main", "Plugin Simulacrum Core carregado.")
