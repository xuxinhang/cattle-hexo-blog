
Get-ChildItem |
	Where-Object { $_.Name -match ".*?\.md" } |
	ForEach-Object {
		$bn = $_.BaseName
		New-Item -Name $bn -Path . -ItemType "directory" -Force
		$pattern = [Regex]"!\[.*?\]\((.+?)\)"
		$text = $_ | Get-Content
		$pattern.Match($text) | ForEach-Object {
			$uri = [Uri][string]$_.Groups[1]
			$FilePath = "$(pwd)/$bn/$($uri.Segments[-1])"
			# (New-Object Net.WebClient).DownloadData($uri) |
			# 	Set-Content -Path  -AsByteStream
			$HttpStream = (New-Object Net.WebClient).OpenRead($uri)
			$FileStream = [System.IO.FileStream]::new($FilePath, [System.IO.FileMode]::OpenOrCreate)
			$HttpStream.CopyTo($FileStream)
			$FileStream.Dispose()
		}
	}
