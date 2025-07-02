require("internet.lua");
local Json = require("json.lua");
local function aiCastingmsg(efeito)
    if not efeito or not efeito.nome or not efeito.custo or not efeito.descricao then
        Log.e("SimulacrumCore-typeConverter", "Efeito inválido: " .. tostring(efeito));
        return "Efeito inválido. Verifique o formato JSON.";
    end
    return "|Nome:" ..
        efeito.nome ..
        "\n|Custo: " .. efeito.custo .. "\n|Descrição:" .. efeito.descricao
end

local function decodeJson(text)
    local respostaJson = text:match("```json\n(.-)\n```") or
        text:match("```(.-)```") or
        text;
    local sucesso, efeito = pcall(Json.decode, respostaJson);
    return sucesso, efeito
end

local function typeConverter(text, tipo)
    if (tipo == "friend" or tipo == "gemini") then
        local decoded = Internet.httpDecode(text);
        return decoded, tipo;
    elseif (tipo == "aiCasting") then
        local sucesso, efeito = decodeJson(text);
        if not sucesso then
            Log.e("SimulacrumCore-typeConverter", "Resposta inválida do Gemini: " .. text);
            return "Resposta inválida do Gemini. Verifique o formato JSON.", "friend";
        end
        local mensagem = aiCastingmsg(efeito);
        return mensagem, "friend";
    elseif (tipo == "aiMulticasting") then
        local sucesso, efeito = decodeJson(text);

        if not sucesso then
            Log.e("SimulacrumCore-typeConverter", "Resposta inválida do Gemini: " .. text);
            return "Resposta inválida do Gemini. Verifique o formato JSON.", "friend";
        end
        if type(efeito) == "table" and #efeito > 0 then
            local mensagem = "";
            for i, efeitoItem in ipairs(efeito) do
                local temp = aiCastingmsg(efeitoItem);
                mensagem = mensagem .. temp .. "\n";
            end
            return mensagem, "friend";
        else
            Log.e("SimulacrumCore-typeConverter", "Resposta inválida do Gemini. Esperava uma lista de objetos JSON.");
            return "Resposta inválida do Gemini. Esperava uma lista de objetos JSON.", "friend";
        end
    else
        Log.e("SimulacrumCore-typeConverter", "Tipo inválido: " .. tostring(type));
        return "", nil;
    end
end
return typeConverter;
