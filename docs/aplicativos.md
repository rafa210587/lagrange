# Aplicativos

Como o assistente usa o navegador, o Blender, o Unity, o Aseprite, janelas de outros programas e o GitHub. Tudo aqui é do Windows; no macOS não há controle visual de janelas.

As opções ficam em **Configurações → Capacidades**, nas seções **Aplicativos** e **Web**. Você não precisa abrir nada antes: peça no chat ("abra a cena no Blender", "teste o login do site") e o assistente pede o que falta.

## Blender e Unity

1. Instale o programa no lugar padrão. A seção **Aplicativos** mostra cada um como **encontrado** (com a versão) ou **não encontrado neste computador**. O Lagrange procura em `C:\Program Files\Blender Foundation`, `%LOCALAPPDATA%\Programs\Blender Foundation` e `C:\Program Files\Unity\Hub\Editor` (editores do Unity Hub), e usa a versão mais nova. Em outra pasta, crie a variável de ambiente de usuário `BLENDER_PATH` ou `UNITY_PATH` com o caminho do `blender.exe` ou do `Unity.exe` e reabra o Lagrange.
2. Peça no chat. Aparece o cartão **Abrir aplicativo**; ao aprovar, o Lagrange espera todas as conversas do projeto pararem de responder (até 10 minutos), abre o programa e mostra "Abrindo o Blender… a conversa continua sozinha em instantes.". A conversa retoma sozinha, já com as ferramentas do aplicativo.
3. Se você fechar o programa, peça de novo: o cartão volta e ele é reaberto.

O que é aberto, sempre dentro da pasta do projeto:

| | Padrão | Observações |
|---|---|---|
| Blender | cena `Art/HarnessScene.blend` | Se o arquivo não existe, abre uma cena vazia e salva nesse caminho. Scripts embutidos no `.blend` não rodam sozinhos. |
| Unity | projeto `Unity` | Sem cena escolhida: a primeira cena ativa do Build Settings, senão a cena alterada por último, senão `Assets/Scenes/Main.unity`. A cena precisa ficar sob `Assets/`, com nome sem acentos. Uma pasta que não existe vira um projeto novo. |

O assistente também pode escolher outra cena ou projeto na conversa. Para fixar um, abra **Avançado: cena ou projeto fixo** em **Aplicativos**, preencha **Cena Blender relativa ao projeto** ou **Projeto Unity relativo ao projeto** e **Cena dentro do projeto Unity**, e clique em **Salvar aplicativos** (**Salvar** na versão publicada). Deixar o campo vazio devolve a escolha à conversa.

Unity com um projeto existente:

- O projeto só abre com a versão do editor gravada em `ProjectSettings/ProjectVersion.txt`. Se ela não estiver instalada, instale-a pelo Unity Hub. Abrir com outra versão converte o projeto.
- Se o projeto já depende de outra versão do pacote `com.coplaydev.unity-mcp`, a preparação é recusada antes de abrir: troque ou remova o pacote no Package Manager.

A primeira preparação baixa a integração de cada programa, numa versão fixa; precisa de internet. No Unity, o pacote vem do GitHub pelo Package Manager, que usa o Git.

Compilar scripts e rodar testes do Unity executam o código C# do projeto como o seu usuário, fora do sandbox. Por isso pedem aprovação mesmo no **Aprovar por mim**.

## Aseprite

Requer o Aseprite 1.3 ou mais novo, na sua cópia licenciada.

1. Em **Aplicativos → Avançado: cena ou projeto fixo**, marque **Usar o Aseprite (o seu executável, em modo batch, sem as suas extensões)**.
2. Em **Aseprite.exe**, informe o caminho, ou deixe vazio para procurar nas pastas de instalação e da Steam. O executável não pode ficar dentro do projeto.
3. Clique em **Salvar aplicativos**.

Ao salvar, o Lagrange registra qual executável foi aprovado. Depois de atualizar ou trocar o Aseprite, salve de novo, senão ele não é usado. O Aseprite roda sem janela: o assistente cria e inspeciona sprites por arquivo, sem controle visual.

## Navegador isolado

Um Chromium separado, num contêiner, sem acesso aos seus arquivos nem aos seus logins. Serve para automação e testes de sites. Ele só alcança endereços públicos da internet: `localhost` e a rede local ficam bloqueados. Para ler páginas públicas, o assistente não precisa dele.

Pré-requisitos:

1. Instale o Podman para Windows. Ele roda numa máquina do WSL, sem root por padrão (`podman machine init`, depois `podman machine start`). O comando `podman` precisa estar no PATH.
2. Reabra o Lagrange. Em **Web**, abaixo de **Navegador isolado**, deve aparecer **Podman encontrado.**
3. Deixe a máquina do Podman ligada sempre que for usar o navegador. Na primeira vez, o Podman baixa a imagem do navegador, e isso pode demorar.

