# Beneath Five Moons / Lumina Darkness | Game Design Document (GDD)

**Versão:** 0.1.0
**Status:** Pré-produção / Consolidação de Conceito
**Documento:** Game Design Document
**Gênero:** RPG de Ação Sandbox em Mundo Aberto / Survival Leve / Simulação Social / RPG de Progressão por Uso
**Perspectiva:** 3ª Pessoa
**Modo Principal:** PvE / Single Player
**Modo Secundário Planejado:** Cooperativo Multiplayer
**PvP:** Em estudo
**Engine:** Godot 4.7.1
**Plataforma Inicial:** PC
**Plataformas Futuras:** Consoles
**Escopo Atual:** MVP + Pós-MVP + Expansões

---

# 1. Visão Geral do Projeto

## 1.1. Conceito de Alto Nível

**Project Quinary Moon / Lumina Darkness** é um RPG de ação sandbox em mundo aberto no qual o jogador constrói sua própria trajetória por meio de exploração, sobrevivência, profissão, relacionamentos, reputação, economia e decisões sociais em um mundo vivo dividido entre as **Terras Alinhadas** e o misterioso **Setor Escuro**.

O jogador não recebe uma trajetória heroica predeterminada.

Ele precisa:

> **sobreviver → explorar → trabalhar → desenvolver habilidades → estabelecer relações → conquistar recursos → construir sua posição no mundo → influenciar territórios e comunidades.**

A experiência deve priorizar **Role Play, administração, exploração e cooperação**, com combate funcionando como um dos sistemas de suporte à sobrevivência e à progressão, e não como o único objetivo do jogo.

---

## 1.2. Fantasia do Jogador

O jogador deve sentir que:

- sua vida possui consequências;
- seu personagem está inserido em uma sociedade;
- sua profissão realmente importa;
- suas relações alteram suas oportunidades;
- o território reage ao uso de seus recursos;
- o mundo continua existindo sem depender exclusivamente dele;
- diferentes jogadores podem construir trajetórias completamente diferentes;
- não existe uma única maneira correta de prosperar.

O objetivo não é simplesmente tornar o personagem mais poderoso.

O objetivo é permitir que o jogador **construa uma vida dentro do mundo**.

---

## 1.3. Gênero

### Gêneros Principais

- RPG de Ação;
- Sandbox;
- Mundo Aberto;
- Survival Leve;
- Simulação Social;
- RPG de Progressão por Uso;
- Exploração;
- Economia Dinâmica.

### Influências de Gameplay

| Referência        | Elementos absorvidos                                                                       |
| ----------------- | ------------------------------------------------------------------------------------------ |
| World of Warcraft | Progressão, reputação, facções, profissões, equipamentos, economia, lore e conteúdo social |
| Stardew Valley    | Ciclo de tempo, estações, coleta, produção, relacionamento e desenvolvimento de comunidade |
| Last Day on Earth | Sobrevivência, gerenciamento de recursos, energia, exploração por risco e crafting         |

As referências devem funcionar como **fontes de inspiração mecânica**, não como cópia estrutural ou visual.

---

# 1.4. Público-Alvo

Público principal:

- jogadores que gostam de RPGs sistêmicos;
- jogadores que gostam de explorar mundos abertos;
- jogadores que valorizam liberdade de progressão;
- jogadores interessados em sobrevivência leve;
- jogadores que gostam de construção de personagem sem classes rígidas;
- jogadores interessados em economia, profissões e administração;
- jogadores que gostam de narrativa emergente.

### Referências de experiência

- Kenshi;
- The Elder Scrolls;
- Outward;
- Stardew Valley;
- World of Warcraft;
- Last Day on Earth.

---

# 1.5. Pilares de Design

## Pilar 1 — O Mundo Está Vivo

O mundo deve reagir às ações dos jogadores.

Recursos podem diminuir, territórios podem prosperar ou degradar, relações podem mudar e conflitos podem surgir.

---

## Pilar 2 — Você Define Quem Seu Personagem É

A identidade do personagem deve surgir principalmente de:

- ações;
- habilidades;
- profissão;
- reputação;
- relacionamentos;
- equipamentos;
- escolhas;
- locais frequentados;
- grupos aos quais o jogador se associa.

---

## Pilar 3 — Prosperidade por Cooperação

O jogador pode sobreviver sozinho, mas sistemas avançados devem criar situações em que:

