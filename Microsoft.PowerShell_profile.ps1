
Get-Alias | Remove-Alias -Force
Set-Alias -Name la -Value Get-ChildItem
Set-Alias -Name rm -Value Remove-Item
Set-Alias -Name mv -Value Move-Item
Set-Alias -Name e -Value C:\Windows\explorer.exe
Set-Alias -Name v -Value nvim.exe
Set-Alias -Name echo -Value Write-Output
Set-Alias -Name which -Value Get-Command

Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource HistoryAndPlugin -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -PredictionViewStyle ListView

# starship
Invoke-Expression (&starship init powershell)

# docker completion
docker completion powershell | Out-String | Invoke-Expression

# kubectl completion
kubectl completion powershell | Out-String | Invoke-Expression
Set-Alias -Name k -Value kubectl
Register-ArgumentCompleter -CommandName k -ScriptBlock $__kubectlCompleterBlock

# fnm
fnm env --use-on-cd | Out-String | Invoke-Expression


