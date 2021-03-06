#Import the O365 library

Import-Module MSOnline

$TenantUname = "xyz@domain.onmicrosoft.com"

 

#reference where you stored the Tenant password

$TenantPass = cat "D:\O365Info\tenantpassword.key" | ConvertTo-SecureString

$TenantCredentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $TenantUname, $TenantPass

 

#Open a session to Exchange on O365

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ Jump -Credential $TenantCredentials -Authentication Basic -AllowRedirection

Import-PSSession $Session -AllowClobber

Connect-MsolService -Credential $TenantCredentials

 

#Declare a file where you will store the proxy address data

$EmailTempfile = "E:\O365Info\O365Emailproxy.csv"

$fileObjectEmail = New-Item $EmailTempFile -type file -force

 

#Declare a file to store the email info

$fileName = "E:\O365Info\O365EmailAddresses.csv"

$fileObject = New-Item $fileName -type file -force

 

#Write the header

$evt_string = "Displayname,EmailAddresses"

$evt_string | Out-file $fileObject -encoding ascii -Append

 

#Get the proxy info

Get-Recipient -Resultsize unlimited -RecipientType Usermailbox | select DisplayName,EmailAddresses | Export-csv -notypeinformation $fileObjectEmail -append -encoding utf8

 

#Read output into a variable

$file = Get-Content $EmailTempfile

for($i=1;$i -lt $file.count;$i++){

$evt_string=""

 

#Split the proxy data into individual addresses

$csvobj = ($file[$i] -split ",")

$EmailAddr = $csvobj[1]

$GetEmail = $EmailAddr -replace '"', '' -split(' ')

 

#write out the display name and email address (One person can have several), filter for smtp only and exclude onmicrosoft.com addresses

for($k=0;$k -lt $GetEmail.count;$k++){

If (($GetEmail[$k] -match "smtp:") -and ($GetEmail[$k] -notmatch "onmicrosoft.com")){

                $evt_string = $csvobj[0]+","+$GetEmail[$k].split(":")[1]

                $evt_string | Out-file $fileObject -encoding utf8 -Append

}

}

}