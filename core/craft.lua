require("log.lua")
local sendMessage = require("firecast/sendMessage.lua")
local getPlayerFromChat = require("firecast/getPlayerFromChat.lua")
local aiPrompt = require("aiPrompt.lua")
local geminiCall = require("gemini/geminiCall.lua")

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
local prompt = content:sub(7):match("^%s*(.-)%s*$") -- Remove "Craft:" prefix
                local materials, rank, craftingModifier = prompt:match("%s*(.-)%s*|%s*(.-)%s*|%s*(.+)$")
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
                local value = 10 + rank * 2;
                local craftingResult = "FALHA";
                if roll >= value then
                    craftingResult = "SUCESSO";
                end
                if roll - craftingModifier == 20 then
                    craftingResult = "SUCESSO";
                    rank = rank + 1; -- Increase rank on critical success
                end
                if roll - craftingModifier == 1 then
                    craftingResult = "FALHA_CRITICA";
                end
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
                local rankAlvo = ranks[tonumber(rank) + 1] or "N/A";
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
                local prompt = aiPrompt.getAiCrafting(contextoJogador);
                geminiCall(prompt, "aiCrafting", message.chat);
end
return craft;