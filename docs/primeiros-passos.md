# Primeiros passos

Do app recém-instalado à primeira conversa: projeto, chave, modelo, conversas e o que acontece ao fechar a janela. A instalação e a lista de provedores estão no [README](../README.md).

## Abrir o app

Abra **Lagrange** pelo Menu Iniciar. Na primeira vez o app pergunta **Como você quer ser chamado?**; o nome aparece no canto da barra lateral e muda depois em **Configurações → Geral**.

A janela abre nas **Conversas pessoais**. No alto, à esquerda, dois botões trocam o lado do app: **Conversa** (conversas pessoais e projetos sem Git) e **Código** (projetos com Git).

## Adicionar um projeto

1. Clique no **+** ao lado de **Projetos**, na barra lateral (ou **Arquivo → Adicionar projeto…**, **Ctrl+Shift+O**).
2. Escolha uma das opções:
   - **Usar uma pasta (opcional)**: liga uma pasta que já existe. Os arquivos ficam onde estão.
   - **Criar projeto**, com um nome: o app cria e guarda a pasta do projeto em `%LOCALAPPDATA%\HarnessAI-Workspaces\projects`.

O Git é opcional. Uma pasta com Git vira projeto de código: comandos rodam no shell confinado sem pedir aprovação (veja [Permissões](permissoes.md)) e cada conversa pode ter a sua worktree (veja [Worktrees](worktrees.md)). Se você criar o Git depois, o menu **⋮** do projeto oferece **Promover a projeto de código**.

Cada projeto tem as suas conversas, memória, aprovações, modelo e consumo.

## Começar sem chave

Uma conta sem chave pode começar pelos modelos gratuitos do OpenCode Zen. Leia e aceite o aviso sobre o uso dos dados antes da primeira mensagem. Em **Configurações → Modelos**, escolha quais modelos gratuitos habilitar. Os planos gratuitos de outros provedores exigem uma chave; veja o [README](../README.md).

## Configurar uma chave

1. Abra **Configurações** (a engrenagem no pé da barra lateral, ou **Ctrl+,**) → **Modelos**.
2. Em **Buscar provider**, digite o nome (por exemplo, `deepseek`) e escolha-o em **Provider**. Para uma API compatível com a da OpenAI, escolha **Cadastrar ID personalizado**, tipo **OpenAI compatível**, e informe **Endpoint / base URL**.
3. Cole a chave em **Credencial**.
4. Em **Modelos habilitados**, marque os modelos que quer ver no chat.
5. Clique em **Salvar provider**.
6. Clique em **Testar modelos habilitados** e confirme em **Enviar teste**. Cada modelo marcado recebe só "Responda apenas: ok", sem histórico (até 20 modelos, uma requisição cada, cobrada pelo provedor). O resultado diz quais não responderam e por quê.

A chave e os modelos habilitados valem para a conta toda: todos os projetos passam a usá-los. Um projeto que ainda tenha uma chave própria, de antes, mostra **Usar a chave da conta**. Se a chave existir só em outro projeto, aparece **Reutilizar a credencial de "…"**.

**Remover provider** tira os modelos dele do chat e apaga a chave salva.

## Escolher o modelo

Embaixo da caixa de mensagem, clique no botão do modelo. Use **Buscar modelo**, os **Recentes** ou **Mais modelos…** para os do catálogo ainda não habilitados. **Gerenciar modelos** abre **Configurações → Modelos**.

O modelo escolhido vale para o projeto inteiro. Para trocá-lo, nenhuma conversa pode estar respondendo nem com aprovação pendente; senão o app recusa e pede para concluir ou cancelar antes.

**Esforço**: quando o modelo oferece níveis de raciocínio, o menu do modelo mostra **Esforço**, com **padrão** (o que o modelo usa sem escolha) e os níveis que ele aceita, como **baixo**, **médio** e **alto**. Mais esforço pode aumentar o tempo e o custo da resposta. A escolha vale para todas as conversas do projeto.

## A primeira conversa

1. Clique em **Novo** (**Ctrl+N**). Num projeto, escolha **Neste projeto**, **Escolher uma pasta…** ou **Sem pasta (conversa solta)**; num projeto com Git, escolha também **Pasta atual** ou **Cópia isolada (worktree)**.
2. Escreva na caixa de mensagem. **Enter** envia; **Shift+Enter** quebra a linha.
3. Enquanto o assistente responde, **Enter** põe a próxima mensagem na fila (**Na fila**); ela sai quando a resposta atual terminar. **Parar** interrompe.

