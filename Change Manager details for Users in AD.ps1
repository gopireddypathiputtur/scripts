$Users = Import-csv C:\Temp\task1.csv
foreach ($User in $Users)
 {
 Set-ADUser $User.SamAccountName -Manager $User.Newmanager
 }
 

 $Users = Import-csv C:\Temp\task2.csv
foreach ($User in $Users)
 {
 Set-ADUser $User.SamAccountName -EmployeeID $User.Newemployeeid
 }

 $Users = Import-csv C:\Temp\task3.csv
foreach ($User in $Users)
 {
 Set-ADUser $User.SamAccountName -Manager $User.manager
 }


  $Users = Import-csv C:\Temp\Managertask3.csv
foreach ($User in $Users)
 {
 Set-ADUser $User.SamAccountName -Manager $User.ManagerSAM
 }