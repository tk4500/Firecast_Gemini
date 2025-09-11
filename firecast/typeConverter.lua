require("internet.lua");
local Json = require("json.lua");
local function aiCastingmsg(efeito)
    if not efeito or not efeito.nome or not efeito.custo or not efeito.descricao then
        Log.e("SimulacrumCore-typeConverter", "Efeito inválido: " .. tostring(efeito));
        return "Efeito inválido. Verifique o formato JSON.";
    end
    if not efeito.rank or efeito.rank == "" then
        efeito.rank = "N/A";
    end
    if not efeito.tipo or efeito.tipo == "" then
        efeito.tipo = "N/A";
    end
    return "|Nome:" ..
        efeito.nome ..
        "\n|Rank: " .. efeito.rank .. "\n|Tipo: " .. efeito.tipo ..
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
    Log.i("SimulacrumCore-typeConverter", "Convertendo tipo: " .. tostring(tipo));

    Log.i("SimulacrumCore-typeConverter", "Decodificando texto: " .. tostring(text));
    if (tipo == "friend" or tipo == "gemini") then
        local decoded = tostring(text);
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
    elseif (tipo == "aiCrafting") then
        local sucesso, efeito = decodeJson(text);
        if not sucesso then
            Log.e("SimulacrumCore-typeConverter", "Resposta inválida do Gemini: " .. text);
            return "Resposta inválida do Gemini. Verifique o formato JSON.", "friend";
        end
        if efeito.sucesso then
            local mensagem = "Receita: " .. efeito.nomeReceita .. "\n";
            mensagem = mensagem .. "Materiais necessários: " .. efeito.materiaisReceita .. "\n";
            mensagem = mensagem .. "Item: " .. efeito.nomeItem .. "\n";
            mensagem = mensagem .. "Tipo: " .. efeito.tipoItem .. "\n";
            mensagem = mensagem .. "Slots: " .. efeito.slots .. "\n";
            mensagem = mensagem .. "Stack: " .. efeito.stack .. "\n";
            mensagem = mensagem .. "Rank: " .. efeito.rankItem .. "\n";
            mensagem = mensagem .. "Valor: " .. efeito.valor .. "\n";
            mensagem = mensagem .. "Efeito: " .. efeito.efeito;
            if efeito.aviso and efeito.aviso ~= "" then
                mensagem = mensagem .. "\nAviso: " .. efeito.aviso;
            end
            return mensagem, "friend";
        else
            local mensagem = "Falha: " .. efeito.nomeFalha .. "\n";
            mensagem = mensagem .. "Causa: " .. efeito.causa .. "\n";
            mensagem = mensagem .. "Consequência: " .. efeito.consequencia;
            if efeito.efeitoColateral and efeito.efeitoColateral ~= "" then
                mensagem = mensagem .. "\nEfeito Colateral: " .. efeito.efeitoColateral;
            end
            return mensagem, "friend";
        end
    elseif (tipo == "aiRefining") then
        local sucesso, efeito = decodeJson(text);
        if not sucesso then
            Log.e("SimulacrumCore-typeConverter", "Resposta inválida do Gemini: " .. text);
            return "Resposta inválida do Gemini. Verifique o formato JSON.", "friend";
        end
        local mensagem = "";
        if efeito.sucesso then
            mensagem = "Item refinado com sucesso!\n";
        else
            mensagem = "Falha no refinamento.\n";
        end
        mensagem = mensagem .. "Item: " .. efeito.nomeItem .. "\n";
        mensagem = mensagem .. "Rank: " .. efeito.rankItem .. "\n";
        mensagem = mensagem .. "Valor: " .. efeito.value .. "\n";
        mensagem = mensagem .. "Tipo: " .. efeito.tipoItem .. "\n";
        mensagem = mensagem .. "Efeito: " .. efeito.efeitoItem;
        mensagem = mensagem .. "\nBônus do Aprimoramento: " .. efeito.bonus;
        if efeito.aviso and efeito.aviso ~= "" then
            mensagem = mensagem .. "\nAviso: " .. efeito.aviso;
        end
        return mensagem, "friend";
    else
        Log.e("SimulacrumCore-typeConverter", "Tipo inválido: " .. tostring(type));
        return "", nil;
    end
end
return typeConverter;