- profissões dependam umas das outras;
- cidades dependam de determinados profissionais;
- jogadores possam fornecer serviços;
- economias locais sejam alimentadas por produção;
- cooperação seja uma vantagem real.

---

# 2. Universo e Lore

# 2.1. O Fenômeno das 5 Luas

O planeta é regido por um fenômeno celeste conhecido como **As Cinco Luas Sincronizadas**.

As cinco luas permanecem eternamente alinhadas no céu juntamente com suas estrelas companheiras, formando uma configuração conhecida como **O Colar do Cosmo**.

| Lua          | Estrela Companion | Influência                              |
| ------------ | ----------------- | --------------------------------------- |
| **Astraea**  | **Astra-Sol**     | Luz, navegação e sabedoria              |
| **Nocturna** | **Umbra-Stella**  | Sombras, mistério, magia e Setor Escuro |
| **Verdania** | **Flora-Stella**  | Vitalidade, marés, colheitas e fauna    |
| **Aethel**   | **Aethel-Guard**  | Ordem, tempo e proteção                 |
| **Ignis**    | **Pyra-Stella**   | Conflitos e eventos cataclísmicos       |

A verdadeira origem do alinhamento deve permanecer parcialmente desconhecida durante o início do jogo.

---

# 2.2. Quintalia

**Quintalia** é o continente principal da experiência inicial.

Sua geografia é profundamente influenciada pelo fenômeno das cinco luas.

Uma cadeia montanhosa colossal divide o continente em duas grandes regiões:

- **Terras Alinhadas**
- **Setor Escuro**

Essa divisão cria uma oposição geográfica, cultural, econômica e política.

---

# 2.3. Terras Alinhadas

Região caracterizada por:

- ciclo normal de dia e noite;
- estações definidas;
- vegetação abundante;
- agricultura;
- cidades muradas;
- rotas comerciais;
- maior segurança relativa.

Principais referências:

### Porto de Astraea

Cidade litorânea relacionada à navegação e à lua **Astraea**.

### Cidadela de Aethel

Grande centro governamental e militar.

Abriga o **Abrigo Central de Órfãos** e uma importante rede de hospitais.

### Vale de Verdania

Região agrícola altamente produtiva influenciada pela lua **Verdania**.

---

# 2.4. Setor Escuro

O **Setor Escuro** é uma região em permanente penumbra/noite onde a luz solar jamais chega.

É caracterizado por:

- frio;
- neblina;
- vegetação bioluminescente;
- ruínas;
- criaturas adaptadas à escuridão;
- facções fora-da-lei;
- recursos raros;
- alto risco;
- alto potencial econômico.

A iluminação é uma mecânica de sobrevivência, navegação e combate.

### O Abismo de Umbra

Garganta colossal onde vivem criaturas adaptadas à escuridão.

### Lux-Oásis

Grande cidade do Setor Escuro construída ao redor de uma fonte artificial de energia e iluminação.

### O Refúgio dos Incógnitos

Acampamento associado a escravos fugitivos e renegados.

---

# 2.5. Muralha das Sombras

A **Muralha das Sombras** é a cordilheira que separa as duas grandes regiões de Quintalia.

Ela funciona simultaneamente como:

- barreira geográfica;
- fronteira cultural;
- fronteira política;
- mecanismo de progressão;
- elemento narrativo.

---

# 2.6. Garganta de Ferro

A **Garganta de Ferro** é o principal ponto natural de conexão entre as regiões.

É uma passagem militarizada e economicamente importante.

A região pode futuramente funcionar como:

- rota comercial;
- zona de conflito;
- área de PvP opcional;
- território de mercenários;
- ponto de controle estratégico.

---

# 3. Estrutura do Mundo

## 3.1. Mundo Aberto Reativo

O mundo deve possuir estados que podem mudar ao longo do tempo.

Exemplos:

- recursos naturais diminuem com exploração excessiva;
- determinadas áreas podem prosperar;
- áreas podem sofrer degradação;
- cidades podem perder influência;
- vilarejos podem crescer;
- rotas comerciais podem ser interrompidas;
- conflitos podem alterar preços;
- determinadas criaturas podem se tornar mais comuns;
- estações alteram disponibilidade de recursos.

---

# 3.2. Sistema de Degradação Territorial

A exploração excessiva deve possuir consequências.

Exemplo:

> Uma mina possui determinada disponibilidade de minério.

Com exploração contínua:

**Alta disponibilidade → exploração → redução → escassez → aumento de valor → recuperação gradual**