Em **Navegador isolado**, escolha e clique em **Salvar navegador** (**Salvar** na versão publicada):

| Opção | O que faz |
|---|---|
| **Desligado** | Padrão. |
| **Ligado, sem login** | Começa limpo a cada uso. |
| **Ligado, com login próprio deste projeto** | Guarda um perfil só deste projeto, fora da pasta dele, com os cookies entre usos. |

Para entrar num site com o perfil do projeto, clique em **Entrar em um site**. Uma janela do navegador abre na sua área de trabalho, pelo WSLg, que já vem no Windows 11. Enquanto ela está aberta, o assistente fica parado. Faça o login e clique em **Concluir login**.

Ler a página e capturar a tela não pedem aprovação. Navegar, clicar, digitar, trocar de aba e enviar arquivo pedem.

Se o app ou o navegador caiu e o perfil ficou travado:

1. Escolha **Desligado** e clique em **Salvar navegador**.
2. Clique em **Recuperar perfil após falha**.

A recuperação é recusada enquanto ainda houver um processo ou contêiner usando o perfil. Ela remove só as travas; os cookies ficam.

## Seu navegador (Chrome ou Edge)

Para páginas em que você já está logado, escolha o navegador em **Web → Seu navegador** (**Chrome**, **Edge** ou **Não usar**). O assistente vê e usa as janelas abertas desse navegador, cada uma como uma superfície separada. Ele não lê nem copia o seu perfil ou as suas senhas. Abra o navegador antes do projeto: uma janela aberta depois só aparece quando o projeto é reaberto.

## Janelas de outros programas

Para um programa sem integração própria (Bloco de Notas, Excel, um app de desenho), o assistente pede que você libere a janela. O cartão **Liberar janela de outro programa** lista as janelas abertas. Você escolhe uma, escolhe **Só observar** ou **Observar e operar (clicar e digitar)**, escolhe o prazo (5, 15, 30 ou 60 minutos) e clica em **Liberar janela**.

- O cartão aparece em todos os modos de aprovação, e não existe "sempre". Ele só pode ser aceito na janela do Lagrange; no terminal e no VS Code dá apenas para rejeitar.
- Terminais, IDEs, ferramentas do sistema, gerenciadores de senha e outros navegadores aparecem como sensíveis. Para liberar um deles, você marca **Entendo o risco**, e o prazo máximo é de 15 minutos.
- Nunca podem ser liberados: o próprio Lagrange, o VS Code e editores derivados (que respondem aprovações do Lagrange), as telas de senha e de administrador do Windows, programas rodando como administrador, e o Chrome e o Edge, que usam **Seu navegador**.
- Acima da conversa, uma barra mostra cada janela liberada e até quando, com o botão **Revogar**.

## Controle visual

No Blender e no Unity abertos pelo Lagrange, nas janelas do seu navegador e nas janelas liberadas, o assistente captura a tela e, quando pode operar, clica e digita. O clique e o teclado ficam limitados àquela janela. Capturas, cliques e teclas são ações com efeito e seguem o modo de aprovação, como descrito em [Permissões](permissoes.md).

O modelo da conversa precisa aceitar imagem. Sem isso, as capturas ficam indisponíveis e o assistente só lê os controles acessíveis da janela. O botão **Capacidades**, no topo da janela, mostra em **Entrada de imagem do modelo selecionado** se o modelo aceita imagem.

## GitHub (pull requests)

Num projeto aberto exatamente na raiz de um repositório Git, o assistente pode criar uma branch `codex/<nome>`, fazer commit dos arquivos que ele indica, dar push (nunca forçado), abrir o pull request, acompanhar os checks, ler os logs das falhas, reexecutar jobs com falha e fazer o merge. O merge só acontece se o commit for o mesmo que foi revisado e todos os checks estiverem verdes.

1. Instale o Git e o GitHub CLI.
2. Uma vez, no terminal: `gh auth login`.

Ele usa o seu login do `gh`; nenhum token passa pelo Lagrange. Cada passo que escreve segue o modo de aprovação. Os pull requests citados na conversa aparecem como cartões acima da caixa de mensagem, com o estado (**CI rodando**, **CI falhou**, **Pronto para mesclar**…) e atalhos como **Corrigir CI**, **Resolver conflito** e **Mesclar**, que pedem a ação ao assistente.

Outros programas com servidor MCP se conectam por projeto: veja [MCP](mcp.md).
