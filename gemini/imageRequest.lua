-- Requisita as bibliotecas necessárias
require("internet.lua")
require("utils.lua")
local Json = require("json.lua")
local sendMessage = require("firecast/sendMessage.lua")
require("async.lua")
require("fireDrive.lua")
require("gemini/setGeminiKey.lua")

-- Função para fazer upload da imagem gerada para o FireDrive (sem alterações)
local function uploadImagemGerada(jsonTable, chat, prompt)
    -- ... (código da sua função 'imageRequest' original, renomeada para clareza)
    Log.i("SimulacrumCore-Upload", "Processando resposta de imagem do Gemini.");
    local base64Data = nil
    local mimeType = nil
    for _, item in ipairs(jsonTable) do
        if item.candidates and item.candidates[1] and item.candidates[1].content and item.candidates[1].content.parts then
            for _, part in ipairs(item.candidates[1].content.parts) do
                if part.inlineData and part.inlineData.data then
                    base64Data, mimeType = part.inlineData.data, part.inlineData.mimeType
                    break
                end
            end
        end
        if base64Data then break end
    end

    if not base64Data or not mimeType then
        Log.i("SimulacrumCore-Upload", "Não foi possível encontrar dados de imagem válidos na resposta do Gemini.")
        sendMessage("Gemini: Não consegui gerar a imagem a partir da resposta da IA.", chat)
        return
    end

    local streamImagem = Utils.newMemoryStream()
    streamImagem:writeBase64(base64Data)
    streamImagem.position = 0
    local nomeDoArquivo = prompt:gsub("[^%w]", "_"):sub(1, 50) .. ".png"

    FireDrive.quickUpload(nomeDoArquivo, mimeType, streamImagem,
        function(fireItem)
            if fireItem and fireItem.url then
                local msg = "[§I" .. fireItem.url .. "]"
                sendMessage(msg, chat, "gemini")
            else
                Log.e("SimulacrumCore-Upload", "Erro no upload para o FireDrive: fireItem inválido.")
                sendMessage("Gemini: Erro ao fazer upload da imagem gerada.", chat)
            end
        end,
        nil,
        function(err)
            Log.e("SimulacrumCore-Upload", "Falha no upload para o FireDrive: " .. tostring(err))
            sendMessage("Gemini: Falha ao fazer upload da imagem gerada.", chat)
        end
    )
end

local function sendRequest(prompt, chat)
    Log.i("SimulacrumCore-Gemini", "Iniciando requisição para Gemini.")
    local url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-preview-image-generation:streamGenerateContent?key=" ..
        GEMINI_API_KEY

    local payload = {
        contents = { { parts = {} } }, -- Inicializa parts como uma tabela vazia
        generationConfig = { responseModalities = { "IMAGE", "TEXT" } }
    }

    -- Verifica se o prompt contém uma imagem para ser usada como entrada
    if string.find(prompt, "%[§I") then
        Log.i("SimulacrumCore-Gemini", "Detectada imagem no prompt. Preparando para envio multimodal.")
        local imageLink = prompt:match("%[§I%s*(.-)%]")
        local cleanPrompt = prompt:gsub("%[§I%s*.-%]", ""):gsub("^%s+", ""):gsub("%s+$", "")

        -- AWAIT: Baixa a imagem de forma assíncrona
        local stream, mimeType = await(Internet.asyncDownload(imageLink))

        if not stream then
            Log.e("SimulacrumCore-Gemini", "Falha ao baixar a imagem de entrada: " .. imageLink)
            sendMessage("Gemini: Falha ao baixar a imagem que você enviou.", chat)
            payload.contents[1].parts = { { text = cleanPrompt } }
        else
            Log.i("SimulacrumCore-Gemini", "Stream" .. tostring(stream) .. " MIME Type: " .. tostring(mimeType));
            local base64Data = stream:readAsBase64(stream.size)
            local clean64 = base64Data:gsub("[\r\n]", "")
            stream:close();
            Log.i("SimulacrumCore-Gemini", "Imagem de entrada convertida para Base64.")
            -- Monta o payload multimodal
            payload.contents[1].parts = {
                { inlineData = { data = clean64, mimeType = mimeType } },
                { text = cleanPrompt }
            }
        end
    else
        -- Payload simples, apenas com texto
        payload.contents[1].parts = { { text = prompt } }
    end

    -- Cria e configura a requisição HTTP
    local request = Internet.newHTTPRequest()

    request.onResponse = function()
        -- Lógica para ler e processar a resposta em stream (mantida da versão anterior)
        local responseStream = request.responseStream
        local buffer, chars = {}, {}
        local bytesLidos = responseStream:read(buffer, responseStream.size)

        if bytesLidos > 0 then
            for i = 1, bytesLidos do
                chars[i] = string.char(buffer[i])
            end
            local responseText = table.concat(chars)

            local success, data = pcall(Json.decode, responseText)
            if success then
                uploadImagemGerada(data, chat, prompt)
            else
                Log.e("SimulacrumCore-Gemini", "Erro ao decodificar JSON: " .. tostring(data))
                sendMessage("Gemini: Não consegui entender a resposta da IA.", chat)
            end
        else
            Log.e("SimulacrumCore-Gemini", "A resposta da API estava vazia.")
            sendMessage("Gemini: A IA retornou uma resposta vazia.", chat)
        end
    end

    request.onError = function(err)
        Log.e("SimulacrumCore-Gemini",
            "Erro na requisição: " .. tostring(err) .. " | Status: " .. tostring(request.statusText))
        Log.e("SimulacrumCore-Gemini", "Resposta do erro: " .. tostring(request.responseText))
        sendMessage("Gemini: Houve um erro de comunicação com a IA.", chat)
    end

    request:open("POST", url)
    request:setRequestHeader("Content-Type", "application/json")
    request:send(Json.encode(payload))
end

return sendRequest
