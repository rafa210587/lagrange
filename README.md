# Lagrange

Assistente local de IA por projeto, para Windows. Cada projeto (uma pasta, com ou sem Git) tem as suas conversas, memória e configurações; o assistente lê e altera arquivos, roda comandos num shell confinado e opera aplicativos como navegador, Blender e Unity, sempre pedindo aprovação para o que tem efeito.

Este repositório guarda só o instalador e as versões publicadas. O código-fonte é privado.

## Instalar

**[Baixe o LagrangeSetup.exe](https://github.com/rafa210587/lagrange/releases/latest/download/LagrangeSetup.exe)** e abra.

Ou, no PowerShell:

```powershell
irm https://raw.githubusercontent.com/rafa210587/lagrange/main/install.ps1 | iex
```

A instalação é **só para a sua conta** e **não pede administrador**. Leva poucos minutos e baixa cerca de 200 MB. No fim, o Lagrange está no Menu Iniciar e o comando `lagrange` funciona em qualquer terminal novo.

Enquanto o instalador não é assinado, o Windows pode mostrar "O Windows protegeu o computador": clique em **Mais informações → Executar assim mesmo**. O comando do PowerShell não passa por esse aviso.

## Requisitos

- Windows 11, 64 bits (x64). O Windows 10 deve funcionar, mas ainda não foi validado.
- Internet durante a instalação e para conversar com o modelo.
- Uma chave de API de um provedor de modelo, configurada no app (o padrão é DeepSeek).
- Opcionais: **Git**, para projetos com worktree por conversa; **Blender** e **Unity**, para operar esses aplicativos.

## O que o instalador faz

1. Baixa, para `%LOCALAPPDATA%\HarnessAI\runtime`, versões fixas de **Node.js**, **uv** e, se não houver um no sistema, **PowerShell 7**. Cada arquivo é conferido pelo SHA-256 antes de ser usado. Nada é instalado no sistema como um todo.
2. Instala o **Python 3.12** pelo uv, também só para a sua conta.
3. Baixa a última versão do Lagrange desta página de Releases e confere o SHA-256 publicado.
4. Instala o **Microsoft Edge WebView2 Runtime** se ele faltar (já vem no Windows 11).
5. Cria o atalho no Menu Iniciar e o comando `lagrange`, e deixa a extensão do VS Code pronta em `%LOCALAPPDATA%\HarnessAI\bin\lagrange.vsix`.

A instalação só baixa arquivos; nenhum dado seu é enviado. Se algo falhar, o registro completo fica em `%TEMP%\lagrange-setup.log`.

## Atualizar

Rode o instalador de novo. A versão nova fica ao lado da anterior; projetos, conversas e configurações são mantidos. Se uma conversa estiver respondendo, a versão anterior só fecha quando ela terminar.

## Desinstalar

Ainda não há desinstalador. Para remover tudo:

1. Feche o Lagrange.
2. Apague a pasta `%LOCALAPPDATA%\HarnessAI` (isso apaga também conversas e configurações).
3. Apague o atalho **Lagrange** no Menu Iniciar.
4. Em **Configurações → Sistema → Sobre → Configurações avançadas do sistema → Variáveis de ambiente**, remova da variável **Path** do usuário as entradas que apontam para `%LOCALAPPDATA%\HarnessAI`.

## Onde já foi validado

| Ambiente | O que foi validado |
|---|---|
| Windows 11 Pro 25H2 (build 26200), x64, escala de tela 100% e 150% | Instalação completa pelo `LagrangeSetup.exe` simulando uma máquina sem Node.js, uv e PowerShell 7 (baixados pelo instalador, sem administrador); o app instalado abre, reabre depois de ser encerrado à força e recupera seleção, rascunho e histórico |
| Windows (GitHub Actions `windows-latest`) | Suíte de aceitação do app em versões anteriores ao pacote público |
| Linux (GitHub Actions `ubuntu-latest`) | Testes do núcleo e da política de segurança (o app em si é só para Windows) |

**Ainda não validado:** a instalação pelo comando do PowerShell (`install.ps1`), que baixa e roda o mesmo `LagrangeSetup.exe`; Windows 10; Windows em ARM (não suportado); uma instalação limpa do Windows, sem nada pré-instalado; uma conta sem permissão de administrador; redes com proxy.

Encontrou um problema? Abra uma [issue](https://github.com/rafa210587/lagrange/issues) com o arquivo `%TEMP%\lagrange-setup.log`.

## Licença

[PolyForm Noncommercial 1.0.0](LICENSE). Uso comercial exige licença separada: rafael210587@gmail.com.
