# Import AD Module             
Import-Module ActiveDirectory            
 $users = Import-Csv -Path C:\Scripts\attributechange\Users.csv                       
 foreach ($user in $users) 
 {Get-ADUser -Filter "SamAccountName -eq '$($user.samaccountname)'"  |  Set-ADUser -sapuserid $($User.sapuserid)}