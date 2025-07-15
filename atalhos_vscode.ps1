# Define codificação UTF-8 corretamente
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Verifica se já existe uma instância rodando
$existingProcess = Get-Process -Name "powershell" -ErrorAction SilentlyContinue | 
    Where-Object { $_.MainWindowTitle -eq "Atalhos VS Code" }

if ($existingProcess) {
    Add-Type -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;
        public class Win32 {
            [DllImport("user32.dll")]
            public static extern bool SetForegroundWindow(IntPtr hWnd);
            [DllImport("user32.dll")]
            public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        }
"@
    [Win32]::ShowWindow($existingProcess.MainWindowHandle, 9)
    [Win32]::SetForegroundWindow($existingProcess.MainWindowHandle)
    exit
}

# Carrega as bibliotecas necessárias
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Cria o formulário principal
$form = New-Object System.Windows.Forms.Form
$form.Text = "Atalhos VS Code - Redimensionável"
$form.Size = New-Object System.Drawing.Size(600, 800)
$form.MinimumSize = New-Object System.Drawing.Size(350, 400)
$form.MaximumSize = New-Object System.Drawing.Size(1200, 2000)
$form.StartPosition = "Manual"
$form.Location = New-Object System.Drawing.Point(10, 10)
$form.TopMost = $true
$form.FormBorderStyle = "Sizable"
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.ShowInTaskbar = $false

# Adiciona funcionalidades de teclado
$form.Add_KeyDown({
    param($meuSender, $e)
    switch ($e.KeyCode) {
        "Escape" { 
            $form.WindowState = "Minimized" 
        }
        "F11" { 
            if ($form.WindowState -eq "Maximized") {
                $form.WindowState = "Normal"
            } else {
                $form.WindowState = "Maximized"
            }
        }
        "F1" {
            $form.Size = New-Object System.Drawing.Size(650, 700)
            $form.WindowState = "Normal"
        }
    }
})

# Cria um painel para organizar melhor os controles
$mainPanel = New-Object System.Windows.Forms.Panel
$mainPanel.Dock = "Fill"
$mainPanel.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)

# Cria a barra de título personalizada
$titlePanel = New-Object System.Windows.Forms.Panel
$titlePanel.Height = 30
$titlePanel.Dock = "Top"
$titlePanel.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Atalhos VS Code | Desenvolvido por Daniel Dias | ecodelearn@outlook.com"
$titleLabel.ForeColor = [System.Drawing.Color]::LightGray
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$titleLabel.AutoSize = $false
$titleLabel.Dock = "Fill"
$titleLabel.TextAlign = "MiddleCenter"

$titlePanel.Controls.Add($titleLabel)

# Cria a caixa de texto
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline = $true
$textBox.ScrollBars = "Vertical"
$textBox.Dock = "Fill"
$textBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$textBox.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
$textBox.ForeColor = [System.Drawing.Color]::White
$textBox.ReadOnly = $true
$textBox.BorderStyle = "None"
$textBox.Margin = New-Object System.Windows.Forms.Padding(5)

