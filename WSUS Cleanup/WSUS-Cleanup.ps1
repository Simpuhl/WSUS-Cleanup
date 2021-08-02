$logfile="C:\Scripts\Logs\WSUS-Cleanup.log"
#$scriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition


$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path $logfile
$Error.Clear()

Write-Output "$((get-date).ToLongTimeString()) $env:COMPUTERNAME - WSUS-Cleanup Script Starting..."
Get-WsusServer | Invoke-WsusServerCleanup -CleanupObsoleteComputers
Get-WsusServer | Invoke-WsusServerCleanup -CleanupObsoleteUpdates
Get-WsusServer | Invoke-WsusServerCleanup -CleanupUnneededContentFiles
#Get-WsusServer | Invoke-WsusServerCleanup -CompressUpdates
Get-WsusServer | Invoke-WsusServerCleanup -DeclineExpiredUpdates
Get-WsusServer | Invoke-WsusServerCleanup -DeclineSupersededUpdates
Write-Output "$((get-date).ToLongTimeString()) $env:COMPUTERNAME - WSUS-Cleanup Script Complete."

Write-Output "$((get-date).ToLongTimeString()) $env:COMPUTERNAME - WSUS-Cleanup-Updates-v4 Script Starting..."
& "$PSScriptRoot\WSUS-Cleanup-Updates-v4.ps1" -Verbose
Write-Output "$((get-date).ToLongTimeString()) $env:COMPUTERNAME - WSUS-Cleanup-Updates-v4 Script Complete."

Write-Output "$((get-date).ToLongTimeString()) $env:COMPUTERNAME - WSUS Database Maintenance Script Starting..."
Invoke-Sqlcmd -ServerInstance "\\.\pipe\microsoft##WID\tsql\query" -InputFile "$PSScriptRoot\WsusDBMaintenance.sql" -Verbose
Write-Output "$((get-date).ToLongTimeString()) $env:COMPUTERNAME - WSUS Database Maintenance Script Complete."


Stop-Transcript