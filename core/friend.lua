local sendMessage = require("firecast/sendMessage.lua")
local rUtils = require("token_utils.lua")
local getPlayerFromChat = require("firecast/getPlayerFromChat.lua")
local aiPrompt = require("aiPrompt.lua")
local geminiCall = require("gemini/geminiCall.lua")
local splitContext = require("gemini/splitContext.lua")
require("log.lua")

local function friend(message)
    local content = message.logRec.msg.content;
    local promptEnergia = content:sub(8):match("^%s*(.-)%s*$") -- Remove "Friend:" prefix e espaços
    local prompt, energiaStr, rankStr = promptEnergia:match("^(.-)%s*%((.-)%)%s*(%w*)$")
    if not prompt or not energiaStr or energiaStr == "" then
        sendMessage(
            " Formato inválido. Use: Friend: prompt (custo) <rank>", message.chat, "friend");
        return;
    end
    local energiaGasta = energiaStr;
    local tokensUsados = rUtils.contarTokens(prompt);
    local jogador = getPlayerFromChat(message);
    Log.i("SimulacrumCore-Friend", "Jogador encontrado: " .. (jogador and jogador.login or "Desconhecido"));
    if not jogador then
        sendMessage(" Jogador não encontrado no chat.", message.chat, "friend");
        return;
    end
    local syncRate = jogador:getBarValue(3);
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
    local rank = rUtils.rolarRankParaTokens(tokens);
    if rankStr then
        rankStr = rankStr:match("^%s*(.-)%s*$") -- Remove espaços
    end
    if rankStr and rankStr ~= "" then
        rank = rankStr
    end
    Log.i("SimulacrumCore-Friend", "Rank calculado: " .. rank);
    local personagem = message.chat.room:findBibliotecaItem(jogador.personagemPrincipal);

    local contextoJogador = {
        nivel = nivel,
        classe = classe,
        raca = raca,
        energiaGasta = energiaGasta,
        tokensUsados = tokensUsados,
        rank = rank,
        maxTokens = tokens,
        promptJogador = prompt,
        chat = message.chat,
        personagem = personagem,
        syncRate = syncRate,
    };
    if tokensUsados > tokens then
        local prompt = splitContext(contextoJogador);
        geminiCall(prompt, "aiMulticasting", message.chat);
    else
        local prompt = aiPrompt.getAiCasting(contextoJogador);
        geminiCall(prompt, "aiCasting", message.chat);
    end
end
return friend;