O sistema deve evitar que o jogador simplesmente explore infinitamente uma fonte de recursos.

---

# 3.3. Sistema de Estações

As estações alteram:

- clima;
- disponibilidade de recursos;
- agricultura;
- pesca;
- caça;
- temperatura;
- necessidades do personagem;
- preços;
- rotas;
- atividades de NPCs.

As estações devem possuir identidade própria.

---

# 3.4. Sistema de Tempo

O mundo possui:

- horas;
- dias;
- semanas;
- estações;
- eventos temporais.

O tempo afeta:

- NPCs;
- comércio;
- missões;
- produção;
- descanso;
- disponibilidade de recursos;
- monstros;
- clima;
- iluminação.

---

# 4. Core Loop

## 4.1. Loop de Curto Prazo

A cada minuto, o jogador deve tomar decisões como:

- explorar;
- coletar;
- lutar;
- fugir;
- negociar;
- trabalhar;
- produzir;
- conversar;
- procurar abrigo;
- administrar recursos.

---

## 4.2. Loop de Médio Prazo

Ao longo de horas de jogo:

**Explorar → Coletar → Produzir → Vender/Usar → Desenvolver habilidade → Melhorar equipamento → Acessar nova região**

---

## 4.3. Loop de Longo Prazo

Ao longo de vários dias:

**Construir reputação → Desenvolver profissão → Estabelecer residência → Criar relações → Aumentar influência → Obter propriedade → Influenciar território → Governar**

---

# 5. Sistemas de Sobrevivência

## 5.1. Necessidades Básicas

O personagem possui:

- Vida;
- Fome;
- Fadiga;
- Energia;
- Temperatura;
- Conforto.

Sede poderá ser adicionada posteriormente caso não seja necessária ao MVP.

---

# 5.2. Fome

A fome diminui com o passar do tempo.

Influências:

- atividade física;
- clima;
- temperatura;
- fadiga;
- equipamentos;
- alimentos;
- profissão.

Alimentos diferentes podem fornecer:

- recuperação de fome;
- energia;
- buffs;
- resistência térmica;
- recuperação de fadiga.

---

# 5.3. Fadiga

A fadiga representa desgaste físico.

Pode aumentar através de:

- corrida;
- combate;
- coleta;
- mineração;
- trabalho;
- exploração;
- frio;
- fome.

A fadiga elevada deve prejudicar determinadas atividades.

---

# 5.4. Temperatura

O personagem sofre modificadores de:

- frio;
- calor.

Os modificadores dependem de:

- estação;
- clima;
- região;
- roupa;
- armadura;
- abrigo;
- alimentos;
- equipamentos especiais.

---

# 5.5. Energia

A energia representa a capacidade diária de realizar determinadas atividades.

Deve ser usada principalmente para atividades de gestão/coleta e trabalho, evitando transformar o combate em uma simples mecânica de gasto energético.

---

# 6. Sistema de Iluminação

O sistema de iluminação é um dos principais diferenciais de gameplay.

No **Setor Escuro**, luz é simultaneamente:

- recurso;
- proteção;
- ferramenta de exploração;
- elemento de stealth;
- ferramenta de combate;
- mecanismo de navegação.

O documento-base estabelece quatro níveis de luminosidade: **Escuridão Absoluta, Penumbra, Luz Moderada e Luz Plena**.

---

## 6.1. Níveis de Luz

| Nível | Estado             | Gameplay                                       |
| ----- | ------------------ | ---------------------------------------------- |
| 0     | Escuridão Absoluta | Visibilidade mínima e alto risco               |
| 1     | Penumbra           | Stealth favorecido                             |
| 2     | Luz Moderada       | Condição normal                                |
| 3     | Luz Plena          | Maior visibilidade e vantagem contra criaturas |

---

## 6.2. Fontes de Luz

### Portáteis

- Tocha de Lança-Resina;
- Lanterna de Cristal de Aethel;
- Lâmpada Bioluminescente.

### Mágicas

- Graça de Astraea;
- Fogo de Pyra.

### Estruturais

- Fogueiras;
- Braseiros;
- Faróis do Alinhamento.

Esses elementos já estão estabelecidos no material-base do projeto.

---

# 7. Exploração

## 7.1. Exploração por Risco

O mundo deve possuir regiões com diferentes níveis de risco.

