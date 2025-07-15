$WshShell = New-Object -ComObject WScript.Shell
$desktop = [Environment]::GetFolderPath('Desktop')
$target = "$PSScriptRoot\atalhos_vscode.ps1"
$shortcut = "$desktop\Atalhos VSCode.lnk"

$sc = $WshShell.CreateShortcut($shortcut)
$sc.TargetPath = "powershell.exe"
$sc.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$target`""
$sc.IconLocation = "$PSScriptRoot\1-00c87720.ico"
$sc.Save()