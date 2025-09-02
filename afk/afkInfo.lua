require("afk/afk.lua")
local rUtils = require("token_utils.lua")
local sendMessage = require("firecast/sendMessage.lua")
local function vhdSave()
    local stream = VHD.openFile("afk.txt", "w+");
    if stream then
        local afk = Utils.tableToStr(AFK);
        stream:writeBinary("utf8", afk);
        stream:close();
    end
end
local function getPlayer(chat, login)
    local mesa = chat.room;
    local player = mesa:findJogador(login);
    if not player then
        return nil;
    end
    return player;
end

local function getLines(login, chat)
    local jogador = getPlayer(chat, login);
    if jogador then
        local linha = jogador:getEditableLine(1);
        local nivel, tokens = 1, 1
        if linha then
            local lvl, tk, rc, cl = linha:match("(%d+)%s*|%s*(%d+)%s*|%s*([^|]+)%s*|%s*([^|]+)")
            nivel = tonumber(lvl) or 1;
            tokens = tonumber(tk) or 1;
        end
        return nivel, tokens
    else
        return 1, 1
    end
end

local function afkinfo(message)
    local content = message.logRec.msg.content;
    if (rUtils.startsWith(content, "afkTime")) then
        content = content:gsub("^afkTime%s*", ""):gsub("^%s+", ""):gsub("%s+$", "")
        local login = message.logRec.entity.login;
        if AFK[content] then
            login = content
        end
        if AFK[login] then
            local duration = AFK[login].duration or 0;
            if AFK[login].status == "online" then
                local join = AFK[login].joinTimeStamp
                local now = os.time(message.logRec.timestamp)
                local diff = now - join
                duration = duration + math.floor(diff / 60)
            end
            sendMessage(login .. " está online há " .. duration .. " minutos.", message.chat, "friend");
        else
            AFK[login] = {}
        end
    end
    if (rUtils.startsWith(content, "afkCredit")) then
        content = content:gsub("^afkCredit%s*", ""):gsub("^%s+", ""):gsub("%s+$", "")
        local login = message.logRec.entity.login;
        if AFK[content] then
            login = content
        end
        if AFK[login] then
            local duration = AFK[login].duration or 0;
            if AFK[login].status == "online" then
                local join = AFK[login].joinTimeStamp
                local now = os.time(message.logRec.timestamp)
                local diff = now - join
                duration = duration + math.floor(diff / 60)
            end
            local credit = duration - (AFK[login].spent or 0)
            sendMessage(
                login .. " está online há " .. duration .. " minutos e tem " .. credit .. " minutos disponiveis de AFK.",
                message.chat, "friend");
        else
            AFK[login] = {}
        end
    end
    if (rUtils.startsWith(content, "afkCash")) then
        local login = message.logRec.entity.login;
        content = content:gsub("^afkCash%s*", "")
        content = tonumber(content)
        if AFK[login] then
            local spent = AFK[login].spent or 0;
            if content ~= nil then
                spent = spent + content
                local duration = AFK[login].duration or 0;
                if AFK[login].status == "online" then
                    local join = AFK[login].joinTimeStamp
                    local now = os.time(message.logRec.timestamp)
                    local diff = now - join
                    duration = duration + math.floor(diff / 60)
                end
                if spent > duration then
                    sendMessage("Você não tem minutos suficientes para gastar.", message.chat, "friend");
                else
                    AFK[login].spent = spent
                    local nivel, tokens = getLines(login, message.chat)
                    if not tokens or tokens < 1 then
                        tokens = 1
                    end
                    local cash = 20 * tonumber(tokens) * content;
                    sendMessage("Você recebeu " .. cash .. " Créditos-S de AFK Cash.", message.chat, "friend");
                end
            else
                sendMessage("Valor inválido para afkCash, use afkCash <valor em minutos>", message.chat, "friend");
            end
        else
            AFK[login] = {}
        end
    end
    if (rUtils.startsWith(content, "afkExp")) then
        local login = message.logRec.entity.login;
        content = content:gsub("^afkExp%s*", "")
        content = tonumber(content)
        if AFK[login] then
            local spent = AFK[login].spent or 0;
            if content ~= nil then
                spent = spent + content
                local duration = AFK[login].duration or 0;
                if AFK[login].status == "online" then
                    local join = AFK[login].joinTimeStamp
                    local now = os.time(message.logRec.timestamp)
                    local diff = now - join
                    duration = duration + math.floor(diff / 60)
                end
                if spent > duration then
                    sendMessage("Você não tem minutos suficientes para gastar.", message.chat, "friend");
                else
                    AFK[login].spent = spent
                    local nivel, tokens = getLines(login, message.chat)
                    local xpUp = 15 * nivel ^ 2 + 85 * nivel;
                    local xpGain = math.floor(xpUp * content / 100);
                    sendMessage("Você recebeu " .. xpGain .. " exp de AFK Exp.", message.chat, "friend");
                    local jogador = getPlayer(message.chat, login);
                    local xpAtual = jogador:getBarValue(4);
                    jogador:requestSetBarValue(4, xpAtual + xpGain, nil);
                end
            else
                sendMessage("Valor inválido para afkCash, use afkCash <valor em minutos>", message.chat, "friend");
            end
        else
            AFK[login] = {}
        end
    end
    vhdSave()
end
return afkinfo
