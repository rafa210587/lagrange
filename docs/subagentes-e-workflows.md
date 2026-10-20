# Subagentes e workflows

Como o assistente divide o trabalho com subagentes, como acompanhar cada um, e como usar workflows para trabalhos longos.

## Quando o assistente delega

O assistente cria subagentes por conta própria, quando a tarefa se divide em partes independentes, ou quando você pede ("use um subagente para revisar os testes"). Cada subagente é de um tipo:

| Tipo | O que pode fazer | Onde trabalha |
|---|---|---|
| **Analisa** | Só lê: escrita e shell ficam bloqueados | Na pasta do projeto |
| **Edita** | Altera arquivos e roda comandos no shell confinado | Numa worktree própria, criada a partir do último commit |

- No máximo cinco subagentes trabalham ao mesmo tempo por projeto. Passando disso, o pedido é recusado.
- Um subagente que edita precisa de um projeto Git com pelo menos um commit. Alterações não commitadas do projeto não entram na worktree dele.
- O subagente que edita não grava no seu projeto: tudo o que ele muda fica na worktree dele, e nada de lá entra no projeto sozinho. A conversa principal recebe o resultado e a lista de arquivos alterados.

## Acompanhar

- Na conversa, cada subagente vira uma linha **Subagente · <título>** com o estado e o tempo. Os estados são Começando, Trabalhando, Concluído, Falhou, Parado e Interrompido. A linha tem os botões **Ver trabalho** e **Parar**.
- **Ver trabalho** abre a aba **Subagentes** do painel lateral, com as listas **Em andamento** e **Concluídos**. Ao escolher um subagente, você entra na conversa dele: a **Tarefa** que recebeu, o **Raciocínio**, as ferramentas usadas e a resposta. Também aparecem o modelo e os tokens.
- Um subagente de uma sessão anterior do projeto carrega a conversa sob demanda (**Carregar conversa do subagente**). Isso leva alguns segundos.
- **Limpar concluídos** tira os terminados da lista sem apagar nada.

## Aprovações e perguntas dos subagentes

As aprovações e perguntas de um subagente aparecem na conversa principal, junto às dela, com o título **Subagente «<título>»:**. Você responde ali, e a resposta segue para o subagente.

## Parar e conversar com um subagente

- **Parar** (na linha da conversa ou no painel) cancela um subagente em andamento. Os arquivos que ele já alterou na worktree são mantidos.
- No painel, você pode escrever para um subagente direto da conversa dele:
  - **Adicionar à fila**: enquanto ele trabalha, a mensagem vai depois do trabalho atual. **Enviar agora** a entrega no próximo passo dele, sem interromper. **Cancelar envio** retira uma mensagem da fila.
  - **Enviar mensagem ao subagente**: depois que ele terminou ou falhou, a mensagem começa um novo trabalho. Você pode trocar o modelo e o esforço em **Modelo das próximas mensagens**.
  - A resposta dele não retoma a conversa principal.

## Especialistas

Um especialista é um subagente com instruções, modelo e esforço próprios, definido por projeto. Fica em **Configurações → Especialistas**.

1. Clique em **Novo especialista** e preencha:
   - **Nome**: letras minúsculas, números e hífen.
   - **Quando usar**: o assistente lê isto para decidir quando delegar.
   - **Modelo**: deixe **Herdar da conversa** ou escolha um.
   - **Esforço**.
   - **Instruções**: até 16.000 caracteres.
   - Marque **Somente leitura: nunca recebe tarefas de edição** se ele só deve analisar.
2. Clique em **Salvar especialista**. O arquivo é gravado em `.opencode/agents/<nome>.md`, no projeto.
3. Clique em **Aplicar agora** para que as conversas passem a usá-lo. O motor do projeto reinicia quando estiver ocioso.

Para usar, escreva `@agente:<nome>` no chat, ou deixe o assistente escolher pelo campo **Quando usar**. O modelo e o esforço do especialista só valem quando o assistente não escolhe outros.

As instruções não dão acesso a nada: arquivos, shell e aplicativos seguem as permissões de sempre.

- Especialistas em `.claude/agents` também aparecem, mas só podem ser duplicados.
- Workflows só enxergam um especialista depois que o arquivo dele é commitado.

## Com Assinaturas

Com **Assinaturas** ligado no topo da conversa, os subagentes rodam no seu Claude Code ou Codex, na sua assinatura. A conversa só coordena.

Um subagente que edita trabalha numa **Linha de trabalho**: uma worktree que só você integra ou descarta. O cartão da linha, no painel do subagente, mostra o estado (Pronta, Um worker está editando, Retida, Integrada ao projeto, Descartada) e os botões:

- **Revisar**: mostra o diff.
- **Integrar**: exige a revisão e um projeto sem alterações não commitadas.
- **Liberar**: devolve ao trabalho uma linha retida.
- **Descartar**: fecha a linha. A worktree continua no disco.

