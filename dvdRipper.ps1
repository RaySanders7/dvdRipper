Param(
    [Parameter(Mandatory)]
    [ValidateSet("movie", "tv", IgnoreCase=$true)]
    [string]
    ${Please enter the format (Valid entires are 'movie' or 'tv')}
)

$format = ${Please enter the format (Valid entires are 'movie' or 'tv')}

if($format -eq "movie") {
    Write-Output "Ripping a movie!"

    $movieName = Read-Host -Prompt 'Movie Name? (With No Spaces in the Name)'
    $year = Read-Host -Prompt 'Year released?'

    Write-Output "Preparing to rip movie $movieName($year)..." 

    .\..\HandBrakeCLI-1.1.2-win-x86_64\HandBrakeCLI.exe -i D:\ --main-feature -o C:\MovieRips\"$movieName($year)".m4v

    Write-Output "Moving movie to server"
    Move-Item -Path "C:\MovieRips\$movieName($year).m4v" -Destination \\rvsserv1\video\Movie -Force
    Write-Output "Move to server complete!"

    Write-Output "Renaming Movie"

    $formattedMovieName = ($movieName -creplace '[^a-z\s]', ' $&').Trim()

    Rename-Item -Path "\\rvsserv1\video\Movie\$movieName`($year).m4v" -NewName "\\rvsserv1\video\Movie\$formattedMovieName` ($year).m4v"
} else {
    Write-Output "Ripping a TV show!"

    $showName = Read-Host -Prompt 'TV Show Name? (With No Spaces in the Name)'
    $seasonNumber = Read-Host -Prompt 'Season number?'
    $episodeNumberStart = Read-Host -Prompt "Starting episode number?"
    $episodeNumberEnd = Read-Host -Prompt "Ending episode number?"

    $episodeCount = $episodeNumberEnd - $episodeNumberStart + 1

    Write-Output "Preparing to rip TV show $showName Season $seasonNumber..." 

    if ($seasonNumber -lt 10) {
        $castedNumber = [string]$seasonNumber
        $seasonNumberString = "0$castedNumber"
    } else {
        $currentEpisodeString = [string]$seasonNumber
    }

    $showFolderExists = Test-Path -PathType Container C:\MovieRips\"$showName" 
    $seasonFolderExists = Test-Path -PathType Container C:\MovieRips\"$showName"\Season"$seasonNumberString"

    if ($showFolderExists -eq $false) {
        Write-Output "Createing show folder at C:\MovieRips\$showName" 
        New-Item -ItemType Directory -Force -Path C:\MovieRips\"$showName"
    }
    
    if ($seasonFolderExists -eq $false) {
        Write-Output "C:\MovieRips\$showName\Season$seasonNumberString" 
        New-Item -ItemType Directory -Force -Path C:\MovieRips\"$showName"\Season"$seasonNumberString"
    }    

    for ($i = [int]$episodeNumberStart; $i -lt $episodeCount; $i++) {        
        Write-Output "Ripping episode $i ..." 

        if ($i -lt 10) {
            $castedNumber = [string]$i
            $currentEpisodeString = "0$castedNumber"
        } else {
            $currentEpisodeString = [string]$i
        }
    
        .\..\HandBrakeCLI-1.1.2-win-x86_64\HandBrakeCLI.exe -i D:\ --title $i --min-duration 600 -o C:\MovieRips\"$showName"\Season"$seasonNumberString"\"$showName-s$seasonNumberString-e$currentEpisodeString".m4v                
    }
}



Write-Output "Script complete!!"
