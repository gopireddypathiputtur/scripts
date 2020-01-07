Const cdoSendUsingMethod = "http://schemas.microsoft.com/cdo/configuration/sendusing", cdoSendUsingPort = 2, cdoSMTPServer = "http://schemas.microsoft.com/cdo/configuration/smtpserver"
Const HARD_DISK = 3
Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8
Dim strComputer, Silent, strGBFree, strDiskFreeSpace , cnt
Dim strDiskDrive, strPercFree, strDiskUsed, CurTime, OutputDir
Dim cbgcolor, wbgcolor, strbgcolor, varlastemail, vartoday, fstyle
Dim sMailSched, strMailTo, strMailFrom, strSubject, StrMessage, strSMTPServer
Dim Command, Count, objPro, colPro, strProPer, strLinePercentCommittedBytesInUse , colMEM, objMEM
Dim f, r, w, ws, WshSysEnv, WshShell
On Error Resume Next
cnt = 0
Silent = 0
strCrit = 10
strWarn = 20
cbgcolor = "#FF0000"
wbgcolor = "#EDDA74"
nbgcolor = "#00FF00"
SourceFile = "Servers_list.txt"
fstyle = "Calibri"
OutputDir = "c:\Scripts\"
Count = 0
Set WshShell = WScript.CreateObject("WScript.Shell")
Set WshSysEnv = WshShell.Environment("PROCESS")
Set ws = CreateObject ("Scripting.FileSystemObject")
OutputFile = OutputDir & "\drivespace.htm"
WarningFIle = OutputDir & "\warning.htm"
If CheckFileExists(outputfile) Then
            Set oldfile = ws.GetFile(OutputFile)
            oldfile.Delete
End If
If CheckFileExists(warningfile) Then
            Set oldfile = ws.GetFile(warningfile)
            oldfile.Delete
End If
CurTime = Now
strSubject = "Intl Servers Report - " & CurTime
Do While Count <= 1
            If Count = 1 Then
                        Set w = ws.OpenTextFile (WarningFile, ForAppending, True)
            ElseIf Count = 0 Then 
                        Set w = ws.OpenTextFile (OutputFile, ForAppending, True)
            End If
            w.Writeline ("<html>")
            w.Writeline ("<head>")
                        w.Writeline ("<title>Drive Space info at " & CurTime & "</title>")
            
w.Writeline ("<style type='text/css'>")
w.Writeline ("<!--")
w.Writeline ("td {")
w.Writeline ("font-family: Tahoma;")
w.Writeline ("font-size: 11px;")
w.Writeline ("border-top: 1px solid #999999;")
w.Writeline ("border-right: 1px solid #999999;")
w.Writeline ("border-bottom: 1px solid #999999;")
w.Writeline ("border-left: 1px solid #999999;")
w.Writeline ("padding-top: 0px;")
w.Writeline ("padding-right: 0px;")
w.Writeline ("padding-bottom: 0px;")
w.Writeline ("padding-left: 0px;")
w.Writeline ("}")
w.Writeline ("body {")
w.Writeline ("margin-left: 5px;")
w.Writeline ("margin-top: 5px;")
w.Writeline ("margin-right: 0px;")
w.Writeline ("margin-bottom: 10px;")
w.Writeline ("")
w.Writeline ("table {")
w.Writeline ("border: thin solid #000000;")
w.Writeline ("}")
w.Writeline ("-->")
w.Writeline ("</style>")
w.Writeline ("<META HTTP-EQUIV='REFRESH' CONTENT='108000'>")
w.Writeline ("</head>")
w.Writeline ("<body>")

            w.Writeline ("<table cellpadding=2 width=50%><tr  bgcolor='#CCCCCC'><td colspan=6 align='center'>")
            w.Writeline ("<font face='tahoma' color='#003399' size='2'><strong>Drive Space info at "& CurTime & "</strong></font>")
            w.Writeline ("</td></tr>")
 
     '   w.Writeline ("<TR bgcolor=#CCCCCC>")
     '              ' w.Writeline ("<TD align=center>Computer Name </font></B></TD>")
     '               w.Writeline ("<TD align=center>Drive </font></B></TD>")
     '               w.Writeline ("<TD align=center>Total Size </font></B></TD>")
     '               w.Writeline ("<TD align=center>Space Used </font></B></TD>")
     '                   w.Writeline ("<TD align=center>Free Space </font></B></TD>")
     '               w.Writeline ("<TD align=center>%Free </font></B></TD>")
     '   w.Writeline ("</TR>")
            Count = Count + 1
            w.close
