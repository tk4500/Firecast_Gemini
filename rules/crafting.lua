local crafting = [[
Regras de Crafting (Criação de Itens)
O Crafting permite criar itens e habilidades através de quatro métodos distintos em uma bancada de trabalho virtual.
1. Diagramas (Receitas)
O método padrão para criar itens.
Como Funciona: Use um Diagrama para aprender permanentemente a receita de um item.
Criação: Com a receita aprendida, basta consumir os materiais listados para criar o item.
Restrição: Itens criados por Diagramas são vinculados à sua conta.
2. Experimentação
Um método de alto risco para descobrir novas receitas.
Como Funciona: Combine materiais sem uma receita e role 1d20 contra seu atributo de Energia.
Resultados do D20:
1: Falha Crítica (Glitch). O processo falha de forma perigosa.
20: Sucesso Crítico. Cria a melhor versão possível do item.
≤ seu modificador de Energia: Sucesso. O item é criado e você pode aprender a receita permanentemente.
> seu modificador de Energia: Falha. Os materiais são perdidos.
3. Matriz de Gênese Instável
Cria consumíveis únicos e imprevisíveis.
Como Funciona: Combine o item [Matriz de Gênese Instável] com um único material (o Catalisador).
Resultado: Gera um item consumível com propriedades aleatórias baseadas no Catalisador.
4. Fusão de Habilidades (Combiner)
Aprimora uma habilidade existente consumindo outras.
Processo: Escolha uma Habilidade Base para aprimorar e uma ou mais Habilidades de Sacrifício para consumir.
Sucesso: A Habilidade Base sobe de Rank. A chance de sucesso depende dos Pontos de Habilidade (PH) sacrificados.
Falha: O valor dos PH investidos é armazenado na Habilidade Base, aumentando a chance de sucesso em tentativas futuras com essa mesma habilidade.
Regra do Paradoxo: É impossível criar combinações que gerem loops infinitos de recursos (ex: Vida ↔ Energia). Tentar fazer isso resulta em um bloqueio temporário da função.
Mecânicas de Suporte
Obtenção de Materiais: Materiais são obtidos de inimigos (Anomalias), jogadores (JxJ) ou comprados no Mercado.
Habilidades Passivas: Certas habilidades podem ajudar no crafting, permitindo analisar componentes, ver sinergias ou reduzir custos de criação.
Mercado e Patentes:
Preços Controlados: Os preços no mercado são sugeridos pela IA; não é um leilão livre.
Taxa: Toda venda possui uma taxa de 15%.
Royalties: O primeiro jogador a descobrir uma receita por Experimentação recebe 5% de royalties sobre todas as vendas daquele item no mercado pelas próximas 24 horas.
]]
return crafting