| Zona            |      Risco | Recompensa |
| --------------- | ---------: | ---------: |
| Segura          |      Baixo |      Baixa |
| Selvagem        |      Médio |      Média |
| Perigosa        |       Alto |       Alta |
| Setor Escuro    | Muito alto | Muito alta |
| Áreas especiais |    Extremo |  Raríssima |

---

# 7.2. Transporte

Sistemas previstos:

- caminhada;
- caravanas;
- rotas comerciais;
- fast travel;
- Faróis do Alinhamento.

O fast travel deve exigir ativação dos pontos correspondentes, evitando eliminar completamente a importância da exploração.

---

# 8. Profissões

## 8.1. Filosofia

O jogador poderá escolher **uma profissão principal**.

A profissão não deve ser apenas uma árvore de crafting.

Ela deve representar uma função social e econômica do personagem.

---

## 8.2. Profissões Potenciais

- Ferreiro;
- Coureiro;
- Mineiro;
- Pescador;
- Agricultor;
- Caçador;
- Alquimista;
- Herbalista;
- Cozinheiro;
- outras profissões posteriormente.

---

# 8.3. Progressão Profissional

Cada profissão possui **5 níveis de domínio**.

Cada nível possui progressão interna de **1 a 100**.

Estrutura:

```text
Profissão
├── Nível 1
│   └── 1–100
├── Nível 2
│   └── 1–100
├── Nível 3
│   └── 1–100
├── Nível 4
│   └── 1–100
└── Nível 5
    └── 1–100
```

---

# 8.4. Limitação por Local

Locais simples possuem limites de desenvolvimento.

Exemplo:

> Uma pequena oficina permite desenvolver Ferreiro até determinado nível.

Para avançar:

- procurar um mestre;
- realizar quests;
- alugar oficina melhor;
- comprar propriedade;
- utilizar equipamento especializado;
- trabalhar com outros jogadores.

---

# 8.5. Dependência entre Profissões

O sistema deve criar dependência econômica.

Exemplo:

**Mineiro → minério → Ferreiro → arma → Guerreiro**

Outro:

**Herbalista → ervas → Alquimista → poção → Explorador**

Isso cria uma razão sistêmica para a cooperação multiplayer.

---

# 9. Progressão do Personagem

## 9.1. Princípio

O personagem deve possuir progressão híbrida.

A proposta atual é combinar:

- nível de personagem;
- atributos;
- habilidades;
- profissão;
- proficiência em armas;
- reputação;
- equipamentos.

---

# 9.2. Nível de Personagem

O brainstorming estabelece que:

> HP aumenta quando o personagem passa de nível.

O nível também poderá funcionar como uma camada geral de progressão.

A forma definitiva de obtenção de XP permanece uma **decisão de design pendente**.

---

# 9.3. Progressão por Uso

As habilidades devem evoluir conforme são utilizadas.

Exemplo:

- lutar com espada → evolução relacionada à espada;
- minerar → evolução de mineração;
- furtividade → evolução de stealth;
- negociar → evolução social/comercial;
- construir → evolução de reconstrução.

---

# 9.4. Atributos

A proposta atual contém:

- **FORÇA**
- **AGILIDADE**
- **VIGOR**
- **INTELIGENCIA**
- **SABEDORIA**
- **CARISMA**

Os três últimos devem ser avaliados durante o balanceamento para evitar sobreposição de funções.

---

# 9.5. Classes

### Estado Atual

**Não haverá classe rígida inicialmente.**

O personagem deverá construir sua identidade através de suas ações.

Exemplo:

```text
Combate + Espadas + Armaduras
        ↓
Perfil Guerreiro

Stealth + Adagas + Exploração
        ↓
Perfil Ladino
```

Assim, **Guerreiro** e **Ladino** podem existir como arquétipos emergentes sem necessariamente serem classes escolhidas em uma tela inicial.

---

# 10. Proficiência em Armas

Cada categoria de arma possui progressão própria.

Exemplo:

```text
Espada
Nível de uso ↑
        ↓
Maior eficiência
        ↓
Talentos específicos
```

A proposta do brainstorming estabelece que utilizar uma arma aumenta sua proficiência, enquanto o uso de outras armas pode reduzir progressivamente a proficiência relativa das anteriores.

Essa mecânica deve ser prototipada cuidadosamente para evitar punição excessiva ao jogador.

---

# 11. Combate

## 11.1. Direção

Combate:

- em tempo real;
- em terceira pessoa;
- baseado em posicionamento;
- com gestão de estamina;
- com stealth;
- com interação com iluminação.

