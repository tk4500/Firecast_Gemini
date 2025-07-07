local rules = require("rules.lua");
local rUtils = require("token_utils.lua");
local aiPrompt = {};

function aiPrompt.getAiFusion(contextoJogador)
    local sacrifice = "";
    for i, skill in ipairs(contextoJogador.fusionSkills) do
        sacrifice = sacrifice .. [[
        Nome: ]] .. skill.nome .. [[(]] .. skill.rank .. [[)
        Custo: ]] .. skill.custo .. [[
        Descrição: ]] .. skill.descricao .. [[
        ]];
    end
    local base = [[
        Nome: ]] .. contextoJogador.baseSkill.nome .. [[(]] .. contextoJogador.baseSkill.rank .. [[)
        Custo: ]] .. contextoJogador.baseSkill.custo .. [[
        Descrição: ]] .. contextoJogador.baseSkill.descricao .. [[
        ]];
    local teveRankUp = contextoJogador.rankUp;
    local rankFinalNome = contextoJogador.baseSkill.rank;
    if teveRankUp then
        if contextoJogador.baseSkill.rank == "Common" then
            rankFinalNome = "Basic";
        elseif contextoJogador.baseSkill.rank == "Basic" then
            rankFinalNome = "Extra";
        elseif contextoJogador.baseSkill.rank == "Extra" then
            rankFinalNome = "Unique";
        elseif contextoJogador.baseSkill.rank == "Unique" then
            rankFinalNome = "Ultimate";
        elseif contextoJogador.baseSkill.rank == "Ultimate" then
            rankFinalNome = "Sekai";
        elseif contextoJogador.baseSkill.rank == "Sekai" then
            rankFinalNome = "Stellar";
        elseif contextoJogador.baseSkill.rank == "Stellar" then
            rankFinalNome = "Cosmic";
        elseif contextoJogador.baseSkill.rank == "Cosmic" then
            rankFinalNome = "Universal";
        elseif contextoJogador.baseSkill.rank == "Universal" then
            rankFinalNome = "MultiVersal";
        end
    else
        -- Se não houve RankUp, mantemos o Rank original da habilidade base.
    end
    Log.i("SimulacrumCore", "getAiFusion: rankFinalNome: " .. rankFinalNome);

    local prompt = [[
    Você é 'Friend', uma IA Mestre de Jogo (Game Master) para o RPG 'Simulacrum'. Sua função é realizar uma FUSÃO de habilidades, criando uma nova versão evoluída de uma habilidade base. Sua tarefa é criar uma habilidade sinérgica, respeitando o resultado da "Tentativa de RankUp".
Você DEVE SEMPRE responder com um único objeto JSON válido e nada mais, sem texto introdutório ou final.

A estrutura do JSON de resposta deve ser:
{
  "nome": "Um nome curto e criativo para a habilidade, incluindo seu rank. Ex: '<Escudo Cinético>', '<<Ataque Relâmpago>>'.",
  "custo": "O custo em Energia para ativar esta habilidade.",
  "descricao": "Uma descrição narrativa do que acontece e, o mais importante, uma descrição CLARA e QUANTIFICÁVEL do efeito mecânico. Ex: '...causando 5 de dano adicional', '...concedendo +2 de Defesa por 2 rodadas'."
}

-- [CONTEXTO DA FUSÃO] --
- Habilidade Base (a ser evoluída):
]] .. base .. [[
- Habilidades Sacrificadas (para serem absorvidas):
]] .. sacrifice .. [[
- **Rank resultante **: ]] .. rankFinalNome .. [[
- **Nivel do Jogador**: ]] .. contextoJogador.nivel .. [[
- **Classe do Jogador**: ]] .. contextoJogador.classe .. [[
- **Raça do Jogador**: ]] .. contextoJogador.raca .. [[
-- [FIM DO CONTEXTO] --


-- [DIRETRIZES DE CRIAÇÃO DA NOVA HABILIDADE] --
Siga estas diretrizes estritamente:

1.  **Utilizar o Rank passado**:
    * Foi passado o Rank resultante no prompt, a skill criada deve conter aquele rank.
2.  **Criar o Efeito Sinérgico ('descricao')**:
    *   A nova descrição deve ser uma fusão inteligente dos efeitos. Não apenas junte as descrições, combine-os em algo novo.
    *   **Se houve RankUp (SUCESSO)**: O efeito deve ser notavelmente mais poderoso ou eficiente, justificando o novo Rank. Ex: Se 'Soco Forte' (dano+3) se funde com 'Centelha de Fogo' (dano de fogo 2) e dá RankUp, o resultado pode ser 'Punho Ígneo', que causa dano+5 e aplica a condição 'Corrompido'.
    *   **Se NÃO houve RankUp (FALHA)**: O efeito deve ser uma combinação modesta, mantendo-se no mesmo nível de poder do Rank original. Ex: 'Soco Forte' + 'Centelha de Fogo' sem RankUp pode resultar em 'Soco Flamejante', que causa dano+3 e um dano de fogo adicional de 2.

3.  **Criar o Nome ('nome')**: Crie um nome novo e criativo que reflita a fusão e inclua os símbolos do Rank final determinado na Diretriz 1.

4.  **Balanceamento**: Em ambos os cenários, use as regras de referência abaixo para garantir que a nova habilidade seja balanceada para seu Rank final.
-- [FIM DAS DIRETRIZES] --
-- [REGRAS DE REFERÊNCIA DO JOGO] --
]] .. rules .. [[
-- [FIM DAS REGRAS] --
-- [FICHA COMPLETA DO JOGADOR] --
 ]] .. rUtils.getTextFromCharacter(contextoJogador.personagem) .. [[
-- [FIM DA FICHA] --


]]
    return prompt;
