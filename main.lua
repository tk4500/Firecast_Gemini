require("firecast.lua")
require("internet.lua")
require("log.lua")
require("dialogs.lua");
local habilidade = require("habilidade.lua")
local aiPrompt = require("aiPrompt.lua")
local rUtils = require("token_utils.lua")
local Json = require("json.lua")
local GEMINI_API_KEY = "";
Log.i("SimulacrumCore", "Plugin Simulacrum Core carregado.")

local sendparams = {
    impersonation = {
        mode = "character",
        avatar = "https://blob.firecast.com.br/blobs/FKWRIAWO_3897632/Friend.gif",
        gender = "masculine",
        name = "[§B][§K0]F[§K15]ri[§K18]e[§K14]n[§K1]d",
    },
    talemarkOptions = {
        defaultTextStyle = {
            color = 1
        },
        parseCharActions = false,
        parseCharEmDashSpeech = false,
        parseCharQuotedSpeech = false,
        parseHeadings = false,
        parseHorzLines = false,
        parseInitialCaps = false,
        parseOutOfChar = false,
        trimTexts = false,
        parseSmileys = false,
    }
}

local geminiparams = {
    impersonation = {
        mode = "character",
        avatar = "https://blob.firecast.com.br/blobs/DNGTVLGU_3898181/6853782070044e5401b50d5c.jpg",
        gender = "masculine",
        name = "[§B][§K1]Gemini",
    },
    talemarkOptions = {
        defaultTextStyle = {
            color = 1,
            bold = true
        },
        parseSmileys = false,

    }
}


local function getPlayerFromChat(mensagem)
    local chat = mensagem.chat;
    local playerlogin = mensagem.logRec.entity.login
    local players = chat.room.jogadores;
    for i = 1, #players do
        local player = players[i];
        if player.login == playerlogin then
            return player;
        end
    end
    return nil; -- Jogador não encontrado
end

local function geminiCall(prompt, type, chat)
    local url = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=" ..
        GEMINI_API_KEY;
    local request = Internet.newHTTPRequest();
    local payload = { contents = { { parts = { { text = prompt } } } } }
    request.onResponse =
        function()
            Log.i("SimulacrumCore", "Resposta recebida do Gemini.");
            local responseJson = request.responseText;
            local sucess, resposta = pcall(Json.decode, responseJson);
            if not sucess then
                Log.e("SimulacrumCore", "Erro ao processar resposta do Gemini: " .. responseJson);
                return;
            end
            if resposta.candidates[1].content.parts[1].text then
                local respostaDecodificada = resposta.candidates[1].content.parts[1].text;
                if type == "gemini" then
                    local decodedYes = Internet.httpDecode(respostaDecodificada);
                    if chat.room.me.isMestre then
                        chat:asyncSendStd(decodedYes, geminiparams);
                    else
                        chat:asyncSendStd(" Resposta do Gemini: " .. decodedYes);
                    end
                elseif type == "friend" then
                    local decodedYes = Internet.httpDecode(respostaDecodificada);
                    if chat.room.me.isMestre then
                        chat:asyncSendStd(decodedYes, sendparams);
                    else
                        chat:asyncSendStd(" Resposta do Friend: " .. decodedYes);
                    end
                elseif type == "aiCasting" then
                    local respostaJson = respostaDecodificada:match("```json\n(.-)\n```") or
                        respostaDecodificada:match("```(.-)```") or
                        respostaDecodificada;
                    local sucesso, efeito = pcall(Json.decode, respostaJson);
                    if sucesso and efeito.nome and efeito.custo and efeito.descricao then
                        chat:asyncSendStd(
                            "|Nome:" ..
                            efeito.nome .. "\n|Custo: " .. efeito.custo .. "\n|Descrição:" .. efeito.descricao,
                            sendparams);
                        Log.i("SimulacrumCore",
                            "Efeito aplicado: " .. efeito.nome .. " com custo de energia: " .. efeito.custo);
                        Log.i("SimulacrumCore", "Descrição do efeito: " .. efeito.descricao);
                    else
                        chat:asyncSendStd(" Resposta inválida do Gemini. Verifique o formato JSON.",
                            sendparams);
                        Log.e("SimulacrumCore", "Resposta inválida do Gemini: " .. respostaJson);
                    end
                elseif type == "aiMulticasting" then
                    local respostaJson = respostaDecodificada:match("```json\n(.-)\n```") or
                        respostaDecodificada:match("```(.-)```") or
                        respostaDecodificada;
                    local sucesso, efeito = pcall(Json.decode, respostaJson);
                    if not sucesso then
                        chat:asyncSendStd(" Resposta inválida do Gemini. Verifique o formato JSON.",
                            sendparams);
                        Log.e("SimulacrumCore", "Resposta inválida do Gemini: " .. respostaJson);
                        return;
                    end
                    if type(efeito) == "table" and #efeito > 0 then
                        for i, efeitoItem in ipairs(efeito) do
                            if efeitoItem.nome and efeitoItem.custo and efeitoItem.descricao then
                                chat:asyncSendStd(
                                    "|Nome:" ..
                                    efeitoItem.nome ..
                                    "\n|Custo: " .. efeitoItem.custo .. "\n|Descrição:" .. efeitoItem.descricao,
                                    sendparams);
                            else
                                chat:asyncSendStd(" Resposta inválida do Gemini. Verifique o formato JSON.",
                                    sendparams);
                                Log.e("SimulacrumCore", "Resposta inválida do Gemini: " .. respostaJson);
                            end
                        end
                    else
                        chat:asyncSendStd(
                            " Resposta inválida do Gemini. Esperava uma lista de objetos JSON.", sendparams);
                        Log.e("SimulacrumCore", "Resposta inválida do Gemini: " .. respostaJson);
                    end
                else
                    Log.e("SimulacrumCore", "Tipo de resposta inválido: " .. type);
                    return;
                end
            else
                Log.e("SimulacrumCore", "Resposta inválida do Gemini: " .. responseJson);
                return;
            end
        end
    request.onError = function(errorMsg)
        if chat.room.me.isMestre then
            if type == "gemini" then
                chat:asyncSendStd(" Erro de comunicação com Gemini: " .. errorMsg, geminiparams);
            else
                chat:asyncSendStd(" Erro de comunicação com Friend: " .. errorMsg, sendparams);
            end
        else
            chat:asyncSendStd(" Erro de comunicação com Gemini: " .. errorMsg);
        end
    end

    request:open("POST", url);
    request:setRequestHeader("Content-Type", "application/json");
    request:send(Json.encode(payload));
