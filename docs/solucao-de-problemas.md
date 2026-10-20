# Solução de problemas

O que fazer quando algo não funciona no Windows: onde estão os logs, motor que reinicia, atualização adiada, processos que ficam abertos, chave inválida, proxy e `lagrange doctor`.

O aviso "O Windows protegeu o computador" na instalação está explicado no [README](../README.md#windows).

## Onde ficam os logs

| Arquivo | O que tem |
|---|---|
| `%TEMP%\lagrange-setup.log` | O registro completo do instalador |
| `%LOCALAPPDATA%\HarnessAI\logs\bootstrap-<id>.log` | Um por abertura do app: as etapas do início |
| `%LOCALAPPDATA%\HarnessAI\logs\<id>.stdout.log` e `<id>.stderr.log` | A saída de cada projeto iniciado, com as etapas da abertura |
| `%LOCALAPPDATA%\HarnessAI\logs\runtime-exits.log` | Cada vez que o motor de um projeto encerrou sozinho: data, pasta do projeto, código de saída e o fim da saída de erro, com segredos ocultados. Ao passar de 1 MB, o anterior vira `runtime-exits.log.previous` |

Os `bootstrap-*.log`, `*.stdout.log` e `*.stderr.log` sem alteração há 14 dias são apagados quando um projeto inicia; o `runtime-exits.log` fica. Ao abrir uma [issue](https://github.com/rafa210587/lagrange/issues), anexe o log que corresponde ao problema.

## O motor reinicia sozinho

Se o motor do assistente de um projeto encerra sozinho, o app o reinicia, esperando 1, 5 e depois 15 segundos; enquanto isso aparece "O runtime encerrou sozinho (código …); reiniciando…". As conversas voltam com ele.

Se ele encerrar mais de 3 vezes em 10 minutos, o app desiste e diz que o motor "encerrou sozinho várias vezes em poucos minutos". Então:

1. Abra o projeto de novo pelo Lagrange para reiniciá-lo.
2. Se voltar a acontecer, abra uma issue com o `runtime-exits.log`, que guarda o motivo de cada encerramento.

## Atualização adiada

Rodar o instalador com o Lagrange aberto funciona, mas a versão nova pode demorar a entrar:

- Antes de ativar a versão nova, o instalador pede a cada projeto aberto que feche. Um projeto ocioso fecha sozinho; um com resposta em andamento ou subagente trabalhando é esperado por até 20 minutos.
- Se uma conversa ainda estiver respondendo, a versão anterior só fecha quando ela terminar, também por até 20 minutos. Passado esse tempo, a versão nova fica instalada e entra quando o Lagrange for reaberto. A janela que estava aberta reabre sozinha na versão nova.

Se ainda houver algo aberto, o instalador mostra "O Lagrange está em uso; a versão nova não foi ativada." e diz o que bloqueia. A versão nova fica copiada mas inativa, e a anterior continua funcionando. Para concluir:

1. Feche a janela do Lagrange.
2. Feche cada projeto, inclusive os ociosos: no menu **⋮** do projeto, na barra lateral, ou em **Arquivo → Fechar projeto** (a mensagem do instalador chama isso de "Encerrar workspace").
3. Feche os terminais em que o comando `lagrange` está aberto.
4. Clique em **Tentar de novo** no instalador. Se a mensagem disser que há um comando nos detalhes, rode exatamente o comando que ela mostra.
5. Se continuar bloqueado, reinicie o Windows e rode o instalador de novo.

Projetos, conversas, chaves e configurações são mantidos em todos os casos.

## Processos que ficam abertos

Fechar a janela não encerra os projetos: cada projeto aberto continua com o seu motor em segundo plano (cerca de 1 GB de memória cada), e sair do `lagrange` no terminal também não fecha o projeto. Além disso, alguns segundos depois de você abrir o app, os dois projetos usados por último são iniciados em segundo plano.

Um projeto fecha sozinho quando ninguém olha para ele há 30 minutos, ou quando há mais de três abertos (fecha o visto há mais tempo). Isso não acontece enquanto ele está respondendo, tem um subagente trabalhando, um terminal aberto no painel **Terminal**, uma automação ativa ou um site publicado por um workflow. Ao voltar para ele, ele inicia de novo.

Para encerrar um projeto agora:

1. Abra o projeto no app.
2. Use **Fechar projeto** no menu **⋮** do projeto, na barra lateral, ou em **Arquivo → Fechar projeto**.
3. Confirme em **Pausar e fechar projeto**: workflows ativos são pausados antes; arquivos, conversas e pendências ficam guardados.

Se a janela travou ou foi fechada à força e o projeto continuou rodando, abra esse projeto de novo pelo app: ele reencontra o que está rodando, e aí você usa **Fechar projeto**. Se nem assim ele fechar, reinicie o Windows.

## Chave inválida

O app não confere a chave ao salvar. Uma chave errada aparece quando o modelo é usado: a resposta da conversa termina com o erro que o provedor devolveu.

Para testar:

1. Vá em **Configurações → Modelos** e escolha o provedor em **Conectados**.
2. Clique em **Testar modelos habilitados** e confirme em **Enviar teste**. É enviada uma requisição curta por modelo habilitado (até 20), cobrada pelo provedor.
3. Cada modelo aparece com "responde" ou com o erro do provedor; se algum falhar, o app diz quantos "não responderam".

Para trocar a chave:

1. Em **Configurações → Modelos**, escolha o provedor.
2. Cole a chave nova em **Credencial** (vazio mantém a chave salva; **Remover credencial salva** apaga a atual).
3. Clique em **Salvar provider** e teste de novo.

Se o app disser que o provedor não aparece como conectado, reabra o projeto e confira a chave.

## Proxy

O Lagrange não tem configuração de proxy. O motor do assistente não recebe as variáveis `HTTPS_PROXY` e `HTTP_PROXY` do seu ambiente, então, numa rede em que a internet só sai por um proxy, as conversas podem não chegar ao provedor do modelo. O instalador também não tem opção de proxy. Redes com proxy ainda não foram testadas.

## lagrange doctor

`lagrange doctor`, na pasta do projeto (ou com `--project <pasta>` ou `--home`), confere a instalação. Se o projeto estiver fechado, ele o inicia. Cada linha começa com ✓ ou ✗, e o comando sai com código 1 se alguma falhar.

| Linha | Se der ✗ |
|---|---|
| `Node …` | Precisa do Node 22 ou mais recente; rode o instalador de novo |
| `Inicializador: …` | O app não está instalado nesta conta; instale ou rode o instalador de novo |
| `Gateway do projeto em … ms` | O projeto não abriu; a mensagem diz por quê (por exemplo, pasta não encontrada) |
| `Modelo: …` | Nenhum modelo escolhido; escolha no app ou com `lagrange model` |
| `Modelos disponíveis: …` | Nenhum provedor conectado; configure a chave em **Configurações → Modelos** |
| Shell confinado | Motor em uso, rede e ferramentas; se estiver indisponível, mostra o motivo e os comandos rodam no terminal do Windows, com aprovação ([Permissões e aprovações](permissoes.md)) |

A última linha mostra o projeto e o modo de acesso. Os outros comandos do terminal estão em [Terminal e VS Code](terminal-e-vscode.md).
