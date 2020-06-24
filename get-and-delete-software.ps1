Function pullSoftware  {
    $32bit = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
    $64bit = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
    $total = $32bit + $64bit 
    Write-Output $total
}

Function deleteSoftware {
    Param ([string]$software=(Read-Host "What software do you want to delete?(Use DisplayName from software search and wildcard!)"))
    write-host "Checking if $software is on the system.."
    $MyApp = Get-Package -Provider Programs -IncludeWindowsInstaller -Name "$software"
    $MyApp
    if($MyApp)
    {
        Write-Host "Attempting to delete..."
        $MyApp |% { & $_.Meta.Attributes["UninstallString"]} -ErrorAction "SilentlyContinue"
        Write-Host "Verifying it's gone..."
        $gp = Get-Package -Provider Programs -IncludeWindowsInstaller -Name "$software"
        if($gp)
        {
            Write-Host "It's still there, something went wrong! Take 2"
            $take2 = Get-WmiObject -Class Win32_Product | Where-Object Name -like "$software"
            $take2.Uninstall()
        } else {
            Write-Host "Software no longer on the system, successfully deleted it!"
            Exit
    }
    } else {
        Write-Host "$software doesnt exist"
        Exit
    }
}


Function prompted {
    $msg = "Do you want to search available software first? [Y/N]"
    $response = Read-Host -Prompt $msg
    switch ($response) {
           Y { pullSoftware | Out-Host }
           Y { deleteSoftware | Out-Host }
           N { deleteSoftware }
           default { "Choose Y or N only"; prompted }
    }
}

prompted
