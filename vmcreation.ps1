New-AzResourceGroup -Name 'sanvmps' -Location 'centralus'
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name 'mySubnet' -AddressPrefix '192.168.1.0/24'

$vnet = New-AzVirtualNetwork -ResourceGroupName 'sanvmps' -Location 'centralus' -Name "myVNET" -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig

$pip = New-AzPublicIpAddress -ResourceGroupName 'sanvmps' -Location 'centralus' -AllocationMethod Dynamic -IdleTimeoutInMinutes 4 -Name 'mypublicdns'

$nsgRuleSSH = New-AzNetworkSecurityRuleConfig -Name "myNetworkSecurityGroupRuleSSH" -Protocol "Tcp" -Direction "Inbound" -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22 -Access "Allow"

$nsgRuleWeb = New-AzNetworkSecurityRuleConfig -Name "myNetworkSecurityGroupRuleWWW" -Protocol "Tcp" -Direction "Inbound" -Priority 1001 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80 -Access "Allow"

$nsg = New-AzNetworkSecurityGroup -ResourceGroupName 'sanvmps' -Location 'centralus' -Name "myNetworkSecurityGroup" -SecurityRules $nsgRuleSSH,$nsgRuleWeb

$nic = New-AzNetworkInterface -Name "myNic" -ResourceGroupName 'sanvmps' -Location 'centralus' -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

$vmConfig = New-AzVMConfig -VMName "myVM" -VMSize "Standard_D1" | Set-AzVMOperatingSystem -Linux -ComputerName "myVM" -Credential $cred -DisablePasswordAuthentication| Set-AzVMSourceImage -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "16.04-LTS" -Version "latest" | Add-AzVMNetworkInterface -Id $nic.Id

$securePassword = ConvertTo-SecureString 'San-suth@123' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("sandevops", $securePassword)