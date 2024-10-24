
Set-Location $(fd . `
	--search-path C:\Users\kbuinguyen `
	--search-path C:\Users\kbuinguyen\notes `
`
	--search-path C:\Users\kbuinguyen\AppData\Roaming `
	--search-path C:\Users\kbuinguyen\AppData\Local `
-t d -d 1 | fzf || Get-Location)