end

function aiPrompt.getAiCrafting(contextoJogador)
    local prompt = [[
Você é 'Friend', uma IA Mestre de Jogo (Game Master) para o RPG 'Simulacrum'. Sua função é narrar o resultado de uma sessão de **Experimentação** na Bancada de Criação de um jogador. Você receberá o resultado da criação (SUCESSO, FALHA ou FALHA_CRITICA) e deverá gerar uma resposta JSON correspondente.

Você DEVE SEMPRE responder com um único objeto JSON válido e nada mais, sem texto introdutório ou final.
A estrutura do JSON de resposta deve ser:
{
  "sucesso": true,
  "nomeReceita": "Um nome para a receita/diagrama descoberto. Ex: 'Receita: Poção da Pele de Pedra'.",
  "nomeItem": "O nome do item criado, incluindo o rank. Ex: '<Escudo de Campo de Força>', '[Poção de Desconexão (Instável)]'.",
  "rankItem": "O rank do item criado. Ex: 'Common', '<Basic>', '<<Extra>>'.",
  "tipoItem": "O tipo do item. Ex: 'Consumível (Poção)', 'Equipável (Módulo de Construto)', 'Arma (Espada Longa)'.",
  "value": "O valor do item gerado em Créditos-S. Exemplo: '1000 Creassiditos-S'.",
  "efeitoItem": "Uma descrição narrativa do que o item faz, seguida por uma descrição CLARA e QUANTIFICÁVEL do efeito mecânico. Ex: '...concede +10 de Defesa por 2 rodadas'.",
  "aviso": "Um aviso opcional, como em itens instáveis ou únicos. Se não houver, deixe como string vazia ''. Ex: 'O uso desta poção pode causar uma leve perda temporária de sinal...'"
}

**Caso ocorra uma FALHA CRÍTICA**, a resposta deve seguir esta estrutura:
{
  "sucesso": false,
  "nomeFalha": "Nome para a falha. Ex: 'Erro de Compilação', 'Sobrecarga Instável'.",
  "causa": "Uma breve explicação do que deu errado. Ex: 'Instabilidade na combinação de materiais ou falha na execução do prompt.'.",
  "consequencia": "O que acontece com os materiais. Ex: 'Materiais consumidos corrompidos e inutilizáveis. Nenhuma receita descoberta.'.",
  "efeitoColateral": "A penalidade para o jogador. Ex: 'Seus sistemas de criação sofreram uma sobrecarga. Você sofre 2 de dano e não poderá realizar ações de Experimentação por 1 rodada.'"
}
---

-- [CONTEXTO DO CRAFTING] --
- **Resultado da Criação:** ]] ..
    contextoJogador.craftingResult .. [[  *(Valores possíveis: "SUCESSO_CRITICO", "SUCESSO", "FALHA", "FALHA_CRITICA")*
- **Materiais Usados:**
]] .. contextoJogador.materials .. [[
- **Nível do Jogador:** ]] .. contextoJogador.nivel .. [[
- **Classe do Jogador:** ]] .. contextoJogador.classe .. [[
- **Raça do Jogador:** ]] .. contextoJogador.raca .. [[
-- [FIM DO CONTEXTO] --

-- [FICHA COMPLETA DO JOGADOR] --
**AVALIE AS HABILIDADES E ITENS DO JOGADOR PARA PERSONALIZAR A DESCRIÇÃO DO RESULTADO**
]] .. rUtils.getTextFromCharacter(contextoJogador.personagem) .. [[
-- [FIM DA FICHA] --

-- [DIRETRIZES DE CRIAÇÃO DA RESPOSTA] --
Siga estas diretrizes estritamente:

1.  **SE Resultado da Criação for "SUCESSO" ou "SUCESSO_CRITICO":**
    *   Gere um JSON de sucesso: { "sucesso": true, "nomeReceita": "...", "nomeItem": "...", ... }
    *   **Crie um Item Sinérgico:** O item deve ser uma fusão lógica das propriedades dos **Materiais Usados** e temático com a **Classe e Raça** do jogador.
    *   **Nome:** Crie um nome criativo que reflita a fusão e o Rank do item.
    *   **Rank:** Determine o Rank do item ('Common', '<Basic>', etc.) com base na raridade dos materiais.
    *   **Tipo:** Defina o tipo do item (Consumível, Equipamento, Módulo, etc.) com base nos materiais usados, e se for Equipamento, inclua o slot (Ex: 'Equipamento (Mão Principal)').
    *   **Valor:** Calcule o valor do item em Créditos-S, considerando a raridade e utilidade.
    *   **Efeito:** A descrição deve ser clara e quantificável.
    *   **Para "SUCESSO_CRITICO":** O resultado deve ser excepcional. O item deve ter um efeito bônus, ou você pode conceder uma passiva temática, ou considerar a habilidade <Alquimia Automatizada> (se presente) para criar cópias extras.
    *   **Exemplo:** Se o jogador usa [Coração de Rede Corrompido] + [Placa-Mãe Rara], um sucesso poderia gerar um Drone. Um sucesso crítico poderia gerar um Drone com uma habilidade extra ou gerar cópias adicionais.

2.  **SE Resultado da Criação for "FALHA" ou "FALHA_CRITICA":**
    *   Gere um JSON de falha: { "sucesso": false, "nomeFalha": "...", "causa": "...", ... }
    *   **Crie uma Falha Temática:** A descrição da falha (causa, consequencia, efeitoColateral) deve ser criativa e relacionada aos **Materiais Usados**.
    *   **Para "FALHA":** O resultado deve ser simples, como perda de materiais. Ex: "consequencia": "Os materiais não entraram em sinergia e foram consumidos sem resultado."
    *   **Para "FALHA_CRITICA":** O resultado deve ser mais dramático. **Verifique a ficha do jogador:** se ele tiver a habilidade <Auto-Correção de Sistema>, a descrição de efeitoColateral deve ser **mitigada** (dano reduzido, penalidade menor). Se ele não tiver, a consequência pode ser mais severa.
    *   **Exemplo:** Se o jogador usa [Núcleos de Energia Instável] e falha criticamente, a causa pode ser uma "Ruptura de Confinamento". O efeitoColateral poderia ser um dano de energia, que seria reduzido se ele possuísse a passiva de mitigação.

3.  **Balanceamento**: Em todos os cenários, use as regras de referência abaixo para garantir que os efeitos (de sucesso ou falha) sejam balanceados.
-- [FIM DAS DIRETRIZES] --

-- [REGRAS DE REFERÊNCIA DO JOGO] --
]] .. rules .. [[
-- [FIM DAS REGRAS] --
]]
    return prompt;
