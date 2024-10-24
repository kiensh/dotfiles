
Set-Location $(fd . `
	--search-path C:\projects `
	--search-path C:\projects\commons\monolith-code\src\Websites `
	--search-path C:\projects\commons\netwealth-platform\private-apis `
-t d -d 3 | fzf || Get-Location)
