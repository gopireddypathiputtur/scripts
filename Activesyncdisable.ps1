﻿Get-Content "C:\Scripts\hc.txt" | foreach {Set-CasMailbox $_ -ActiveSyncEnabled $false}