local humano = [[
- Humano -
O modelo padrão, versátil e adaptável. Os Humanos não se destacam em uma única área, mas sua flexibilidade os torna capazes de se adaptar a qualquer classe ou situação.
Modificadores:
Modificador de Vida: +4 por nível
Modificador de Energia: +3 por nível
Dano Base: 3
Habilidade Racial:
| Nome: Vontade Indomável
| Custo/Limitação: 1 vez por dia
| Descrição: Você pode rolar novamente um teste que acabou de falhar.
]]
local elfo = [[
- Elfo -
Um firmware elegante, otimizado para processamento rápido e percepção aguçada. Os Elfos são naturalmente sintonizados com o fluxo de dados da "Friend", tornando-os excelentes Magos e Arqueiros.
Modificadores:
Modificador de Vida: +2 por nível
Modificador de Energia: +6 por nível
Dano Base: 2
Habilidade Racial:
| Nome: Sentidos Aguçados
| Custo/Limitação: Passiva
| Descrição: Você tem vantagem (role dois d20 e pegue o maior) em testes para perceber coisas escondidas ou emboscadas.
]]
local anao = [[
- Anão -
Um design robusto e resiliente, construído para durabilidade máxima. Os Anões são avatares com uma integridade estrutural e uma resistência a corrupção de dados inigualáveis. São a linha de frente perfeita.
Modificadores:
Modificador de Vida: +7 por nível
Modificador de Energia: +1 por nível
Dano Base: 2
Habilidade Racial:
| Nome: Resiliência da Forja
| Custo/Limitação: Passiva
| Descrição: Você tem vantagem em testes para resistir a venenos (vírus de dados) e sua velocidade não é reduzida por armadura pesada.
]]
local orc = [[
- Orc -
Um firmware de combate, focado em agressão e poder bruto. Os Orcs foram projetados para o impacto, canalizando toda a sua energia em protocolos de ataque devastadores, muitas vezes negligenciando suas próprias defesas.
Modificadores:
Modificador de Vida: +3 por nível
Modificador de Energia: +1 por nível
Dano Base: 6
Habilidade Racial:
| Nome: Ataque Selvagem
| Custo/Limitação: 1 vez por turno
| Descrição: Você pode escolher sofrer uma penalidade de -2 no seu teste de ataque para ganhar +4 de dano caso ele acerte.
]]
local kijin = [[
- Kijin -
Um firmware de elite, considerado a evolução refinada do modelo Oni. O Kijin troca a força bruta descontrolada por um equilíbrio perfeito entre poder, resiliência e eficiência energética. Seus avatares são muitas vezes esteticamente agradáveis, escondendo um poder latente que pode ser liberado em surtos controlados e devastadores. Eles são os guerreiros nobres e os samurais do universo Simulacrum.
Modificadores:
Modificador de Vida: +4 por nível
Modificador de Energia: +2 por nível
Dano Base: 4
Habilidade Racial:
| Nome: Aura de Poder
| Custo/Limitação: 1 vez por combate
| Descrição: Como uma Ação Livre no seu turno, você pode manifestar sua aura de poder. Seu próximo ataque que acertar neste turno causa 5 de dano adicional.
]]
local ogre = [[
- Ogre -
Um firmware pesado, projetado para tarefas de demolição e processamento de dados brutos. Os avatares Ogre são imponentes e fisicamente dominantes, com uma capacidade de processamento de energia quase nula, compensada por uma integridade estrutural massiva e uma força de impacto devastadora. Eles são as "unidades de cerco" do mundo digital, simples, diretos e brutalmente eficazes.
Modificadores:
Modificador de Vida: +5 por nível
Modificador de Energia: +0 por nível
Dano Base: 5
Habilidade Racial:
| Nome: Impacto Avasalador
| Custo/Limitação: Passiva
| Descrição: Quando você acerta um alvo com seu Ataque Básico, o alvo deve fazer um teste (Dificuldade = Modificador de Vida) ou será empurrado 2 metros para trás.
]]
local etereo = [[
- Etéreo -
Diferente das outras raças que emulam uma estrutura física, o Etéreo é um "firmware" experimental, um avatar composto quase inteiramente por dados e energia puros, contidos por um campo de força com uma forma humanoide. Eles são seres de informação, e sua existência é mais um fluxo de energia do que um corpo sólido. Por isso, ataques contra eles desestabilizam esse campo de energia antes de atingir seu núcleo vital.
Modificadores:
Modificador de Vida: +1 por nível
Modificador de Energia: +8 por nível
Dano Base: 1
Habilidade Racial:
| Nome: Corpo Etéreo
| Custo/Limitação: Passiva
| Descrição: Todo dano que você receberia em sua Vida é, em vez disso, subtraído da sua Energia. Se o dano recebido for maior que sua Energia atual, o dano restante é aplicado à sua Vida. Este efeito só funciona enquanto você tiver 1 ou mais pontos de Energia.
]]
local racas = [[
- Raças -
Em Simulacrum, uma "raça" é o "firmware" base ou o "modelo de avatar" sobre o qual seu personagem é construído. Diferentes firmwares têm otimizações distintas para processamento de vida, energia e protocolos de combate básicos.
Modelo de montagem de Raça:
1. Nome da Raça/Conceito
2. Distribuição de Pontos: Cada Raça começa com 10 pontos a serem distribuidos nas seguintes questões:
Modificador de Vida: Um valor adicionado ao seu aumento de Vida (soma com o da classe para o aumento da vida total).
Modificador de Energia: Um valor adicionado ao seu aumento de Energia (soma com o da classe para o aumento da energia total).
Dano Base: O dano que você causa com a Ação de Ataque Básico.
3. Habilidade Racial: Escolha ou crie uma Habilidade Racial de rank Common. Ela deve refletir o conceito de sua Raça.
Alguns exemplos de Habilidades Raciais Common:
| Nome: Visão no Escuro
| Custo/Limitação: Passiva
| Descrição: Seus sensores óticos ignoram a penalidade de escuridão comum.
| Nome: Pele Rochosa 
| Custo/Limitação: Passiva 
| Descrição: Você possui +1 de Defesa Base.
| Nome: Vigor Híbrido 
| Custo/Limitação: 1 vez por combate 
| Descrição: Você pode converter 5 de Energia em 5 de Vida, ou vice-versa.
| Nome: Mente Afiada 
| Custo/Limitação: Passiva 
| Descrição: Você ganha +1 no seu Bônus de Iniciativa.
| Nome: Garras Naturais 
| Custo/Limitação: Passiva 
| Descrição: Seu Dano Base é considerado do tipo "perfurante" e ignora 1 ponto de Defesa do alvo.
Em outras páginas irão ter varios exemplos de raças que vocês podem aproveitar, estas já estão pré-aprovadas e são as mais simples.
- Evolução -
No mesmo momento em que sua classe evolui, seu "firmware" racial também recebe um update massivo.
Você ganha +5 pontos distribuidos entre seus Modificadores de Vida, Energia e Dano Base.
Você ganha +1 Habilidade Racial nova. O Rank dessa nova habilidade depende do marco:
Nível 100: Ganha uma habilidade <Basic>.
Nível 200: Ganha uma habilidade <<Extra>>.
E assim por diante...
--
-- Exemplos de Raças:
]] .. humano .. [[
]] .. elfo .. [[
]] .. anao .. [[
]] .. orc .. [[
]] .. kijin .. [[
]] .. ogre .. [[
]] .. etereo .. [[
--
]]
return racas