O documento-base propõe combate Action-Tactical, incluindo bloqueio, parry, esquiva e postura.

---

# 11.2. Defesa

Possíveis ações:

- bloquear;
- esquivar;
- parry;
- posicionar-se;
- fugir;
- utilizar ambiente;
- utilizar luz.

---

# 11.3. Stealth

O stealth depende de:

- iluminação;
- distância;
- ruído;
- velocidade;
- equipamento;
- armadura;
- posição;
- percepção do inimigo.

Armaduras mais pesadas podem aplicar penalidade de stealth.

---

# 11.4. Combate Baseado em Luz

No Setor Escuro, determinadas criaturas devem possuir interação direta com a iluminação.

Exemplo:

```text
Escuridão
↓
Criatura fortalecida

Penumbra
↓
Comportamento normal

Luz Plena
↓
Criatura enfraquecida / repelida
```

Essa relação é um dos principais sistemas diferenciais do projeto.

---

# 12. Equipamentos

## 12.1. Categorias

- Armas;
- Armaduras;
- Ferramentas;
- Equipamentos profissionais;
- Equipamentos de exploração;
- Equipamentos de iluminação;
- Itens utilitários;
- Artefatos;
- Itens mágicos.

---

# 12.2. Durabilidade

Itens comuns possuem durabilidade.

Quando a durabilidade chega a zero:

> o item é descartado automaticamente.

Itens mágicos e artefatos são exceções.

---

# 12.3. Evolução de Equipamentos

Equipamentos podem possuir:

- qualidade;
- nível;
- atributos;
- durabilidade;
- requisitos;
- bônus;
- especializações.

---

# 13. Loot

## 13.1. Recursos

Exemplos:

- madeira;
- pedra;
- minério;
- ervas;
- alimentos;
- peles;
- materiais de monstros.

---

## 13.2. Loot de Inimigos

Monstros e inimigos podem fornecer:

- materiais;
- armas;
- armaduras;
- componentes;
- itens raros;
- moedas;
- itens de missão.

O loot deve estar conectado à economia para evitar excesso de itens sem função.

---

# 14. Crafting

O crafting deve ser principalmente determinado pela profissão.

Exemplo:

| Profissão  | Produção                                     |
| ---------- | -------------------------------------------- |
| Ferreiro   | Armas / ferramentas / equipamentos metálicos |
| Coureiro   | Armaduras / acessórios de couro              |
| Alquimista | Poções / compostos                           |
| Cozinheiro | Alimentos                                    |
| Herbalista | Ingredientes                                 |
| Mineiro    | Recursos minerais                            |
| Pescador   | Peixes                                       |
| Caçador    | Carne / peles / materiais                    |

---

# 15. Economia

## 15.1. Economia Local

Cada território deve possuir sua própria dinâmica.

Preços podem ser influenciados por:

- oferta;
- demanda;
- estação;
- escassez;
- distância;
- guerra;
- recursos locais;
- comportamento dos jogadores.

---

# 15.2. Economia Global

A economia global representa mercados mais amplos.

Entretanto, ela deve possuir mecanismos de proteção contra inflação e concentração excessiva de riqueza.

---

# 15.3. Loja do Jogador

Jogadores poderão vender itens produzidos através de sua profissão.

Deve existir:

- limite de preço;
- controle de quantidade;
- taxas;
- possíveis impostos;
- mecanismos contra manipulação econômica.

---

# 15.4. Sistema de Leilão

Itens raros poderão ser negociados através de leilão.

Regras propostas:

- itens possuem limite de valor;
- leilões não devem alterar diretamente a economia global/local;
- itens raros podem utilizar mercado específico;
- taxas podem funcionar como mecanismo de controle.

---

# 15.5. Mercado Negro

O Mercado Negro utiliza uma moeda própria.

Características:

- moeda diferente da economia convencional;
- itens raros;
- itens proibidos;
- equipamentos especiais;
- acesso condicionado à reputação/facção.

---

# 16. Crenças e Religiões

O mundo deverá possuir aproximadamente:

- 5 religiões principais;
- crenças locais.

Essas crenças podem influenciar:

- NPCs;
- reputação;
- preços;
- missões;
- territórios;
- conflitos;
- acesso a determinados locais;
- relações com facções.

---

# 16.1. Conflito Religioso

Existem dois níveis:

### Conflito Soft

- preços diferentes;
- diálogos hostis;
- perda de reputação;
- restrições sociais;
- dificuldade de acesso.

