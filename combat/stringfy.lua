local function parseHab(habList)
    local habilidades = ""
    for i, hab in ipairs(habList) do
        local habilidade = string.format(
            "Nome: %s\nRank: %s\nTipo: %s\nCusto: %s\nDescrição: %s\n",
            hab.nome or "N/A",
            hab.rank or "N/A",
            hab.tipo or "N/A",
            hab.custo or "N/A",
            hab.descricao or "N/A"
        );
        if hab.uses then
            habilidade = habilidade .. string.format("Usos: %s\n", hab.uses);
        end
        habilidades = habilidades .. habilidade .. "\n";
    end
    return habilidades;
end

local function getInfoFromPlayer(jogador)
    local player = {
        login = jogador.login,
        nick = jogador.nick or "N/A",
    }
    local _
    player.vidaAtual, player.vidaMax, _ = jogador:getBarValue(1);
    player.energiaAtual, player.energiaMax, _ = jogador:getBarValue(2);
    _, _, player.sync = jogador:getBarValue(3);
    player.nivel, player.tokens, player.raca, player.classe = jogador:getEditableLine(1):match("(%d+)%s*|%s*(%d+)%s*|%s*([^|]+)%s*|%s*([^|]+)");
    return player;
end
local function parseEffects(effects)
    local effectsString = ""
    for i, effect in ipairs(effects) do
        local effectDesc = string.format(
            "Descrição: %s\nDuração: %s turnos\n",
            effect.descricao or "N/A",
            effect.turns or "N/A"
        );
        effectsString = effectsString .. effectDesc .. "\n";
    end
    return effectsString;
end



local function stringfy(entity, isEnemy)
    if isEnemy then
        local habilidades = parseHab(entity.habilidades or {});
        local effects = parseEffects(entity.effects or {});
        if not habilidades or habilidades == "" then
            habilidades = "Nenhuma habilidade disponível.";
        end
        if not effects or effects == "" then
            effects = "Nenhum efeito ativo.";
        end
        return [[
        Nome: ]] .. (entity.nome or "N/A") .. [[
        Nível: ]] .. (entity.nivel or 1) .. [[
        Descrição: ]] .. (entity.desc or "N/A") .. [[
        Vida: ]] .. (entity.vidaAtual or 0) .. [[ / ]] .. (entity.vidaMax or 0) .. [[
        Energia: ]] .. (entity.energiaAtual or 0) .. [[ / ]] .. (entity.energiaMax or 0) .. [[
        SYNC: ]] .. (entity.sync or 0) .. [[ %
        Defesa: ]] .. (entity.defesa or 0) .. [[
        Dano Base: ]] .. (entity.danoBase or 0) .. [[
        CD(Desafio): ]] .. (entity.dificuldadeMod or 0) .. [[
        Ações Usadas: ]] .. (entity.principalActions or 0) .. [[
        Movimentação Usadas: ]] .. (entity.movementActions or 0) .. [[
        Reações Usadas: ]] .. (entity.reacaoActions or 0) .. [[
        Habilidades: ]] .. habilidades .. [[
        Efeitos: ]] .. effects .. [[
        ]]
    else
        local player = getInfoFromPlayer(entity);
        return [[
        Login: ]] .. (player.login or "N/A") .. [[
        Personagem: ]] .. (player.nick or "N/A") .. [[
        Nível: ]] .. (player.nivel or 1) .. [[
        Raça: ]] .. (player.raca or "N/A") .. [[
        Classe: ]] .. (player.classe or "N/A") .. [[
        Vida: ]] .. (player.vidaAtual or 0) .. [[ / ]] .. (player.vidaMax or 0) .. [[
        Energia: ]] .. (player.energiaAtual or 0) .. [[ / ]] .. (player.energiaMax or 0) .. [[
        SYNC: ]] .. (player.sync or 0) .. [[ %
        Tokens: ]] .. (player.tokens or 1) .. [[
        ]]
    end
end
return stringfy;
