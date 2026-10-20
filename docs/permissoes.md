# Permissões e aprovações

O que o assistente faz sozinho, o que pede a você e o que nunca faz; como responder um cartão de aprovação e como desfazer uma aprovação "sempre".

## Os três modos

O modo vale para o projeto inteiro (cada projeto tem o seu) e começa em **Solicitar aprovação**.

| | **Solicitar aprovação** | **Aprovar por mim** | **Acesso completo** |
|---|---|---|---|
| Ler e buscar arquivos do projeto | sem pedir | sem pedir | sem pedir |
| Criar e editar arquivos do projeto | pede | sem pedir | sem pedir |
| Comandos no shell confinado, projeto **com Git** | sem pedir | sem pedir | sem pedir |
| Comandos no shell confinado, projeto sem Git | pede | sem pedir | sem pedir |
| Ações no Blender e no Unity preparados pelo app (consultar a cena não pede) | pede | sem pedir | sem pedir |
| Compilar scripts e rodar testes do Unity | pede | pede | sem pedir |
| Web, depois do primeiro acesso da conversa | pede a cada destino novo | sem pedir | sem pedir |
| Sair do sandbox para o terminal do Windows | pede | pede | sem pedir |
| Comandos no terminal do Windows (fora do sandbox) | pede cada um | pede cada um | sem pedir |

**Acesso completo** roda comandos e ações com o seu usuário do Windows, inclusive fora do projeto. Não é um isolamento do sistema: use só enquanto acompanha a execução.

O que segue igual em todos os modos, inclusive no **Acesso completo**:

- **Sempre bloqueado**: as ferramentas de arquivo não leem nem escrevem fora do projeto, nem na pasta interna do app, nem em arquivos sensíveis (`.env*`, exceto `.env.example`; `credentials`, `credentials.json`, `secrets.json`, `service-account.json`; `.pem`, `.key`, `.p12`, `.pfx`; qualquer coisa dentro de `.git`, `.ssh`, `.aws`, `.azure`, `.gnupg` ou `browser-profile`). Ferramentas desconhecidas são recusadas. No modo plano, nada é escrito nem executado.
- **Sempre pergunta**: o primeiro acesso à web de cada conversa; liberar a janela de outro programa; adicionar um servidor MCP local; ferramentas de MCP ainda não classificadas; chamadas com argumentos acima de 100.000 caracteres. Liberar janela e adicionar MCP não oferecem "sempre".
- **Limites do projeto**: as regras `permissions.deny` e `permissions.ask` de `.claude/settings.json` e `.claude/settings.local.json` da pasta valem para qualquer modelo e qualquer modo; elas só tiram permissão. Você as vê em **Configurações → Projeto → Avançado: regras, hooks e servidores MCP do repositório**.
- O limite de custo do projeto (veja [Custo](custo.md)).

## Onde trocar o modo

- Na caixa de mensagem, no seletor **Modo de aprovação**, ao lado do botão de enviar.
- Em **Configurações → Permissões → Aprovações do projeto**, com **Salvar modo**.
- No terminal, `/modo` (ou `/modo supervisionado`, `/modo projeto`, `/modo completo`).

Escolher **Acesso completo** pede confirmação: **Confirmar acesso completo** na caixa de mensagem, **Ativar Acesso completo** em Configurações, ou digitar `completo` no terminal.

## O cartão de aprovação

O cartão aparece acima da caixa de mensagem. Ele diz o que será feito (o comando, ou os arquivos), **Por que pergunta** e, em **Detalhes da operação**, os argumentos e um hash deles. Um subagente que pede aprovação tem o nome dele no título.

| Botão | Efeito |
|---|---|
| **Aprovar uma vez** | Só esta chamada, com estes argumentos exatos. |
| **Sempre permitir editar este arquivo** | Para criar ou editar arquivo: as próximas edições desse mesmo arquivo do projeto passam sem pedir, qualquer que seja o texto. |
| **Sempre permitir este comando exato** | Para comandos no terminal do Windows: só a repetição exata do comando. Se o comando chama um script, o script roda de novo mesmo que tenha mudado. |
| **Sempre permitir esta ação neste projeto** | Para as outras ações: só a mesma ação com exatamente os mesmos argumentos. |
| **Rejeitar** | O assistente é avisado e segue sem essa ação. A mesma chamada, repetida na mesma conversa, é rejeitada sem novo cartão. |