Quando o assistente quer fazer algo com efeito, aparece um cartão de aprovação logo acima da caixa de mensagem (veja [Permissões](permissoes.md)).

**Anexar** (o clipe, ou colar, ou arrastar para a caixa) aceita imagens PNG, JPEG e WebP de até 5 MB e arquivos de texto (`.md`, `.json`, `.csv`, `.log` e outros) de até 256 KB; no máximo 8 anexos e 16 MB por mensagem. Se o modelo não lê imagens, o app avisa antes de enviar e sugere um que lê.

**Plano** (no alto da conversa, ou **Visualizar → Modo plano**): o assistente lê e planeja, mas não escreve arquivos, não roda comandos e não cria subagentes. Quando o plano estiver bom, clique em **Aprovar plano e executar**. Vale para aquela conversa e não existe nas conversas pessoais.

## Conversas pessoais e de projeto

- **Conversas pessoais** ficam fora de qualquer projeto: sem pasta, sem modo plano. Arquivos que o assistente gerar nelas vão para `%LOCALAPPDATA%\HarnessAI-Workspaces\chats`.
- **Conversas de projeto** trabalham na pasta do projeto e aparecem embaixo dele em **Projetos**, e em **Neste workspace** quando ele está aberto.

**Buscar conversas** (**Ctrl+K**) procura nos títulos e nas mensagens. **Mostrar arquivadas** inclui as arquivadas.

## Menu da conversa

O **⋮** ao lado de cada conversa abre:

| Item | O que faz |
|---|---|
| **Renomear…** | Muda o título. |
| **Arquivar** / **Desarquivar** | Tira da lista (ou devolve); nada é apagado. |
| **Mover para projeto…** | Leva a conversa, com todo o histórico, para outro projeto ou para as **Conversas pessoais**. Os arquivos do projeto não são copiados. |
| **Continuar em nova conversa** | Copia o histórico inteiro para uma conversa nova (bifurca a conversa toda); a original fica como está. |
| **Exportar cópia segura** | Gera um JSON importável, sem o conteúdo das mensagens. |
| **Criar backup completo…** | Gera um JSON com tudo, inclusive argumentos de ferramentas e possíveis segredos. Pede o título exato; guarde o arquivo com cuidado. |
| **Excluir…** | Apaga a conversa permanentemente. |

Uma conversa de outro projeto mostra só **Abrir conversa**. **Arquivo → Importar conversa…** traz de volta uma cópia exportada (até 16 MiB, salva dentro do projeto).

Embaixo de cada mensagem sua há **Copiar mensagem**, **Reprocessar: enviar esta mensagem de novo**, **Bifurcar: nova conversa a partir daqui** e **Desfazer até aqui**.

## Tema

O botão de tema, no alto à direita, alterna entre usar o sistema, claro e escuro. A escolha fica em **Configurações → Geral → Tema** (**Usar o sistema**, **Claro**, **Escuro**).

## Ao fechar a janela

Fechar a janela não fecha os projetos: cada projeto aberto continua rodando, com as respostas e automações em andamento.

- Um projeto que você não olha há **30 minutos** e que não está trabalhando é suspenso.
- No máximo **três** projetos ficam ligados. Ao abrir um quarto, o que você viu há mais tempo é suspenso.
- Nenhum dos dois suspende um projeto que está respondendo, com subagente trabalhando, com terminal aberto ou com automação ativa.
- Um projeto suspenso volta sozinho quando você o abre de novo. As conversas pessoais não são suspensas.

Para fechar um projeto de vez: **Arquivo → Fechar projeto**, ou **⋮** do projeto → **Fechar projeto**. O app pede confirmação em **Pausar e fechar projeto**; workflows ativos são pausados e arquivos, conversas e pendências ficam guardados.

O **⋮** do projeto também tem **Remover da lista…** (só o atalho sai; pasta, conversas e memória ficam) e **Excluir dados do projeto…** (apaga conversas, memória, aprovações e consumo guardados pelo app, mas nenhum arquivo da sua pasta; pede o nome exato).
