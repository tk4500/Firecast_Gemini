require("ndb.lua");
local skill ={}

skill.base = {
    Common = 5,
    Basic = 10,
    Extra = 50,
    Unique = 100,
    Ultimate = 500,
    Sekai = 1000,
    Stellar = 5000,
    Cosmic = 10000,
    Universal = 50000,
    MultiVersal = 100000
}
skill.ranks = {
    Common = 1,
    Basic = 5,
    Extra = 10,
    Unique = 50,
    Ultimate = 100,
    Sekai = 500,
    Stellar = 1000,
    Cosmic = 5000,
    Universal = 10000,
    MultiVersal = 50000
}

local function getSkillTables(login, mesa)
    local jogador = mesa:findJogador(login);
    if not jogador then
        mesa.chat:writeEx("jogador não encontrado");
        return {};
    end
    local personagem = mesa:findBibliotecaItem(jogador.personagemPrincipal);
    if not personagem then
        mesa.chat:writeEx("personagem não encontrado");
        return {};
    end
    local nodePromise = personagem:asyncOpenNDB();
    local node = await(nodePromise);
    if not node then
        mesa.chat:writeEx("Erro ao abrir o nó do personagem");
        return {};
    end
    local nodes = NDB.getChildNodes(node);
    local habilidades = nil;
    for _, n in ipairs(nodes) do
        if NDB.getNodeName(n) == "habilidades" then
            habilidades = n;
            break;
        end
    end
    if not habilidades then
        mesa.chat:writeEx("Nenhuma habilidade encontrada para o personagem: " .. jogador.personagemPrincipal);
        return {};
    end
    return habilidades;
end

function skill.skillFusion(login, mesa)
    local habilidades = getSkillTables(login, mesa);
    local list = NDB.getChildNodes(habilidades);
    if #list < 2 then
        mesa.chat:writeEx("Você precisa de pelo menos duas habilidades para fundir.");
        return;
    end
    return list, habilidades;
end

function skill.getSkills(login, mesa)
    local habilidades = getSkillTables(login, mesa);
    local list = NDB.getChildNodes(habilidades);
    if #list == 0 then
        mesa.chat:writeEx("Nenhuma habilidade encontrada para o jogador: " .. login);
        return;
    end
    for _, h in ipairs(list) do
        mesa.chat:writeEx(" - " .. h.nome .. " (" .. h.rank .. ") - Custo: " .. h.custo .. "\n" .. h.descricao);
    end

end    

function skill.new(skillData)
    local jogador = skillData.mesa:findJogador(skillData.login);
    if not jogador then
        skillData.mesa.chat:writeEx("jogador não encontrado");
        return;
    end
    local skill = {
        nome = skillData.nome or "Habilidade Desconhecida",
        rank = skillData.rank or "Common",
        custo = skillData.custo or "0 Energia",
        descricao = skillData.descricao or "Descrição não fornecida"
    };
    local personagem = skillData.mesa:findBibliotecaItem(jogador.personagemPrincipal);
    if not personagem then
        skillData.mesa.chat:writeEx("personagem não encontrado");
        return;
    end
    local nodePromise = personagem:asyncOpenNDB();
    local node = await(nodePromise);
    if not node then
        skillData.mesa.chat:writeEx("Erro ao abrir o nó do personagem");
        return;
    end
    local habilidades = node.habilidades;
    if not habilidades then
        node.habilidades = {};
        habilidades = node.habilidades;
    end
    -- Verifica se a habilidade já existe
    for _, h in ipairs(habilidades) do
        if h.nome == skill.nome and h.rank == skill.rank then
            skillData.mesa.chat:writeEx("Habilidade já existe: " .. skill.nome);
            return;
        end
    end
    table.insert(habilidades, skill);
    skillData.mesa.chat:writeEx("Habilidade adicionada: " .. skill.nome .. " (" .. skill.rank .. ")");


end

return skill