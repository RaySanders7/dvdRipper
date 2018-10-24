Param(
    [string]$movieName,
    [string]$year
)

.\..\HandBrakeCLI-1.1.2-win-x86_64\HandBrakeCLI.exe -i D:\ --main-feature -o C:\MovieRips\"$movieName($year)".m4v

Move-Item -Path "C:\MovieRips\$movieName($year).m4v" -Destination \\rvsserv1\video\Movie -Force