# Lista de atalhos sem caracteres especiais problemáticos
$atalhosList = @(
    "=== ATALHOS VS CODE - WINDOWS PT-BR ===",
    "",
    "COMENTARIOS:",
    "Ctrl + ;              - Comentar/descomentar linha",
    "Shift + Alt + A       - Comentar/descomentar bloco",
    "",
    "SELECAO E EDICAO DE VARIAVEIS:",
    "Ctrl + D              - Selecionar proxima ocorrencia",
    "Ctrl + K, Ctrl + D    - Pular selecao e ir para proxima",
    "Ctrl + Shift + L      - Selecionar todas as ocorrencias",
    "Ctrl + F2             - Selecionar todas as ocorrencias",
    "F2                    - Renomear simbolo",
    "",
    "MULTI-CURSOR:",
    "Alt + Click           - Adicionar cursor",
    "Ctrl + Alt + UP       - Cursor linha acima",
    "Ctrl + Alt + DOWN     - Cursor linha abaixo",
    "Ctrl + U              - Desfazer ultima selecao",
    "",
    "MOVIMENTACAO DE CODIGO:",
    "Alt + UP              - Mover linha para cima",
    "Alt + DOWN            - Mover linha para baixo",
    "Shift + Alt + UP      - Duplicar linha acima",
    "Shift + Alt + DOWN    - Duplicar linha abaixo",
    "Ctrl + Shift + K      - Deletar linha",
    "Ctrl + X              - Recortar linha (sem selecao)",
    "",
    "INSERCAO DE LINHAS:",
    "Ctrl + Enter          - Nova linha abaixo",
    "Ctrl + Shift + Enter  - Nova linha acima",
    "",
    "SELECAO:",
    "Ctrl + L              - Selecionar linha inteira",
    "Ctrl + Shift + RIGHT  - Selecionar palavra a direita",
    "Ctrl + Shift + LEFT   - Selecionar palavra a esquerda",
    "Shift + Alt + RIGHT   - Expandir selecao",
    "Shift + Alt + LEFT    - Contrair selecao",
    "",
    "BUSCA E SUBSTITUICAO:",
    "Ctrl + F              - Buscar",
    "Ctrl + H              - Buscar e substituir",
    "Ctrl + G              - Ir para linha",
    "Ctrl + T              - Ir para simbolo",
    "Ctrl + Shift + O      - Ir para simbolo no arquivo",
    "Ctrl + Shift + F      - Buscar em arquivos",
    "F3                    - Proxima ocorrencia",
    "Shift + F3            - Ocorrencia anterior",
    "",
    "INDENTACAO:",
    "Tab                   - Aumentar indentacao",
    "Shift + Tab           - Diminuir indentacao",
    "Ctrl + ]              - Aumentar indentacao",
    "Ctrl + [              - Diminuir indentacao",
    "",
    "FORMATACAO:",
    "Shift + Alt + F       - Formatar documento",
    "Ctrl + K, Ctrl + F    - Formatar selecao",
    "",
    "NAVEGACAO GERAL:",
    "Ctrl + P              - Buscar arquivo (Quick Open)",
    "Ctrl + Shift + P      - Paleta de comandos",
    "Ctrl + Shift + E      - Explorer",
    "Ctrl + '              - Terminal integrado",
    "Ctrl + B              - Mostrar/ocultar sidebar",
    "Ctrl + J              - Mostrar/ocultar painel",
    "",
    "ABAS E JANELAS:",
    "Ctrl + N              - Novo arquivo",
    "Ctrl + O              - Abrir arquivo",
    "Ctrl + S              - Salvar",
    "Ctrl + W              - Fechar aba",
    "Ctrl + Shift + T      - Reabrir aba fechada",
    "Ctrl + Tab            - Proxima aba",
    "Ctrl + Shift + Tab    - Aba anterior",
    "",
    "DOBRAR/EXPANDIR CODIGO:",
    "Ctrl + Shift + [      - Dobrar regiao",
    "Ctrl + Shift + ]      - Expandir regiao",
    "Ctrl + K, Ctrl + 0    - Dobrar todas",
    "Ctrl + K, Ctrl + J    - Expandir todas",
    "",
    "NAVEGACAO DE CODIGO:",
    "Ctrl + RIGHT          - Proxima palavra",
    "Ctrl + LEFT           - Palavra anterior",
    "Home                  - Inicio da linha",
    "End                   - Fim da linha",
    "Ctrl + Home           - Inicio do arquivo",
    "Ctrl + End            - Fim do arquivo",
    "Alt + LEFT            - Voltar",
    "Alt + RIGHT           - Avancar",
    "",
    "INTELLISENSE:",
    "Ctrl + Space          - Trigger IntelliSense",
    "Ctrl + Shift + Space  - Parameter hints",
    "Ctrl + .              - Quick fix",
    "F12                   - Ir para definicao",
    "Alt + F12             - Peek definition",
    "Shift + F12           - Mostrar referencias",
    "",
    "DEBUGGING:",
    "F5                    - Iniciar debugging",
    "Ctrl + F5             - Executar sem debugging",
    "F9                    - Toggle breakpoint",
    "F10                   - Step over",
    "F11                   - Step into",
    "",
    "TERMINAL:",
    "Ctrl + Shift + '      - Novo terminal",
    "Ctrl + C              - Interromper processo",
    "Ctrl + V              - Colar no terminal",
    "",
    "GIT:",
    "Ctrl + Shift + G      - Abrir controle de versao",
    "Ctrl + K, Ctrl + G    - Git: Show Graph",
    "",
    "EXTENSOES UTEIS:",
    "Ctrl + Shift + X      - Marketplace de extensoes",
    "Ctrl + K, Ctrl + T    - Selecionar tema de cores",
    "",
    "=== CONTROLES DA JANELA ===",
    "ESC                   - Minimizar janela",
    "F11                   - Maximizar/Restaurar",
    "F1                    - Tamanho padrao"
)

# Junta todas as linhas
$textBox.Text = $atalhosList -join "`r`n"

# Organiza os controles
$mainPanel.Controls.Add($textBox)
$form.Controls.Add($titlePanel)
$form.Controls.Add($mainPanel)

# Exibe o formulário
$form.ShowDialog()