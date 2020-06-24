# Delete Software With PowerBroker

This script uses the PowerBroker elevated permissions within PowerShell to query the registry to software and delete it. The `Get-Package` module to do a verification and deletes it with the `UninstallString`. The string may not work if where the `ProviderName` is `Programs` or has the `UninstallString` missing in registry. The second attempt to delete is made with `Get-WmiObject`. This is a slower older way of querying and not considered best practice anymore, but can still be used as a "plan B."

Also, this can be used in any elevated PowerShell session, the script was just adapted to abuse PowerBroker. 

## Usage

Start a PowerShell session with PowerBroker. To do that click the Start Menu and type `PowerShell` right-click and select `Open file location`. Right-click PowerShell and select `Run as PowerBroker Administrator`. Save this script to whichever directory you have write permissions to and run it. 
```
.\get-and-delete-software.ps1
```
When prompted select `Y` to get a list or `N` to jump right into deleting software. Use a wildcard for the software name or use the exact `DisplayName` for the search output. The script does a check for you if the software is still installed. To do yet another sanity check, run the following:

```
Get-Package -Provider Programs -IncludeWindowsInstaller -Name "SOFTWARE_NAME"
```