Loop
Count = 0
Set f = ws.OpenTextFile (SourceFile, ForReading, True) 
Do While f.AtEndOfStream <> True
            If f.AtEndOfStream <> True Then
                        strComputer = f.ReadLine
strLinePercentCommittedBytesInUse = ""
                        Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
						
						'Gets PROCESSOR Usage 
						strProPer = ""
						Set colPro = objWMIService.ExecQuery("SELECT PercentProcessorTime  FROM Win32_PerfFormattedData_PerfOS_Processor WHERE Name = '_Total'") 
						For Each objPro In colPro 
							strProPer = strProPer & " " & objPro.PercentProcessorTime 
						Next 
						
						'Gets CPU MEMORY Usage 
						'SELECT Caption, CommittedBytes, AvailableBytes, PercentCommittedBytesInUse, PagesPerSec, PageFaultsPerSec FROM Win32_PerfFormattedData_PerfOS_Memory

						'

						Set colMEM = objWMIService.ExecQuery("Select PercentCommittedBytesInUse FROM Win32_PerfFormattedData_PerfOS_Memory ",,48) 
						For Each objMEM In colMEM       
    						strLinePercentCommittedBytesInUse = strLinePercentCommittedBytesInUse & " " & objMEM.PercentCommittedBytesInUse


					Next 
  
						
					


                        Set colDisks = objWMIService.ExecQuery ("Select * from Win32_LogicalDisk Where DriveType = " & HARD_DISK & "")
						
                        For Each objDisk in colDisks
                                    strDiskDrive = objDisk.DeviceID
                                    strDiskUsed = FormatNumber((((objDisk.Size - objDisk.FreeSpace) / 1024) / 1024) / 1024)
                                    strDiskSize = FormatNumber(((objDisk.Size / 1024) / 1024) / 1024,2)
                                    strDiskFree = FormatNumber(((objDisk.Freespace / 1024) / 1024) / 1024,2)
                                    strPercFree = FormatNumber(objDisk.FreeSpace/objDisk.Size,2)
                                    strPercFree = strPercFree * 100
                                    If strPercFree <= strWarn and strPercFree > strCrit Then
                                                strBgcolor = wbgcolor
                                                Count = Count + 1
                                    ElseIf strPercFree < strWarn and strPercFree <= strCrit Then
                                                strBgcolor = cbgcolor
                                                Count = Count + 1
									ElseIf strPercFree > strWarn Then
                                                strBgcolor = nbgcolor
                                               ' Count = Count + 1			
                                    End If
									
									
                                    Call WriteLines
									cnt = 1
                        Next
						cnt = 0
                        Count = 0
            End If
Loop
CurTime = Now
Do While Count <= 1
            If Count = 1 Then
                        Set w = ws.OpenTextFile(WarningFile, ForAppending,True)
'                       w.Writeline ("<th bgcolor=" & Chr(34) & strbgcolor & Chr(34) & ""& "colspan=6 width=100%><font size=1 color=white font=" & fstyle & ""& "> finished processing at " & CurTime & "</font></tr></table></html>")
                        w.close
                        Set w = ws.OpenTextFile(WarningFile, ForReading, False, TristateUseDefault) 
            ElseIf Count = 0 Then                                            
                        Set w = ws.OpenTextFile (OutputFile, ForAppending, True)
'                       w.Writeline ("<th bgcolor=" & Chr(34) & strbgcolor & Chr(34) & ""& "colspan=6 width=100%><font size=1 color=white font=" & fstyle & ""& "> finished processing at " & CurTime & "</font></tr></table></html>")
                        w.close
                        Set w = ws.OpenTextFile(OutputFile, ForReading, False, TristateUseDefault) 
            End If                                                           
            Count = Count + 1
            strMessage = w.ReadAll
            w.close
