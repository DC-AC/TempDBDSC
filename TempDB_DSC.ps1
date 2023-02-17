
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12  #used to force TLS12

Install-Module dbatools

if (!(test-path -Path D:\MSSQL)) {new-item -ItemType Directory -Path D:\MSSQL}
if (!(test-path -Path C:\Scripts)) {new-item -ItemType Directory -Path C:\Scripts}

$disk=get-wmiobject -Class Win32_logicaldisk -Filter "deviceid='D:'"
$space=$disk.size/1GB -as [INT]
$target=$space*.8*1024 

Set-DBATempDBConfig -SQLInstance . -DataPath D:\MSSQL -DataFileSize $target #-DisableGrowth If you don't want growth #-OutputScriptOnly #used to just output the script if necessary


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


