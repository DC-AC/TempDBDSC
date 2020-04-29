Install-Module dbatools

if (!(test-path -Path D:\MSSQL)) {new-item -ItemType Directory -Path D:\MSSQL}
if (!(test-path -Path C:\Scripts)) {new-item -ItemType Directory -Path C:\Scripts}

$disk=get-wmiobject -Class Win32_logicaldisk -Filter "deviceid='D:'"
$space=$disk.size/1GB -as [INT]
$target=$space*.8*1024 

Set-DBATempDBConfig -SQLInstance . -DataPath D:\MSSQL -DataFileSize $target


# Create File

if (!(test-path -Path C:\Scripts)) {new-item -ItemType Directory -Path C:\Scripts}
if (!(test-path -Path C:\Scripts\tempdb.ps1)) {New-Item -ItemType File -Path  C:\Scripts\tempdb.ps1}

#Set Content of Script

Set-Content -Path C:\Scripts\tempdb.ps1 -value "`$SQLService = ""SQL Server (MSSQLSERVER)""
`$SQLAgentService = ""SQL Server Agent (MSSQLServer)""
`$tempFolder = 'D:\MSSQL'
if (!(test-path -Path `$tempFolder)) {new-item -ItemType Directory -Path `$tempFolder}
start-service `$SQLServer
start-service `$SQLAgentService"

# Set Service to Manual Start

set-service -name "MSSQLSERVER" -StartupType Manual


#Scheduled Task Creation

$a = New-ScheduledTaskAction -Execute "powershell.exe" -Argument C:\Scripts\TempDB.ps1
$t = New-ScheduledTaskTrigger -AtStartup
$p = New-ScheduledTaskPrincipal "NT Authority\SYSTEM"
$s = New-ScheduledTaskSettingsSet
$d = New-ScheduledTask -Action $a -Principal $p -Trigger $t -Settings $s
Register-ScheduledTask TempDBJob -InputObject $d


