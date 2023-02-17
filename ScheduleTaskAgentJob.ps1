# Set Service to Manual Start

set-service -name "MSSQLSERVER" -StartupType Manual


#Scheduled Task Creation

$a = New-ScheduledTaskAction -Execute "powershell.exe" -Argument C:\Scripts\TempDB.ps1
$t = New-ScheduledTaskTrigger -AtStartup
$p = New-ScheduledTaskPrincipal "NT Authority\SYSTEM"
$s = New-ScheduledTaskSettingsSet
$d = New-ScheduledTask -Action $a -Principal $p -Trigger $t -Settings $s
Register-ScheduledTask TempDBJob -InputObject $d

