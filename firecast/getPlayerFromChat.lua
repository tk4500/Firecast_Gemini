local function getPlayerFromChat(mensagem)
    local mesa = mensagem.chat.room;
    local playerlogin = mensagem.logRec.entity.login
    local player = mesa:findJogador(playerlogin);
    if not player then
        return nil;
    end
    return player;
end
return getPlayerFromChat;