Qualquer mudança nos argumentos gera um cartão novo. No terminal e no VS Code as opções são as mesmas (veja [Terminal e VS Code](terminal-e-vscode.md)); liberar uma janela ou adicionar um MCP só é possível na janela do app, e lá fora dá apenas para rejeitar.

## O shell confinado

Os comandos do assistente rodam no shell confinado: `cmd.exe` dentro de um contêiner do Windows (AppContainer), que grava só na pasta do projeto e na pasta temporária, não lê o resto do seu perfil e não acessa a rede. Num projeto com Git, `git status`, `git diff` e `git log` funcionam, mas `.git` é só leitura: `git add`, `commit` e `push` não rodam ali.

Num projeto com Git, com o shell confinado ativo, todo comando vai para ele e roda sem pedir aprovação, em qualquer modo; o terminal do Windows nem é oferecido ao assistente. Num projeto sem Git, o shell confinado pede aprovação em **Solicitar aprovação** e roda sem pedir nos outros modos.

O estado fica em **Configurações → Permissões → Shell confinado**:

- Mostra se o shell está ativo e com que motor. Se estiver indisponível, os comandos vão para o terminal do Windows, sempre com aprovação.
- Lista as ferramentas encontradas na máquina e se cada uma **roda confinado**. Uma ferramenta instalada numa pasta que o contêiner não lê mostra **Liberar** seguido do nome dela: o botão dá leitura e execução daquela pasta ao shell confinado, e o Windows pede confirmação de administrador.
- Quando há mais de um motor, você escolhe entre **AppContainer** (o padrão, sem instalação) e **Contas do sandbox** (contas locais próprias; **Instalar**, **Reparar** e **Remover contas** pedem administrador). Trocar o motor reinicia o projeto.

## Internet no shell confinado

Em **Configurações → Permissões → Shell confinado**, marque **Permitir acesso à internet**. A escolha vale só para o projeto aberto.

- Libera só a internet pública, para instalar dependências e baixar pacotes. A rede local e a própria máquina continuam bloqueadas por uma regra do Firewall do Windows; na primeira vez o Windows pode pedir confirmação de administrador para criá-la.
- Ligar ou desligar reinicia o projeto.
- Com rede, um comando também pode enviar arquivos do projeto para fora. Por isso o primeiro comando com internet de cada conversa pede aprovação (exceto em **Acesso completo**); aprovado, os seguintes da conversa seguem a regra normal do modo.

## Sair do sandbox

Num projeto com Git, para o que o confinamento não permite (por exemplo, rede local ou algo fora do projeto), o assistente pede para sair do sandbox, num cartão **Sair do sandbox: terminal do Windows**. Aprovado, ele passa a ter o terminal do Windows nesta conversa. Num projeto sem Git esse terminal já está disponível ao assistente.

O terminal do Windows roda com o seu usuário, sem confinamento, e pode acessar a rede e arquivos fora do projeto. Cada comando nele pede aprovação (cartão **Rodar comando**), exceto em **Acesso completo**.

## Revisar e revogar aprovações "sempre"

- **Configurações → Permissões → Permissões persistentes**: cada regra mostra o tipo (por exemplo, **Alteração de arquivo** ou **Comando no terminal**), o alcance (**Este arquivo** ou **Exatamente os mesmos argumentos**) e a data. **Revogar** apaga uma; **Revogar todas** apaga todas. Revogar não muda o modo.
- No terminal: `/regras` lista as aprovações "sempre" do projeto e revoga a escolhida, ou **Todas**.

As regras são do projeto. Uma conversa em worktree é outro projeto, com aprovações próprias (veja [Worktrees](worktrees.md)).

## O que uma troca revoga

- **Trocar o modo** (ou revogar uma regra): os cartões ainda sem resposta somem, e liberações temporárias, como janelas de outros programas, são revogadas. As regras "sempre" ficam.
- **Trocar o modelo** do projeto: só é aceito com nenhuma conversa respondendo, nenhum subagente trabalhando e nenhuma aprovação pendente; as liberações temporárias são revogadas. As regras "sempre" ficam.
- **Uma atualização do app que muda as regras de segurança** volta o projeto para **Solicitar aprovação** e apaga as regras "sempre" dele.
- **Ligar o modo plano** numa conversa descarta os cartões pendentes dela.
