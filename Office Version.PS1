foreach ($computer in (Get-Content "C:\Scripts\Officeversion\Computers.txt")){
  write-verbose "Working on $computer..." -Verbose
  Invoke-Command -ComputerName "$Computer" -ScriptBlock {
    Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\office15* |
    Select-Object DisplayName, DisplayVersion, Publisher
  } | export-csv C:\Scripts\Officeversion\results.csv -Append -NoTypeInformation
  }