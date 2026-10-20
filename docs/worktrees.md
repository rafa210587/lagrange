# Worktrees, revisão, integração e desfazer

Como isolar uma conversa numa worktree, revisar o que mudou, levar para o projeto e desfazer respostas.

## Pasta atual ou worktree

Clique em **Novo** (Ctrl+N). A janela **Nova conversa** pergunta onde a conversa nasce (**Neste projeto**, **Escolher uma pasta…** ou **Sem pasta (conversa solta)**) e, em **Neste projeto**, de que jeito:

| Opção | O que acontece |
|---|---|
| **Pasta atual** (o padrão) | A conversa trabalha direto na pasta do projeto. Abre na hora. |
| **Cópia isolada (worktree)** | O app cria uma worktree Git com uma branch própria e abre a conversa nela. Leva alguns segundos (o botão mostra **Preparando…**). Use quando várias tarefas rodarem em paralelo ou quando o projeto não puder ser tocado. |

A worktree só aparece como opção quando:

- a pasta é um repositório Git com pelo menos um commit;
- a conversa não está já dentro de uma worktree.

Fora disso, a conversa usa a pasta atual e a janela explica por quê.

A worktree parte do último commit. Alterações não commitadas do projeto, incluindo arquivos novos, **não são copiadas**. Se o caminho da worktree passar do limite do Windows, a conversa é criada na pasta atual com um aviso; para usar worktrees nesse projeto, habilite `core.longpaths` no Git.

## O que a worktree herda

| Vem do projeto de origem | Começa do zero |
|---|---|
| Chaves de provedor e modelo escolhido | Modo de aprovação e aprovações "sempre" |
| A memória do projeto, que é a mesma (o que você confirma numa vale na outra) | |

As permissões são explicadas em [permissões](permissoes.md) e a memória em [memória e skills](memoria-e-skills.md).

## Revisar o que mudou

Num projeto com Git, a aba **Mudanças** do painel lateral mostra as **Mudanças não commitadas** da pasta da conversa, seja o projeto ou a worktree. Os arquivos alterados nesta conversa levam a marca ●. Use **Atualizar** quando aparecer "O agente alterou arquivos desde esta leitura."

- **Comentar uma linha:** clique na linha do diff, escreva e clique em **Comentar**. Os comentários se acumulam; **Enviar N comentário(s) ao agente** manda todos de uma vez como mensagem na conversa.
- **Revisar mudanças:** um subagente que só lê revisa as mudanças não commitadas e lista achados com arquivo e linha. Cada achado tem **Ver** e **Comentar**. A revisão tem limite de 10 minutos e não começa uma resposta nova na conversa. Arquivos sensíveis aparecem como ocultos e ficam fora da revisão.

## Commitar e integrar uma worktree

A integração junta a branch da worktree ao projeto de origem. Ela é feita **a partir do projeto de origem**, nunca de dentro da worktree.

1. Na worktree, commite o trabalho. Peça ao assistente ou use o seu próprio Git. A integração só leva o que está commitado, e a worktree precisa estar sem alterações pendentes.
2. Feche a worktree: no **⋮** dela em **Projetos**, **Fechar projeto**.
3. Abra o projeto de origem. Se você estiver dentro da worktree, **Configurações → Projeto** mostra **Abrir projeto de origem**.
4. No projeto de origem, vá em **Configurações → Projeto → Áreas de trabalho isoladas** e escolha a tarefa em **Tarefa Worktree**. O diff contra o commit de partida aparece sozinho. **Revisar alterações** lê esse diff de novo.
5. Clique em **Integrar com segurança**. O app faz um merge sem fast-forward na branch atual do projeto de origem, com um commit de merge.

A integração é recusada, sem mudar nada, quando:

- alguma conversa do projeto de origem está respondendo, há aprovação pendente, um subagente roda ou um resultado espera conferência (a mensagem diz qual);
- a worktree tem alterações não commitadas, ou não tem nenhum commit novo;
- a worktree mudou depois da revisão ("A tarefa mudou após a revisão" ou "A revisão mudou antes da integração");
- o projeto de origem tem alterações não commitadas, mudou depois da revisão ou trocou de branch desde que a worktree foi criada;
- a tarefa já foi integrada.

Se o merge der conflito, o app desfaz o merge ("A integração encontrou conflitos; origem restaurada"). A origem volta a como estava e os arquivos da worktree não são tocados. Os conflitos não são resolvidos automaticamente.

Depois da integração, a worktree e a branch continuam no disco e a tarefa passa a constar como integrada. Nada é apagado sozinho.

### Várias tarefas em paralelo

Integre uma de cada vez. Cada integração muda o projeto de origem e invalida a revisão das outras ("A origem mudou após a revisão"). Para a próxima, clique em **Revisar alterações** e depois em **Integrar com segurança**.

## Desfazer e voltar a uma mensagem

Passe o mouse sobre uma mensagem sua para ver as ações:

- **Desfazer até aqui**: tira da conversa essa mensagem e tudo o que veio depois, e restaura os arquivos. Para desfazer só a última resposta, use na sua última mensagem.
- **Reprocessar: enviar esta mensagem de novo**: desfaz do mesmo jeito e reenvia a mensagem.
- **Bifurcar: nova conversa a partir daqui**: cria outra conversa a partir desse ponto, sem desfazer nada nesta.

Antes de agir, o app mostra uma confirmação (**Desfazer até esta mensagem**) com:

- os arquivos que voltam ao estado anterior;
- o aviso "Arquivos NÃO serão restaurados (sem projeto Git)", fora de um projeto Git;
- as ferramentas cujo efeito "Não será desfeito".

Ao confirmar em **Desfazer**, o texto da mensagem volta para a caixa de mensagem, se ela estiver vazia. Desfazer só funciona com a conversa parada.

> **Atenção: desfazer não guarda as suas edições.** Cada arquivo do projeto que mudou durante as respostas desfeitas volta ao conteúdo que tinha **antes da primeira mudança**, e um arquivo criado nelas é apagado. Isso inclui o que **você** editou nesses mesmos arquivos depois da resposta, ou enquanto o assistente trabalhava: essas edições também se perdem. Arquivos que mudaram só nos intervalos entre as respostas não são tocados. Se quiser manter uma edição sua, faça um commit ou uma cópia antes.

O que fica de fora:

- arquivos ignorados pelo Git (`.gitignore`), que não são restaurados;
- tudo o que não é arquivo do projeto: comandos que mexeram fora dele, rede, aplicativos, navegador, servidores MCP e subagentes. Confira esses efeitos manualmente;
- fora de um projeto Git, só a conversa volta, e os arquivos não.

Depois de desfazer, uma faixa avisa "Conversa e arquivos voltaram ao ponto escolhido. Enviar uma nova mensagem descarta o que foi desfeito." e oferece **Refazer**:

- **Refazer** devolve a conversa e todos os arquivos do projeto ao estado do momento em que você desfez, inclusive arquivos que você mudou depois de desfazer.
- Ao enviar uma nova mensagem, o que foi desfeito é descartado e **Refazer** some.

No terminal e no VS Code, veja [terminal e VS Code](terminal-e-vscode.md).
