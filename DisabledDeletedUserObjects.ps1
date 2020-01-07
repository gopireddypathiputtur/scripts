# Mod by SNXT 2016-10-19
import-module activedirectory 
$domain = "vel.co.in" 
$DaysInactive = 120
$time = (Get-Date).Adddays(-($DaysInactive))

# Get all AD User with lastLogonTimestamp less than our time and set to enable
Get-ADUser -Filter {LastLogonTimeStamp -lt $time -and enabled -eq $true} -Properties LastLogonTimeStamp |
 
# Output Name and lastLogonTimestamp into CSV
select-object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | Export-Csv -Path "E:\SCRIPT_OUTPUT\DISABLED DELETED OBJECTS\Users_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv" -notypeinformation


#OU you want to place delete Users
$120Days = (Get-Date).AddDays(-120)
Get-ADUser -Filter {LastLogonDate -lt $120Days} -SearchBase "OU=DISABLED USERS,DC=vel,DC=co,DC=in" | remove-adobject -Recursive -Verbose -Confirm:$false