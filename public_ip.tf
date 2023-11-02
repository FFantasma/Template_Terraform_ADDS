#Create a public IP
resource "azurerm_public_ip" "pub_ip" {
  name                = "adds_dc01_ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"

  #   tags = {
  #     environment = "Production"
  #   }
}