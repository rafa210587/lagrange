# Memória e skills

O que o assistente lembra entre conversas, como você controla isso, e como dar a ele instruções especializadas (skills) e outros pacotes.

## Memória

Fica em **Configurações → Personalização**, em dois grupos:

| Grupo | Vale em |
|---|---|
| **Você** | Todos os projetos (preferências, quem você é, como quer as respostas). |
| **Este projeto** | As conversas e worktrees deste projeto. Nas conversas pessoais, o grupo se chama **Conversas pessoais**. |

Quando as duas se contradizem, vale a do projeto.

A chave **Usar memória nas conversas** liga ou desliga a consulta: ligada, o assistente lê o que está confirmado a cada mensagem.

### Propostas do assistente

O assistente pode propor uma memória durante a conversa. Ela aparece ali mesmo como **Memória proposta: …**, com **Confirmar** e **Rejeitar**, e só entra no contexto depois que você confirma. Uma proposta para **Você** vale fora do projeto, então antes disso ela pede aprovação como qualquer ação com efeito. As propostas também ficam no topo da lista em **Personalização**, marcadas como **Proposta**.

### Adicionar, editar, esquecer

- Para adicionar: escreva no campo abaixo das listas, escolha **Guardar em Você** ou **Guardar neste projeto** e clique em **Salvar**. O que você adiciona já entra confirmado.
- Clique numa memória para abrir: **Editar**, **Mover para Você** (só as do projeto) e **Esquecer**.
- **Esquecer** remove o texto e impede que ele volte nas buscas. Não apaga conversas antigas nem arquivos que você já exportou.
- Duas memórias que se contradizem ficam fora das conversas até você esquecer a que deixou de valer.

### Exportar e importar

- Em **Exportar**: **Exportar Você em Markdown** (`memoria-voce.md`) ou **Exportar este projeto em Markdown** (`memoria-projeto.md`).
- **Importar memória de outros assistentes** (na versão publicada, pelo botão **Iniciar importação**) mostra um prompt para colar no ChatGPT, Claude ou outro assistente (**Copiar prompt**); cole a resposta e clique em **Importar para Você**. Também dá para usar **Importar de um arquivo Markdown** (até 2 MB). Cada item de lista (`- …`) vira uma **proposta** em **Você** para você confirmar; itens repetidos são ignorados.

No terminal, `/lembrar <texto>` guarda uma memória e `lagrange memory export` / `lagrange memory import` fazem o mesmo que os botões; veja [Terminal e VS Code](terminal-e-vscode.md).

## Skills

Uma skill é uma pasta com um `SKILL.md`: instruções que o assistente carrega quando a tarefa pede. Ele sempre vê o nome e a descrição; o arquivo inteiro só entra no contexto quando usado.

Veja e ligue as skills em **Configurações → Skills**:

- **Do Lagrange**: as que vêm com o app e as dos pacotes instalados, cada uma com uma chave para ligar ou desligar. Cada linha mostra a estimativa de tokens (**Catálogo ≈ …** e **ao usar ≈ …**) e o uso no período escolhido (**1 dia**, **7 dias**, **30 dias**).
- **Dos projetos**: as que o próprio projeto traz em `.agents/skills` ou `.claude/skills` (uma subpasta por skill, com `SKILL.md`). Essas valem automaticamente no projeto; para tirar, tire a pasta.

### Instalar um pacote de uma pasta

Para skills, agentes, regras e servidores MCP que não estão no projeto, monte uma pasta local com um `lagrange-extension.json`. O manifesto mínimo de uma skill:

```json
{"id":"minha-skill","version":"1","type":"skill","file":"SKILL.md"}
```

- `id`: minúsculas, números e `-`, começando por letra (até 64 caracteres).
- `type`: `skill`, `agent`, `rule` ou `command` (com `file` apontando para o arquivo de texto), `mcp` (veja [MCP](mcp.md)) ou `plugin`, que reúne até 30 desses numa lista `entries`.
- Um `command` é só um modelo de prompt: não pode rodar shell nem trocar modelo ou agente.

Para instalar:

1. Em **Configurações → Skills**, abra **Instalar de uma pasta**.
2. Em **Pasta da fonte para instalar ou atualizar**, informe o caminho da pasta.
3. Marque **Confio nesta fonte: os servidores MCP dela rodam processos locais com o meu usuário** e clique em **Instalar / atualizar**.
4. O pacote aparece em **Pacotes instalados**, **desligado**. Clique em **Ligar**. Pacotes com servidor MCP também precisam de **Autorizar MCP neste projeto** em cada projeto.

O app copia a pasta e usa essa cópia, conferida a cada abertura. Para atualizar, edite a pasta original e repita a instalação com o mesmo caminho: a nova versão substitui a anterior e mantém se estava ligada. **Remover** desativa o pacote.

**Ligar** e **Desligar** valem para todos os projetos; outros projetos abertos só adotam a mudança quando são reabertos.

Limites e condições:

- No máximo 8 MiB e 500 arquivos por pacote. Links, `.git`, `node_modules`, `.env*` e arquivos `credentials*`/`secrets*` são recusados.
- Não há hooks em JavaScript nem download de nada da internet: só o que está na pasta.
- Instalar, ligar, desligar ou remover exige o projeto parado (sem conversa respondendo, aprovação pendente ou subagente rodando) e **revoga as permissões "sempre"** do projeto (veja [Permissões](permissoes.md)).
- Instruções de skills, agentes e regras não dão nenhuma permissão: o que o assistente faz continua passando pelo modo de aprovação.
