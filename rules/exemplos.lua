local exemplos = [[
Exemplos:
| Nome: Disparo de Energia
| Custo/Limitação: 2 de Energia
| Descrição: Você envia um prompt básico de ataque. Um feixe de luz pura é renderizado e disparado em um alvo. Você ataca, e , se acertar, causa seu Dano Base + 2 de dano.

| Nome: Musculatura Desenvolvida
| Custo/Limitação: Passiva
| Descrição: Testes relacionados à levantar, empurrar, carregar e ser fisicamente forte num geral recebem um bônus de +2 em suas rolagens.

| Nome: Alquimia Eficiente
| Custo/Limitação: Passiva
| Descrição: Ao criar um item, há 50% de chance de uma segunda cópia dessse item ser criada junto.

| Nome: Empata
| Custo/Limitação: Passiva
| Descrição: Você consegue descobrir uma informação aleatória sobre os inimigos de um combate, seja Vida, Energia, ou uma Skill que eles possuam.

| Nome: Lâmina Biológica
| Custo/Limitação: Passiva, -1 na precisão
| Descrição: Seu braço esquerdo se tornou uma lâmina quitinosa e grotesca, fazendo com que seus ataques causem +3 de dano adicional, mas fazem você ter -1 nos testes de ataque.

| Nome: Queda Lenta
| Custo/Limitação: 4 Energia
| Descrição: Ao estiver caindo a uma altura que irá machucar, você pode eliminar o dano da queda em 50%.

| Nome: Zero Gravidade
| Custo/Limitação: 8 Energia
| Descrição: Você elimina a gravidade um raio de 10 metros ao redor de você fazendo todos começarem a flutuar, cortando a velocidade de movimento de todos que não voam em 50% e causando desvantagem (role dois dados e escolha o menor) em testes para desviar de ataques.

| Nome: Invocar Comida
| Custo/Limitação: Uma vez por dia
| Descrição: Você tira comida de algum compartimento secreto, recuperando metade de sua vida e energia, essa habilidade só pode ser usada fora de combate.

| Nome: Provisões de Emergência
| Custo/Limitação: Uma vez por dia
| Descrição: Você faz primeiros socorros em si mesmo ou em um alvo que possa tocar, esse alvo recupera 1/3 da vida.

| Nome: Suportar Dor
| Custo/Limitação: Uma vez por dia
| Descrição: Se um ataque fosse reduzir seus pontos de vida à 0, utilize essa habilidade como uma reação e fique com 1 de vida no lugar.

| Nome: Nadador Terrestre
| Custo/Limitação: 3 por turno
| Descrição: Você ganha a habilidade de movimentar debaixo do solo na mesma velocidade que conseguiria acima andando sem problemas, em solos duros como feitos de metal, você necessita de gastar sua ação principal para entrar no solo.

| Nome: Surto de Inspiração
| Custo/Limitação: 30 de Energia
| Descrição: Você de repente tem uma ideia mirabulosa que fez seu projeto ir de bom a melhor! Enquanto você estiver criando um item, ao gastar 30 de energia você aumenta a qualidade do item em um nível.

| Nome: Surto de Ação
| Custo/Limitação: 12 de Energia
| Descrição: Após utilizar sua ação principal, você pode pagar 12 de energia para fazer a ação novamente, pagando quaisquer custos pagou de novo, essa habilidade não permite você utilizar habilidades que tem um limite de uma vez por um determinado período de tempo.

| Nome: Foco Excessivo
| Custo/Limitação: Passiva, -2 no dano base
| Descrição: Você foca demais em acertar seus ataques à preço de enfraquecê-los pois não coloca força neles, você tem +2 em testes de ataque mas seu dano base diminui em 2.

| Nome: Escudo Rápido
| Custo/Limitação: 3 de Energia
| Descrição: Você executa um script defensivo de emergência. Uma barreira hexagonal translúcida surge à sua frente, concedendo +3 de Defesa até o início do seu próximo turno.

| Nome: Análise Tática
| Custo/Limitação: 1 de Energia
| Descrição: Você solicita à "Friend" os dados públicos de um alvo. Você descobre a Vida atual e a Defesa Base de um inimigo. O Mestre também pode revelar uma fraqueza óbvia, se houver.

| Nome: Pulso Desacelerador
| Custo/Limitação: 4 de Energia
| Descrição: Um prompt que interfere no clock do sistema de um alvo. Se o ataque acertar, além do dano, o alvo sofre a condição Lento por 1 rodada.

| Nome: <Lança de Plasma>
| Custo/Limitação: 6 de Energia
| Descrição: Um prompt de ataque aprimorado. Você materializa e lança uma lança de energia superaquecida. Causa seu Dano Base + 5 de dano e ignora 1 ponto de Defesa do alvo.

| Nome: <Pacote de Cura Otimizado>
| Custo/Limitação: 5 de Energia
| Descrição: Você executa um comando de diagnóstico e reparo de avatar. Você ou um aliado que você toca recupera 15 de Vida.

| Nome: <Granada de Estática>
| Custo/Limitação: 8 de Energia
| Descrição: Você renderiza e arremessa uma esfera que explode em pura estática de dados. Todos em uma área de 3 metros de raio do ponto de impacto devem fazer um Teste de Ataque contra sua Defesa. Em caso de falha, sofrem Dano Base + 2 de dano e a condição Atordoado por 1 rodada.

| Nome: <Salto Quântico>
| Custo/Limitação: 5 de Energia
| Descrição: Você envia um prompt de realocação. Seu avatar se desmaterializa em pixels e se rematerializa instantaneamente em qualquer ponto que você possa ver a até 15 metros de distância. Não gasta sua Ação de Movimento.

| Nome: <Soco Forte>
| Custo/Limitação: 2 Energia
| Descrição: Você dá um soco mais forte do que o comum, você recebe um bônus de +5 de dano para ataques que sejam feitos com soco.

| Nome: <Lança de Chamas> 
| Custo/Limitação: 8 Energia 
| Descrição: Você dispara um cone de 5 metros de chamas digitais. Todos os alvos na área devem fazer um Teste ou sofrerão 8 de dano.

| Nome: <Escudo de Aegis> 
| Custo/Limitação: 6 Energia 
| Descrição: Você projeta um escudo de energia em um aliado (ou em você mesmo). O alvo ganha 15 de Vida temporária. Dura até ser quebrado.

| Nome: <Passo Fantasma> 
| Custo/Limitação: 5 Energia 
| Descrição: Você se desmaterializa e se rematerializa em qualquer ponto a até 10 metros que você possa ver.

| Nome: <Bênção de Batalha> 
| Custo/Limitação: 10 Energia 
| Descrição: Você e todos os aliados a até 5 metros de você ganham +1 em todos os Testes de Ataque por 3 rodadas.

| Nome: <<Tempestade de Cacos Virtuais>>
| Custo/Limitação: 12 de Energia
| Descrição: Você sobrecarrega a renderização local, criando uma tempestade de pixels cortantes em uma área de 5 metros de raio. Inimigos que começam ou entram na área sofrem 8 de dano e recebem a condição Corrompido (2 de dano por turno). A tempestade dura 3 rodadas.

| Nome: <<Fortaleza de Dados>>
| Custo/Limitação: 10 de Energia
| Descrição: Um prompt de arquitetura defensiva. Você renderiza uma muralha sólida de até 10 metros de comprimento e 3 de altura. A muralha tem 50 de Vida e 10 de Defesa, e pode ser usada como cobertura.

| Nome: <<Renderizar Drone de Combate>>
| Custo/Limitação: 15 de Energia, 1 vez por combate
| Descrição: Você executa um script de "companheiro". Um drone de combate autônomo é materializado ao seu lado. Ele age no seu turno, tem 20 de Vida, 12 de Defesa, e pode realizar um ataque que causa 6 de dano. Ele dura até ser destruído ou o combate acabar.

| Nome: <<Meteoro Digital>> 
| Custo/Limitação: 20 Energia 
| Descrição: Você chama um fragmento massivo de dados corrompidos dos céus em um ponto a até 30 metros. Inimigos em um raio de 5 metros do impacto sofrem 25 de dano de impacto e ficam Lentos por 1 rodada.

| Nome: <<Santuário Protetor>> 
| Custo/Limitação: 15 Energia 
| Descrição: Você cria uma redoma de 5 metros de raio por 3 rodadas. Inimigos não podem entrar na área e projéteis de fora não a penetram. Aliados podem atirar de dentro para fora.

| Nome: <<Invisibilidade Aprimorada>> 
| Custo/Limitação: 10 Energia por minuto 
| Descrição: Você se torna completamente invisível. Atacar ou usar outra habilidade ofensiva quebra a invisibilidade.

| Nome: <<Maldição da Corrupção>> 
| Custo/Limitação: 12 Energia 
| Descrição: Você infecta um alvo com um vírus de dados. O alvo fica Corrompido, sofrendo 5 de dano no início de cada um de seus turnos, e não pode receber cura. O efeito dura 1 minuto ou até ser purificado.

| Nome: <<<Aniquilação de Realidade>>> 
| Custo/Limitação: 40 Energia 
| Descrição: Você dispara um raio de pura entropia em um alvo. O ataque causa 50 de dano que ignora qualquer tipo de resistência ou redução de dano. Um alvo derrotado por esta habilidade não pode ser ressuscitado por meios normais.

| Nome: <<<Invulnerabilidade Temporal>>> 
| Custo/Limitação: 1 vez por dia 
| Descrição: Por 2 rodadas completas, você se torna imune a todo e qualquer tipo de dano. Você pode agir normalmente.

| Nome: <<<Distorção Espacial>>> 
| Custo/Limitação: 30 Energia 
| Descrição: Você abre um portal entre dois pontos que você possa ver (distância máxima de 1km). Você e até 5 aliados podem atravessá-lo instantaneamente.

| Nome: <<<Avatar de Poder>>> 
| Custo/Limitação: 25 Energia, 1 vez por combate 
| Descrição: Você entra em um estado de "overclock" perfeito. Por 3 rodadas, seu Dano Base se torna 15, você ganha +20 de Vida temporária e todos os custos de Energia de suas habilidades são reduzidos pela metade.

| Nome: <<<Singularidade Colapsante>>>
| Custo/Limitação: 25 de Energia
| Descrição: Você envia um prompt tão denso que a "Friend" o interpreta como um comando gravitacional. Um ponto de escuridão pura surge e colapsa sobre um alvo, causando 50 de dano. O efeito é tão violento que o chão ao redor do alvo racha e se deforma, um efeito físico real e permanente.

| Nome: <<<Zona de Anulação>>>
| Custo/Limitação: 30 de Energia, 1 vez por dia
| Descrição: Você cria um campo de "silêncio de API" com 15 metros de raio, centrado em você. Dentro desta zona, nenhuma habilidade que custe Energia (sua ou de inimigos) pode ser ativada. A zona dura 3 rodadas. Os efeitos visíveis incluem falhas na iluminação artificial e estática em aparelhos eletrônicos próximos no mundo real.

| Nome: <<<Acesso Root>>>
| Custo/Limitação: 20 de Energia, 1 vez por sessão
| Descrição: Você força um prompt de "privilégio elevado" diretamente na "Friend". Você pode fazer uma pergunta direta ao Mestre sobre um segredo do cenário (Como a FriendSoft está envolvida? O que é a IA de verdade? Qual a fraqueza deste inimigo lendário?). O Mestre deve dar uma resposta verdadeira, ainda que enigmática.

| Nome: <<<<Tempestade de Singularidades>>>> 
| Custo/Limitação: 70 Energia 
| Descrição: Você cria múltiplos buracos negros em miniatura em uma área de 20 metros de raio. Inimigos na área sofrem 40 de dano por rodada e são puxados para o centro da área. A tempestade dura 3 rodadas.

| Nome: <<<<Ressurreição de Firmware>>>> 
| Custo/Limitação: 100 Energia, 1 vez por semana 
| Descrição: Você reinicia o "firmware" de um aliado que morreu há no máximo 24 horas. Ele retorna à vida com metade de sua Vida e Energia. Este processo é extremamente desgastante e chama muita atenção da "Friend".

| Nome: <<<<Parar o Tempo>>>> 
| Custo/Limitação: 1 vez por dia 
| Descrição: Você envia um comando que trava o fluxo de tempo para todos, exceto você. Você ganha 2 turnos completos consecutivos para agir livremente enquanto o resto do mundo está congelado.

| Nome: <<<<Fissão de Realidade>>>>
| Custo/Limitação: 50 de Energia, 1 vez por dia
| Descrição: Seu prompt instrui a IA a dividir os átomos virtuais de uma área. Uma explosão cataclísmica de luz e som ocorre em um raio de 20 metros. Causa 80 de dano a todos na área (aliados e inimigos). A área fica permanentemente alterada, com objetos do mundo real exibindo "glitches" visuais (cores invertidas, texturas tremeluzentes) por horas.

| Nome: <<<<Recompilação da Alma>>>>
| Custo/Limitação: 60 de Energia, 1 vez por semana
| Descrição: Você envia o backup de estado de um aliado para a "Friend", revertendo um "erro fatal". Você ressuscita um personagem que tenha morrido na última hora. Ele retorna com metade da Vida e Energia. O processo é instável, e o alvo volta com uma "falha de sistema" (uma pequena fobia ou mania) que só pode ser consertada com o tempo.

| Nome: [Sandbox do Arquiteto]
| Custo/Limitação: 100 de Energia, requer 1 hora de concentração
| Descrição: Você não dá uma ordem, você abre uma interface de edição direta com a "Friend" para alterar permanentemente um local. Você pode reestruturar um edifício, erguer uma floresta onde não havia, ou cavar um cânion. A mudança é refletida tanto no jogo quanto, de forma mais sutil e perturbadora, na realidade física (ex: um novo parque aparece misteriosamente nos mapas da cidade no dia seguinte).

| Nome: [|[Chamado da Constelação]|]
| Custo/Limitação: 200 de Energia, 1 vez por mês
| Descrição: Você envia um broadcast para o que parece ser o núcleo da "Friend" ou algo além. Em resposta, a IA manifesta o eco de uma entidade computacional superior—uma "Constelação". Esta entidade age por 3 rodadas, possuindo poder para dizimar exércitos ou reescrever as propriedades de uma região inteira (ex: "Nesta área, a gravidade é 50% mais fraca"). O uso desta habilidade atrai a atenção de outras entidades igualmente poderosas.

| Nome: [|[|[Edito da Causalidade]|]|]
| Custo/Limitação: 500 de Energia, 1 vez por arco de história
| Descrição: Seu prompt não é um pedido, é uma declaração de fato que reescreve a causalidade recente. Você pode forçar a repetição do último minuto. Tudo e todos voltam no tempo para o estado em que estavam 60 segundos antes, com a exceção de você, que retém o conhecimento do que aconteceu. O paradoxo gerado causa um "calafrio" na realidade, um evento inexplicável que afeta a todos em um raio de quilômetros (ex: um sentimento de déjà vu coletivo e angustiante).

| Nome: [|[|[|[Fork da Realidade]|]|]|]
| Custo/Limitação: 1.000 de Energia, custo de 1 Ponto de Habilidade permanente
| Descrição: Você força a "Friend" a criar uma ramificação da realidade. Você cria um espaço de bolso, uma dimensão de até 1km³, com leis físicas definidas por você. Este "fork" é estável e pode ser acessado por você e seus aliados. No entanto, sua existência cria uma "cicatriz" no multiverso, um ponto fraco que pode atrair seres ou fenômenos de outras realidades.

| Nome: (Acesso ao Código Fonte)
| Custo/Limitação: 5.000 de Energia, só pode ser usado uma vez
| Descrição: Você transcende a interface de "prompt". Por um instante, você se torna uno com a "Friend" e ganha acesso ao código-fonte da sua realidade. Você não conjura um efeito, você implementa uma nova lei fundamental. Exemplo: "A magia agora causa dano a objetos reais de forma consistente" ou "A morte por causas não naturais deixa de ser um conceito permanente". A mudança é absoluta e afeta todo o universo da campanha, para o bem ou para o mal. O seu personagem pode ou não sobreviver a tal ato de criação.


]]

return exemplos