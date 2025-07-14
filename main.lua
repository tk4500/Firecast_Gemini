require("firecast.lua")
require("internet.lua")
require("log.lua")
require("dialogs.lua");
local getPlayerFromChat = require("firecast/getPlayerFromChat.lua")
local craft = require("core/craft.lua")
local friend = require("core/friend.lua")
local fusion = require("core/fusion.lua")
local geminiCall = require("gemini/geminiCall.lua")
local aiPrompt = require("aiPrompt.lua")
local setGeminiKey = require("gemini/setGeminiKey.lua")
local rUtils = require("token_utils.lua")
Log.i("SimulacrumCore-Main", "Plugin Simulacrum Core carregando.")

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
                local personagem = message.chat.room:findBibliotecaItem(jogador.personagemPrincipal);
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
            if (rUtils.startsWith(content, "geminiKey ") and message.mine) then
                local key = content:sub(10):match("^%s*(.-)%s*$") -- Remove "geminiKey " prefix
                setGeminiKey(key, message.chat);
            end
        end
    end
);
Log.i("SimulacrumCore-Main", "Plugin Simulacrum Core carregado.")
