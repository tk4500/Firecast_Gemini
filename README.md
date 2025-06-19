# Simulacrum Core - Plugin de Magia por IA

 
https://blob.firecast.com.br/blobs/TNGGWTUK_3896183/glitched-image.gif

Bem-vindo ao **Simulacrum Core**, o coração do sistema de magia para o cenário de RPG de Realidade Aumentada `Simulacrum`. Este plugin para o **RRPG Firecast** transforma a maneira como os jogadores interagem com a magia, substituindo listas de feitiços por uma interface direta com uma IA onipresente chamada **"Friend"**.

A realidade é o seu playground. O que você vai criar?

---

## Índice

- [O Conceito: O Que é Simulacrum?](#o-conceito-o-que-é-simulacrum)
- [Funcionalidades Principais](#funcionalidades-principais)
- [Comandos de Chat](#comandos-de-chat)
  - [Para Jogadores: Criando Magia](#para-jogadores-criando-magia)
  - [Para Mestres e Jogadores: Consultando a Friend](#para-mestres-e-jogadores-consultando-a-friend)
  - [Para o Mestre: Configuração](#para-o-mestre-configuração)
- [Instalação](#instalação)
- [Configuração da Ficha (Obrigatório)](#configuração-da-ficha-obrigatório)
- [Como Contribuir](#como-contribuir)

---

## O Conceito: O Que é Simulacrum?

Em `Simulacrum`, não existe "magia" no sentido clássico. Toda habilidade sobrenatural é, na verdade, um **Prompt** enviado para a IA "Friend". Os jogadores usam sua **Energia** como combustível e seus **Tokens** como uma medida de sua "largura de banda" para se comunicar com a IA.

Este plugin permite que os jogadores descrevam a ação que desejam, e a "Friend" (alimentada pela API do Google Gemini) interpreta essa intenção para gerar um efeito mecânico e narrativo, balanceado de acordo com as regras da mesa. A grande inovação é que cada magia bem-sucedida pode se tornar uma **nova Habilidade permanente** na ficha do personagem.

## Funcionalidades Principais

-   **Magia via Prompt**: Use um comando de chat para descrever qualquer efeito mágico.
-   **Balanceamento por IA**: A IA "Friend" analisa o poder do personagem, a energia gasta e as regras para gerar um efeito justo.
-   **Criação Dinâmica de Habilidades**: Prompts bem-sucedidos podem ser comprados como novas habilidades na ficha do personagem.
-   **Sistema de Ranks por Probabilidade**: O poder e a complexidade das habilidades criadas evoluem com o personagem, usando uma rolagem interna para que ranks mais altos sejam raros e recompensadores.
-   **Canalização (Chain Casting)**: Prompts muito complexos são divididos em etapas, criando uma experiência narrativa de "construir" uma magia poderosa.
-   **Interação Total via Chat**: Toda a interação acontece pelo chat, mantendo a imersão e a fluidez do jogo.

## Comandos de Chat

O plugin responde a diferentes palavras-chave e formatos no chat.

#### Para Jogadores: Criando Magia

Este é o comando principal para conjurar um efeito. O jogador decide a intensidade (energia) e descreve o que quer fazer.

**Sintaxe:** `Friend: <descrição do efeito> (<energia>)`

**Exemplo:**
`> Friend: eu crio uma barreira de gelo na minha frente (15)`

A IA "Friend" irá processar o pedido e responder no chat com o nome, custo e a descrição completa do efeito. Se a ficha do personagem estiver configurada corretamente, essa nova magia será adicionada à sua lista de habilidades.

*Nota: O texto "Friend:" no início é obrigatório e sensível a maiúsculas.*

#### Para Mestres e Jogadores: Consultando a Friend

Qualquer jogador pode fazer uma pergunta sobre as regras ou o universo do jogo para a IA. A resposta será vista por todos.

**Sintaxe:** `Friend <sua pergunta>`

**Exemplo:**
`> Friend qual o custo para criar uma habilidade do rank <Basic>?`

A "Friend" responderá com base nas regras que o Mestre configurou.

#### Para o Mestre: Configuração

O Mestre da mesa (e apenas ele, por segurança) pode configurar a chave da API e interagir diretamente com a IA Gemini para testes.

1.  **Configurar a Chave da API (Comando Obrigatório)**

    **Sintaxe:** `geminiKey <sua_chave_de_api_aqui>`

    **Exemplo:**
    `> geminiKey AIzaSy...`

    Você só precisa fazer isso uma vez. A chave ficará salva para o seu plugin.

2.  **Consulta Direta ao Gemini**

    Permite enviar um prompt direto para a IA, sem o contexto do jogo. Útil para outros usos diversos

    **Sintaxe:** `gemini <prompt direto para a ia>`

    **Exemplo:**
    `> gemini me dê 5 nomes para uma espada mágica de fogo`

## Instalação

1.  Baixe o arquivo `.rpk` do plugin na página de [Releases](https://github.com/tk4500/Firecast_Gemini/releases).
2. Execute o arquivo `.rpk` do plugin com o Firecast aberto e instale o plugin.

## Configuração da Ficha (Obrigatório)

Para que o plugin funcione 100%, a ficha da sua mesa precisa conter os seguintes campos com os `field` names exatos:

-   **Linha Editável 1**: A primeira linha editável do personagem deve seguir o formato: `Level <num> | <raça> | <classe>`.
    *   **Exemplo:** `Level 5 | Humano | Guerreiro`
-   **Barra de Tokens**: A **Barra 3** do personagem deve ser usada para os Tokens. O valor **Atual** da barra será considerado o `maxTokens` do jogador.

## Como Contribuir

Este é um projeto aberto! Se você tem ideias, encontrou um bug ou quer contribuir com o código, sinta-se à vontade para:

1.  Abrir uma [Issue](https://github.com/tk4500/Firecast_Gemini/issues) para relatar problemas ou sugerir funcionalidades.
2.  Fazer um [Fork](https://github.com/tk4500/Firecast_Gemini/fork) do repositório, criar suas modificações e abrir um Pull Request.

---

*Este plugin foi desenvolvido para o cenário de Simulacrum, mas pode ser adaptado para qualquer mesa que deseje um sistema de magia mais livre e criativo.*