end
local function splitContext(contextoJogador)
    local tokens = contextoJogador.maxTokens;
    local prompt = contextoJogador.promptJogador;
    local energiaGasta = contextoJogador.energiaGasta;
    local prompts = rUtils.promptSplitter(prompt, tokens);
    if #prompts == 0 then
        contextoJogador.chat:asyncSendStd(" Não foi possível dividir o prompt. Verifique o tamanho do prompt.",
            sendparams);
        return;
    end
    contextoJogador.chat:asyncSendStd(" Prompt dividido em " .. #prompts .. " partes.", sendparams);
    contextoJogador.promptJogador = "";
    for i = 1, #prompts do
        if (contextoJogador.promptJogador == "") then
            contextoJogador.promptJogador = prompts[i];
        else
            contextoJogador.promptJogador = contextoJogador.promptJogador .. " | " .. prompts[i];
        end
    end
    if type(contextoJogador.energiaGasta) == "number" then
        local energiaDividida = math.floor(energiaGasta / #prompts);
        contextoJogador.energiaGasta = energiaDividida;
    end
    local prompt = aiPrompt.getAiMultiCasting(contextoJogador);
    geminiCall(prompt, "aiMulticasting", contextoJogador.chat);
end

Firecast.Messaging.listen(
    "HandleChatCommand",
    function(message)
        if message.command == "geminiKey" then
            local key = message.parameter
            if key and key ~= "" then
                GEMINI_API_KEY = key;
                message.chat:writeEx(" Chave Gemini definida com sucesso.", sendparams);
                Log.i("SimulacrumCore", "Chave Gemini definida: " .. GEMINI_API_KEY);
            else
                message.chat:writeEx(" Chave Gemini inválida. Use: geminiKey <sua_chave>", sendparams);
                Log.e("SimulacrumCore", "Chave Gemini inválida recebida.");
            end
            message.response = { handled = true };
        end

        if message.command == "getSkill" then
            local login = message.parameter;
            habilidade.getSkills(login, message.chat.room);
            message.response = { handled = true };
        end

        if message.command == "skillFusion" then
            local login = message.parameter;
            local list, habilidades = habilidade.skillFusion(login, message.chat.room);
            local listNames = {};
            for i, skill in ipairs(list) do
                table.insert(listNames, skill.nome .. " (" .. skill.rank .. ")");
            end
            
            Dialogs.choose("Selecione a habilidade base para a fusão:", listNames,
                function(selected, selectedIndex, selectedText)
                    if selected and habilidades then
                        local selectedNode = list[selectedIndex];
                        local baseSkill = NDB.getAttributes(selectedNode);
                        table.remove(list, selectedIndex);
                        table.remove(listNames, selectedIndex);
                        NDB.deleteNode(selectedNode);
                        local rank = habilidade.ranks[baseSkill.rank];
                        if not rank then
                            message.chat:writeEx("Rank inválido: " .. baseSkill.rank);
                            local skill = NDB.createChildNode(habilidades, baseSkill.nome)
                            skill.nome = baseSkill.nome
                            skill.rank = baseSkill.rank
                            skill.custo = baseSkill.custo
                            skill.descricao = baseSkill.descricao
                            return;
                        end
                        Dialogs.chooseMultiple("Selecione as habilidades a serem fundidas:",
                            listNames,
                            function(selected, selectedIndexes, selectedTexts)
                                if selected then
                                    local fusionSkills = {};
                                    for i, index in ipairs(selectedIndexes) do
                                        local skill = NDB.getAttributes(list[index]);
                                        if skill then
                                            table.insert(fusionSkills, skill);
                                            NDB.deleteNode(list[index]);
                                        end
                                    end
                                    if #fusionSkills == 0 then
                                        message.chat:writeEx("Nenhuma habilidade selecionada para fusão.");
                                        return;
                                    end
                                    local ph = 0;
                                    for k, v in pairs(fusionSkills) do
                                        local valor = habilidade.ranks[v.rank];
                                        if valor then
                                            ph = ph + valor;
                                        else
                                            Log.e("SimulacrumCore", "Rank inválido: " .. v.rank);
                                        end
                                    end
                                    if ph == 0 then
                                        message.chat:writeEx("Nenhum PH calculado para as habilidades selecionadas.");
                                    end
                                    local isRankUp = ph >= math.random(rank);
                                    local jogador = message.chat.room:findJogador(login);
                                    local linha = jogador:getEditableLine(1);
                                    local nivel, raca, classe = linha:match("Level%s*(%d+)%s*|%s*([^|]+)%s*|%s*(.+)");

                                    local contextoJogador = {
                                        nivel = tonumber(nivel) or 1,
                                        classe = classe:match("^%s*(.-)%s*$") or "Classe",
                                        raca = raca:match("^%s*(.-)%s*$") or "Raça",
                                        rankUp = isRankUp,
                                        baseSkill = baseSkill,
                                        fusionSkills = fusionSkills
                                    }
                                    local prompt = aiPrompt.getAiFusion(contextoJogador);
                                    geminiCall(prompt, "aiCasting", message.chat);
                                    Log.i("SimulacrumCore", "Prompt de fusão enviado");
                                else
                                    local skill = NDB.createChildNode(habilidades, baseSkill.nome)
                                    skill.nome = baseSkill.nome
                                    skill.rank = baseSkill.rank
                                    skill.custo = baseSkill.custo
                                    skill.descricao = baseSkill.descricao
                                end
                            end)
                    end
                end)
            message.response = { handled = true };
        end
    end)

Firecast.Messaging.listen("ChatMessageEx",
    function(message)
        if message.logRec.msg.content then
            local content = message.logRec.msg.content;
            Log.i("SimulacrumCore", "ChatMessageEx received: " .. content);
            if (rUtils.startsWith(content, "Friend:")) then
                local promptEnergia = content:sub(8):match("^%s*(.-)%s*$") -- Remove "Friend:" prefix e espaços
                local prompt, energiaStr = promptEnergia:match("^(.-)%s*%((.-)%)%s*$")
                if not prompt or not energiaStr or energiaStr == "" then
                    message.chat:asyncSendStd(" Formato inválido. Use: Friend: <prompt> (<energia>)", sendparams);
                    return;
                end
                local energiaGasta = energiaStr;
                if not energiaGasta then
                    message.chat:asyncSendStd(" Energia inválida.", sendparams);
                    return;
                end
                local tokensUsados = rUtils.contarTokens(prompt);
                local jogador = getPlayerFromChat(message);
                Log.i("SimulacrumCore", "Jogador encontrado: " .. (jogador and jogador.login or "Desconhecido"));
                if not jogador then
                    message.chat:asyncSendStd(" Jogador não encontrado no chat.", sendparams);
                    return;
                end
                local tokens = jogador:getBarValue(3);
                local linha = jogador:getEditableLine(1);
                Log.i("SimulacrumCore",
                    "Tokens disponíveis: " .. (tokens or "Desconhecido") .. ", Tokens usados: " .. tokensUsados);
                if not linha then
                    message.chat:asyncSendStd(" Não foi possível obter a linha editável do jogador.", sendparams);
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

                local contextoJogador = {
                    nivel = nivel,
                    classe = classe,
                    raca = raca,
                    energiaGasta = energiaGasta,
                    tokensUsados = tokensUsados,
                    rank = rank,
                    maxTokens = tokens,
                    promptJogador = prompt,
                    chat = message.chat
                };
                if tokensUsados > tokens then
                    splitContext(contextoJogador);
                    return;
                end
                local prompt = aiPrompt.getAiCasting(contextoJogador);
                geminiCall(prompt, "aiCasting", message.chat);
            end
            if (rUtils.startsWith(content, "Friend ")) then
                local prompt = content:sub(8):match("^%s*(.-)%s*$") -- Remove "Friend " prefix
                geminiCall(prompt, "friend", message.chat);
            end
            if (rUtils.startsWith(content, "geminiKey ") and message.mine) then
                local key = content:sub(10):match("^%s*(.-)%s*$") -- Remove "geminiKey " prefix
                if key and key ~= "" then
                    GEMINI_API_KEY = key;
                    message.chat:asyncSendStd(" Chave Gemini definida com sucesso.", sendparams);
                    Log.i("SimulacrumCore", "Chave Gemini definida: " .. GEMINI_API_KEY);
                else
                    message.chat:asyncSendStd(" Chave Gemini inválida. Use: geminiKey <sua_chave>", sendparams);
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