### Conflito Hard

- combate;
- perseguições;
- invasões;
- guerras territoriais;
- bloqueios;
- alteração de controle territorial.

---

# 17. Facções

## 17.1. Facções Principais

O documento-base estabelece quatro grandes grupos:

1. **Os Guardiões do Alinhamento**
2. **O Sindicato de Umbra**
3. **A Irmandade de Bronze**
4. **Os Devotos da Quinta Lua**

Suas posições políticas e ideológicas criam uma matriz de conflito entre ordem, independência, mercenariado e culto/anomalia.

---

# 17.2. Reputação

A reputação pode variar entre:

- Odiado;
- Hostil;
- Neutro;
- Aliado;
- Lendário.

Os efeitos podem incluir:

- preços;
- moradia;
- missões;
- passagem;
- serviços;
- equipamentos;
- proteção;
- perseguição.

---

# 17.3. Reputação Multidimensional

O personagem não possuirá apenas uma reputação global.

Pode possuir reputação com:

- cidades;
- vilarejos;
- facções;
- religiões;
- crenças;
- NPCs;
- profissões;
- locais.

Isso permite situações como:

> Excelente reputação em uma cidade e péssima reputação em outra.

---

# 18. Relacionamentos com NPCs

NPCs possuem relacionamento individual.

Escala proposta:

```text
Hate
 ↓
Dislike
 ↓
Neutral
 ↓
Like
 ↓
Friendship
 ↓
Love
```

O relacionamento pode gerar:

- descontos;
- informações;
- quests;
- abrigo;
- serviços;
- acesso a locais;
- ajuda em tarefas;
- oportunidades profissionais.

---

# 19. Quests

## 19.1. Categorias

- Main Quest;
- Origin Quest;
- Profession Quest;
- Faction Quest;
- Local Quest;
- NPC Quest;
- Dynamic Quest;
- World Event.

---

# 19.2. Quests Emergentes

O jogo deve privilegiar quests que surjam das condições do mundo.

Exemplo:

```text
Mina explorada excessivamente
        ↓
Escassez de minério
        ↓
Ferreiros sofrem
        ↓
Preço das armas aumenta
        ↓
Cidade solicita minério
        ↓
Quest de mineração aparece
```

---

# 20. Territórios

Cada:

- cidade;
- vila;
- assentamento;
- território;

possui:

- governante;
- população;
- recursos;
- reputação;
- economia;
- crenças;
- segurança;
- conflitos;
- infraestrutura.

---

# 20.1. Governo

O jogador poderá eventualmente:

> dominar um vilarejo.

No endgame, isso pode evoluir para:

- administrar território;
- estabelecer políticas;
- controlar impostos;
- administrar recursos;
- contratar defesa;
- influenciar economia;
- resolver conflitos.

---

# 20.2. Exército Local

Cidades e vilarejos podem possuir forças de defesa.

O tamanho e a qualidade do exército dependem de:

- riqueza;
- população;
- governante;
- recursos;
- ameaças;
- relações políticas.

---

# 21. Conflitos Territoriais

Existem dois níveis:

### Soft

- disputas econômicas;
- bloqueios;
- rivalidades;
- propaganda;
- sanções;
- diferenças de preço.

### Hard

- invasões;
- guerras;
- batalhas;
- tomada de territórios;
- destruição de infraestrutura.

O sistema de guerra territorial deve ser considerado **Pós-MVP**.

---

# 22. Habitação

O jogador começa podendo:

- alugar quarto;
- trabalhar em troca de moradia;
- dormir em locais improvisados.

Posteriormente poderá:

- alugar imóvel;
- comprar imóvel;
- construir propriedade;
- desenvolver sua residência;
- construir assentamento.

O material-base já estabelece pensões, trabalho por moradia e posteriormente compra/construção de propriedade.

---

# 23. Origens

O jogador poderá escolher uma entre cinco origens iniciais:

1. **O Órfão**
2. **O Sobrevivente do Coma**
3. **O Herdeiro da Tragédia**
4. **O Encontrado**
5. **O Escravo Fugitivo**

Cada origem modifica:

- localização inicial;
- equipamentos;
- situação social;
- objetivo inicial;
- relacionamento com determinados grupos;
- introdução narrativa.

O documento-base já define os cinco backgrounds e seus objetivos iniciais.

---

# 24. Sistema de Achievements

Conquistas podem recompensar:

