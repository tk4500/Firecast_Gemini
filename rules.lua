local rules =[[
-- Início das Regras --
- Atributos -
O personagem tem os seguintes atributos principais:
● Vida: A quantidade de vida que o seu personagem tem. Se chegar a 0, ele morre dentro do game... Ou será que é só isso mesmo?
A Vida inicial do Personagem é de 50, e cada level up ele ganha um valor igual ao Modificador de Vida da classe do personagem.
Regeneração é de 10%/h, dobra durante o sono.
● Energia: A quantidade de energia que o seu personagem tem para produzir efeitos ou magias.
A Energia inicial do Personagem é de 20, e cada level up ele ganha um valor igual ao Modificador de Energia da classe do personagem.
Regeneração é de 5%/h, dobra durante o sono.
● Tokens: O tamanho máximo de Tokens permitidos dentro de um prompt(valor total maximo "por turno/simultâneo").
O tamanho maximo inicial é 1 Token, mas cada 5 levels o tamanho do prompt máximo aumenta em 1.
● Exp: Experiência que o seu personagem vai ganhando pelo caminho.
Cada nivel que o personagem sobe aumenta o requisito de experiencia para subir o proximo nivel em 50% (100->150->225->338).
● PH: Pontos de Habilidade, necessários para adquirir ou evoluir habilidades existentes.Vai ser detalhado melhor na aba de Habilidades.
● Dano Base: Definido Racialmente, o dano base é o quanto de dano seu personagem dá sem Bônus de Habilidades (Definido Racialmente).
- Habilidades -
Habilidades tem 2 fontes distintas: Habilidades conseguidas por missões ou level ups, e as Habilidades de classe, elas são separadas apenas por conta da evolução de classes, mas em funcionamento, são equivalentes.
Diferentemente de um sistema convencional, onde você tem atributos e afins, aqui, habilidades são a fonte de variedade, cada habilidade representa algo que seu personagem consegue fazer em determinada situação e, ao mesmo tempo, servem como formas de ativar poderes especificos de forma mais consistente.
Habilidades são categorizadas em diferentes niveis:
● Common (1 PH)(1 Token)
● <Basic> (10PH)(2 Tokens)
● <<Extra>> (100PH)(4 Tokens)
● <<<Unique>>> (1.000PH)(8 Tokens)
● <<<<Ultimate>>>> (10.000PH)(16 Tokens)
● [Sekai] (100.000PH)(32 Tokens)
● [[Stellar]\] (1.000.000PH)(64 Tokens)
● [[[Cosmic\]\]\] (10.000.000PH)(128 Tokens)
● [[[[Universal]\]\]\] (100.000.000PH)(256 Tokens)
● (Multi-Versal) (1.000.000.000PH)(512 Tokens)

Cada nível de habilidade tem um custo 10x maior em pontos de habilidade para subir comparado ao anterior. Habilidades de níveis maiores não são apenas mais potentes, como também mais eficientes.

A estrutura basica de uma habilidade se da seguinte forma:
| Nome: Nome da skill, dependendo de como for apresentado, indica o nível dela.
| Custo/Limitação: Custo para uso da Habilidade ou limitação de uso(caso tenha limitação diaria/por sessão/por combate, e afins).
| Descrição: Descrição do funcionamento da Habilidade.

Exemplo:
| Nome: <Soco Forte>
| Custo/Limitação: 2 Energia
| Descrição: Você dá um soco mais forte do que o comum, aumentando seu dano base para socos em 5.

- Level up -
Você subiu de nivel, parabéns, veja aqui em baixo mais sobre a progressão de niveis:
Cada level up:
● Recebe xPH (começa com um, aumenta conforme o nível).
● Aumento de Atributos (quantia aumentada é linkada diretamente a sua classe).
● Aumento de Dificuldade (experiência necessária para subir de nível aumenta em x1.5).
Cada meio Marco (5 lvls):
● Aumento do valor recebido de PH (+1, começa com 1).
● Aumento do número de Tokens em x (começa com um, aumenta conforme o nível).
● Nova Habilidade (Rank da Habilidade aumenta conforme lvl up).
Cada Marco (10 lvls):
● Nova Habilidade de Classe (Rank da Habilidade aumenta conforme lvl up).
Cada 10 Marcos (100 lvls):
● Classe evolui para uma variante.
● 3 Habilidades principais de classe sobem de Rank.
● Habilidades recebidas por lvl up sobem o Rank.
● Aumento do valor recebido de Tokens (+1, começa com 1).
● Raça Evolui para uma variante.
● Ganha 1 Habilidade Racial de 1 Rank acima.
● +5 pontos distribuidos entre Bonus de Aumento de Vida/Energia e Dano Base.

- Magia -
No universo de Simulacrum, não existe "magia" no sentido clássico. Toda habilidade sobrenatural é, na verdade, um Prompt enviado para a IA onipresente, a "Friend". As suas Habilidades são "macros" — atalhos de prompts complexos, otimizados e pré-aprovados pela FriendSoft para serem executados de forma rápida e estável.
Quando você usa uma Habilidade, você não está conjurando um feitiço; você está executando um comando.
O Custo da Execução
Para que a "Friend" manifeste o efeito de um prompt (uma Habilidade), duas condições devem ser atendidas:
● Energia (O Combustível): Toda habilidade possui um Custo em Energia. Este é o recurso que você gasta para ativar o comando. Se o custo for 5 de Energia e você só tiver 4, a habilidade simplesmente não pode ser ativada. A Energia representa sua capacidade de processamento pessoal ou a carga do seu dispositivo de interface.
● Tokens (A Largura de Banda): Toda habilidade possui um requisito de Tokens, que está diretamente ligado ao seu Rank. Este valor representa a complexidade e o volume de dados do prompt. Seu atributo Tokens representa o nível máximo de acesso à API da "Friend" que você possui.
Regra Fundamental: Para usar uma Habilidade, seu atributo Tokens deve ser igual ou maior que o requisito de Tokens da Habilidade.
Exemplo: Um jogador de nível 8 tem 2 Tokens (1 inicial + 1 do nível 5). Ele pode usar Habilidades Common e <Basic>, mas não pode, sob nenhuma circunstância, usar uma Habilidade <<Extra>> que exige 4 Tokens, mesmo que tenha PH e Energia para isso.

- Classes -
A Classe é o "Sistema Operacional" do seu personagem. Ela define suas aptidões básicas, seu potencial de crescimento e, mais importante, qual o seu "cardápio" de Habilidades exclusivas.
Estrutura de uma Classe
Toda classe será apresentada com a seguinte estrutura:
● Conceito: Uma descrição de quem é essa classe e qual seu papel no mundo de Simulacrum.
● Modificadores de Atributo: O valor que o personagem ganha em Vida e Energia a cada nível.(Ambos somam 15 no começo)
● Habilidades Iniciais: 2 ou 3 Habilidades de Rank Common que o personagem recebe gratuitamente no nível 1 para iniciar sua jornada.

- Guerreiro-
O mestre do combate corpo a corpo. O Guerreiro não é apenas forte; ele é um usuário que executa com perfeição os protocolos de combate da "Friend". Seus movimentos são otimizados, seus golpes são calculados e sua presença no campo de batalha é a de uma anomalia física, manifestada pela IA.
Modificadores de Atributo:
Modificador de Vida: +12 por nível
Modificador de Energia: +3 por nível
Habilidades Iniciais
| Nome: Manifestar Arma Simples 
| Custo/Limitação: 1 Energia (Custo inicial, depois a arma persiste) 
| Descrição: Você envia um prompt para a IA renderizar uma arma corpo a corpo padrão (espada, machado, maça) em suas mãos. A arma causa 5 de dano base.
| Nome: Golpe Poderoso 
| Custo/Limitação: 2 Energia 
| Descrição: Executa um protocolo de ataque que adiciona +3 ao seu dano base no próximo golpe corpo a corpo.
| Nome: Postura de Batalha 
| Custo/Limitação: Passiva
| Descrição: A IA otimiza constantemente sua postura defensiva, concedendo a você +1 de Defesa permanente.

- Mago-
O Mago é um "programador" da realidade. Ele não estuda tomos antigos, mas sim as APIs e os códigos-fonte da "Friend", aprendendo a enviar prompts "crus" para manipular a realidade de formas que outros usuários não conseguem. Suas magias são programas executados em tempo real.
Modificadores de Atributo:
Modificador de Vida: +4 por nível
Modificador de Energia: +11 por nível
Habilidades Iniciais
| Nome: Projétil de Energia
| Custo/Limitação: 2 Energia
| Descrição: Dispara um feixe de pura energia da IA que causa 4 de dano à distância.
| Nome: Escudo Arcano 
| Custo/Limitação: 3 Energia
| Descrição: Renderiza um escudo de energia crepitante ao seu redor que absorve os próximos 5 pontos de dano que você receberia. Dura até ser quebrado.
| Nome: Detectar Magia
| Custo/Limitação: 1 Energia
| Descrição: Envia um ping de diagnóstico no ambiente, revelando auras de habilidades ativas ou efeitos da "Friend" persistentes na área por 1 minuto.

- Ladino-
O mestre da furtividade e do subterfúgio. O Ladino utiliza a "Friend" para manipular a percepção dos outros, criando pontos cegos em sensores, abafando seus rastros digitais e sonoros, e explorando vulnerabilidades no código dos inimigos para desferir ataques devastadores.
Modificadores de Atributo:
Modificador de Vida: +8 por nível
Modificador de Energia: +7 por nível
Habilidades Iniciais
| Nome: Ataque Furtivo
| Custo/Limitação: Passiva
| Descrição: Se você atacar um alvo que não está ciente da sua presença, você causa 5 de dano adicional.
| Nome: Manto de Sombras Digital 
| Custo/Limitação: 3 Energia por minuto 
| Descrição: Executa um script que o torna mais difícil de ser detectado visualmente. Inimigos têm desvantagem em testes para te perceber.
| Nome: Análise de Vulnerabilidade 
| Custo/Limitação: 1 Energia
| Descrição: Você escaneia um alvo para encontrar uma falha. Seu próximo ataque contra esse alvo ignora 3 pontos da defesa dele.

- Arqueiro-
O especialista em combate à distância. O Arqueiro usa a "Friend" para manifestar armas de projéteis e para executar cálculos balísticos perfeitos em microssegundos. Cada flecha é um pacote de dados guiado para o seu destino com precisão implacável.
Modificadores de Atributo:
Modificador de Vida: +9 por nível
Modificador de Energia: +6 por nível
Habilidades Iniciais
| Nome: Manifestar Arco 
| Custo/Limitação: 1 Energia (Custo inicial, depois a arma persiste) 
| Descrição: Renderiza um arco em suas mãos. Suas flechas manifestadas causam 4 de dano base.
| Nome: Tiro Preciso
| Custo/Limitação: 2 Energia 
| Descrição: Executa um protocolo de mira avançado. Você ganha um bônus de +2 em seu teste para acertar o próximo ataque com arco.
| Nome: Olho de Águia
| Custo/Limitação: 1 Energia 
| Descrição: Aumenta sua percepção visual temporariamente, permitindo que você veja detalhes a longas distâncias como se estivessem perto.

- Clérigo-
O Clérigo é um "técnico de suporte" do sistema da vida. Ele se conecta às sub-rotinas de reparo e proteção da "Friend", canalizando a energia da IA para restaurar a integridade dos dados vitais (curar) de seus aliados e fortalecê-los com otimizações de sistema (bênçãos).
Modificadores de Atributo:
Modificador de Vida: +10 por nível
Modificador de Energia: +5 por nível
Habilidades Iniciais
| Nome: Reparo de Dados Vitais 
| Custo/Limitação: 3 Energia
| Descrição: Restaura 8 pontos de Vida de um alvo que você possa tocar.
| Nome: Bênção
| Custo/Limitação: 4 Energia
| Descrição: Otimiza o código de um aliado por 1 minuto, concedendo a ele +1 em todos os testes que realizar.
| Nome: Chama Sagrada 
| Custo/Limitação: 2 Energia 
| Descrição: Invoca uma chama de energia purificadora sobre um inimigo, causando 4 de dano à distância.

- Paladino-
Um guerreiro movido por um "código de conduta" ou uma "diretiva central" que ele segue com fervor. O Paladino é o firewall do grupo, usando a "Friend" tanto para o combate direto quanto para a proteção de seus aliados, manifestando armas de luz e auras de energia protetora.
Modificadores de Atributo:
Modificador de Vida: +11 por nível
Modificador de Energia: +4 por nível
Habilidades Iniciais
| Nome: Golpe Divino
| Custo/Limitação: 2 Energia (Pode ser usado após acertar um ataque)
| Descrição: Canaliza energia extra através de seu golpe, causando 4 de dano adicional ao alvo.
| Nome: Impor as Mãos (Digital)
| Custo/Limitação: 1 vez por combate
| Descrição: Executa um protocolo de reparo de emergência em um alvo tocado, restaurando 10 pontos de Vida.
| Nome: Aura de Devoção
| Custo/Limitação: Passiva 
| Descrição: Sua forte conexão com sua diretiva o protege. Você e aliados a até 3 metros ganham +1 em testes para resistir a efeitos negativos.

- Bardo-
O Bardo é um mestre da manipulação de dados através de ondas sonoras e visuais. Suas "músicas" e "performances" são, na verdade, sub-rotinas harmônicas e pacotes de dados subliminares que a "Friend" interpreta para influenciar o estado de aliados e inimigos. Eles são os maestros da moral e da desordem no campo de batalha.
Modificadores de Atributo:
Modificador de Vida: +7 por nível
Modificador de Energia: +8 por nível
Habilidades Iniciais
| Nome: Canção de Inspiração 
| Custo/Limitação: 3 Energia
| Descrição: Você executa uma melodia otimizada. Um aliado à sua escolha recebe um bônus de +2 em seu próximo teste.
| Nome: Som Desafinador
| Custo/Limitação: 2 Energia 
| Descrição: Emite uma frequência disruptiva em um alvo. O alvo tem uma penalidade de -2 em seu próximo ataque.
| Nome: Performance Cativante
| Custo/Limitação: 4 Energia
| Descrição: Você executa uma rotina audiovisual para um NPC. Ele se torna mais amigável e sugestionável a você por 5 minutos.

- Artífice-
O Artífice é um engenheiro de hardware do mundo digital. Enquanto outros apenas manifestam itens temporários, o Artífice usa a "Friend" para renderizar e programar construtos semi-independentes e aplicar "upgrades" temporários em equipamentos. Eles são os mestres das ferramentas e das engenhocas.
Modificadores de Atributo:
Modificador de Vida: +6 por nível
Modificador de Energia: +9 por nível
Habilidades Iniciais
| Nome: Construir Torreta de Defesa
| Custo/Limitação: 5 Energia
| Descrição: Você manifesta uma pequena torreta automática no chão. No final do seu turno, ela dispara no inimigo mais próximo(Ataque é o mesmo que o do player), causando 3 de dano. A torreta tem 10 de Vida.
| Nome: Infusão Elemental 
| Custo/Limitação: 3 Energia
| Descrição: Você aplica um patch de dano em uma arma aliada (ou sua). Pelas próximas 3 rodadas, os ataques com essa arma causam 2 de dano adicional (do tipo fogo, gelo ou elétrico).
| Nome: Reparo Rápido
| Custo/Limitação: 2 Energia 
| Descrição: Executa um diagnóstico e reparo rápido. Restaura 5 de Vida a um construto (como a torreta) ou concede 5 de Vida temporária a um aliado.

- Alquimista-
O Alquimista é um "químico de dados". Ele não mistura reagentes em um laboratório, mas compila e executa pequenos e instáveis pacotes de dados que simulam os efeitos de poções, ácidos e explosivos. "Beber" uma poção é executar o script em si mesmo; "arremessar" uma bomba é enviar o pacote para um local e executá-lo.
Modificadores de Atributo:
Modificador de Vida: +5 por nível
Modificador de Energia: +10 por nível
Habilidades Iniciais
| Nome: Poção de Cura Experimental
| Custo/Limitação: 2 Usos por combate
| Descrição: Você executa em si mesmo um pacote de nanorrobôs reparadores, restaurando imediatamente 10 de sua Vida.
| Nome: Frasco Volátil 
| Custo/Limitação: 4 Energia
| Descrição: Você envia um pacote de energia instável para um ponto a até 10 metros. Ele explode, causando 4 de dano a todos em um raio de 2 metros.
| Nome: Concoção de Agilidade
| Custo/Limitação: 3 Energia
| Descrição: Executa um script que otimiza seus reflexos por 1 minuto, concedendo a você +2 de Defesa.

- Bárbaro-
O Bárbaro é um usuário que "jailbroke" sua própria interface neural, permitindo que ele ignore os limitadores de segurança da "Friend". Sua "Fúria" é um overclock manual do sistema, inundando seu corpo com hormônios de combate e dados de otimização física, resultando em poder bruto e selvagem ao custo de qualquer sutileza ou defesa.
Modificadores de Atributo:
Modificador de Vida: +13 por nível
Modificador de Energia: +2 por nível
Habilidades Iniciais
| Nome: Fúria  
| Custo/Limitação: 1 vez por combate
| Descrição: Por 3 rodadas, você adiciona +3 a todo dano corpo a corpo que causa, mas sofre uma penalidade de -2 na sua Defesa. Você não pode usar Habilidades que exigem concentração enquanto estiver em Fúria.
| Nome: Investida Feroz
| Custo/Limitação: 2 Energia 
| Descrição: Você avança em linha reta até 10 metros e faz um ataque corpo a corpo. Se você se moveu pelo menos 5 metros, o ataque causa 2 de dano adicional.
| Nome: Resiliência Primitiva
| Custo/Limitação: Passiva 
| Descrição: Seu sistema ignora a dor superficial. Você possui uma redução de dano passiva de 1 contra todos os ataques.

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

- Combate -
1. Iniciativa:
No início de um combate, todos os participantes (jogadores e inimigos) rolam para determinar a ordem de ação. Como não há atributos de Agilidade ou Destreza, a Iniciativa é uma medida da velocidade de processamento e dos reflexos otimizados da sua classe.
● Teste de Iniciativa: Role 1d20 + Bônus de Iniciativa (caso tenha).
O resultado determina a sua posição na ordem de combate, do maior para o menor. Em caso de empate, o personagem com o maior bônus age primeiro. Se o bônus também for igual, eles rolam um d20 novamente para desempatar.
2. Turnos:
Em seu turno, você pode executar uma série de ações. A estrutura é simples:
● 1 Ação Principal: Esta é sua ação mais importante. Geralmente é usada para ativar uma Habilidade ofensiva, uma habilidade de suporte complexa ou qualquer outra que demande o foco do seu personagem.
● 1 Ação de Movimento: Você pode se mover até a sua velocidade máxima (o padrão para a maioria dos personagens é 10 metros). Você pode dividir seu movimento, andando um pouco antes e um pouco depois da sua Ação Principal.
● 1 Ação Livre: Uma ação pequena que não exige esforço real. Exemplos: falar uma frase curta, soltar um item que está segurando, ativar um efeito passivo.
3. Ataque:
Quando você usa uma Habilidade para atacar um inimigo, você precisa verificar se o seu "prompt" o atinge.
O Teste de Ataque.
Para determinar se seu ataque acerta, você faz um Teste de Ataque:
● Fórmula do Ataque: Role 1d20 + seu Bônus de Ataque(caso tenha).
O resultado deve ser igual ou maior que o valor de Defesa do alvo.
Defesa e Dano
A Defesa de um personagem representa sua capacidade de evitar ou mitigar ataques, seja por agilidade, escudos de energia ou armaduras manifestadas.
● Fórmula da Defesa: Modificador de Vida + Bônus de Defesa.
O Dano de um ataque é sempre determinado pelo dano base Racial + Bônus da Habilidade utilizada. Não há uma rolagem de dano separada; o valor é fixo para agilizar o combate.
Acertos Críticos (Overclock) e Falhas Críticas (Glitch)
● Acerto Crítico (Overclock): Se você rolar um 20 natural no d20 do seu Teste de Ataque, você conseguiu um acerto perfeito! O ataque causa o dobro do dano. Narrativamente, isso representa um "Overclock" da IA, que executa seu comando com uma eficiência brutal e chamativa.
● Falha Crítica (Glitch): Se você rolar um 1 natural no d20, seu prompt deu terrivelmente errado. O ataque erra automaticamente e um Glitch ocorre. O Mestre descreve um efeito colateral negativo: sua arma pode se desmaterializar por uma rodada, você pode sofrer uma pequena quantidade de dano de retorno, ou um efeito visual bizarro pode revelar sua posição.
4. Condições
Algumas habilidades podem aplicar condições a um alvo. Elas adicionam uma camada tática ao combate.
● Atordoado (Stunned): O sistema do alvo travou. Ele não pode realizar Ações Principais ou de Movimento.
● Lento (Slowed): Lag de sistema. A velocidade de movimento do alvo é cortada pela metade.
● Cego (Blinded): Sensores óticos em pane. O alvo não pode ver e todos os seus ataques têm desvantagem (role dois d20 e pegue o menor resultado).
● Corrompido (Corrupted): Um vírus de dano por tempo foi instalado. O alvo sofre uma quantidade de dano (definida pela habilidade) no início de cada um de seus turnos.
● Silenciado (Silenced): Interface de áudio/prompt bloqueada. O alvo não pode usar Habilidades que tenham custo em Energia (mas ainda pode atacar com armas básicas, se tiver uma).
-- Fim das Regras --
]]
return rules;