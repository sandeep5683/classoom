$resourcegroup = New-AzResourceGroup -name "Sannetwork" -location "centralus"
$websubnet = New-AzVirtualNetworkSubnetConfig -Name 'web' -AddressPrefix '10.10.0.0/24'
$datasubnet = New-AzVirtualNetworkSubnetConfig -Name 'data' -AddressPrefix '10.10.1.0/24'
$vnet = New-AzVirtualNetwork -Name 'sanwork' -ResourceGroupName $resourcegroup.ResourceGroupName -Location $resourcegroup.Location -AddressPrefix '10.10.0.0/16' -Subnet $websubnet,$datasubnet
Add-AzVirtualNetworkSubnetConfig -Name 'business'  -VirtualNetwork $vnet -AddressPrefix '10.10.2.0/24'|Set-AzVirtualNetwork
Add-AzVirtualNetworkSubnetConfig -Name 'management' -VirtualNetwork $vnet -AddressPrefix '10.10.3.0/24'|Set-AzVirtualNetwork

Add-AzVirtualNetworkSubnetConfig -Name 'dummy' -VirtualNetwork $vnet -AddressPrefix '10.10.100.0/24' |Set-AzVirtualNetwork

$nsg = New-AzNetworkSecurityGroup -Name 'vmnsgps3' -ResourceGroupName 'vmdemo' -Location 'centralus'
Get-AzNetworkSecurityGroup -Name 'vmnsgps1' -ResourceGroupName 'vmdemo'|Add-AzNetworkSecurityRuleConfig -name 'rule2' -priority '310' -access 'allow' -description 'allow hhtp' -DestinationAddressPrefix '*' -SourceAddressPrefix '*' -destinationportrange '80' -direction 'inbound' -protocol 'tcp' -sourceportrange '*'|Set-AzNetworkSecurityGroup