- títulos;
- cosméticos;
- moedas;
- itens;
- conhecimento;
- desbloqueios;
- reconhecimento social.

As recompensas devem evitar quebrar a economia.

---

# 25. HUD

A interface inicial deve apresentar:

- Barra de Vida;
- Barra de Energia;
- Barra de Fadiga;
- Indicadores de sobrevivência;
- Mapa/Minimapa;
- Indicador de iluminação;
- Inventário;
- equipamento;
- efeitos temporários.

O sistema de iluminação também prevê indicador de combustível da lanterna e indicador de Pânico/Sanidade.

---

# 26. Multiplayer Cooperativo

## 26.1. Filosofia

O multiplayer deve ampliar o jogo, não substituir a experiência single player.

O jogador deve conseguir:

- jogar sozinho;
- convidar amigos;
- compartilhar recursos;
- realizar profissões complementares;
- explorar;
- enfrentar inimigos;
- construir;
- administrar.

---

# 26.2. Interdependência

Exemplo:

```text
Jogador A
Mineiro
      ↓
Minério
      ↓
Jogador B
Ferreiro
      ↓
Armas
      ↓
Jogador C
Caçador
      ↓
Peles
      ↓
Jogador D
Coureiro
      ↓
Armaduras
```

A cooperação deve surgir organicamente dos sistemas econômicos.

---

# 27. PvP

## Estado: EM ESTUDO

O PvP não deve fazer parte do núcleo inicial.

Possibilidades futuras:

- áreas específicas;
- guerras territoriais;
- conflitos entre facções;
- duelos;
- servidores/modos específicos.

A decisão definitiva deve ocorrer somente após o núcleo PvE/cooperativo estar validado.

---

# 28. Matriz de Escopo

## 28.1. MVP

O MVP deve provar que o jogo é divertido sem depender dos sistemas massivos.

| Sistema                         | MVP                 |
| ------------------------------- | ------------------- |
| Mundo aberto                    | ✅                  |
| Movimentação                    | ✅                  |
| Exploração                      | ✅                  |
| Dia/noite                       | ✅                  |
| Fome                            | ✅                  |
| Fadiga                          | ✅                  |
| Temperatura básica              | ✅                  |
| Coleta                          | ✅                  |
| Crafting básico                 | ✅                  |
| Inventário                      | ✅                  |
| Equipamentos                    | ✅                  |
| Durabilidade                    | ✅                  |
| Combate básico                  | ✅                  |
| Stealth básico                  | ✅                  |
| Iluminação básica               | ✅                  |
| Monstros                        | ✅                  |
| NPCs                            | ✅                  |
| Quests básicas                  | ✅                  |
| Uma profissão funcional         | ✅                  |
| Sistema básico de reputação     | ✅                  |
| Uma cidade                      | ✅                  |
| Um vilarejo                     | ✅                  |
| Uma área selvagem               | ✅                  |
| Primeiro acesso ao Setor Escuro | ⚠️ Opcional         |
| Multiplayer                     | ⚠️ Fundação técnica |
| PvP                             | ❌                  |
| Guerra territorial              | ❌                  |
| Mercado Negro                   | ❌                  |
| Economia global                 | ❌                  |
| Governo de vilarejo             | ❌                  |
| Sistema religioso completo      | ❌                  |

---

# 29. Pós-MVP

Sistemas prioritários:

- múltiplas profissões;
- progressão profissional completa;
- economia local;
- loja de jogadores;
- relacionamentos avançados;
- facções;
- reputação avançada;
- crenças;
- religiões;
- mercado negro;
- sistema de leilão;
- crafting avançado;
- propriedades;
- multiplayer cooperativo completo;
- dependência entre profissões;
- mais cidades;
- mais vilarejos;
- eventos dinâmicos;
- conflitos territoriais limitados.

---

# 30. Expansões / DLC

Sistemas de longo prazo:

- novas luas;
- outros planetas;
- outras regiões de Quintalia;
- grandes eventos globais;
- guerras em escala continental;
- grandes arcos narrativos;
- endgame;
- governo avançado;
- sistemas políticos;
- guerras religiosas;
- novas profissões;
- novas raças;
- novas facções;
- novas dimensões/territórios;
- viagens interplanetárias.

Esses sistemas não devem influenciar a arquitetura do MVP além do necessário para permitir expansão futura.

---

# 31. Roadmap Macro

