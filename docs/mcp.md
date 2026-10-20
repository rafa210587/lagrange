# Servidores MCP

Como ligar servidores MCP (GitHub, bancos de dados, ferramentas de design…) a um projeto, como as ferramentas deles pedem aprovação, e como outros agentes usam o Lagrange por MCP.

Tudo aqui vale por projeto: um servidor ligado num projeto não aparece em outro. Automações nunca usam ferramentas MCP (veja [Automações](automacoes.md)).

## Formas de ligar um servidor

| Forma | Onde | Para |
|---|---|---|
| `.mcp.json` do repositório | Arquivo na pasta do projeto | Servidores locais que o repositório já declara (formato do Claude Code). |
| Registro oficial, pelo chat | Pedido ao assistente | Achar e adicionar um servidor publicado, sem editar arquivo. |
| Pacote de extensão | **Configurações → Skills** | Um servidor local seu, empacotado e reaproveitado em vários projetos. |
| Endpoint remoto HTTPS | **Configurações → Projeto** | Um servidor na internet, sem login. |

Um servidor local roda como um processo com o seu usuário, com acesso aos seus arquivos e à rede, fora do shell confinado. Só ligue o que você confia.

## Servidores do `.mcp.json`

O Lagrange lê o `.mcp.json` na raiz do projeto, no mesmo formato do Claude Code:

```json
{"mcpServers": {"github": {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"], "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}}}}
```

Nada roda até você aprovar:

1. Abra **Configurações → Projeto** e expanda **Avançado: regras, hooks e servidores MCP do repositório**. Os servidores aparecem em **MCP do projeto**, com o comando exato.
2. Cada `${VARIÁVEL}` vira um campo de senha: preencha e clique em **Salvar**. O valor fica guardado com a proteção de dados do Windows, só neste projeto; ele nunca é lido das variáveis de ambiente do seu Windows.
3. Clique em **Aprovar este comando**. O servidor é iniciado uma vez para listar as ferramentas.
4. Se o `.mcp.json` mudar, a aprovação caduca (**A entrada mudou — confira e aprove de novo**). **Revogar** desliga o servidor.

Entradas remotas (`url`) no `.mcp.json` aparecem como não suportadas.

## Servidores do registro oficial

Peça no chat, por exemplo: "procure um servidor MCP para o Postgres e adicione ao projeto".

1. A busca pede aprovação; só o termo buscado vai para o registro oficial de MCP (`registry.modelcontextprotocol.io`).
2. O assistente propõe um servidor. O cartão mostra nome, versão, quem publicou, código-fonte, pacote, o comando que vai rodar e as variáveis de que ele precisa. O pacote vem da internet: a versão fica fixa, as dependências dele não.
3. **Adicionar ao projeto** baixa e inicia o servidor uma vez para listar as ferramentas; a conversa continua sozinha quando ele conecta.
4. Se ele precisar de credenciais, preencha em **MCP do projeto** (passo 2 acima) e aprove lá. Nunca passe credenciais pelo chat.

Esses servidores ficam guardados pelo app, não no repositório, e aparecem em **MCP do projeto** com **Remover do projeto**, que apaga a entrada, a aprovação e as credenciais. Até 30 por projeto.

## Servidor local num pacote de extensão

Empacote o servidor numa pasta com um `lagrange-extension.json` do tipo `mcp`:

```json
{"id":"meu-mcp","version":"1","type":"mcp","command":["node","{package}/server.js"],"tools":["buscar","listar"]}
```

- `command`: o comando e os argumentos, em lista. `{package}` vira a pasta do pacote instalado.
- `tools`: os nomes exatos das ferramentas que ele oferece.

Instale como qualquer pacote ([Memória e skills](memoria-e-skills.md#instalar-um-pacote-de-uma-pasta)), clique em **Ligar** e, em cada projeto onde ele deve rodar, em **Autorizar MCP neste projeto**.

## Servidor remoto HTTPS

Em **Configurações → Projeto**, seção **Propostas MCP locais**:

1. Preencha **Nome local do servidor** (começa por letra; letras, números, `_` e `-`; até 41 caracteres) e **Endpoint HTTPS**, e clique em **Pré-visualizar proposta**.
2. Confira o endereço e clique em **Aprovar proposta**. Isso ainda não conecta nem libera ferramentas.
3. Clique em **Conectar**. O Lagrange confere o destino antes de qualquer acesso; com a conexão aberta, o cartão mostra o endereço conferido e as ferramentas que o servidor listou. Só essas podem ser usadas.

Restrições:

- O endereço precisa ser HTTPS, com nome público (sem IP, `localhost`, `.local`, `.internal`, `.lan` e afins) e sem usuário, senha, parâmetros ou token na URL.
- Não há login: servidores que exigem OAuth ou outra autenticação ainda não funcionam.
- Ao reabrir o projeto, a conexão começa fechada: clique em **Conectar** de novo.
- **Revogar consentimento local** fecha a conexão e remove as ferramentas dele; **Reconectar** refaz a conexão; **Remover** apaga uma proposta não aprovada ou revogada.

## Ferramentas MCP nos cartões de aprovação

O título do cartão é o nome da ferramenta, prefixado pelo servidor; para servidores remotos, o cartão diz também **Servidor MCP remoto: <nome> (<endereço>)**. **Sempre permitir esta ação neste projeto** libera só a repetição com os mesmos argumentos.

| Servidor | Quando a ferramenta pede aprovação |
|---|---|
| **MCP do projeto** (`.mcp.json` e registro), sem marcação | Sempre, em qualquer modo, inclusive **Acesso completo**. |
| **MCP do projeto**, marcada **— somente leitura** | Só em **Solicitar aprovação**; em **Aprovar por mim** e **Acesso completo** roda sem perguntar. |
| Pacote de extensão ou remoto | Em **Solicitar aprovação** e **Aprovar por mim**; em **Acesso completo** roda sem perguntar. |

A caixa **— somente leitura** fica na lista de ferramentas de cada servidor em **MCP do projeto**. O que o servidor diz sobre si mesmo não conta: a marcação é sua e caduca se o comando mudar. Veja [Permissões](permissoes.md) sobre os modos e como revogar permissões "sempre".

## Outros agentes usando o Lagrange (`lagrange mcp`)

`lagrange mcp` faz um projeto do Lagrange servir de servidor MCP para outros agentes, como o Claude Code ou o Codex. Eles entregam uma tarefa (`lagrange_run`), listam e leem conversas (`lagrange_sessions`, `lagrange_session`) e consultam projeto, modelo e modo (`lagrange_status`). O Lagrange usa o próprio modelo, memória e política, e nunca aprova nada: se a tarefa precisar de uma decisão, o turno para e a resposta diz o que foi pedido. Responda no app.

Para registrar no Claude Code, na pasta do projeto:

```powershell
claude mcp add lagrange -- "$env:LOCALAPPDATA\HarnessAI\bin\lagrange.cmd" mcp --project .
```

No Codex, adicione `[mcp_servers.lagrange]` ao `config.toml`, com `command` apontando para esse `lagrange.cmd` e `args = ["mcp", "--project", "<pasta do projeto>"]`. Requer a parte **Terminal** instalada (veja [Terminal e VS Code](terminal-e-vscode.md)).
