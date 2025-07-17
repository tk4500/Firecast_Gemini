local sendRequest = require("gemini/sendRequest");
local typeConverter = require("firecast/typeConverter");
local Json = require("json.lua");
require("log.lua")
local sendMessage = require("firecast/sendMessage");

local function decodeJson(text)
    local respostaJson = text:match("```json\n(.-)\n```") or
        text:match("```(.-)```") or
        text;
    local sucesso, efeito = pcall(Json.decode, respostaJson);
    return sucesso, efeito
end

local function combatCall(prompt, chat)
    local promise = sendRequest(prompt);
    local sucesso, response = pawait(promise);
    if not sucesso then
        Log.e("SimulacrumCore-CombatCall", "Erro ao enviar pedido de combate: " .. response);
        sendMessage(" Erro ao enviar pedido de combate: " .. response, chat, "friend");
        return;
    end
    local sucess, resposta = pcall(Json.decode, response);
    if not sucess then
        Log.e("SimulacrumCore-CombatCall", "Erro ao processar resposta do Combat: " .. response);
        return;
    end
    if resposta.candidates[1].content.parts[1].text then
                local respostaDecodificada = resposta.candidates[1].content.parts[1].text;
                local sucesso, finalJson = decodeJson(respostaDecodificada);
        if not sucesso then
            Log.e("SimulacrumCore-CombatCall", "Erro ao decodificar JSON de resposta do Combat: " .. respostaDecodificada);
            return;
        end
        return finalJson;
    else
        Log.e("SimulacrumCore-CombatCall", "Resposta inválida do Combat: " .. response);
        return;
    end
end

return combatCall;
