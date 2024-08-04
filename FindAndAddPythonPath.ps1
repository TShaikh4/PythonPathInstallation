# Function to find Python installation path
function Find-PythonPath {
    $commonPythonPaths = @(
        "$env:LOCALAPPDATA\Programs\Python\Python*",
        "C:\Python*",
        "$env:ProgramFiles\Python*",
        "$env:ProgramFiles(x86)\Python*"
    )

    foreach ($path in $commonPythonPaths) {
        $pythonDirs = Get-ChildItem -Path $path -Directory -ErrorAction SilentlyContinue
        foreach ($dir in $pythonDirs) {
            $pythonExe = Join-Path $dir.FullName "python.exe"
            if (Test-Path $pythonExe) {
                return $pythonExe
            }
        }
    }

    Write-Error "Python executable not found. Ensure Python is installed."
    return $null
}

# Function to add Python path to the system PATH variable
function Add-ToSystemPath {
    param (
        [string]$newPath
    )
    $envPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    if ($envPath -notcontains $newPath) {
        [System.Environment]::SetEnvironmentVariable("Path", "$envPath;$newPath", [System.EnvironmentVariableTarget]::Machine)
        Write-Output "Added $newPath to the system PATH."
    } else {
        Write-Output "$newPath is already in the system PATH."
    }
}

# Main script
$pythonExePath = Find-PythonPath
if ($pythonExePath) {
    $pythonDir = [System.IO.Path]::GetDirectoryName($pythonExePath)
    Add-ToSystemPath -newPath $pythonDir
} else {
    Write-Error "Could not find the Python installation path."
}

# Restart PowerShell to apply changes
Write-Output "Please restart PowerShell for the changes to take effect."
