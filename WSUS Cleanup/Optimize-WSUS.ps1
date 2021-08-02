﻿<#
.SYNOPSIS
	Optimize WSUS DB and performs maintenance.

.DESCRIPTION
	Optimize WSUS DB using official Microsoft SQL script and performs server maintenance.
    
    WsusDBMaintenance.sql and script must be on the same path.
    
    Works in Server 2016 and 2012 R2.

    Saves log in script path: yyyyMMdd__Optimize-WSUS.log
      
    Prerequisites for running Invoke-Sqlcmd

    https://www.microsoft.com/en-us/download/details.aspx?id=42295
    
    Install packages in order:
        1. SQLSysClrTypes.msi
        2. SharedManagementObjects.msi  
        3. PowerShellTools.msi
    
    .NOTES 
	Author: Juan Granados 
	Date:   March 2018
#>
#Requires -RunAsAdministrator
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Start-Transcript "$scriptPath\$(Get-Date -format "yyyyMMdd")_Optimize-WSUS.log"
Get-WsusServer | Invoke-WsusServerCleanup -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates
Invoke-Sqlcmd -ServerInstance "\\.\pipe\microsoft##WID\tsql\query" -InputFile "$scriptPath\WsusDBMaintenance.sql" -Verbose
Stop-Transcript