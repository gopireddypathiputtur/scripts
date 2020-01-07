# Modified by Satish V. on 2017-09-20
import-module activedirectory 
$domain = "vel.co.in" 
$120Days = (Get-Date).AddDays(-120)

 
# Get all AD computers with lastLogonTimestamp less than our time
Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp |
 
# Output all hostnames with lastLogonTimestamp into CSV
select-object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | Export-Csv -Path "E:\Script_Output\DISABLED DELETED OBJECTS\Computers_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv" -notypeinformation


#Output Hostnames with LastlogonTimestamp less than 120days from Disabled Computer OU
$DestinationOU = "OU=DISABLED COMPUTERS,DC=vel,DC=co,DC=in"
Get-ADComputer -Filter {LastLogonDate -lt $120Days} -SearchBase $DestinationOU -property * | select-object Name, dNSHostName, DistinguishedName, DisplayName, Enabled, LastLogonDate, lastLogonTimestamp |Export-Csv -Path "E:\Script_Output\DISABLED DELETED OBJECTS\ComputersToBeDeletedOn_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv" -notypeinformation


#OU you want to place and delete 120days Inactive computers
$DestinationOU = "OU=DISABLED COMPUTERS,DC=vel,DC=co,DC=in"
Get-ADComputer -SearchBase $DestinationOU -property Name, LastLogonDate -Filter {LastLogonDate -lt $120Days} | remove-adobject -Recursive -Verbose -Confirm:$false