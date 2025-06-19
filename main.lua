require("firecast.lua")
require("internet.lua")
require("log.lua")
local rules = require("rules.lua")
local Json = require("json.lua")
local GEMINI_API_KEY = "";
Log.i("SimulacrumCore", "Plugin Simulacrum Core carregado.")

local sendparams = {
impersonation = {
    mode = "character",
    avatar = "https://blob.firecast.com.br/blobs/FKWRIAWO_3897632/Friend.gif",
    gender = "masculine",
    name = "[§B][§K0]F[§K15]ri[§K18]e[§K14]n[§K1]d",
},talemarkOptions = {
    defaultTextStyle = {
        color = 1,
        bold = true
    },
    parseCharActions = false,
    parseCharEmDashSpeech = false,
    parseCharQuotedSpeech = false,
    parseCommonMarkStrongEmphasis = false,
    parseHeadings = false,
    parseHorzLines = false,
    parseInitialCaps = false,
    parseOutOfChar = false,
    trimTexts = false,
}
}

local geminiparams = {
    impersonation = {
    mode = "character",
    avatar = "https://blob.firecast.com.br/blobs/DNGTVLGU_3898181/6853782070044e5401b50d5c.jpg",
    gender = "masculine",
    name = "[§B][§K1]Gemini",
},talemarkOptions = {
    defaultTextStyle = {
        color = 1,
        bold = true
    },
    parseSmileys = false,
    
}
}


