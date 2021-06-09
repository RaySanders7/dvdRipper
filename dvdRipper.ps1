Param(
    # [string]$movieName,
    # [string]$year
    [Parameter(Mandatory)]
    [ValidateSet("movie", "tv", IgnoreCase=$true)]
    [string]$format
)

if($format -eq "movie") {
    Write-Output "Hi movie"
} else {
    Write-Output "Hi tv show"   
}

# .\..\HandBrakeCLI-1.1.2-win-x86_64\HandBrakeCLI.exe -i D:\ --main-feature -o C:\MovieRips\"$movieName($year)".m4v

# Write-Output "Moving file to server"
# Move-Item -Path "C:\MovieRips\$movieName($year).m4v" -Destination \\rvsserv1\video\Movie -Force
# Write-Output "Move to server complete!"

# Write-Output "Renaming File"

# $formattedMovieName = ($movieName -creplace '[^a-z\s]', ' $&').Trim()

# Rename-Item -Path "\\rvsserv1\video\Movie\$movieName`($year).m4v" -NewName "\\rvsserv1\video\Movie\$formattedMovieName` ($year).m4v"

Write-Output "Script complete!!"