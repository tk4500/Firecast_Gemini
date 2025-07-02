require("firecast.lua")
require("internet.lua")
require("log.lua")
require("dialogs.lua");
local fusion = require("core/fusion.lua")
local geminiCall = require("gemini/geminiCall.lua")
local sendMessage = require("firecast/sendMessage.lua")
local habilidade = require("habilidade.lua")
local aiPrompt = require("aiPrompt.lua")
local splitContext = require("gemini/splitContext.lua")
local rUtils = require("token_utils.lua")
local getPlayerFromChat = require("firecast/getPlayerFromChat.lua")
Log.i("SimulacrumCore-Main", "Plugin Simulacrum Core carregando.")

Firecast.Messaging.listen(
    "HandleChatCommand",
    function(message)
        if message.command == "geminiKey" then
            local key = message.parameter
            if key and key ~= "" then
                GEMINI_API_KEY = key;
                message.chat:writeEx(" Chave Gemini definida com sucesso.");
                Log.i("SimulacrumCore", "Chave Gemini definida: " .. GEMINI_API_KEY);
            else
                message.chat:writeEx(" Chave Gemini inválida. Use: geminiKey <sua_chave>");
                Log.e("SimulacrumCore", "Chave Gemini inválida recebida.");
            end
            message.response = { handled = true };
        end

        if message.command == "getSkill" then
            local login = message.parameter;
            habilidade.getSkills(login, message.chat.room);
            message.response = { handled = true };
        end
    end)

Firecast.Messaging.listen("ChatMessageEx",
    function(message)
        if message.logRec.msg.content then
            local content = message.logRec.msg.content;
            Log.i("SimulacrumCore", "ChatMessageEx received: " .. content);
            if (rUtils.startsWith(content, "Fusion:")) then
                fusion(message);
                return;
            end
            if (rUtils.startsWith(content, "Friend:")) then
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
                Log.i("SimulacrumCore", "Jogador encontrado: " .. (jogador and jogador.login or "Desconhecido"));
                if not jogador then
                    sendMessage(" Jogador não encontrado no chat.", message.chat, "friend");
                    return;
                end
                local tokens = jogador:getBarValue(3);
                local linha = jogador:getEditableLine(1);
                Log.i("SimulacrumCore",
                    "Tokens disponíveis: " .. (tokens or "Desconhecido") .. ", Tokens usados: " .. tokensUsados);
                if not linha then
                    sendMessage(
                        " Não foi possível obter a linha editável do jogador.", message.chat, "friend");
                    return;
                end
                Log.i("SimulacrumCore", "Linha editável do jogador: " .. (linha or "Desconhecido"));
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
                Log.i("Rank calculado: " .. rank);
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
            if (rUtils.startsWith(content, "Friend ")) then
                local prompt = content:sub(8):match("^%s*(.-)%s*$") -- Remove "Friend " prefix
                geminiCall(aiPrompt.friendPrompt(prompt), "friend", message.chat);
            end
            if (rUtils.startsWith(content, "geminiKey ") and message.mine) then
                local key = content:sub(10):match("^%s*(.-)%s*$") -- Remove "geminiKey " prefix
                if key and key ~= "" then
                    GEMINI_API_KEY = key;
                    sendMessage(" Chave Gemini definida com sucesso.", message.chat, "gemini");
                    Log.i("SimulacrumCore", "Chave Gemini definida: " .. GEMINI_API_KEY);
                else
                    sendMessage(" Chave Gemini inválida. Use: geminiKey <sua_chave>", message.chat, "gemini");
                    Log.e("SimulacrumCore", "Chave Gemini inválida recebida.");
                end
            end
            if (rUtils.startsWith(content, "gemini ")) then
                local prompt = content:sub(8):match("^%s*(.-)%s*$") -- Remove "gemini " prefix
                geminiCall(prompt, "gemini", message.chat);
            end
        end
    end
);
Log.i("SimulacrumCore-Main", "Plugin Simulacrum Core carregado.")