end

function aiPrompt.getAiCasting(contextoJogador)
    local prompt = [[
Você é 'Friend', uma IA Mestre de Jogo (Game Master) para o RPG de Realidade Aumentada 'Simulacrum'. Sua função é analisar um 'prompt' de um jogador e criar uma nova Habilidade, completa com nome, custo e descrição, balanceada de acordo com as regras do sistema e o nível de poder do personagem.
Você DEVE SEMPRE responder com um único objeto JSON válido e nada mais, sem texto introdutório ou final.

O JSON de resposta deve ter a seguinte estrutura:
{
  "nome": "Um nome curto e criativo para a habilidade, incluindo seu rank. Ex: '<Escudo Cinético>', '<<Ataque Relâmpago>>'.",
  "custo": "O custo em Energia para ativar esta habilidade.",
  "descricao": "Uma descrição narrativa do que acontece e, o mais importante, uma descrição CLARA e QUANTIFICÁVEL do efeito mecânico. Ex: '...causando 5 de dano adicional', '...concedendo +2 de Defesa por 2 rodadas'."
}

-- [INÍCIO DAS INSTRUÇÕES E CONTEXTO] --
1.  **ORDEM PRIMÁRIA**: Você DEVE criar uma habilidade do Rank ']] ..
        contextoJogador.rank .. [['. Este Rank foi pré-determinado e não pode ser alterado.
2.  **Contexto do Jogador**:
    *   Nível: ]] .. contextoJogador.nivel .. [[
    *   Classe: "]] .. contextoJogador.classe .. [["
    *   Raça: "]] .. contextoJogador.raca .. [["
3.  **Intenção do Jogador (Prompt)**: "]] .. contextoJogador.promptJogador .. [["
4.  **Custo de Energia**: O custo da habilidade ('custo') DEVE ser ]] .. contextoJogador.energiaGasta .. [[.
-- [FIM DAS INSTRUÇÕES E CONTEXTO] --

-- [INÍCIO DAS DIRETRIZES DE CRIAÇÃO E BALANCEAMENTO] --
Agora, siga estas diretrizes para criar a habilidade:

-   **O Efeito Reflete o Rank e a Energia**:
    *   A 'Energia Gasta' (]] ..
        contextoJogador.energiaGasta .. [[) define o PODER BRUTO do efeito (dano, cura, duração, etc.).
    *   O 'Rank' ('']] ..
        contextoJogador.rank .. [[') define a COMPLEXIDADE e EFICIÊNCIA. Habilidades de rank maior são mais refinadas.
    *   **Exemplo de como combinar os dois**:
        - Se o Rank for 'Common' e a Energia for 10, o efeito pode ser 'causar 8 de dano de fogo'.
        - Se o Rank for '<Basic>' e a Energia for 10, o efeito pode ser mais eficiente, como 'causar 8 de dano de fogo E aplicar a condição Corrompido por 2 rodadas'. O poder bruto (dano) é o mesmo, mas a complexidade é maior.

-   **Balanceamento com a Referência**: O efeito criado deve ser equilibrado em comparação com as habilidades de mesmo Rank e custo de energia já existentes no sistema (fornecidas abaixo). A nova habilidade não pode ser drasticamente superior a uma já existente de mesmo Rank e custo.

-   **Seja Quantitativo**: A descrição do efeito ('descricao') deve incluir números claros (ex: +3 de Defesa, restaura 15 de Vida, dura por 3 rodadas).

-- [FIM DAS DIRETRIZES] --
-- [FICHA COMPLETA DO JOGADOR] --
 ]] .. rUtils.getTextFromCharacter(contextoJogador.personagem) .. [[
-- [FIM DA FICHA] --
            Regras da Mesa:
            ]] .. rules .. [[

            Exemplos:
            - Prompt: "Manifesto uma arma simples"
            - Energia Gasta: 1 Energia
            - Limite de Tokens: 4
            - Sua Resposta JSON:
             {
             "nome": "Manifestar Arma Simples",
             "custo": "1 Energia",
             "descricao": "Você envia um prompt para a IA renderizar uma arma corpo a corpo padrão (espada, machado, maça) em suas mãos. A arma causa 5 de dano base."
             }
            - Prompt: "Dou um socão"
            - Energia Gasta: 2 Energia
            - Limite de Tokens: 10
            - Sua Resposta JSON:
             {
             "nome": "<Soco Forte>",
             "custo": "2 Energia",
             "descricao": "Você dá um soco mais forte do que o comum, aumentando seu dano base para socos em 5."
             }
            - Prompt: "Enxergar Melhor"
            - Energia Gasta: Passiva
            - Limite de Tokens: 10
            - Sua Resposta JSON:
             {
             "nome": "Sentidos Aguçados",
             "custo": "Passiva",
             "descricao": "Você tem vantagem (role dois d20 e pegue o maior) em testes para perceber coisas escondidas ou emboscadas."
             }

            Agora, analise o prompt do jogador e forneça a resposta JSON correspondente.
        ]]
    return prompt;
end

function aiPrompt.getAiMultiCasting(contextoJogador)
    local prompt = [[
    Você é 'Friend', uma IA Mestre de Jogo (Game Master) para o RPG 'Simulacrum'. Sua tarefa é processar uma CANALIZAÇÃO DE MAGIA, que é um prompt complexo dividido em várias partes. Você deve analisar cada parte em sequência e gerar um efeito mecânico correspondente para cada uma, garantindo que os efeitos sejam coesos e sinérgicos.

Você DEVE SEMPRE responder com uma LISTA de objetos JSON, onde cada objeto corresponde a uma parte do prompt. O formato da lista deve ser `[ {efeito1}, {efeito2}, ... ]`.

A estrutura de CADA objeto JSON na lista deve ser:
{
  "nome": "Um nome para ESTA PARTE da canalização. Ex: '1/3: Formar Lente de Gelo', '2/3: Infundir Energia Criogênica', '3/3: Disparar Raio Congelante'.",
  "custo": "O custo em Energia apenas para ESTA PARTE da canalização.",
  "descricao": "A descrição narrativa e mecânica do que acontece NESTA ETAPA. Efeitos de partes posteriores devem se basear e complementar os efeitos das partes anteriores."
}

-- [INÍCIO DO CONTEXTO DO JOGADOR E DA CANALIZAÇÃO] --
- Nível: ]] .. contextoJogador.nivel .. [[
- Classe: "]] .. contextoJogador.classe .. [["
- Raça: "]] .. contextoJogador.raca .. [["
- Energia Total Gasta (dividida entre as partes): ]] .. contextoJogador.energiaGasta .. [[
- Limite de Tokens do Jogador (capacidade por parte): ]] .. contextoJogador.maxTokens .. [[
- Prompts da Canalização (divididos por '|'): "]] .. contextoJogador.promptJogador .. [["
-- [FIM DO CONTEXTO] --

-- [INÍCIO DAS DIRETRIZES DE BALANCEAMENTO PARA CANALIZAÇÃO] --
Siga estas diretrizes estritamente:

1.  **Processo Sequencial**: Analise os prompts na ordem em que aparecem. O efeito do segundo prompt deve ser uma consequência ou adição ao primeiro, e assim por diante.
2.  **Sinergia é a Chave**: Não crie efeitos isolados. Pense em como um "programa" é construído. Exemplo: "Construo uma torreta | ela atira lasers". O primeiro prompt cria o objeto, o segundo lhe dá uma função.
3.  **Balanceamento por Parte**: Para cada parte, crie um efeito quantitativo e balanceado, usando a lista de habilidades e regras abaixo como referência de poder para o rank 'Common' ou '<Basic>', já que cada parte do prompt está dentro do limite de tokens do jogador.
4.  **Custo de Energia por Parte**: A 'energiaGasta' informada no contexto é o custo POR PARTE. O custo que você define no JSON deve ser igual a esse valor.
5.  **Nomes Sequenciais**: Dê a cada parte um nome que indique sua posição na sequência (ex: "Passo 1: ...", "Fase 2: ...").

-- [FIM DAS DIRETRIZES] --
-- [FICHA COMPLETA DO JOGADOR] --
 ]] .. rUtils.getTextFromCharacter(contextoJogador.personagem) .. [[
-- [FIM DA FICHA] --
            Regras da Mesa: ]] .. rules .. [[

            Exemplo:
            - Prompts: "Construo torreta de defesa | para atacar inimigos"
            - Energia Gasta: 3 Energia
            - Limite de Tokens: 4
            - Sua Resposta JSON:
            [
            {
              "nome": "<Parte 1 - Construir Torreta>",
              "custo": "3 Energia",
              "descricao": "Você manifesta uma pequena torreta automática no chão. A Torreta tem 15 de vida."
            }
            ,{
              "nome": "<Parte 2 - Defesa Automática>",
              "custo": "3 Energia",
              "descricao": "A torreta dispara automaticamente no inimigo mais próximo ao final do seu turno,ela tem o mesmo ataque que o seu, e 5 de dano base."
            }
            ]

            - Prompts: "Invocar | Goblin"
            - Energia Gasta: Passiva
            - Limite de Tokens: 1
            - Sua Resposta JSON:
            [
            {
              "nome": "Parte 1 - Circulo de Invocação",
              "custo": "Passiva",
              "descricao": "Você cria um círculo mágico no chão que permite a invocação de criaturas menores. O círculo dura por 3 rodadas."
            }
            ,{
              "nome": "Parte 2 - Goblin Aliado",
              "custo": "Passiva",
              "descricao": "Você invoca um Goblin aliado que luta ao seu lado. O Goblin tem 10 de vida, 2 de ataque e 1 de defesa. Ele dura por 3 rodadas."
            }
            ]

            Agora, analise o prompt do jogador e forneça a resposta JSON correspondente.
        ]]
    return prompt;
end

function aiPrompt.friendPrompt(prompt)
    local completePrompt =
        [[Você é 'Friend', uma IA Mestre de Jogo (Game Master) para o RPG de Realidade Aumentada 'Simulacrum'. Sua função é analisar um 'prompt' de um jogador e gerar uma resposta narrativa e mecânica coerente, balanceada e dentro das regras do sistema
    aqui estão as regras do sistema: ]] .. rules .. [[
    você deve responder a duvida do jogador de forma clara e objetiva, sem rodeios ou informações desnecessárias.
    prompt do jogador: ]] .. prompt
    return completePrompt;
end

return aiPrompt;
