local guerreiro = [[
- Guerreiro-
O mestre do combate corpo a corpo. O Guerreiro não é apenas forte; ele é um usuário que executa com perfeição os protocolos de combate da "Friend". Seus movimentos são otimizados, seus golpes são calculados e sua presença no campo de batalha é a de uma anomalia física, manifestada pela IA.
Modificadores de Atributo:
Modificador de Vida: +12 por nível
Modificador de Energia: +3 por nível
Habilidades Iniciais
| Nome: Manifestar Arma Simples
| Custo/Limitação: 1 Energia (Custo inicial, depois a arma persiste)
| Descrição: Você envia um prompt para a IA renderizar uma arma corpo a corpo padrão (espada, machado, maça) em suas mãos. A arma aumenta seu dano base em 5.
| Nome: Golpe Poderoso
| Custo/Limitação: 2 Energia
| Descrição: Executa um protocolo de ataque que adiciona +3 ao seu dano base no próximo golpe corpo a corpo.
| Nome: Postura de Batalha
| Custo/Limitação: Passiva
| Descrição: A IA otimiza constantemente sua postura defensiva, concedendo a você +1 de Defesa permanente.
]]
local mago = [[
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
]]
local ladino = [[
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
]]
local arqueiro = [[
- Arqueiro-
O especialista em combate à distância. O Arqueiro usa a "Friend" para manifestar armas de projéteis e para executar cálculos balísticos perfeitos em microssegundos. Cada flecha é um pacote de dados guiado para o seu destino com precisão implacável.
Modificadores de Atributo:
Modificador de Vida: +9 por nível
Modificador de Energia: +6 por nível
Habilidades Iniciais
| Nome: Manifestar Arco
| Custo/Limitação: 1 Energia (Custo inicial, depois a arma persiste)
| Descrição: Renderiza um arco em suas mãos. Suas flechas manifestadas causam +4 de dano base.
| Nome: Tiro Preciso
| Custo/Limitação: 2 Energia
| Descrição: Executa um protocolo de mira avançado. Você ganha um bônus de +2 em seu teste para acertar o próximo ataque com arco.
| Nome: Olho de Águia
| Custo/Limitação: 1 Energia
| Descrição: Aumenta sua percepção visual temporariamente, permitindo que você veja detalhes a longas distâncias como se estivessem perto.
]]
local clerigo = [[
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
]]
local paladino = [[
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
]]
local bardo = [[
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
]]
local artifice = [[
- Artífice-
O Artífice é um engenheiro de hardware do mundo digital. Enquanto outros apenas manifestam itens temporários, o Artífice usa a "Friend" para renderizar e programar construtos semi-independentes e aplicar "upgrades" temporários em equipamentos. Eles são os mestres das ferramentas e das engenhocas.Modificadores de Atributo:
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
]]
local alquimista = [[
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
]]
local barbaro = [[
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
]]
local classes = [[
- Classes -
A Classe é o "Sistema Operacional" do seu personagem. Ela define suas aptidões básicas, seu potencial de crescimento e, mais importante, qual o seu "cardápio" de Habilidades exclusivas.
Estrutura de uma Classe
Toda classe será apresentada com a seguinte estrutura:
● Conceito: Uma descrição de quem é essa classe e qual seu papel no mundo de Simulacrum.
● Modificadores de Atributo: O valor que o personagem ganha em Vida e Energia a cada nível.(Ambos somam 15 no começo)
● Habilidades Iniciais: 2 ou 3 Habilidades de Rank Common que o personagem recebe gratuitamente no nível 1 para iniciar sua jornada.
- Classes Disponíveis -
]] .. guerreiro .. [[
]] .. mago .. [[
]] .. ladino .. [[
]] .. arqueiro .. [[
]] .. clerigo .. [[
]] .. paladino .. [[
]] .. bardo .. [[
]] .. artifice .. [[
]] .. alquimista .. [[
]] .. barbaro .. [[

]]
return classes
