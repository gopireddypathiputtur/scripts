$groups = Get-Content C:\grouplist.txt

$results = foreach ($group in $groups) {
    Get-ADGroupMember $group | select samaccountname, name, @{n='GroupName';e={$group}}, @{n='Description';e={(Get-ADGroup $group -Properties description).description}}
}

$results

$results | Export-csv C:\grouplistresult.txt -NoTypeInformation