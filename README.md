# atalhos-vscode

Ferramenta para exibir e consultar rapidamente os principais atalhos do VS Code em português (Windows), com interface gráfica em PowerShell.

## Arquivos

- [`criar_atalho.ps1`](criar_atalho.ps1): Script para criar um atalho na área de trabalho que executa o painel de atalhos.
- [`atalhos_vscode.ps1`](atalhos_vscode.ps1): Script principal que exibe a janela com os atalhos do VS Code.
- [`1-00c87720.ico`](1-00c87720.ico): Ícone utilizado no atalho da área de trabalho.

## Como usar

1. **Clone o repositório:**
   ```sh
   git clone https://github.com/ecodelearn/atalhos-vscode.git
   cd atalhos-vscode
   ```

2. **Crie o atalho na área de trabalho:**
   - Clique com o botão direito em [`criar_atalho.ps1`](criar_atalho.ps1) e selecione "Executar com PowerShell".
   - Isso criará um atalho chamado **Atalhos VSCode** na sua área de trabalho.

3. **Abra o painel de atalhos:**
   - Clique duas vezes no atalho criado na área de trabalho.
   - Uma janela será aberta exibindo os principais atalhos do VS Code para Windows, em português.

## Requisitos

- Windows 10 ou superior
- PowerShell 5.1 ou superior
- Permissão para executar scripts PowerShell

## Observações

- O script principal não altera configurações do sistema, apenas exibe uma janela informativa.
- Para atualizar os atalhos, edite o arquivo [`atalhos_vscode.ps1`](atalhos_vscode.ps1).

---
Desenvolvido por Daniel Dias | ecodelearn@outlook.com