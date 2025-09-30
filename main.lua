require("vhd.lua");
require("firecast.lua")
require("internet.lua")
require("log.lua")
require("dialogs.lua");
require("afk/afk.lua")
local afkinfo = require("afk/afkInfo.lua")
require("tts/tts.lua")
local afk = require("afk/afkChange.lua")
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
local imageRequest = require("gemini/imageRequest.lua")
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
        if message.command == "ttskey" then
            local key = message.parameter
            TTS_KEY = key;
            Log.i("SimulacrumCore-TTS", "Chave TTS definida.");
            message.response = { handled = true };
        end
        if message.command == "tts" then
            TTS_ACTIVE = not TTS_ACTIVE;
            Log.i("SimulacrumCore-TTS", "TTS ativo: " .. tostring(TTS_ACTIVE));
            message.response = { handled = true };
        end
        if message.command == "ttsLanguage" then
            local lang = message.parameter
            if lang and lang ~= "" then
                TTS_LANGUAGE = lang;
                Log.i("SimulacrumCore-TTS", "Idioma TTS definido: " .. tostring(TTS_LANGUAGE));
                message.chat:writeEx(" Idioma TTS definido para: " .. tostring(TTS_LANGUAGE));
            else
                message.chat:writeEx(" Idioma TTS inválido. Use: ttsLanguage <código_idioma>");
            end
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
        if message.logRec.msg.msgType == "sys_userJoin" then
            if message.chat.room.codigoInterno == 251479 then
                Log.i("SimulacrumCore-Main", "Usuário entrou na mesa 251479: " .. tostring(message.logRec.entity.login));
                afk(message.logRec)
            end

        end
        if message.logRec.msg.msgType == "sys_userLeave" then
            if message.chat.room.codigoInterno == 251479 then
                Log.i("SimulacrumCore-Main", "Usuário saiu da mesa 251479: " .. tostring(message.logRec.entity.login));
                afk(message.logRec)
            end
        end
        if message.logRec.msg.content then
            local content = message.logRec.msg.content;
            Log.i("SimulacrumCore-Main", "ChatMessageEx received: " .. tostring(content));
            if (rUtils.startsWith(content, "Fusion:")) then
                fusion(message);
                return;
            end
            if (rUtils.startsWith(content, "Friend:")) then
                friend(message);
                return;
            end
            if (rUtils.startsWith(content, "tts")) then
                local text = content:sub(4):match("^%s*(.-)%s*$") -- Remove "tts " prefix
                if not TTS_KEY or TTS_KEY == "" then
                    sendMessage(" Chave TTS não definida. Use o comando /ttskey <sua_chave_aqui> para definir.", message.chat, "friend");
                    return;
                end
                if not text or text == "" then
                    sendMessage(" Texto vazio para TTS.", message.chat, "friend");
                    return;
                end
                TtsMessage(text, message.chat.room);
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

            if (rUtils.startsWith(content, "geminiImage ")) then
                local prompt = content:sub(12):match("^%s*(.-)%s*$") -- Remove "geminiImage" prefix
                imageRequest(prompt, message.chat);
            end

            if (rUtils.startsWith(content, "Craft:")) then
                craft(message);
                return;
            end
            if (rUtils.startsWith(content, "Refine:")) then
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
            if (rUtils.startsWith(content, "afk")) then
                afkinfo(message);
            end
        end
    end
);

local chat = Firecast.findMesa(251479).chat;
if chat then
    Log.i("SimulacrumCore-Main", "Resetando chat para evitar problemas de cache.");
    chat:enviarMensagem("/reset");
    local logRecs = chat:readLogRecs();
    local file = VHD.openFile("afk.txt");
    if file then
        local fileData = {}
        local read = file:read(fileData, file.size);
        if read then
            local afkData = string.char(table.unpack(fileData));
            AFK = Utils.strToTable(afkData);
        end
    end
    for _, participant in ipairs(chat.participants) do
        local login = participant.login;
        Log.i("SimulacrumCore-Main", "Verificando estado AFK do participante: " .. tostring(login));
        for i = #logRecs, 1, -1 do
            local logRec = logRecs[i];
            if logRec.msg.msgType == "sys_userJoin" and logRec.entity and logRec.entity.login == login then
                Log.i("SimulacrumCore-Main", "Participante " .. tostring(login) .. " entrou.");
                afk(logRec);
                break;
            end
        end
    end
end


Log.i("SimulacrumCore-Main", "Plugin Simulacrum Core carregado.")
