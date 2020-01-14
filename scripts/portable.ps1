<#
.SYNOPSIS
    Universal portable mode enabler
    IDE subdirectory is needed.
.PARAMETER Directory
    Current '$dir' of application
.PARAMETER Persist
    Persist directory of application
#>
param([Parameter(Mandatory)][String] $Directory, [Parameter(Mandatory)][String] $Persist)

$properties = Join-Path 'IDE' 'bin\idea.properties'

if (Join-Path $Persist $properties | Test-Path) {
    $fullProp = Join-path $Directory $properties
    $currentForward = (Split-Path $Directory | Join-Path -ChildPath 'current') -replace '\\', '/'
    $profileDir = "$currentForward/profile"

    $CONT = Get-Content $fullProp
    # Set portable configuration
    $CONT = $CONT -replace '^#\s*(idea.config.path=).*$', "`$1$profileDir/config"
    $CONT = $CONT -replace '^#\s*(idea.system.path=).*$', "`$1$profileDir/system"
    $CONT = $CONT -replace '^#\s*(idea.plugins.path=).*$', '$1${idea.config.path}/plugins'
    $CONT = $CONT -replace '^#\s*(idea.log.path=).*$', '$1${idea.system.path}/log'

    Set-Content $fullProp $CONT -Encoding Ascii -Force
} else {
    $properties = Join-Path $Persist $properties
    Write-Host "Software portable processing failed." -ForegroundColor Red
    Write-Host "properties file does not exist." -ForegroundColor Red
    Write-Host "directory: $properties" -ForegroundColor Red
    exit 1
}
