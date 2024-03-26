# Définit l'adresse de la playlist source
$playlistSource = "C:\Data\Code\caca-removal-tool\data\Caca.m3u8"

# Stocke toutes les adresses dans fileList
$fileList = Get-Content $playlistSource | Where-Object { $_ -like "C:\*" }

# Vérifie l'existance de chaque fichier de la liste fileList
$nbFilesFound = 0
$nbFilesTotal = 0
foreach ($file in $fileList) {
    if (Test-Path $file) {
        $nbFilesFound ++
    }
    $nbFilesTotal ++
}
Write-Output "Files found : $nbFilesFound/$nbFilesTotal."


