Option Explicit

Dim strFile, objGroup, objFSO, objFile, strComputerDN, objComputer, objFSO1, outFile1, objFile1
Dim objRootDSE, strDNSDomain, objTrans, strNetBIOSDomain, strComputer

Const ForReading = 1
' Constants for the NameTranslate object.
Const ADS_NAME_INITTYPE_GC = 3
Const ADS_NAME_TYPE_NT4 = 3
Const ADS_NAME_TYPE_1779 = 1

 
Set objFSO1=CreateObject("Scripting.FileSystemObject")
outFile1="C:\Scripts\Result.txt"
Set objFile1 = objFSO1.CreateTextFile(outFile1,True)

' Specify the text file of computer NetBIOS names.
strFile = "c:\Scripts\Computers.txt"

' Bind to the group object.
Set objGroup = GetObject("LDAP://cn=Mcafee AV Non compliance,cn=computers,dc=Vel,dc=co,dc=in")

' Determine DNS name of domain from RootDSE.
Set objRootDSE = GetObject("LDAP://RootDSE")
strDNSDomain = objRootDSE.Get("defaultNamingContext")

' Use the NameTranslate object to find the NetBIOS domain name from the
' DNS domain name.
Set objTrans = CreateObject("NameTranslate")
objTrans.Init ADS_NAME_INITTYPE_GC, ""
objTrans.Set ADS_NAME_TYPE_1779, strDNSDomain
strNetBIOSDomain = objTrans.Get(ADS_NAME_TYPE_NT4)
' Remove trailing backslash.
strNetBIOSDomain = Left(strNetBIOSDomain, Len(strNetBIOSDomain) - 1)

' Open the file for read access.
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(strFile, ForReading)

' Read each line of the file.
Do Until objFile.AtEndOfStream
    strComputer = Trim(objFile.ReadLine)
    ' Skip blank lines.
    If (strComputer <> "") Then
        ' Use the Set method to specify the NT format of the computer name.
        ' The sAMAccountName of the computer will be the NetBIOS name with trailing "$".
        ' Trap error if computer does not exist.
        On Error Resume Next
        objTrans.Set ADS_NAME_TYPE_NT4, strNetBIOSDomain & "\" & strComputer & "$"
        If (Err.Number <>  0) Then
            On Error GoTo 0
            objFile1.Write "Computer " & strComputer & " does not exist"
        Else
            On Error GoTo 0
            ' Use the Get method to retrieve the Distinguished Name.
            strComputerDN = objTrans.Get(ADS_NAME_TYPE_1779)

            ' Bind to the computer object.
            Set objComputer = GetObject("LDAP://" & strComputerDN)

            ' Check if computer a member of the group.
            If (objGroup.IsMember(objComputer.ADsPath) = False) Then
                ' Add the computer to the group.
                objGroup.Add(objComputer.ADsPath)
            End If
        End If
    End If
Loop

' Clean up.
objFile.Close
objFile1.Close



