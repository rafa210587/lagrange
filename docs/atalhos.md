# Atalhos de teclado

As teclas do app, da conversa no terminal (`lagrange`) e da extensão do VS Code.

## App

A lista abaixo é a mesma de **Ajuda → Atalhos de teclado** (Ctrl+/):

| Ação | Tecla |
|---|---|
| Nova conversa | Ctrl+N |
| Adicionar projeto… | Ctrl+Shift+O |
| Configurações | Ctrl+, |
| Desfazer | Ctrl+Z |
| Refazer | Ctrl+Y |
| Recortar | Ctrl+X |
| Copiar | Ctrl+C |
| Selecionar tudo | Ctrl+A |
| Buscar conversas | Ctrl+K |
| Barra lateral | Ctrl+B |
| Atalhos de teclado | Ctrl+/ |
| Enviar a mensagem | Enter |
| Quebrar a linha | Shift+Enter |
| Abrir o menu | Alt ou F10 |
| Fechar um painel | Esc |

Desfazer, Refazer, Recortar, Copiar e Selecionar tudo valem para o texto que você está editando; desfazer uma resposta do assistente é outra coisa ([Worktrees, revisão e desfazer](worktrees.md)). Esc fecha também a escolha de modelo e as Configurações.

Outras teclas no app:

- Nas sugestões de `@` e `/` da caixa de mensagem: ↑/↓ escolhe, Enter ou Tab insere, Esc fecha.
- No menu (depois de Alt ou F10): setas, Home e End navegam; Esc fecha.
- Na borda da barra lateral, com foco: ←/→ ajustam a largura; Home e End vão ao mínimo e ao máximo.
- Na mensagem para um subagente: Ctrl+Enter envia ou adiciona à fila.
- No visualizador de imagens anexadas: ←/→ passam de imagem, Esc fecha.

## Terminal

Na conversa em tela cheia ou `--inline`:

| Tecla | O que faz |
|---|---|
| Enter | Envia (com sugestões de `/` abertas, roda a escolhida) |
| `\` + Enter, Ctrl+J, Shift+Enter ou Alt+Enter | Nova linha na mensagem (Shift e Alt dependem do terminal repassar a tecla) |
| Esc | Interrompe a resposta |
| Ctrl+C | Interrompe a resposta; sem resposta, limpa a caixa; com a caixa vazia, sai |
| Ctrl+D | Sai, com a caixa vazia |
| Shift+Tab | Alterna entre **Solicitar aprovação** e **Aprovar por mim**. **Acesso completo** só com `/modo completo` |
| Tab | Completa `@arquivo` e `@agent-<nome>`; com sugestões de `/` abertas, insere a escolhida |
| ↑/↓ | Mensagens anteriores (numa mensagem de uma linha); com sugestões abertas, escolhe |
| Ctrl+R | Busca mensagens anteriores (`/historico`) |
| Ctrl+G | Escreve a mensagem no seu editor (`$VISUAL`, `$EDITOR` ou o Bloco de Notas) |
| Ctrl+O | Detalhe da última etapa |
| Ctrl+L | Limpa a tela |
| Ctrl+W / Ctrl+U | Apaga a palavra anterior / até o início |
| Ctrl+←/→ | Move por palavra |
| Home ou Ctrl+A / End ou Ctrl+E | Início / fim da linha |
| ↓ (no fim do histórico, caixa vazia) ou → | Vai para a lista de subagentes abaixo da caixa |
| Na lista: ↑/↓, Enter ou →, x ou Delete, Esc ou ← | Escolhe, entra na conversa do subagente, para o subagente, volta |
| ← (caixa vazia, dentro de um subagente) | Volta à conversa principal; Enter manda a mensagem para o subagente |

Só na tela cheia:

| Tecla | O que faz |
|---|---|
| PgUp/PgDn, roda do mouse | Rolam a conversa |
| Shift+↑/↓ | Rolam 3 linhas |
| Shift + arrastar | Seleciona texto com a roda do mouse ligada (`/mouse` desliga a roda) |

Nos menus (aprovações, perguntas e listas dos comandos de barra): ↑/↓ escolhe, Enter confirma, um número de 1 a 9 escolhe direto, Esc cancela.

Com `--plain` não há menus: digite o número da opção. Tab completa `@arquivo`, e Ctrl+C interrompe a resposta ou sai.

Os comandos de barra estão em [Terminal e VS Code](terminal-e-vscode.md#comandos-de-barra).

## VS Code

| Tecla | O que faz |
|---|---|
| Ctrl+Alt+L | Abre o painel do Lagrange; com uma seleção no editor, põe a referência `@arquivo:linhas` na caixa |
| Enter | Envia |
| Shift+Enter | Nova linha |
| ↑/↓, Enter ou Tab, Esc | Nas sugestões de `@` e `/`: escolhe, insere, fecha |
| Ctrl+V | Cola uma imagem na mensagem |

Os comandos da extensão estão em [Terminal e VS Code](terminal-e-vscode.md#extensão-do-vs-code).
