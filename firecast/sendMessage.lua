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

local function sendMessage(message, chat, param)
    if not message or not chat then
        Log.e("SimulacrumCore", "sendMessage: Parâmetros inválidos.");
        return;
    end
    if #message > 4000 then
        local firstNewline = message:find("\n")
        if firstNewline then
            local mesafinal = message:sub(1, firstNewline - 1)
            local mesbfinal = message:sub(firstNewline + 1, #message)
            while #mesafinal < 3500 do
                local newline = mesbfinal:find("\n")
                if not newline then break end
                mesafinal = mesafinal .. "\n" .. mesbfinal:sub(1, newline - 1)
                mesbfinal = mesbfinal:sub(newline + 1)
            end
            sendMessage(mesafinal, chat, param)
            sendMessage(mesbfinal, chat, param)
            return
        end

    end
    if (param == "gemini") then
        chat:asyncSendStd(message, geminiparams);
    elseif (param == "friend") then
        chat:asyncSendStd(message, sendparams);
    elseif not param then
        chat:asyncSendStd(message);
    else
        Log.e("SimulacrumCore", "sendMessage: Parâmetro inválido: " .. param);
        return;
    end
end
return sendMessage;