local function startsWith(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end
-- Função para contar palavras (tokens) em uma string.
local function contarTokens(str)
    local count = 0
    for _ in string.gmatch(str, "%S+") do
        count = count + 1
    end
    return count
end

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

local function gemini(prompt, chat)
    local url = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=" .. GEMINI_API_KEY;
    local request = Internet.newHTTPRequest();
    local encodedPrompt = Internet.httpEncode(prompt);
    local payload = { contents = { { parts = { { text = encodedPrompt } } } } }
    request.onResponse =
        function()
            Log.i("SimulacrumCore", "Resposta recebida do Gemini.");
            local responseJson = request.responseText;
            Log.i("SimulacrumCore", "Resposta do Gemini: " .. responseJson);
            local sucess, resposta = pcall(Json.decode, responseJson);
            if not sucess then
                chat:asyncSendStd(" Erro ao processar resposta do Gemini: " .. responseJson, geminiparams);
                Log.e("SimulacrumCore", "Erro ao processar resposta do Gemini: " .. responseJson);
                return;
            end
            if resposta.candidates[1].content.parts[1].text then
                local yes = resposta.candidates[1].content.parts[1].text;
                local decodedYes = Internet.httpDecode(yes);
                if chat.room.me.isMestre then
                    chat:asyncSendStd( decodedYes , geminiparams);
                else
                    chat:asyncSendStd(" Resposta do Gemini: " .. decodedYes);
                end
            else
                chat:asyncSendStd(" Resposta inválida do Gemini. Esperava um objeto JSON.", sendparams);
                Log.e("SimulacrumCore", "Resposta inválida do Gemini: " .. responseJson);
            end
        end;
    request:open("POST", url);
    request:setRequestHeader("Content-Type", "application/json");
    request:send(Json.encode(payload));
end


local function aiCasting(contextoJogador)
    local url = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=" .. GEMINI_API_KEY;

    local fullPrompt = [[
            Você é 'Friend', uma IA Mestre de Jogo para o RPG de Realidade Aumentada 'Simulacrum'. Sua função é analisar um 'prompt' de um jogador e descrever o efeito mágico resultante.
            Você DEVE SEMPRE responder com um único objeto JSON válido.

            O JSON de resposta deve ter a seguinte estrutura:
            {
              "nome": "Um nome curto e criativo para a habilidade. Ex: 'Escudo Cinético(7 tokens)', 'Lâmina Espectral(10 tokens)'.",
              "custo": "Um número inteiro representando a energia gasta pelo jogador para executar o efeito. Ex: 30, 50, 100.",
              "descricao": "Uma descrição narrativa e vívida do que acontece. A intensidade do efeito DEVE ser proporcional à energia gasta e à complexidade (tokens) do prompt, dentro dos limites do jogador."
            }

            Contexto do Jogador:
            - Nível: ]] .. contextoJogador.nivel .. [[
            - Classe: "]] .. contextoJogador.classe .. [["
            - Raça: "]] .. contextoJogador.raca .. [["
            - Energia Gasta no Prompt: ]] .. contextoJogador.energiaGasta .. [[
            - Complexidade do Prompt (Tokens Usados): ]] .. contextoJogador.tokensUsados .. [[
            - Limite de Tokens do Jogador (Largura de Banda): ]] .. contextoJogador.maxTokens .. [[

            Suas diretrizes:
            1. Analise o prompt do jogador: "]] .. contextoJogador.promptJogador .. [["
            2. O jogador está gastando ]] ..
        contextoJogador.tokensUsados .. [[ tokens de um limite de ]] .. contextoJogador.maxTokens .. [[.
            3. A energia gasta de ]] .. contextoJogador.energiaGasta .. [[ é o "combustível".
            4. Descreva um efeito ('descricao') cuja escala e poder sejam CONSISTENTES com o nivel de poder do personagem e a energia gasta. Deve ser principalmente algo que o personagem conseguiria fazer com aquela quantidade de energia , mas com um toque de criatividade, prefira dar focos a bonus ou efeitos quantificados.
            5. Crie um 'nome' adequado para cada ação.
            6. Para o efeito, leve em conta principalmente a capacidade de tokens do jogador, e não tanto a quantidade que ele usou no prompt. O jogador pode usar mais de um prompt, mas o efeito deve ser coerente com a energia gasta.

            Regras da Mesa: ]].. rules ..[[

            Exemplos:
            - Prompt: "Manifesto uma arma simples" (4 tokens)
            - Energia Gasta: 1 Energia
            - Limite de Tokens: 10
            - Sua Resposta JSON:
             {
             "nome": "Manifestar Arma Simples(4 tokens)", 
             "custo": "1", 
             "descricao": "Você envia um prompt para a IA renderizar uma arma corpo a corpo padrão (espada, machado, maça) em suas mãos. A arma causa 5 de dano base." 
             }
            - Prompt: "Realizo um golpe poderoso" (4 tokens)
            - Energia Gasta: 2 Energia
            - Limite de Tokens: 10
            - Sua Resposta JSON:
             {
             "nome": "Golpe Poderoso(4 tokens)", 
             "custo": "2", 
             "descricao": "Executa um protocolo de ataque que adiciona +3 ao seu dano base no próximo golpe corpo a corpo." 
             }

            Agora, analise o prompt do jogador e forneça a resposta JSON correspondente.
        ]]
    local request = Internet.newHTTPRequest();
    local payload = { contents = { { parts = { { text = fullPrompt } } } } }
    request.onResponse =
        function()
            Log.i("SimulacrumCore", "Resposta recebida do Gemini.");
            local responseJson = request.responseText;
            local sucess, resposta = pcall(Json.decode, responseJson);
            Log.i("SimulacrumCore", "Resposta do Gemini: " .. responseJson);
            if not sucess then
                contextoJogador.chat:asyncSendStd(" Erro ao processar resposta do Gemini: " .. responseJson, sendparams);
                Log.e("SimulacrumCore", "Erro ao processar resposta do Gemini: " .. responseJson);
                return;
            end
            if resposta.candidates[1].content.parts[1].text then
                local respostaJson = resposta.candidates[1].content.parts[1].text;
                 respostaJson = respostaJson:match("```json\n(.-)\n```") or respostaJson:match("```(.-)```") or respostaJson;
                Log.i("SimulacrumCore", "Resposta JSON do Gemini: " .. respostaJson);
                local sucesso, efeito = pcall(Json.decode, respostaJson);
                Log.i("SimulacrumCore", "Efeito decodificado: " .. tostring(sucesso));
                Log.i("SimulacrumCore", "Efeito: " .. tostring(efeito));
                if sucesso and efeito.nome and efeito.custo and efeito.descricao then
                    contextoJogador.chat:asyncSendStd("|Nome:" .. efeito.nome .. "\n|Custo: " .. efeito.custo .. " Energia\n|Descrição:".. efeito.descricao, sendparams);
                    Log.i("SimulacrumCore", "Efeito aplicado: " .. efeito.nome .. " com custo de energia: " .. efeito.custo);
                    Log.i("SimulacrumCore", "Descrição do efeito: " .. efeito.descricao);
                else
                    contextoJogador.chat:asyncSendStd(" Resposta inválida do Gemini. Verifique o formato JSON.", sendparams);
                    Log.e("SimulacrumCore", "Resposta inválida do Gemini: " .. respostaJson);
                end
            else
                contextoJogador.chat:asyncSendStd(" Resposta inválida do Gemini. Esperava um objeto JSON.", sendparams);
                Log.e("SimulacrumCore", "Resposta inválida do Gemini: " .. responseJson);
            end
        end;
    local var = Json.encode(payload);
    Log.i("SimulacrumCore", "Payload enviado: " .. var);
    request.onError = function(errorMsg) contextoJogador.chat:asyncSendStd("Erro de comunicação com 'Friend': " .. errorMsg, sendparams) end

    request:open("POST", url);
    request:setRequestHeader("Content-Type", "application/json");
    request:send(var);
    Log.i("SimulacrumCore", "Fim da Execução do aiCasting");
end

local function aiMultiCasting(contextoJogador)
    local url = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=" .. GEMINI_API_KEY;


    local fullPrompt = [[
            Você é 'Friend', uma IA Mestre de Jogo para o RPG de Realidade Aumentada 'Simulacrum'. Sua função é analisar um conjunto de 'prompts' de um jogador e descrever o efeito mágico resultante.
            Você DEVE SEMPRE responder com uma única lista de objetos JSON válida.

            O JSON de resposta deve ter a seguinte estrutura:
            {
              "nome": "Um nome curto e criativo para a habilidade. Ex: 'Escudo Cinético(7 tokens)', 'Lâmina Espectral(10 tokens)'.",
              "custo": "Um número inteiro representando a energia gasta pelo jogador para executar o efeito. Ex: 30, 50, 100.",
              "descricao": "Uma descrição narrativa e vívida do que acontece. A intensidade do efeito DEVE ser proporcional à energia gasta e à complexidade (tokens) do prompt, dentro dos limites do jogador."
            }

            Contexto do Jogador:
            - Nível: ]] .. contextoJogador.nivel .. [[
            - Classe: "]] .. contextoJogador.classe .. [["
            - Raça: "]] .. contextoJogador.raca .. [["
            - Energia Gasta no Prompt: ]] .. contextoJogador.energiaGasta .. [[
            - Limite de Tokens do Jogador (Largura de Banda): ]] .. contextoJogador.maxTokens .. [[

            Suas diretrizes:
            1. Analise os prompts do jogador: "]] .. contextoJogador.promptJogador .. [["
            2. Calcule a quantia de tokens por prompt de um limite de ]] .. contextoJogador.maxTokens .. [[.
            3. A energia gasta de ]] .. contextoJogador.energiaGasta .. [[ por prompt é o "combustível".
            4. Descreva um efeito ('descricao') cuja escala e poder sejam CONSISTENTES com o nivel de poder do personagem e a energia gasta. Deve ser principalmente algo que o personagem conseguiria fazer com aquela quantidade de energia , mas com um toque de criatividade, prefira dar focos a bonus ou efeitos quantificados.
            5. Crie um 'nome' adequado para cada ação.
            6. Para o efeito, leve em conta principalmente a capacidade de tokens do jogador, e não tanto a quantidade que ele usou no prompt. O jogador pode usar mais de um prompt, mas o efeito deve ser coerente com a energia gasta.

            Regras da Mesa: ]].. rules ..[[

            Exemplo:
            - Prompts: "Construo torreta de defesa | para atacar inimigos" (4 + 3 tokens)
            - Energia Gasta: 3 Energia
            - Limite de Tokens: 4
            - Sua Resposta JSON:
            [
            {
              "nome": "Construir Torreta(4 tokens)",
              "custo": 3,
              "descricao": "Você manifesta uma pequena torreta automática no chão. A Torreta tem 10 de vida."
            }
            ,{
              "nome": "Defesa Automática(3 tokens)",
              "custo": 3,
              "descricao": "A torreta dispara automaticamente no inimigo mais próximo ao final do seu turno,ela tem o mesmo ataque que o seu, e 3 de dano base."
            }
            ]

            Agora, analise o prompt do jogador e forneça a resposta JSON correspondente.
        ]]

    local request = Internet.newHTTPRequest();
    local payload = { contents = { { parts = { { text = fullPrompt } } } } }
    request.onResponse =
        function()
            Log.i("SimulacrumCore", "Resposta recebida do Gemini.");
            local responseJson = request.responseText;
            local sucess, resposta = pcall(Json.decode, responseJson);
            Log.i("SimulacrumCore", "Resposta do Gemini: " .. responseJson);
            if not sucess then
                contextoJogador.chat:asyncSendStd(" Erro ao processar resposta do Gemini: " .. responseJson, sendparams);
                Log.e("SimulacrumCore", "Erro ao processar resposta do Gemini: " .. responseJson);
                return;
            end
            if resposta.candidates[1].content.parts[1].text then
                local respostaJson = resposta.candidates[1].content.parts[1].text;
                 respostaJson = respostaJson:match("```json\n(.-)\n```") or respostaJson:match("```(.-)```") or respostaJson;
                Log.i("SimulacrumCore", "Resposta JSON do Gemini: " .. respostaJson);
                local sucesso, efeito = pcall(Json.decode, respostaJson);
                Log.i("SimulacrumCore", "Efeito decodificado: " .. tostring(sucesso));
                Log.i("SimulacrumCore", "Efeito: " .. tostring(efeito));
                    if not sucesso then
                        contextoJogador.chat:asyncSendStd(" Resposta inválida do Gemini. Verifique o formato JSON.", sendparams);
                        Log.e("SimulacrumCore", "Resposta inválida do Gemini: " .. respostaJson);
                        return;
                    end
                    if type(efeito) == "table" and #efeito > 0 then
                        for i, efeitoItem in ipairs(efeito) do
                            if efeitoItem.nome and efeitoItem.custo and efeitoItem.descricao then
                               contextoJogador.chat:asyncSendStd("|Nome:" .. efeitoItem.nome .. "\n|Custo: " .. efeitoItem.custo .. " Energia\n|Descrição:".. efeitoItem.descricao, sendparams);
                            else
                                contextoJogador.chat:asyncSendStd(" Resposta inválida do Gemini. Verifique o formato JSON.", sendparams);
                                Log.e("SimulacrumCore", "Resposta inválida do Gemini: " .. respostaJson);
                            end
                        end
                    else
                        contextoJogador.chat:asyncSendStd(" Resposta inválida do Gemini. Esperava uma lista de objetos JSON.", sendparams);
                        Log.e("SimulacrumCore", "Resposta inválida do Gemini: " .. respostaJson);
                    end
            else
                contextoJogador.chat:asyncSendStd(" Resposta inválida do Gemini. Esperava um objeto JSON.", sendparams);
                Log.e("SimulacrumCore", "Resposta inválida do Gemini: " .. responseJson);
            end
        end;
    request.onError = function(errorMsg) contextoJogador.chat:asyncSendStd("Erro de comunicação com 'Friend': " .. errorMsg, sendparams) end
    
    request:open("POST", url);
    request:setRequestHeader("Content-Type", "application/json");
    request:send(Json.encode(payload));
    Log.i("SimulacrumCore", "Fim da Execução do aiMultiCasting");
end

local function promptSplitter(prompt, maxTokens)
    local prompts = {}
    local palavras = {}
    for palavra in prompt:gmatch("%S+") do
        table.insert(palavras, palavra)
    end
    local currentPrompt = ""
    for i, palavra in ipairs(palavras) do
        if (currentPrompt == "") then
            currentPrompt = palavra;
        else
            currentPrompt = currentPrompt .. " " .. palavra;
        end
        local tokensUsados = contarTokens(currentPrompt)
        if tokensUsados >= maxTokens then
            table.insert(prompts, currentPrompt)
            currentPrompt = "";
        end
    end
    if currentPrompt ~= "" then
        table.insert(prompts, currentPrompt)
    end
    return prompts
end
local function splitContext(contextoJogador)
    local tokens = contextoJogador.maxTokens;
    local prompt = contextoJogador.promptJogador;
    local energiaGasta = contextoJogador.energiaGasta;
    local prompts = promptSplitter(prompt, tokens);
    if #prompts == 0 then
        contextoJogador.chat:asyncSendStd(" Não foi possível dividir o prompt. Verifique o tamanho do prompt.", sendparams);
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
    local energiaDividida = math.floor(energiaGasta / #prompts);
    contextoJogador.energiaGasta = energiaDividida;
    aiMultiCasting(contextoJogador);
end


Firecast.Messaging.listen("ChatMessageEx",
    function(message)
        if message.logRec.msg.content then
            local content = message.logRec.msg.content;
            Log.i("SimulacrumCore", "ChatMessageEx received: " .. content);
            if (startsWith(content, "Friend:")) then
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
                local tokensUsados = contarTokens(prompt);
                local jogador = getPlayerFromChat(message);
                Log.i("SimulacrumCore", "Jogador encontrado: " .. (jogador and jogador.login or "Desconhecido"));
                if not jogador then
                    message.chat:asyncSendStd(" Jogador não encontrado no chat.", sendparams);
                    return;
                end
                local tokens = jogador:getBarValue(3);
                local linha = jogador:getEditableLine(1);
                Log.i("SimulacrumCore", "Tokens disponíveis: " .. (tokens or "Desconhecido") .. ", Tokens usados: " .. tokensUsados);
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

                local contextoJogador = {
                    nivel = nivel,
                    classe = classe,
                    raca = raca,
                    energiaGasta = energiaGasta,
                    tokensUsados = tokensUsados,
                    maxTokens = tokens,
                    promptJogador = prompt,
                    chat = message.chat
                };
                if tokensUsados > tokens then
                    splitContext(contextoJogador);
                    return;
                end
                aiCasting(contextoJogador);
            end
            if(startsWith(content, "geminiKey ") and message.mine) then
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
            if(startsWith(content, "gemini ")) then
                local prompt = content:sub(8):match("^%s*(.-)%s*$") -- Remove "gemini " prefix
                gemini(prompt, message.chat);
            end
        end
    end
);
