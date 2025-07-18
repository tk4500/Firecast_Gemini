local function opsParser(ops)
    local resultado = "{"
    for _, op in ipairs(ops) do
        if op.tipo == "dado" then
            resultado = resultado .. "["
            for i = 1, #op.resultados do
                if i < #op.resultados then
                    resultado = resultado .. op.resultados[i] .. ","
                else
                    resultado = resultado .. op.resultados[i]
                end
            end
            resultado = resultado .. "]"
        elseif op.tipo == "soma" then
            resultado = resultado .. "+" 
        elseif op.tipo == "subtracao" then
            resultado = resultado .. "-" 
        elseif op.tipo == "imediato" then
                resultado = resultado .. op.valor
        end
    end
    resultado = resultado .. "}"
    return resultado;
end

local function rollParser(roll)
    local resultado = "rolou "
    if not roll or roll == "" then
        return "";
    end
    if roll.tipo == "direta" then
            resultado = resultado .. roll.asString .. " = " .. roll.resultado .. opsParser(roll.ops);
    end
end


local function logParse(logRec)
    if logRec.isDeleted then
        return "";
    end
    local msg = logRec.msg;
    if msg.msgType == "standart" then
        local content = msg.content;
        local name = ""
        if msg.impersonation.mode == "character" then
            name = msg.impersonation.name or "Desconhecido";
        elseif msg.impersonation.mode == "narrator" then
            name = "Narrador";
        else
            name = logRec.entity.nick or "Desconhecido";
        end
        if content and content ~= "" then
            return string.format("%s: %s\n", name, content);
        else
            return string.format("%s enviou uma mensagem vazia.\n", name);
        end
    elseif msg.msgType == "dice" then
        local content = rollParser(msg.roll);
        local name = ""
        if msg.impersonation.mode == "character" then
            name = msg.impersonation.name or "Desconhecido";
        elseif msg.impersonation.mode == "narrator" then
            name = "Narrador";
        else
            name = logRec.entity.nick or "Desconhecido";
        end
        if content and content ~= "" then
            return string.format("%s: %s\n", name, content);
        else
            return string.format("%s enviou uma mensagem vazia.\n", name);
        end
    end
end

local function logRead(chat)
    local logRecs = chat:readLogRecs();
    local logText = "";
    for _, logRec in ipairs(logRecs) do
        local logp = logParse(logRec);
        if logp and logp ~= "" then
            logText = logText .. logp;
        end
    end
    if logText == "" then
        return "Nenhum registro de log encontrado.";
    end
    return logText;
end
return logRead
