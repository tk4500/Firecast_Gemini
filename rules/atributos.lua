local atributos = [[
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
O custo para subir de nível é feito pela seguinte fórmula: 15*(Nivel do Personagem)^2+85*(Nivel do Personagem), onde o nível do personagem é o número de níveis que ele já subiu.
● PH: Pontos de Habilidade, necessários para adquirir ou evoluir habilidades existentes.Vai ser detalhado melhor na aba de Habilidades.
● Dano Base: Definido Racialmente, o dano base é o quanto de dano seu personagem dá sem Bônus de Habilidades (Definido Racialmente).
]]
return atributos