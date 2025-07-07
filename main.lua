require("firecast.lua")
require("internet.lua")
require("log.lua")
require("dialogs.lua");
local sendMessage = require("firecast/sendMessage.lua")
local getPlayerFromChat = require("firecast/getPlayerFromChat.lua")
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
            if (rUtils.startsWith(content, "Friend ")) then
                local prompt = content:sub(8):match("^%s*(.-)%s*$") -- Remove "Friend " prefix
                geminiCall(aiPrompt.friendPrompt(prompt), "friend", message.chat);
            end
            if (rUtils.startsWith(content, "gemini ")) then
                local prompt = content:sub(8):match("^%s*(.-)%s*$") -- Remove "gemini " prefix
                geminiCall(prompt, "gemini", message.chat);
            end

            if (rUtils.startsWith(content, "Craft:")) then
                local prompt = content:sub(7):match("^%s*(.-)%s*$") -- Remove "Craft:" prefix
                local materials, craftingModifier = prompt:match("^(.-)%s*%((.-)%)%s*$")
                if not materials then
                    sendMessage(
                        " Formato inválido. Use: Craft: <materiais> (<modificador>)", message.chat, "friend");
                    return;
                end
                if not craftingModifier or craftingModifier == "" then
                    craftingModifier = "0"; -- Default modifier if not provided
                end

                if tonumber(craftingModifier) == nil then
                    sendMessage(
                        " O modificador de Craft precisa ser um número. Use: Craft: <materiais> (<modificador numérico>)", message.chat, "friend");
                    return;
                end
                
                local jogador = getPlayerFromChat(message);
                local personagem = message.chat.room:findBibliotecaItem(jogador.personagemPrincipal);
                local params = {
                    impersonation = {
                        mode = "character",
                        avatar = personagem.avatar or jogador.avatar or "",
                        name = jogador.nick
                    }
                }
                local promise = message.chat:asyncRoll("1d20", jogador.nick .. " Crafting Roll", params);
                local roll, a, b = await(promise);
                local craftingResult = "";
                if roll == 1 then
                    craftingResult = "FALHA_CRITICA";
                elseif roll == 20 then
                    craftingResult = "SUCESSO_CRITICO";
                elseif roll <= tonumber(craftingModifier) then
                    craftingResult = "SUCESSO";
                else
                    craftingResult = "FALHA";
                end
                Log.i("SimulacrumCore-Main", "Roll: " .. roll)
                Log.i("SimulacrumCore-Main", "Materials: " .. materials)
                Log.i("SimulacrumCore-Main", "Crafting Modifier: " .. craftingModifier)
                local linha = jogador:getEditableLine(1);
                local nivel, raca, classe = 1, "Raça", "Classe"
                if linha then
                    local lvl, rc, cl = linha:match("Level%s*(%d+)%s*|%s*([^|]+)%s*|%s*(.+)")
                    if lvl and rc and cl then
                        nivel = lvl
                        raca = rc:match("^%s*(.-)%s*$")
                        classe = cl:match("^%s*(.-)%s*$")
                    end
                end
                local contextoJogador = {
                    materials = materials,
                    craftingResult = craftingResult,
                    nivel = tonumber(nivel) or 1,
                    classe = classe:match("^%s*(.-)%s*$") or "Classe",
                    raca = raca:match("^%s*(.-)%s*$") or "Raça",
                    personagem = personagem,
                }
                local prompt = aiPrompt.getAiCrafting(contextoJogador);
                geminiCall(prompt, "aiCrafting", message.chat);
            end
            if (rUtils.startsWith(content, "geminiKey ") and message.mine) then
                local key = content:sub(10):match("^%s*(.-)%s*$") -- Remove "geminiKey " prefix
                setGeminiKey(key, message.chat);
            end
        end
    end
);
Log.i("SimulacrumCore-Main", "Plugin Simulacrum Core carregado.")
