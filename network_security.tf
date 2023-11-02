#create a Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "NSG-LAB-AZ800"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  security_rule {
    name                       = "AllowAnyRDPInbound_10.10.1.4"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "201.17.120.94"
    destination_address_prefix = "10.10.1.4"

  }

  #   tags = {
  #     environment = "Production"
  #   }
}

#Associating an NSG with a subnet
resource "azurerm_subnet_network_security_group_association" "mgmt-nsg-association" {
  subnet_id                 = azurerm_subnet.subnet_adds01.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}