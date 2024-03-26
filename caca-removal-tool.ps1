# Répare les conneries d'encodage de PS
$PSDefaultParameterValues['Out-Host:Encoding'] = 'utf8'
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['Get-Content:Encoding'] = 'utf8'

# Autres variables
$playlistExtension = "*.m3u8"


# Selection de la source
#   - Soit le path d'une playlist
#   - Soit une des playlist dans le même répertoire que le script

$sourceSelection = $true

while ($sourceSelection) {
    # Selection d'un path ou vide pour parcours de la racine du script
    $selectSource = Read-Host "Veuillez saisir le chemin de la playlist au format .m3u8 (laisser vide si dans le même dossier que ce script) "
    
    # Si source renseignée n'est pas vide
    #   Vérifie si le path est correct, sinon
    if ($selectSource -ne "") {
        if (Test-Path $selectSource and $selectSource -match "$playlistExtension$") {
            Write-Host -ForegroundColor Green  "La playlist a été trouvée à l'adresse spécifiée."
            $playlistSource = $selectSource
            $sourceSelection = $false
        }
        else {
            Write-Host -ForegroundColor Yellow "Le fichier spécifié n'existe pas ou n'est pas au bon format."
        }
    }
    else {
        $fileChoices = Get-ChildItem -Path $PSScriptRoot -Filter $playlistExtension

        # Afficher le nom des fichiers trouvés
        $choiceNb = 1
        foreach ($file in $fileChoices) {
            Write-Host -ForegroundColor Cyan "[$choiceNb] = ($file.Name)"
            $choiceNb ++
        }
        $sourceNbSelection = $true
        while ($sourceNbSelection) {
            $selectSourceNb = Read-Host "Choisir la playlist souhaitée"
            if ($selectSourceNb -lt $fileChoices.Count+1){
                $playlistSource = $fileChoices[$selectSourceNb-1]
                Write-Host -ForegroundColor Green "Playlist selectionnée : $playlistSource"
                $sourceNbSelection = $false
            }
            else {
                Write-Host -ForegroundColor Yellow "Choix incorrect."
            }
        }
        $sourceSelection = $false
    }
}






# Définit l'adresse de la playlist source
# $playlistSource = "C:\Data\Code\caca-removal-tool\data\Caca.m3u8"

# Stocke toutes les adresses dans fileList
$fileList = Get-Content $playlistSource | Where-Object { $_ -like "C:\*" }

# Vérifie l'existance de chaque fichier de la liste fileList
$listFound = @()
$listNotFound = @()
foreach ($file in $fileList) {
    if (Test-Path $file) {
        # Compte le nombre de fichiers trouvés et les ajoute à la liste listFound
        $listFound += $file
    }
    else {
        # Liste les fichiers absents
        $listNotFound += $file
    }
}
$nbFilesFound = $listFound.Count
$nbFilesTotal = $nbFilesFound + $listNotFound.Count

Write-Host -ForegroundColor Green "Files found : $nbFilesFound/$nbFilesTotal."
foreach ($file in $listNotFound) {
    Write-Host -ForegroundColor Red $file
}
$listNotFound | Out-File -FilePath "files_not_found.txt"


$deleteConfirm = Read-Host "Supprimer $nbFilesFound fichiers ? (Y/N)"
if ($deleteConfirm -eq "Y" -or $deleteConfirm -eq "y") {
    Write-Host -ForegroundColor Green "Fichiers supprimés."
}
else {
    Write-Host -ForegroundColor Green "0 fichiers ont été supprimés."
}
# foreach ($file in $listFound) {
#     # Remove-Item -Path file
# }