# Automações agendadas

Como criar uma tarefa que o assistente roda sozinho de tempos em tempos, o que ela pode fazer e onde ver o resultado.

## Criar

1. Abra o projeto e, no painel à direita, a aba **Automações**.
2. Em **Nova automação**, preencha:
   - **Nome**: até 60 caracteres, letras, números, espaço, `_`, `.` e `-`; único no projeto.
   - **O que ela deve fazer**: o pedido, até 8.000 caracteres.
   - **Com que frequência**: **A cada 15 minutos**, **A cada hora**, **A cada 4 horas** ou **Uma vez por dia**. O intervalo conta a partir da criação: a primeira execução acontece um intervalo depois, não na hora.
   - **Modelo**: um dos modelos conectados, ou **O modelo atual da conversa**.
   - **Custo máximo por execução (opcional)**: na moeda do provedor. Fica obrigatório quando o modelo tem preço conhecido; sem ele, a criação é recusada com "Informe um orçamento por execução".
3. Clique em **Criar automação**.

Cada execução dura no máximo 20 minutos; esse limite não é ajustável pela janela. Cada projeto aceita até 20 automações. Para mudar uma automação, exclua e crie de novo: não há edição.

## O que uma automação pode fazer

Ninguém aprova nada durante uma execução, então ela tem um conjunto fixo e menor de permissões, que o modo de aprovação do projeto não altera:

- **Pode**: ler e buscar arquivos do projeto, usar skills, consultar a memória do projeto e escrever arquivos **somente** na própria pasta de saída da execução.
- **Não pode**: alterar arquivos do projeto, usar o shell, acessar a web, usar o navegador, aplicativos (Blender, Unity), controle visual, servidores MCP, pull requests ou subagentes.

Uma ferramenta negada aparece no resultado como **Negado: …**. As pastas de saída ficam em `%LOCALAPPDATA%\HarnessAI\automations\Automations\`, uma por automação (o nome sem acentos, em minúsculas) com uma subpasta por execução; o caminho exato aparece no cartão da execução.

Cada execução é uma conversa com o título **Automação: <nome>**. Se você escrever nela, ela vira uma conversa comum, com as aprovações normais.

## Quando ela roda (e quando não)

- Só enquanto o projeto está aberto no Lagrange. Com o app fechado ou o computador desligado ou em suspensão, nada roda.
- Um projeto com automação ativa não é suspenso: nem depois de 30 minutos parado, nem para abrir um quarto projeto (veja os limites de memória no [README](../README.md#requisitos-no-windows)).
- Uma execução perdida é feita uma vez quando o projeto volta a abrir, se o atraso for de até 6 horas; com mais atraso, ela é registrada como **pulada**. Execuções perdidas não se acumulam.
- Roda uma automação por vez em cada projeto e no máximo duas ao mesmo tempo somando todos os projetos. Uma execução que chega com outra em andamento é registrada como **pulada**, sem fila.

## Resultados

A seção **Resultados** da aba **Automações** lista as execuções mais recentes; um ponto na aba indica que há resultado não lido. Cada cartão mostra o estado, quando começou, quanto tempo levou, o custo e o resumo que o assistente escreveu:

| Estado | Significado |
|---|---|
| **concluída** | Terminou com algo a relatar. |
| **nada a relatar** | Terminou sem novidade; já chega marcada como lida. |
| **bloqueada** | Uma ação foi negada pelas permissões da automação, ou a execução nem começou. |
| **falhou** | Erro do modelo ou resposta fora do formato esperado. |
| **interrompida** | Passou dos 20 minutos. |
| **interrompida — teto de custo atingido** | Parou antes da chamada seguinte ao modelo porque o custo máximo foi atingido. |
| **interrompida — resultado desconhecido** | O app foi reiniciado ou não conseguiu confirmar o fim da conversa. |
| **pulada** | Não rodou (atraso grande, outra em andamento). |

No caso de resultado desconhecido, a automação não roda de novo sozinha até você resolver: o cartão confere o fim da conversa (**Verificar término da sessão**) e, se ela terminou, oferece **Confirmar que não há efeitos pendentes**. Confirme só depois de ver na pasta de saída e na conversa que nada ficou pela metade.

Use **Marcar como lida** para limpar o aviso. O custo de cada execução também entra no consumo do projeto (veja [Custo](custo.md)).

## Pausar, executar agora, excluir

Na lista **Automações**, cada linha mostra a frequência, o modelo e o estado (**ativa**, **pausada** ou **pausada após 3 falhas**), com os botões:

- **Pausar** / **Retomar**. Ao retomar, a próxima execução acontece um intervalo depois.
- **Executar agora**: roda fora do horário (só com a automação ativa).
- **Excluir**: pede confirmação; as execuções anteriores continuam em **Resultados**.

**Pausar todas** pausa todas as automações do projeto.

Três execuções seguidas que terminam como **falhou**, **interrompida** ou **bloqueada** pausam a automação. Corrija a causa e clique em **Retomar**, que zera a contagem.
