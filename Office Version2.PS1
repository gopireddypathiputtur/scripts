Get-Content PClist.txt |
    ForEach-Object{
        $reg=[Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $_)
        $reg.OpenSubKey('software\Microsoft\Office').GetSubKeyNames() |% {$_}
    }