# list of exclusions to add to Microsoft defender to make things work "faster" as MsMpeng.exe takes up a lot of time each time the IIS server starts up and when the reporting services is initiated.

# Add SQL sserver to the exclusion list
Add-MpPreference -ExclusionPath "C:\Program Files\Microsoft SQL Server"

Add-MpPreference -ExclusionPath "K:\AosService\PackagesLocalDirectory"
Add-MpPreference -ExclusionPath "K:\AosService\WebRoot"