Uma linha fica retida quando o worker parou no meio, quando o efeito de um comando ficou incerto ou quando ele alterou arquivos que instruem agentes ou configuram o Git. Nesses casos, confira antes de liberar.

## Workflows

Um workflow divide um trabalho longo em etapas e tarefas, cada uma feita por um agente próprio, várias ao mesmo tempo. Nada roda antes de você aprovar o plano.

### Ligar

Em **Configurações → Geral**, marque **Workflows (experimental)**. Aparece o botão do modo Workflows no topo da janela, ao lado dos modos Conversa e Código. Na mesma seção:

- **Condução padrão** define onde o workflow para e espera você. As opções são **Aprovar marcos: depois de refinar e antes de executar**, **Aprovar cada etapa** e **Autônomo: sem paradas entre etapas**. Cada workflow pode mudar isso depois. Perguntas dos agentes e aprovações de ferramentas valem em todos os modos.
- **Manter o computador acordado durante workflows**: não mantém a tela ligada. O pedido é liberado com a bateria abaixo de 20% ou depois de 2 horas com tudo esperando você.

### Começar

Há dois caminhos:

- **Pela conversa:** peça um trabalho grande. O assistente pode propor um workflow, que aparece como um cartão **Workflow proposto**, com o número de tarefas e de etapas. Clique em **Revisar e aprovar**.
- **No modo Workflows:** clique em **Novo workflow** e preencha:
  - **Objetivo**.
  - **Começar**: **Do zero, neste projeto**, **A partir de uma conversa** ou **Em outro projeto**.
  - **O que já está pronto (opcional)** e **Critérios de aceite (opcional)**.
  - **Etapas**: refinar, planejar, decompor, construir, verificar e, com Git, **Commitar ao fim de cada tarefa** e **Abrir um pull request no fim**.
  - **Tarefas ao mesmo tempo**: de 1 a 16, padrão 4.

  Depois clique em **Propor workflow**. Um modelo escreve a proposta. **Ver o raciocínio** abre a conversa dele, e é lá que você responde se ele fizer uma pergunta.

### Revisar o plano e iniciar

A proposta aparece como um quadro de etapas e tarefas. Nele você pode:

- marcar uma etapa como "opcional", para pulá-la;
- marcar "parar antes", para o workflow esperar você naquele ponto;
- se o plano pede modelos que você não habilitou, usar **Usar o automático nelas**.

**Iniciar** aprova o plano e começa. Ele autoriza as edições de arquivos e os comandos no shell confinado, na área de cada tarefa. Efeitos externos, como aplicativos e imagens, continuam pedindo as suas permissões.

### Acompanhar

- No quadro, **Ver tarefa** mostra uma tarefa e **Ver agente** abre a conversa do agente dela.
- As aprovações e perguntas dos agentes aparecem na fila do workflow (**Aprovar uma vez** / **Rejeitar**). Elas nunca são aprovadas automaticamente nem respondidas por outro agente.
- Os controles do workflow:
  - **Pausar** espera as tarefas em curso.
  - **Forçar pausa** interrompe os agentes na hora. Os arquivos ficam, mas operações já iniciadas podem exigir conferência.
  - **Retomar** (ou **Continuar para <etapa>**) segue depois de uma parada.
  - **Excluir workflow** tira o workflow da lista e preserva os arquivos produzidos.
  - **Refazer workflow** e **Refazer etapa** preparam de novo o que foi cancelado ou precisa de correção.
- No fim aparece o **Relatório final**.

### Onde fica o resultado

| Projeto | Como as tarefas trabalham | Como o resultado chega ao projeto |
|---|---|---|
| Com Git | Em cópias isoladas. O resultado fica numa branch | **Revisar e integrar ao projeto**: a integração é recusada se o projeto tiver mudado ou tiver alterações não commitadas |
| Sem Git | Direto na pasta, uma tarefa por vez, com uma cópia antes de cada uma | Já está na pasta. **Desfazer mudanças**, numa tarefa, volta os arquivos que ela alterou, mas os que ela criou ficam |

Se o workflow rodar numa pasta separada, o app avisa "Resultado na pasta separada". Revise os arquivos antes de copiá-los ao projeto.

Num site estático, o workflow pode verificar as páginas num navegador isolado e servi-las localmente. Depois aparecem **Copiar URL do site** e **Subir site novamente**.

### Limites

- As tarefas começam sem rede. Se o plano tem tarefas que pedem rede, o quadro mostra **Recursos e origem das personas** antes de iniciar, e **Revisar e iniciar sem rede** roda só as tarefas que não dependem dela. Acesso à rede exige uma confirmação própria; aprovar o plano não o autoriza.
- A condução só define as paradas entre etapas e não concede permissões.
