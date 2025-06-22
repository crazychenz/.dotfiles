# Run this to create this profile.
if (!(Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force };

function Set-LightMode {
    Set-PSReadLineOption -Colors @{
      Command            = 'Black'
      Parameter          = 'DarkBlue'
      Operator           = 'DarkMagenta'      
      String             = 'DarkGreen'
      Variable           = 'DarkYellow'
      Type               = 'DarkBlue'
      Number             = 'DarkRed'
      Member             = 'DarkBlue'
      Emphasis           = 'DarkGray'
      Error              = 'Red'
      Selection          = 'White'
      Comment            = 'Green'
      Keyword            = 'DarkMagenta'
      ContinuationPrompt = 'DarkGray'
    }
	
	function global:prompt {
		$time = Get-Date -Format "HH:mm:ss"
		$user = $env:USERNAME
		$hostname = $env:COMPUTERNAME
		$location = Get-Location
		$gitInfo = ""
		
		# Enhanced git info with status
		if (Get-Command git -ErrorAction SilentlyContinue) {
			try {
				$branch = git branch --show-current 2>$null
				if ($branch) {
					$status = git status --porcelain 2>$null
					$statusIndicator = if ($status) { "*" } else { "" }
					$gitInfo = " ($branch$statusIndicator)"
				}
			} catch { }
		}
		
		# User@Hostname
		Write-Host $user -NoNewline -ForegroundColor DarkGreen
		Write-Host "@" -NoNewline -ForegroundColor DarkGray
		Write-Host $hostname -NoNewline -ForegroundColor DarkBlue
		
		# Git branch (with * if dirty)
		if ($gitInfo) {
			Write-Host $gitInfo -NoNewline -ForegroundColor DarkMagenta
		}
		
		# Time
		Write-Host " [" -NoNewline -ForegroundColor DarkGray
		Write-Host $time -NoNewline -ForegroundColor DarkGray
		Write-Host "] " -ForegroundColor DarkGray
		
		# Path
		Write-Host "PS " -NoNewline -ForegroundColor DarkGray
		Write-Host (Get-Location) -NoNewline -ForegroundColor DarkGreen
		Write-Host ">" -NoNewline -ForegroundColor DarkGray
		return " "
	}

	# Terminal (e.g. tmux) remaps these values.
    #$host.UI.RawUI.BackgroundColor = "White"
    #$host.UI.RawUI.ForegroundColor = "Black"
    Clear-Host
	
	# Set system dark mode, but let the user reset explorer if it matters.
	# Resetting explorer each time we start pwsh seems a bit much.
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1
	# TODO: Consider checking value before restarting?
    #Stop-Process -Name explorer -Force
    #Start-Process explorer.exe
}

function Set-DarkMode {

    Set-PSReadLineOption -Colors @{
      Command            = 'Cyan'
      Parameter          = 'Yellow'
      Operator           = 'Magenta'
      String             = 'Green'
      Variable           = 'Yellow'
      Type               = 'Cyan'
      Number             = 'Red'
      Member             = 'Cyan'
      Emphasis           = 'Yellow'
      Error              = 'Red'
      Selection          = 'DarkGray'
      Comment            = 'DarkGreen'
      Keyword            = 'Magenta'
      ContinuationPrompt = 'Gray'
    }

	function global:prompt {
		$time = Get-Date -Format "HH:mm:ss"
		$user = $env:USERNAME
		$hostname = $env:COMPUTERNAME
		$location = Get-Location
		$gitInfo = ""
		
		# Enhanced git info with status
		if (Get-Command git -ErrorAction SilentlyContinue) {
			try {
				$branch = git branch --show-current 2>$null
				if ($branch) {
					$status = git status --porcelain 2>$null
					$statusIndicator = if ($status) { "*" } else { "" }
					$gitInfo = " ($branch$statusIndicator)"
				}
			} catch { }
		}
		
		# User@Hostname
		Write-Host $user -NoNewline -ForegroundColor Green
		Write-Host "@" -NoNewline -ForegroundColor DarkGray
		Write-Host $hostname -NoNewline -ForegroundColor Yellow
		
		# Git branch (with * if dirty)
		if ($gitInfo) {
			Write-Host $gitInfo -NoNewline -ForegroundColor Magenta
		}
		
		# Time
		Write-Host " [" -NoNewline -ForegroundColor DarkGray
		Write-Host $time -NoNewline -ForegroundColor Cyan
		Write-Host "] " -ForegroundColor DarkGray
		
		# Path
		Write-Host "PS " -NoNewline -ForegroundColor DarkGray
		Write-Host (Get-Location) -NoNewline -ForegroundColor Blue
		Write-Host ">" -NoNewline -ForegroundColor White
		return " "
	}

	# Terminal (e.g. tmux) remaps these values.
    #$host.UI.RawUI.BackgroundColor = "Black"
    #$host.UI.RawUI.ForegroundColor = "White"
    Clear-Host

	# Set system dark mode, but let the user reset explorer if it matters.
	# Resetting explorer each time we start pwsh seems a bit much.
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
	# TODO: Consider checking value before restarting?
    #Stop-Process -Name explorer -Force
    #Start-Process explorer.exe
}

# Check for light theme preference
$lightThemeFile = Join-Path $env:USERPROFILE ".light_theme"
$useLight = $false

# First check if .light_theme file exists
if (Test-Path $lightThemeFile) {
    $useLight = $true
}

# Override with environment variable if it exists
if ($env:LIGHT_THEME -ne $null) {
    # Convert string to boolean
    $useLight = switch ($env:LIGHT_THEME.ToLower()) {
        "true" { $true }
        "1" { $true }
        "yes" { $true }
        "on" { $true }
        default { $false }
    }
}

if ($useLight) {
	Set-LightMode
} else {
	Set-DarkMode
}
