Param(
    [Parameter(Mandatory)]
    [ValidateSet("movie", "tv", IgnoreCase=$true)]
    [string]$format
)

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
    $seasonNumber = Read-Host -Prompt 'Season number (With Format XX)?'
    $stringEpisodeNumberStart = Read-Host -Prompt "Starting episode number? (With Format XX)"
    $stringEpisodeNumberEnd = Read-Host -Prompt "Ending episode number? (With Format XX)"

    $intEpisodeNumberStart = [int]$stringEpisodeNumberStart
    $intEpisodeNumberEnd = [int]$stringEpisodeNumberEnd

    $episodeCount = $intEpisodeNumberEnd - $intEpisodeNumberStart + 1

    Write-Output "Preparing to rip TV show $showName Season $seasonNumber..." 
    Write-Output "Start = $intEpisodeNumberStart" 
    Write-Output "End = $intEpisodeNumberEnd" 
    Write-Output "End = $episodeCount" 

    for ($i = 0; $i -lt $episodeCount; $i++) {
        $currentTitleNumber = $i + 1
        Write-Output "Ripping episode $currentTitleNumber ..." 
        # .\..\HandBrakeCLI-1.1.2-win-x86_64\HandBrakeCLI.exe -i D:\ --title $currentTitleNumber -o C:\MovieRips\"$showName"\"Season$seasonNumber\$showName-s"
    }
}



Write-Output "Script complete!!"