loop
If Silent = 0 Then
            Command = OutputFile
            WshShell.Run Command,1,False
End If
Call EmailFile
 
Function Writelines
			
            If Count = 1 Then
                        Set w = ws.OpenTextFile (WarningFile, ForAppending, True)
            ElseIf Count = 0 Then 
                        Set w = ws.OpenTextFile (OutputFile, ForAppending, True)
            End If 

		if cnt = 0 Then		
			 
			w.Writeline("<tr bgcolor='#CCCCCC'>")
			w.Writeline("<td width='50%' align='center' colSpan=6><font face='tahoma' color='#003399' size='2'><strong>" & StrComputer & "</strong></font></td>")
			w.Writeline("</tr>")
			w.Writeline("<tr bgcolor='#CCCCCC'><td align=center><B>CPU Usage</B></td><td align=center><B>" & strProPer & "%</B></td><td align=center><B>Memory Usage</B></td><td align=center><B>" & strLinePercentCommittedBytesInUse & "%</B></td></tr>")	
			        w.Writeline ("<TR bgcolor=#CCCCCC>")
                   w.Writeline ("<TD align=center>Computer Name </font></B></TD>")
                    w.Writeline ("<TD align=center>Drive </font></B></TD>")
                    w.Writeline ("<TD align=center>Total Size </font></B></TD>")
                    w.Writeline ("<TD align=center>Space Used </font></B></TD>")
                        w.Writeline ("<TD align=center>Free Space </font></B></TD>")
                    w.Writeline ("<TD align=center>%Free </font></B></TD>")
        w.Writeline ("</TR>")
			
		end if
							
        w.Writeline ("<TR>")
            w.Writeline ("<TD ><font face="_
            & "" & fstyle & "  size=2>" & strComputer & "</font></TD>")
        w.Writeline ("<TD  align=center><font face="_
            & "" & fstyle & "  size=2>" & strDiskDrive & "</font></TD>")
        w.Writeline ("<TD  align=center><font face="_
        & "" & fstyle & "  size=2>" & strDiskSize & " GB </font></TD>")
        w.Writeline ("<TD  align=center><font face="_
        & "" & fstyle & "  size=2>" & strDiskUsed & " GB </font></TD>")
            w.Writeline ("<TD  align=center><font face="_
        & "" & fstyle & "  size=2>" & strDiskFree & " GB </font></TD>")
        w.Writeline ("<TD bgcolor=" & Chr(34)  & strbgcolor & Chr(34) & " align=center><B><font face="_
        & "" & fstyle & "  size=2>" & strPercFree & "% </font></B></TD>")
        w.Writeline ("</TR>")
        w.close
            If Count = 1 Then
                        Count = Count - 1
                        WriteLines
            End If
        strDiskDrive = ""
            strDiskSize = ""
            strDiskUsed = ""
            strPercFree = ""
            strbgcolor = ""
End Function
 
Function CheckFileExists(sFileName)
            Dim FileSystemObject
            Set FileSystemObject = CreateObject("Scripting.FileSystemObject")
            If (FileSystemObject.FileExists(sFileName)) Then
                        CheckFileExists = True
            Else
                        CheckFileExists = False
            End If
            Set FileSystemObject = Nothing
End Function
 
Function EmailFile
            Dim iMsg, iConf, Flds
            Set iMsg = CreateObject("CDO.Message")
            Set iConf = CreateObject("CDO.Configuration")
            Set Flds = iConf.Fields
            With Flds
                        .Item(cdoSendUsingMethod) = cdoSendUsingPort
                        .Item(cdoSMTPServer) = strSMTPServer
                        .Update
            End With
 
            With iMsg
                        Set .Configuration = iConf
                        .To = strMailTo
                        .From = strMailFrom
                        .Subject = strSubject
                        .TextBody = strMessage
            End With
            iMsg.HTMLBody = strMessage
            iMsg.AddAttachment WarningFile 
            iMsg.AddAttachment OutputFile
            iMsg.Send
End Function