# Import AD Module             
Import-Module ActiveDirectory            

# Import CSV into variable $userscsv            
#$userscsv = import-csv             
$users = Import-Csv -Path 'C:\Scripts\Attributechange\Users.csv'           
# Loop through CSV and update users if the exist in CSV file            

foreach ($user in $users)
{            
    #Search in specified OU and Update existing attributes            
    Get-ADUser -Filter "SamAccountName -eq '$($user.SamAccountName)'" -Properties * | Set-ADUser -sapuserid $($user.sapuserid)
}