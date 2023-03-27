#======================================================================
# NO POWERSHELL WINDOW DURING THE INSTALL
#======================================================================
$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
add-type -name win -member $t -namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)

#======================================================================
# CHECK IF THE SCRIPT IS ELEVATED / ELEVATE IF NOT
#======================================================================
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Exit
}

#======================================================================
# TURN OFF PROGRESS BAR TO MAKE SCRIPT RUN FASTER
#======================================================================

$ProgressPreference = 'SilentlyContinue'

#======================================================================
# BYPASS EXECUTION POLICY TO ALLOW SCRIPT TO RUN
#======================================================================

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Check if winget is installed
        Write-Host "Checking if Winget is Installed..."
        if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe) {
            #Checks if winget executable exists and if the Windows Version is 1809 or higher
            Write-Host "Winget Already Installed"
        }
        else {
            #Gets the computer's information
            $ComputerInfo = Get-ComputerInfo

            #Gets the Windows Edition
            $OSName = if ($ComputerInfo.OSName) {
                $ComputerInfo.OSName
            }else {
                $ComputerInfo.WindowsProductName
            }

            if (((($OSName.IndexOf("LTSC")) -ne -1) -or ($OSName.IndexOf("Server") -ne -1)) -and (($ComputerInfo.WindowsVersion) -ge "1809")) {
                
                Write-Host "Running Alternative Installer for LTSC/Server Editions"

                # Switching to winget-install from PSGallery from asheroto
                # Source: https://github.com/asheroto/winget-in...
                
                Start-Process powershell.exe -Verb RunAs -ArgumentList "-command irm https://raw.githubusercontent.com/Chr... | iex | Out-Host" -WindowStyle Normal
                
            }
            elseif (((Get-ComputerInfo).WindowsVersion) -lt "1809") {
                #Checks if Windows Version is too old for winget
                Write-Host "Winget is not supported on this version of Windows (Pre-1809)"
            }
            else {
                #Installing Winget from the Microsoft Store
                Write-Host "Winget not found, installing it now."
                Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
                $nid = (Get-Process AppInstaller).Id
                Wait-Process -Id $nid
                Write-Host "Winget Installed"
            }
        }

### Installing Programs ###
# Utility
winget install RARLab.WinRAR -h --accept-package-agreements --accept-source-agreements
winget install WireGuard.WireGuard -h --accept-package-agreements --accept-source-agreements
winget install ExpressVPN.ExpressVPN -h --accept-package-agreements --accept-source-agreements
winget install Nextcloud.NextcloudDesktop -h --accept-package-agreements --accept-source-agreements
winget install KDE.KDEConnect -h --accept-package-agreements --accept-source-agreements
winget install Bitwarden.Bitwarden -h --accept-package-agreements --accept-source-agreements

# Coding
winget install Git.Git -h --accept-package-agreements --accept-source-agreements
winget install Microsoft.VisualStudioCode -h --accept-package-agreements --accept-source-agreements
winget install Notepad++.Notepad++ -h --accept-package-agreements --accept-source-agreements    
winget install GitHub.GitHubDesktop -h --accept-package-agreements --accept-source-agreements
winget install RustDesk.RustDesk -h --accept-package-agreements --accept-source-agreements
winget install Eugeny.Tabby -h --accept-package-agreements --accept-source-agreements

# Gaming 
winget install Valve.Steam -h --accept-package-agreements --accept-source-agreements
winget install PPSSPPTeam.PPSSPP -h --accept-package-agreements --accept-source-agreements
winget install LizardByte.Sunshine  -h --accept-package-agreements --accept-source-agreements# Open source moonlight
winget install ViGEm.ViGEmBus -h --accept-package-agreements --accept-source-agreements # Controller Drivers for Sunshine

# Daily
winget install Brave.Brave -h --accept-package-agreements --accept-source-agreements
winget install Discord.Discord -h --accept-package-agreements --accept-source-agreements

# Productivity
winget install TheDocumentFoundation.LibreOffice -h --accept-package-agreements --accept-source-agreements
winget install Obsidian.Obsidian -h --accept-package-agreements --accept-source-agreements
winget install 9MVVSZK43QQW  -h --accept-package-agreements --accept-source-agreements  # Draw.io Diagrams
winget install GIMP.GIMP -h --accept-package-agreements --accept-source-agreements

### You still need to download the following:
# Cakewalk by Bandlab
# Davinci Resolve