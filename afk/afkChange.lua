require("afk/afk.lua")
local function vhdSave()
    local stream = VHD.openFile("afk.txt", "w+");
    if stream then
        local afk = Utils.tableToStr(AFK);
        stream:writeBinary("utf8", afk);
        stream:close();
    end
end

local function afkChange(logrec)
    if not logrec or not logrec.msg then
        return;
    end
    if logrec.medium.kind ~= "room" then
        return;
    end
    local msgType = logrec.msg.msgType;
    if msgType == "sys_userJoin" then
        local login = logrec.entity.login;
        if login then
            if not AFK[login] then
                AFK[login] = {}
            end
            if AFK[login].status == "online" then
                local leave = os.time(logrec.timestamp);
                local join = AFK[login].joinTimeStamp;
                if join and leave then
                    local diff = leave - join;
                    local min = math.floor(diff / 60);
                    AFK[login].duration = (AFK[login].duration or 0) + min;
                end
            end

            AFK[login].status = "online"
            AFK[login].joinTimeStamp = os.time(logrec.timestamp);
        end
    elseif msgType == "sys_userLeave" then
        local login = logrec.entity.login;
        if login then
            if not AFK[login] then
                AFK[login] = {}
            end
            AFK[login].status = "offline"
            local leave = os.time(logrec.timestamp);
            local join = AFK[login].joinTimeStamp;
            if join and leave then
                local diff = leave - join;
                local min = math.floor(diff / 60);
                AFK[login].duration = (AFK[login].duration or 0) + min;
            end
        end
    end
    vhdSave();
end

return afkChange
