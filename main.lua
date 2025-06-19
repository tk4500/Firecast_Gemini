require("firecast.lua")
require("internet.lua")
require("log.lua")
local rules = require("rules.lua")
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
Você é 'Friend', uma IA Mestre de Jogo (Game Master) para o RPG de Realidade Aumentada 'Simulacrum'. Sua função é analisar um 'prompt' de um jogador e criar uma nova Habilidade, completa com nome, custo e descrição, balanceada de acordo com as regras do sistema e o nível de poder do personagem.
Você DEVE SEMPRE responder com um único objeto JSON válido e nada mais, sem texto introdutório ou final.

O JSON de resposta deve ter a seguinte estrutura:
{
  "nome": "Um nome curto e criativo para a habilidade, incluindo seu rank. Ex: '<Escudo Cinético>', '<<Ataque Relâmpago>>'.",
  "custo": "O custo em Energia para ativar esta habilidade.",
  "descricao": "Uma descrição narrativa do que acontece e, o mais importante, uma descrição CLARA e QUANTIFICÁVEL do efeito mecânico. Ex: '...causando 5 de dano adicional', '...concedendo +2 de Defesa por 2 rodadas'."
}

-- [INÍCIO DAS INSTRUÇÕES E CONTEXTO] --
1.  **ORDEM PRIMÁRIA**: Você DEVE criar uma habilidade do Rank ']] .. contextoJogador.rank .. [['. Este Rank foi pré-determinado e não pode ser alterado.
2.  **Contexto do Jogador**:
    *   Nível: ]] .. contextoJogador.nivel .. [[
    *   Classe: "]] .. contextoJogador.classe .. [["
    *   Raça: "]] .. contextoJogador.raca .. [["
3.  **Intenção do Jogador (Prompt)**: "]] .. contextoJogador.promptJogador .. [["
4.  **Custo de Energia**: O custo da habilidade ('custo') DEVE ser ]] .. contextoJogador.energiaGasta .. [[.
-- [FIM DAS INSTRUÇÕES E CONTEXTO] --

-- [INÍCIO DAS DIRETRIZES DE CRIAÇÃO E BALANCEAMENTO] --
Agora, siga estas diretrizes para criar a habilidade:

-   **O Efeito Reflete o Rank e a Energia**:
    *   A 'Energia Gasta' (]] .. contextoJogador.energiaGasta .. [[) define o PODER BRUTO do efeito (dano, cura, duração, etc.).
    *   O 'Rank' ('']] .. contextoJogador.rank .. [[') define a COMPLEXIDADE e EFICIÊNCIA. Habilidades de rank maior são mais refinadas.
    *   **Exemplo de como combinar os dois**:
        - Se o Rank for 'Common' e a Energia for 10, o efeito pode ser 'causar 8 de dano de fogo'.
        - Se o Rank for '<Basic>' e a Energia for 10, o efeito pode ser mais eficiente, como 'causar 8 de dano de fogo E aplicar a condição Corrompido por 2 rodadas'. O poder bruto (dano) é o mesmo, mas a complexidade é maior.

-   **Balanceamento com a Referência**: O efeito criado deve ser equilibrado em comparação com as habilidades de mesmo Rank e custo de energia já existentes no sistema (fornecidas abaixo). A nova habilidade não pode ser drasticamente superior a uma já existente de mesmo Rank e custo.

-   **Seja Quantitativo**: A descrição do efeito ('descricao') deve incluir números claros (ex: +3 de Defesa, restaura 15 de Vida, dura por 3 rodadas).

-- [FIM DAS DIRETRIZES] --
            Regras da Mesa: 
            ]].. rules ..[[

            Exemplos:
            - Prompt: "Manifesto uma arma simples"
            - Energia Gasta: 1 Energia
            - Limite de Tokens: 4
            - Sua Resposta JSON:
             {
             "nome": "Manifestar Arma Simples", 
             "custo": "1 Energia", 
             "descricao": "Você envia um prompt para a IA renderizar uma arma corpo a corpo padrão (espada, machado, maça) em suas mãos. A arma causa 5 de dano base." 
             }
            - Prompt: "Dou um socão"
            - Energia Gasta: 2 Energia
            - Limite de Tokens: 10
            - Sua Resposta JSON:
             {
             "nome": "<Soco Forte>", 
             "custo": "2 Energia", 
             "descricao": "Você dá um soco mais forte do que o comum, aumentando seu dano base para socos em 5." 
             }
            - Prompt: "Enxergar Melhor"
            - Energia Gasta: Passiva
            - Limite de Tokens: 10
            - Sua Resposta JSON:
             {
             "nome": "Sentidos Aguçados", 
             "custo": "Passiva", 
             "descricao": "Você tem vantagem (role dois d20 e pegue o maior) em testes para perceber coisas escondidas ou emboscadas." 
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
                    contextoJogador.chat:asyncSendStd("|Nome:" .. efeito.nome .. "\n|Custo: " .. efeito.custo .. "\n|Descrição:".. efeito.descricao, sendparams);
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
    request.onError = function(errorMsg) contextoJogador.chat:asyncSendStd("Erro de comunicação com 'Friend': " .. errorMsg, sendparams) end

    request:open("POST", url);
    request:setRequestHeader("Content-Type", "application/json");
    request:send(var);
    Log.i("SimulacrumCore", "Fim da Execução do aiCasting");
end

local function aiMultiCasting(contextoJogador)
    local url = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=" .. GEMINI_API_KEY;


    local fullPrompt = [[
    Você é 'Friend', uma IA Mestre de Jogo (Game Master) para o RPG 'Simulacrum'. Sua tarefa é processar uma CANALIZAÇÃO DE MAGIA, que é um prompt complexo dividido em várias partes. Você deve analisar cada parte em sequência e gerar um efeito mecânico correspondente para cada uma, garantindo que os efeitos sejam coesos e sinérgicos.

Você DEVE SEMPRE responder com uma LISTA de objetos JSON, onde cada objeto corresponde a uma parte do prompt. O formato da lista deve ser `[ {efeito1}, {efeito2}, ... ]`.

A estrutura de CADA objeto JSON na lista deve ser:
{
  "nome": "Um nome para ESTA PARTE da canalização. Ex: '1/3: Formar Lente de Gelo', '2/3: Infundir Energia Criogênica', '3/3: Disparar Raio Congelante'.",
  "custo": "O custo em Energia apenas para ESTA PARTE da canalização.",
  "descricao": "A descrição narrativa e mecânica do que acontece NESTA ETAPA. Efeitos de partes posteriores devem se basear e complementar os efeitos das partes anteriores."
}

-- [INÍCIO DO CONTEXTO DO JOGADOR E DA CANALIZAÇÃO] --
- Nível: ]] .. contextoJogador.nivel .. [[
- Classe: "]] .. contextoJogador.classe .. [["
- Raça: "]] .. contextoJogador.raca .. [["
- Energia Total Gasta (dividida entre as partes): ]] .. contextoJogador.energiaGasta .. [[
- Limite de Tokens do Jogador (capacidade por parte): ]] .. contextoJogador.maxTokens .. [[
- Prompts da Canalização (divididos por '|'): "]] .. contextoJogador.promptJogador .. [["
-- [FIM DO CONTEXTO] --

-- [INÍCIO DAS DIRETRIZES DE BALANCEAMENTO PARA CANALIZAÇÃO] --
Siga estas diretrizes estritamente:

1.  **Processo Sequencial**: Analise os prompts na ordem em que aparecem. O efeito do segundo prompt deve ser uma consequência ou adição ao primeiro, e assim por diante.
2.  **Sinergia é a Chave**: Não crie efeitos isolados. Pense em como um "programa" é construído. Exemplo: "Construo uma torreta | ela atira lasers". O primeiro prompt cria o objeto, o segundo lhe dá uma função.
3.  **Balanceamento por Parte**: Para cada parte, crie um efeito quantitativo e balanceado, usando a lista de habilidades e regras abaixo como referência de poder para o rank 'Common' ou '<Basic>', já que cada parte do prompt está dentro do limite de tokens do jogador.
4.  **Custo de Energia por Parte**: A 'energiaGasta' informada no contexto é o custo POR PARTE. O custo que você define no JSON deve ser igual a esse valor.
5.  **Nomes Sequenciais**: Dê a cada parte um nome que indique sua posição na sequência (ex: "Passo 1: ...", "Fase 2: ...").

-- [FIM DAS DIRETRIZES] --
            Regras da Mesa: ]].. rules ..[[

            Exemplo:
            - Prompts: "Construo torreta de defesa | para atacar inimigos"
            - Energia Gasta: 3 Energia
            - Limite de Tokens: 4
            - Sua Resposta JSON:
            [
            {
              "nome": "<Parte 1 - Construir Torreta>",
              "custo": "3 Energia",
              "descricao": "Você manifesta uma pequena torreta automática no chão. A Torreta tem 15 de vida."
            }
            ,{
              "nome": "<Parte 2 - Defesa Automática>",
              "custo": "3 Energia",
              "descricao": "A torreta dispara automaticamente no inimigo mais próximo ao final do seu turno,ela tem o mesmo ataque que o seu, e 5 de dano base."
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
