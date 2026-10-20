# Custo e limite de custo

Onde ver quanto as conversas gastaram e como impedir que passem de um valor.

O custo de cada resposta é o que o motor calcula com o preço que o catálogo informa para o modelo. Quando o preço não é informado, o custo aparece como desconhecido, nunca como zero. O consumo é registrado por projeto.

## Na conversa

- **Indicador de contexto**, o anel ao lado do seletor de modelo na caixa de mensagem. Passe o mouse ou foque nele para ver o contexto usado na última resposta (por exemplo, "Contexto usado: 40% (…)"), quanto falta até a compactação automática, a janela do modelo e, "Nesta conversa", os tokens novos, os reaproveitados do cache, os escritos e o custo. O número mede a última resposta. Não é uma previsão do custo da próxima. Depois de trocar de modelo, a porcentagem só volta quando o novo modelo responder.
- **Atividade**, no painel lateral, mostra cada passo da conversa com tokens, custo e tempo.

## Em Configurações → Uso

O painel **Custos** mostra o consumo deste projeto:

- **Agrupar por**: **Hora**, **Dia**, **Semana** ou **Mês**.
- **Exibir**: **Total** ou **Por modelo**.
- **Moeda**: **USD** ou **BRL**.
- **De (UTC)** e **Até, sem incluir o dia (UTC)**: o período, em datas UTC.
- **Modelos (vazio = todos)**: até 20 modelos, com **Buscar modelo**.

O painel tem um gráfico e uma tabela por moeda. Para cada uma mostra "Total conhecido" e quantos itens ficaram sem custo. Itens sem moeda informada ficam numa seção própria, **Moeda não informada**. O painel lê no máximo os 10.000 registros mais recentes e avisa quando o resultado foi limitado. Períodos sem consumo não aparecem.

Em **BRL**, só os custos em dólar são convertidos, pela cotação de venda PTAX do Banco Central. A cotação é buscada na internet e guardada por até 6 horas. Sem ela, o painel mostra "Cotação BRL indisponível" em vez de converter.

Em **Dados de consumo**, na mesma página:

- **Exportar registros (JSON)** grava `lagrange-consumo-<id>.json` na pasta do projeto. Depois, **Visualizar exportação** abre o arquivo.
- **Apagar registros** apaga o consumo registrado deste projeto, depois que você marca a confirmação. As conversas ficam.

## No terminal

Dentro da conversa, `/consumo` mostra o consumo desta conversa, o de hoje (desde a meia-noite local) e o do projeto, com tokens de entrada e saída e quantos itens ficaram sem custo informado. Veja [Terminal e VS Code](terminal-e-vscode.md).

## Limite de custo

Fica em **Configurações → Permissões → Limite de custo** e começa vazio, ou seja, sem limite.

1. Em **Limite do projeto**, digite o valor, na moeda do provedor.
2. Clique em **Salvar limite** para valer no projeto inteiro, ou em **Aplicar só à conversa aberta** para valer só na conversa atual.

Antes de cada chamada ao modelo, o Lagrange soma o custo registrado. Quando a soma chega ao limite, a chamada é barrada antes de acontecer, com a mensagem "Orçamento atingido; ajuste o limite na administração". A resposta que cruza o limite já foi paga. O bloqueio vale até você aumentar ou remover o limite: apague o valor e salve de novo.

Com um limite ligado, um único custo desconhecido também barra as chamadas ("Orçamento não verificável: há custo desconhecido"), porque não dá para saber quanto já foi gasto. Se o seu modelo não informa preço, não use limite com ele.

As automações têm um limite próprio por execução, definido ao criá-las: veja [Automações](automacoes.md).
