local rUtils = require("token_utils.lua")
local sendMessage = require("firecast/sendMessage.lua")
local habilidade = require("habilidade.lua")
require("log.lua")
require("ndb.lua")
local aiPrompt = require("aiPrompt.lua")
local geminiCall = require("gemini/geminiCall.lua")
local function fusion(message)
    local content = message.logRec.msg.content;
    local prompt = content:sub(8);
    local baseSkill, fusionSkills = rUtils.parseFusion(prompt);
    if not baseSkill or not baseSkill.nome or not baseSkill.rank then
        sendMessage(
            " Formato inválido. Use: Fusion: [HabilidadeBase(Rank)] [Habilidade1(Rank)] [Habilidade2(Rank)] ...",
            message.chat, "friend");
        return;
    end
    Log.i("SimulacrumCore-Fusion", "Base Skill: " .. baseSkill.nome .. " (Rank: " .. baseSkill.rank .. ")");
    Log.i("SimulacrumCore-Fusion", "Fusion Skills: " .. #fusionSkills .. " habilidades selecionadas.");
    local rank = habilidade.base[baseSkill.rank];
    if not rank then
        Log.e("SimulacrumCore-Fusion", "Rank inválido: " .. baseSkill.rank);
        return;
    else
        Log.i("SimulacrumCore-Fusion", "Rank encontrado: " .. rank);
    end
    if not baseSkill or not fusionSkills or #fusionSkills == 0 then
        sendMessage(
            " Formato inválido. Use: Fusion: [HabilidadeBase(Rank)] [Habilidade1(Rank)] [Habilidade2(Rank)] ...",
            message.chat, "friend");
        return;
    end
    local skilltable = habilidade.getSkillTables(message.logRec.entity.login, message.chat.room);
    if not skilltable then
        sendMessage(
            " Habilidade base não encontrada. Verifique se você possui habilidades registradas.",
            message.chat, "friend");
        return;
    end
    local list = NDB.getChildNodes(skilltable);
    Log.i("SimulacrumCore-Fusion", "Habilidades encontradas: " .. #list);
    for i, skill in ipairs(list) do
        local skillatt = NDB.getAttributes(skill);
        Log.i("SimulacrumCore-Fusion",
            "Habilidade encontrada: " .. skillatt.nome .. " (Rank: " .. skillatt.rank .. ")");
        Log.i("SimulacrumCore-Fusion", "Custo: " .. skillatt.custo .. ", Descrição: " .. skillatt.descricao);
        if skill.nome == baseSkill.nome and skill.rank == baseSkill.rank then
            baseSkill.custo = skillatt.custo;
            baseSkill.descricao = skillatt.descricao;
            Log.i("SimulacrumCore-Fusion",
                "Habilidade base encontrada: " .. baseSkill.nome .. " (Rank: " .. baseSkill.rank .. ")");
            Log.i("SimulacrumCore-Fusion", "Custo: " .. baseSkill.custo .. ", Descrição: " .. baseSkill.descricao);
            NDB.deleteNode(skill);
        end
        if #fusionSkills == 1 then
            if skill.nome == fusionSkills[1].nome and skill.rank == fusionSkills[1].rank then
                fusionSkills[1].custo = skillatt.custo;
                fusionSkills[1].descricao = skillatt.descricao;
                Log.i("SimulacrumCore-Fusion",
                    "Habilidade de fusão encontrada: " .. fusionSkills[1].nome .. " (Rank: " ..
                    fusionSkills[1].rank .. ")");
                Log.i("SimulacrumCore-Fusion", "Custo: " .. fusionSkills[1].custo .. ", Descrição: " ..
                    fusionSkills[1].descricao);
                NDB.deleteNode(skill);
            end
        else
            for j, fusionSkill in ipairs(fusionSkills) do
                if skill.nome == fusionSkill.nome and skill.rank == fusionSkill.rank then
                    fusionSkill.custo = skillatt.custo;
                    fusionSkill.descricao = skillatt.descricao;
                    Log.i("SimulacrumCore-Fusion",
                        "Habilidade de fusão encontrada: " .. fusionSkill.nome .. " (Rank: " ..
                        fusionSkill.rank .. ")");
                    Log.i("SimulacrumCore-Fusion", "Custo: " .. fusionSkill.custo .. ", Descrição: " ..
                        fusionSkill.descricao);
                    NDB.deleteNode(skill);
                    break;
                end
            end
        end
    end
    local ph = 0;
    for k, v in pairs(fusionSkills) do
        local valor = habilidade.ranks[v.rank];
        if valor then
            ph = ph + valor;
        else
            Log.e("SimulacrumCore-Fusion", "Rank inválido: " .. v.rank);
        end
    end
    if ph == 0 then
        message.chat:writeEx("Nenhum PH calculado para as habilidades selecionadas.");
    end
    Log.i("SimulacrumCore-Fusion", "PH calculado: " .. ph);
    Log.i("SimulacrumCore-Fusion", "Rank: " .. rank);
    local isRankUp = false;
    local teste = math.random(rank);
    Log.i("SimulacrumCore-Fusion", "Teste aleatório: " .. teste);
    if (ph >= teste) then
        isRankUp = true;
    end
    Log.i("SimulacrumCore-Fusion", "Rank Up: " .. tostring(isRankUp));
    local jogador = message.chat.room:findJogador(message.logRec.entity.login);
    local linha = jogador:getEditableLine(1);
    local nivel, raca, classe = linha:match("Level%s*(%d+)%s*|%s*([^|]+)%s*|%s*(.+)");
    local personagem = message.chat.room:findBibliotecaItem(jogador.personagemPrincipal);
    local contextoJogador = {
        nivel = tonumber(nivel) or 1,
        classe = classe:match("^%s*(.-)%s*$") or "Classe",
        raca = raca:match("^%s*(.-)%s*$") or "Raça",
        rankUp = isRankUp,
        baseSkill = baseSkill,
        fusionSkills = fusionSkills,
        personagem = personagem
    }
    local prompt = aiPrompt.getAiFusion(contextoJogador);
    geminiCall(prompt, "aiCasting", message.chat);
    Log.i("SimulacrumCore-Fusion", "Prompt de fusão enviado");
end

return fusion
