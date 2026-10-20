# Terminal e VS Code

Referência completa do comando `lagrange` (subcomandos, opções e comandos de barra) e da extensão do VS Code. O resumo de quatro comandos está no [README](../README.md#3-no-terminal); as teclas estão em [Atalhos de teclado](atalhos.md).

O terminal e o VS Code usam o projeto, as conversas, a memória e o modelo configurados no app. Escolha um modelo e, se ele exigir, configure a chave no app primeiro ([Primeiros passos](primeiros-passos.md)).

## Abrir uma conversa no terminal

Na pasta do projeto:

| Comando | O que faz |
|---|---|
| `lagrange` | Conversa em tela cheia. A tela aparece na hora; se o projeto estava fechado, ele inicia em alguns segundos e você já pode escrever |
| `lagrange -c` (`--continue`) | Retoma a conversa mais recente do projeto |
| `lagrange -r <id>` (`--resume`) | Retoma uma conversa pelo id (os ids começam com `ses`; veja `lagrange sessions`) |
| `lagrange --inline` | Conversa dentro do histórico do terminal, sem tela cheia |
| `lagrange --plain` | Sem cores nem redesenho: um prompt de linha simples. Também vale com a variável `NO_COLOR` ou quando a saída não é um terminal |
| `lagrange --tui` | Força a tela cheia mesmo sem cores |

Qualquer pasta serve: uma pasta nunca aberta vira um projeto. Sem terminal interativo (por exemplo, `Get-Content pedido.txt | lagrange`), o texto do stdin é enviado como em `lagrange exec`.

Na conversa:

- O que você digita enquanto ele responde entra na fila e vai depois.
- Aprovações e perguntas aparecem como menus: **Aprovar uma vez**, **Sempre este arquivo** / **Sempre este comando exato** / **Sempre esta ação**, ou **Rejeitar** ([Permissões e aprovações](permissoes.md)). Liberar a janela de outro programa ou adicionar um servidor MCP só pode ser aprovado na janela do app; no terminal dá apenas para rejeitar.
- Uma memória proposta no fim da resposta é decidida ali: `c` confirma, `r` rejeita, Enter deixa para depois.
- `@arquivo` + Tab completa arquivos do projeto; `@agent-<nome>` pede a tarefa a um subagente do projeto (veja `/agentes`).
- Em respostas, `arquivo:linha` vira link clicável no Windows Terminal e no terminal do VS Code.
- Uma resposta que levou mais de 10 segundos toca o sinal do terminal ao terminar.
- Ao sair (`/sair`, Ctrl+C ou Ctrl+D com a caixa vazia, ou fechando o terminal), a resposta em andamento e os subagentes desta conversa são parados; workflows continuam no projeto. A conversa fica guardada (retome com `lagrange -c`). O projeto continua aberto em segundo plano ([Processos que ficam abertos](solucao-de-problemas.md#processos-que-ficam-abertos)).

## Um turno sem interação: `lagrange exec`

```powershell
lagrange exec "resuma o README"
lagrange exec -c "e agora os testes?"            # continua a última conversa (ou -r <id>)
Get-Content pedido.txt | lagrange exec -          # "-" (ou nenhum texto) lê do stdin
```

Sem `-c`/`-r`, cada `exec` cria uma conversa nova.

| Opção | O que faz |
|---|---|
| `--output text` | Padrão: só a resposta final no stdout |
| `--output json` | Um objeto JSON no fim: `sessionID`, `status`, `tools` (as etapas), `text` e, se houve, `error` |
| `--output stream-json` | Uma linha JSON por evento: `start`, `text_delta` (a resposta enquanto é escrita), `tool` (etapa `running`/`completed`/`error`), `approval`, `text`, `error` e sempre `done` no fim |
| `-i`, `--image <arquivo>` | Anexa uma imagem (PNG, JPEG, GIF ou WebP, até 5 MB). Repetível |
| `--plan` | Turno em modo plano: nada é alterado |
| `--subscription` | Turno com o trabalho delegado ao Claude Code ou ao Codex, na sua assinatura |
| `-o`, `--output-file <arquivo>` | Grava também a resposta final no arquivo |
| `--output-schema <schema.json>` | Pede a resposta em JSON e a confere contra o JSON Schema. O schema é lido antes de abrir o projeto: um schema inválido ou com recursos que não dá para conferir é recusado sem gastar nada. Com `text`, a resposta sai formatada |

Com `--output json` ou `stream-json`, os erros também saem em JSON no stdout (`type: "error"`, `message`, `code`). Avisos como "Iniciando o projeto…" vão para o stderr.

O `exec` nunca aprova nada. Se o turno pedir uma aprovação ou uma resposta sua, ele para sem decidir, escreve no stderr o que foi pedido e por quê, e sai com código 2; continue no app ou com `lagrange -r <id>`. Ctrl+C interrompe o turno; um segundo Ctrl+C sai sem esperar.

| Código de saída | Significado |
|---|---|
| 0 | Concluído |
| 1 | Erro (argumento, arquivo, projeto, modelo…) |
| 2 | Precisa de uma decisão sua |
| 3 | Turno interrompido ou falhou, ou a resposta não seguiu o `--output-schema` |

## Outros subcomandos

| Comando | O que faz |
|---|---|
| `lagrange sessions [--json]` | Conversas do projeto, da mais recente: id, data, estado (concluída, em andamento, aguardando aprovação ou resposta, interrompida, falhou, sem mensagens) e título |
| `lagrange status [--json]` | Projeto, modelo, modo de acesso e esforço |
| `lagrange model` | Lista os modelos disponíveis (`*` marca o atual) |
| `lagrange model <provedor/modelo>` | Troca o modelo do projeto, como no app |
| `lagrange effort [nível\|padrão]` | Mostra os níveis do modelo atual ou troca o esforço de raciocínio |
| `lagrange memory export [arquivo.md\|arquivo.json]` | Exporta a memória do projeto; sem arquivo, escreve o Markdown no terminal |
| `lagrange memory import <arquivo>` | Importa `.md`, `.markdown`, `.txt` (um item por linha, `- texto`) ou uma exportação JSON do Lagrange. Cria só **propostas**, que você confirma no app ou com `/memoria` |
| `--reference` em `memory` | Usa a memória de referência, compartilhada entre os projetos, em vez da do projeto ([Memória e skills](memoria-e-skills.md)) |
| `lagrange workflows [id] [--json]` | Workflows do projeto; com o id, progresso, custo, permissões e checks |
| `lagrange workflows review <id>` / `integrate <id>` | Revisa o diff de um workflow; `integrate` só entrega depois de você digitar `integrar` |
| `lagrange lines [--json]` (`-r <id>`) | Linhas de trabalho dos workers da conversa (padrão: a mais recente) |
| `lagrange lines review\|integrate\|release\|discard <n\|id>` | Revisa, integra (digite `integrar`), libera (digite `liberar`) ou fecha (digite `descartar`; a worktree fica no disco) uma linha |
| `lagrange lines handoff <n\|id> [--prompt "<texto>"]` | Passa a linha ao outro worker depois de você responder `s` |
| `lagrange mcp` | Servidor MCP (stdio) para outro agente entregar tarefas a este projeto (ferramentas `lagrange_run`, `lagrange_sessions`, `lagrange_session`, `lagrange_status`). Nunca aprova: uma tarefa que precisa de decisão para e diz o que foi pedido |
| `lagrange doctor` | Confere a instalação, o projeto, o modelo e o shell confinado ([o que cada linha quer dizer](solucao-de-problemas.md#lagrange-doctor)) |
| `lagrange completion powershell` | Script de autocompletar para o PowerShell |
| `lagrange -h` / `-v` | Ajuda / versão instalada |

Integrar, liberar e descartar exigem um terminal interativo e a palavra digitada; num script eles se recusam. Workflows e linhas de trabalho estão em [Subagentes e workflows](subagentes-e-workflows.md).

Para registrar o Lagrange no Claude Code, na pasta do projeto:

```powershell
claude mcp add lagrange -- "$env:LOCALAPPDATA\HarnessAI\bin\lagrange.cmd" mcp --project .
```

Para autocompletar no PowerShell, adicione ao seu `$PROFILE`:

```powershell
lagrange completion powershell | Out-String | Invoke-Expression
```

Ele completa subcomandos e opções e, depois de `model` ou `effort`, os valores do projeto, se ele já estiver aberto.

## Opções que valem para todos

| Opção | O que faz |
|---|---|
| `--project <pasta>` | Usa outro projeto (padrão: a pasta atual) |
| `--home` | Usa as conversas pessoais, fora de qualquer projeto |
| `--plain` | Sem cores nem redesenho (também com `NO_COLOR`) |
| `--json` | Saída em JSON em `sessions`, `status`, `workflows` e `lines` |

## Comandos de barra

Digite `/` na conversa do terminal para ver a lista com o que cada um faz (↑/↓ escolhe, Tab completa, Enter roda). Os comandos do projeto e do app também aparecem ali e em `/ajuda`, e rodam como na janela.

| Comando | O que faz |
|---|---|
| `/ajuda` | Lista os comandos e as teclas |
| `/nova` | A próxima mensagem começa outra conversa |
| `/conversas` | Escolhe uma das 15 conversas mais recentes para retomar |
| `/voltar` | Escolhe uma das suas últimas 20 mensagens e desfaz ela e tudo depois dela, com confirmação |
| `/desfazer` | Desfaz a sua última mensagem e a resposta, com confirmação. Antes, mostra que arquivos voltam e o que não pode ser desfeito ([Worktrees, revisão e desfazer](worktrees.md)) |
| `/exportar [completo]` | Salva uma cópia segura da conversa. `completo` salva a transcrição inteira, com argumentos de ferramentas e possíveis segredos, e pede que você digite o título |
| `/historico [termo]` | Busca mensagens que você escreveu e põe a escolhida na caixa para editar |
| `/subagentes [parar]` | Subagentes desta conversa: escolha um para ver o que ele fez; `parar` interrompe um que está trabalhando |
| `/linhas [revisar\|integrar\|liberar\|descartar\|passar] <número>` | Linhas de trabalho dos workers, como em `lagrange lines`; `passar` aceita uma instrução extra |
| `/mouse [liga\|desliga]` | Liga ou desliga a roda do mouse na tela cheia. Desligada, o terminal volta a selecionar texto normalmente |
| `/modelo [provedor/modelo]` | Troca o modelo do projeto (vale também no app) |
| `/esforco [nível\|padrão]` | Esforço de raciocínio (também `/esforço`) |
| `/modo [supervisionado\|projeto\|completo]` | Modo de acesso. `completo` exige digitar `completo` |
| `/plano` | Liga ou desliga o modo plano da conversa (depois da primeira mensagem) |
| `/assinatura [liga\|desliga]` | Liga ou desliga os workers por assinatura (Claude Code, Codex) nesta conversa; a primeira vez pede que você digite `ligar`. `/assinatura passagem on\|off` e `/assinatura revisao on\|off` mudam a passagem automática e a revisão cruzada da conta |
| `/consumo` | Tokens e custo nesta conversa, hoje e no projeto ([Custo](custo.md)) |
| `/status` | Projeto, modelo e modo de acesso |
| `/revisar` | Revisa as mudanças não commitadas: cada achado com severidade, `arquivo:linha`, evidência e ação sugerida |
| `/diff [arquivo]` | Arquivos alterados (● marca os desta conversa); com um arquivo, as linhas |
| `/pr` | Pull requests desta conversa e o estado de cada um |
| `/abrir <arquivo[:linha]>` | Abre um arquivo do projeto no VS Code ou, sem ele, no programa padrão |
| `/integrar` | Escolhe uma tarefa Worktree, mostra o diff e integra depois de você digitar `integrar` |
| `/init` | Pede ao assistente que crie ou atualize o `AGENTS.md` na raiz; a escrita passa pela aprovação de sempre |
| `/mcp` | Servidores MCP do `.mcp.json` do projeto e o estado de cada um; aprovar e revogar é no app ([MCP](mcp.md)) |
| `/regras` | Revoga aprovações "sempre" do projeto, uma ou todas |
| `/referencia` | Anexa outro projeto de código, só leitura, a partir da próxima mensagem |
| `/skills [filtro]` | Skills e comandos do projeto |
| `/agentes [filtro]` | Subagentes do projeto |
| `/sandbox` | Estado do shell confinado: motor, rede e ferramentas. `/sandbox rede liga\|desliga` e `/sandbox motor` reiniciam o projeto |
| `/memoria [referencia]` | Propostas de memória pendentes, para confirmar ou rejeitar |
| `/lembrar [referencia] <texto>` | Guarda uma memória; com `referencia`, vale para todos os projetos |
| `/imagem <arquivo>` | Anexa uma imagem à próxima mensagem (PNG, JPEG, GIF ou WebP, até 5 MB) |
| `/colar` | Anexa à próxima mensagem a imagem copiada |
| `/sair` | Sai (também `/exit` e `/quit`) |

## Extensão do VS Code

Abra uma pasta e clique no ícone **ℒ** na barra de atividades, ou use **Ctrl+Alt+L**. A extensão só funciona com a pasta marcada como confiável: no Modo Restrito do VS Code ela fica desligada até você confiar na pasta. Com várias pastas no workspace, escolha no topo do painel qual delas é o projeto.

O painel conversa sobre essa pasta, com os cartões de aprovação e as perguntas respondidos por clique. Uma etapa que editou um arquivo abre o diff dele (último commit ↔ disco); `arquivo:linha` numa resposta abre o arquivo.

No topo do painel:

- **Conversas**: continua uma conversa anterior.
- **Desfazer**: desfaz a última resposta, depois de mostrar o que volta e o que não pode ser desfeito.
- **Atualizar status**, **Problemas**, **Ver diff** e **Revisar no Lagrange** (abre a revisão no app; o painel não integra arquivos), com uma linha sobre o projeto e o workflow dele.

Abaixo da conversa:

- O modelo e o esforço de raciocínio, que valem para o projeto, como no app.
- O modo de acesso: **Solicitar aprovação** ou **Aprovar por mim**. **Acesso completo** só pode ser ligado na janela do app; com ele ligado, o painel mostra "Acesso completo (troque no app)".
- **Plano**: liga ou desliga o modo plano da conversa.
- **Assinaturas** e **Ajustes**, quando os workers por assinatura estão disponíveis.
- O chip com o arquivo aberto e a seleção, enviados com a mensagem; clique nele para não enviar.
- `@` completa arquivos; `/` lista os comandos do projeto e do app (os comandos de barra do terminal não valem aqui).
- Uma imagem colada (Ctrl+V) é anexada: até 4, de até 5 MB cada.
- **Parar** interrompe a resposta.
- Os subagentes e as linhas de trabalho da conversa.

Comandos (Ctrl+Shift+P, categoria **Lagrange**):

| Comando | O que faz |
|---|---|
| **Perguntar sobre a seleção** | Põe na caixa as linhas selecionadas, com o arquivo e o intervalo. Também no menu de contexto do editor, com seleção |
| **Corrigir problemas do arquivo** | Põe na caixa os erros e avisos do arquivo (até 50). Também no menu de contexto do editor |
| **Ver alterações** | Escolhe um arquivo alterado e abre o diff com o último commit |
| **Abrir no app** | Abre este projeto na janela do Lagrange |
| **Conversas anteriores** | O mesmo que **Conversas** |
| **Desfazer a última resposta** | O mesmo que **Desfazer** |
| **Nova conversa** | Começa outra conversa |
| **Focar o painel** | **Ctrl+Alt+L**; com uma seleção, põe a referência `@arquivo:linhas` na caixa |

A extensão carrega o seu cliente do app instalado: reinstalar ou atualizar o app atualiza o painel. Sem o app instalado, o painel diz que o Lagrange não está instalado.
