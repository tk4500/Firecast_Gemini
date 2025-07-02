local sendRequest = require("gemini/sendRequest");
local typeConverter = require("firecast/typeConverter");
local Json = require("json.lua");
require("log.lua")
local sendMessage = require("firecast/sendMessage");

local function geminiCall(prompt, type, chat)
    local promise = sendRequest(prompt);
    promise:onSuccess(
        function(node)
            Log.i("SimulacrumCore-GeminiCall", "Resposta recebida do Gemini.");
            local responseJson = node;
            local sucess, resposta = pcall(Json.decode, responseJson);
            if not sucess then
                Log.e("SimulacrumCore-GeminiCall", "Erro ao processar resposta do Gemini: " .. responseJson);
                return;
            end
            if resposta.candidates[1].content.parts[1].text then
                local respostaDecodificada = resposta.candidates[1].content.parts[1].text;
                local mensagem, param = typeConverter(respostaDecodificada, type);
                if not mensagem or mensagem == "" then
                    Log.e("SimulacrumCore-GeminiCall", "Mensagem vazia ou inválida recebida do Gemini.");
                    return;
                end
                if chat.room.me.isMestre then
                    sendMessage(mensagem, chat, param);
                else
                    sendMessage(mensagem, chat);
                end
            else
                Log.e("SimulacrumCore-GeminiCall", "Resposta inválida do Gemini: " .. responseJson);
                return;
            end
        end
    )
    promise:onError(
        function(errorMsg)
            if chat.room.me.isMestre then
                if type == "gemini" then
                    sendMessage(" Erro de comunicação com Gemini: " .. errorMsg, chat, "gemini");
                else
                    sendMessage(" Erro de comunicação com Friend: " .. errorMsg, chat, "friend");
                end
            else
                sendMessage(
                    " Erro de comunicação com Gemini: " .. errorMsg, chat);
            end
        end
    )
end

return geminiCall