$When = ((Get-Date).AddDays(-30)).Date
Get-ADUser -Filter {whenCreated -ge $When} -Properties whenCreated

Select-Object Name,Type,whenCreated | export-csv C:\user.csv -notypeinformation

