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
        avatar = "https://blob.firecast.com.br/blobs/GMGWTHCP_4038434/68c8d9c789bc75b701b6557a.png",
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

local function sendMessage(message, chat, param)
    if not message or not chat then
        Log.e("SimulacrumCore", "sendMessage: Parâmetros inválidos.");
        return;
    end
    if #message > 3000 then
        Log.i("SimulacrumCore", "sendMessage: Mensagem muito longa, dividindo em partes.");
        local firstNewline = message:find("\n")
        if firstNewline then
            local mesAFinal = message:sub(1, firstNewline - 1)
            local mesBFinal = message:sub(firstNewline + 1, #message)
            local lineBreakCount = 0
            while #mesAFinal < 2500 and lineBreakCount < 30 do
                
                local newline = mesBFinal:find("\n")
                if not newline then break end
                
                mesAFinal = mesAFinal .. "\n" .. mesBFinal:sub(1, newline - 1)
                lineBreakCount = lineBreakCount + 1
                mesBFinal = mesBFinal:sub(newline + 1)
            end
            Log.i("SimulacrumCore", "sendMessage: Enviando partes da mensagem.");
            Log.i("SimulacrumCore", "Parte 1: " .. mesAFinal);
            Log.i("SimulacrumCore", "Parte 2: " .. mesBFinal);
            sendMessage(mesAFinal, chat, param)
            sendMessage(mesBFinal, chat, param)
            return
        end

    end
    if (param == "gemini") then
        if chat.room.me.isMestre then
        chat:asyncSendStd(message, geminiparams);
        else
            chat:asyncSendStd("[§I https://blob.firecast.com.br/blobs/HSQUQKOR_4037633/68c84ef589bc75b701b12349.png][20,20]:".. message);
        end
    elseif (param == "friend") then
        if chat.room.me.isMestre then
        chat:asyncSendStd(message, sendparams);
        else
            chat:asyncSendStd("[§I ".. sendparams.impersonation.avatar .."][20,20]:".. message);
        end
    elseif not param then
        chat:asyncSendStd(message);
    else
        Log.e("SimulacrumCore", "sendMessage: Parâmetro inválido: " .. param);
        return;
    end
end
return sendMessage;
