require("log.lua")
local getPlayerFromChat = require("firecast/getPlayerFromChat.lua")
local aiPrompt = require("aiPrompt.lua")
local geminiCall = require("gemini/geminiCall.lua")
local sendMessage = require("firecast/sendMessage.lua")

local ranks = {
    "Common",
    "Basic",
    "Extra",
    "Unique",
    "Ultimate",
    "Sekai",
    "Stellar",
    "Cosmic",
    "Universal",
    "Multi-Versal"
}

local function craft(message)
    local content = message.logRec.msg.content;
local mat = content:sub(7):match("^%s*(.-)%s*$") -- Remove "Craft:" prefix
                local materials, rank, craftingModifier = mat:match("%s*(.-)%s*|%s*(.-)%s*|%s*(.+)$")
                if not materials then
                    sendMessage(
                        " Formato inválido. Use: Craft: <materiais> | (rank )", message.chat, "friend");
                    return;
                end
                if not craftingModifier or craftingModifier == "" then
                    craftingModifier = "0"; -- Default modifier if not provided
                end
                if not rank or rank == "" then
                    rank = "0"; -- Default rank if not provided
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
                local promise = message.chat:asyncRoll("1d20+".. craftingModifier , jogador.nick .. " Crafting Roll", params);
                local roll, a, b = await(promise);
                local value = 12 + rank * 3;
                local craftingResult = "SUCESSO";
                if roll < value then
                    sendMessage(
                        " Crafting falhou com " .. roll .. ". Valor necessário: " .. value .. ".",
                        message.chat, "friend");
                    return;
                end
                if roll - craftingModifier == 20 then
                    craftingResult = "SUCESSO_CRITICO";
                end
                if roll - craftingModifier == 1 then
                    sendMessage(
                        " Crafting falhou criticamente com " .. roll .. ". Valor necessário: " .. value .. ".",
                        message.chat, "friend");
                    return;
                end
                rank = rank + 1; -- Increase rank on success
                Log.i("SimulacrumCore-Main", "Roll: " .. roll)
                Log.i("SimulacrumCore-Main", "Materials: " .. materials)
                Log.i("SimulacrumCore-Main", "Crafting Modifier: " .. craftingModifier)
                local linha = jogador:getEditableLine(1);
                local nivel, raca, classe, tokens = 1, "Raça", "Classe", 1
                if linha then
                    local lvl, tk, rc, cl = linha:match("(%d+)%s*|%s*(%d+)%s*|%s*([^|]+)%s*|%s*([^|]+)")
                    if lvl and rc and cl and tk then
                        nivel = lvl
                        raca = rc:match("^%s*(.-)%s*$")
                        classe = cl:match("^%s*(.-)%s*$")
                        tokens = tonumber(tk) or 1
                    end
                end
                local rankAlvo = ranks[tonumber(rank)] or "N/A";
                Log.i("SimulacrumCore-Main", "Rank Alvo: " .. rankAlvo)
                local contextoJogador = {
                    materials = materials,
                    craftingResult = craftingResult,
                    nivel = tonumber(nivel) or 1,
                    classe = classe:match("^%s*(.-)%s*$") or "Classe",
                    raca = raca:match("^%s*(.-)%s*$") or "Raça",
                    personagem = personagem,
                    tokens = tokens,
                    rankAlvo = rankAlvo,
                }
                local prompt = aiPrompt.getAiRankUp(contextoJogador);
                geminiCall(prompt, "aiCrafting", message.chat);
end
return craft;