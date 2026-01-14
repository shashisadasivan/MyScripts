# list of exclusions to add to Microsoft defender to make things work "faster" as MsMpeng.exe takes up a lot of time each time the IIS server starts up and when the reporting services is initiated.
# https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-extension-file-exclusions-microsoft-defender-antivirus?view=o365-worldwide
# Get-MpPreference | Select-Object -ExpandProperty ExclusionPath

# Add SQL sserver to the exclusion list
Add-D365WindowsDefenderRules
Add-MpPreference -ExclusionPath "C:\Program Files\Microsoft SQL Server"

Add-MpPreference -ExclusionPath "K:\AosService\PackagesLocalDirectory"
Add-MpPreference -ExclusionPath "K:\AosService\WebRoot"
Add-MpPreference -ExclusionPath '%userprofile%\Documents\IISExpress'
Add-MpPreference -ExclusionPath '%userprofile%\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations'
Add-MpPreference -ExclusionPath 'C:\Program Files\Common Files\Microsoft Shared\Office16\mso20win32client.dll'

# To check for what is causing : https://learn.microsoft.com/en-us/defender-endpoint/tune-performance-defender-antivirus#using-performance-analyzer
# New-MpPerformanceRecording -RecordTo C:\Temp\msmpengRecord.etl
# Get-MpPerformanceReport -Path C:\Temp\msmpengRecord.etl -TopFiles 3 -TopScansPerFile 10
