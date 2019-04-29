#NTMS
$cred=Get-Credential
$RG=Read-host "RG Name"
Write-Host "Select RG Location name"
$location=(
    Get-AzLocation |
    Sort-Object -Property Location |
    Select-Object -Property Location, Displayname |
    Out-GridView -OutputMode Single -Title 'Select an Azure Region'
).Location
Write-Host "Select First VM Location name"
$location1=(
    Get-AzLocation |
    Sort-Object -Property Location |
    Select-Object -Property Location, Displayname |
    Out-GridView -OutputMode Single -Title 'Select an Azure Region'
).Location
Write-Host "Select Second VM Location name"
$location2 = (
    Get-AzLocation |
    Sort-Object -Property Location |
    Select-Object -Property Location, Displayname |
    Out-GridView -OutputMode Single -Title 'Select an Azure Region'
).Location
Write-Host "Select third VM Location name"
$location3 = (
    Get-AzLocation |
    Sort-Object -Property Location |
    Select-Object -Property Location, Displayname |
    Out-GridView -OutputMode Single -Title 'Select an Azure Region'
).Location
$firstvm=Read-host "Enter first VM name"
$secondvm=Read-host "Enter second VM name"
$thirdvm=Read-host "Enter third VM name"
New-AzResourceGroup -Name $RG -Location $location
new-azvm -Name $firstvm -ResourceGroupName $RG -Location $location1 -Credential $cred -VirtualNetworkName vnet1 -AddressPrefix 10.1.0.0/16 -SubnetName websubnet -SubnetAddressPrefix 10.1.1.0/24 -Image Win2016Datacenter -PublicIpAddressName ntms-$firstvm-publicip -OpenPorts 80,3389 -Size Standard_B2MS -asjob
new-azvm -Name $secondvm -ResourceGroupName $RG -Location $location2 -Credential $cred -VirtualNetworkName vnet2 -AddressPrefix 10.2.0.0/16 -SubnetName websubnet -SubnetAddressPrefix 10.2.1.0/24 -Image Win2016Datacenter -PublicIpAddressName ntms-$secondvm-publicip -OpenPorts 80,3389 -Size Standard_B2MS -asjob 
new-azvm -Name $thirdvm -ResourceGroupName $RG -Location $location3 -Credential $cred -VirtualNetworkName vnet3 -AddressPrefix 10.3.0.0/16 -SubnetName websubnet -SubnetAddressPrefix 10.3.1.0/24 -Image Win2016Datacenter -PublicIpAddressName ntms-$thirdvm-publicip -OpenPorts 80,3389 -Size Standard_B2MS -AsJob
get-azvm -ResourceGroupName $RG | %{Set-AzVMExtension -ResourceGroupName $RG -ExtensionName "IIS" -VMName $_.Name -Location $_.Location -Publisher Microsoft.Compute -ExtensionType CustomScriptExtension -TypeHandlerVersion 1.8 -asjob -SettingString '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)}'}