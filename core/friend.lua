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
    local prompt, energiaStr = promptEnergia:match("^(.-)%s*%((.-)%)%s*$")
    if not prompt or not energiaStr or energiaStr == "" then
        sendMessage(
            " Formato inválido. Use: Friend: <prompt> (<energia>)", message.chat, "friend");
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
    local tokens = jogador:getBarValue(3);
    local linha = jogador:getEditableLine(1);
    Log.i("SimulacrumCore-Friend",
        "Tokens disponíveis: " .. (tokens or "Desconhecido") .. ", Tokens usados: " .. tokensUsados);
    if not linha then
        sendMessage(
            " Não foi possível obter a linha editável do jogador.", message.chat, "friend");
        return;
    end
    Log.i("SimulacrumCore-Friend", "Linha editável do jogador: " .. (linha or "Desconhecido"));
    local nivel, raca, classe = 1, "Raça", "Classe"
    if linha then
        local lvl, rc, cl = linha:match("Level%s*(%d+)%s*|%s*([^|]+)%s*|%s*(.+)")
        if lvl and rc and cl then
            nivel = lvl
            raca = rc:match("^%s*(.-)%s*$")
            classe = cl:match("^%s*(.-)%s*$")
        end
    end

    local rank = rUtils.rolarRankParaTokens(tokens);
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
        personagem = personagem
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
