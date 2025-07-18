local function sendCombatMessage(chat, message, npcName)
    chat:asyncSendStd(message, {
        impersonation ={
            mode = "character",
            name = npcName or "Combat",
        }
    })
end
return sendCombatMessage;