```text
FASE 0
Fundação e Prototipagem
        ↓
FASE 1
MVP — Core Gameplay
        ↓
FASE 2
Expansão do Sandbox
        ↓
FASE 3
Economia + Profissões + Social
        ↓
FASE 4
Multiplayer Cooperativo
        ↓
FASE 5
Territórios + Governo
        ↓
FASE 6
Endgame
        ↓
FASE 7
Expansões / DLC
```

---

# 32. Sistemas que Devem Permanecer como Decisões de Design

As seguintes questões ainda não devem ser consideradas definitivas:

| Questão                            | Estado                                               |
| ---------------------------------- | ---------------------------------------------------- |
| Progressão linear ou não linear    | Pendente                                             |
| Classe fixa                        | Pendente                                             |
| Classes emergentes                 | Forte candidato                                      |
| Inteligência / Sabedoria / Carisma | Pendente                                             |
| PvP                                | Em estudo                                            |
| Sede                               | Pendente                                             |
| Multiplayer desde o MVP            | Arquitetura deve prever, gameplay pode ser posterior |
| Guerra territorial                 | Pós-MVP                                              |
| Governo de vilarejo                | Pós-MVP/Endgame                                      |
| Religiões completas                | Pós-MVP                                              |
| Viagem para outros planetas        | DLC                                                  |
| Número definitivo de profissões    | Pendente                                             |
| Número definitivo de cidades       | Pendente                                             |
| Sistema definitivo de moeda        | Pendente                                             |

---

# 33. Princípios de Balanceamento

## 33.1. Evitar Power Creep

Nenhum sistema deve tornar os anteriores irrelevantes.

---

## 33.2. Economia Controlada

Devem existir mecanismos contra:

- inflação;
- duplicação de riqueza;
- monopolização;
- abuso do mercado;
- farming infinito;
- geração excessiva de moeda.

---

## 33.3. Profissão com Valor Real

Cada profissão deve possuir:

- utilidade;
- demanda;
- especialização;
- progressão;
- dependências;
- oportunidades econômicas.

---

# 34. Experiência Desejada do Jogador

O jogador deve conseguir contar histórias emergentes como:

> "Comecei como um Órfão, trabalhei em uma fazenda para conseguir moradia, comecei a aprender uma profissão, fiz amizade com um ferreiro, consegui meu primeiro equipamento, comecei a explorar regiões perigosas, construí reputação em uma cidade, viajei para a Garganta de Ferro, entrei no Setor Escuro, encontrei novos aliados e eventualmente me tornei responsável por um vilarejo."

Essa narrativa deve surgir principalmente dos sistemas, e não apenas de cutscenes.

---

# 35. Definição do Core Game

O coração do projeto pode ser resumido como:

```text
VIVER
 ↓
EXPLORAR
 ↓
COLETAR
 ↓
PRODUZIR
 ↓
NEGOCIAR
 ↓
DESENVOLVER
 ↓
RELACIONAR-SE
 ↓
CONQUISTAR ESPAÇO NO MUNDO
 ↓
INFLUENCIAR O MUNDO
```

O jogo deve evitar que o jogador seja obrigado a seguir:

```text
Quest → Combate → Quest → Combate → Boss
```

como única estrutura de progressão.

Em vez disso:

```text
O jogador escolhe uma vida.
O mundo reage.
As consequências criam novas oportunidades.
```

---

# 36. Diretriz Central de Design

> **O personagem não deve ser definido pelo que o jogo diz que ele é.**
>
> **Ele deve ser definido pelo que o jogador faz com ele.**

A profissão, reputação, relacionamentos, equipamentos, território, habilidades e decisões devem construir progressivamente a identidade do personagem.

Esse princípio deve orientar todas as futuras decisões de design do projeto.

---

# 37. Próxima Etapa do GDD

A próxima versão deverá transformar este documento conceitual em um **GDD de produção**, aprofundando cada sistema em:

1. Objetivo do sistema;
2. Regras;
3. Variáveis;
4. Estados;
5. Progressão;
6. Dependências;
7. Inputs do jogador;
8. Outputs;
9. Recompensas;
10. Penalidades;
11. Interações com outros sistemas;
12. Requisitos para MVP;
13. Requisitos Pós-MVP;
14. Requisitos para Expansões;
15. Riscos de implementação;
16. Critérios de validação.

A prioridade deve ser transformar o conceito em um conjunto de sistemas **implementáveis, testáveis e balanceáveis**, evitando que o GDD se torne apenas uma coleção de ideias.
