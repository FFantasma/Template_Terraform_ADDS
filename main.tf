#Creates the Azure VM
resource "azurerm_windows_virtual_machine" "dc01" {
  name                = "VM-ADDS-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = var.win_username
  admin_password      = var.win_userpass
  network_interface_ids = [
    azurerm_network_interface.dc01_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

#Creates the Azure Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "VNET-ADDS-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.10.0.0/16"]
}

#Creates the subnet
resource "azurerm_subnet" "subnet_adds01" {
  name                 = "SUBNET-ADDS-01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

#Creates a vNIC for the VM
resource "azurerm_network_interface" "dc01_nic" {
  name                = "adds_dc01_nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "adds_dc01_nic"
    subnet_id                     = azurerm_subnet.subnet_adds01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pub_ip.id
  }
}

#Install Active Directory on the DC01 VM
resource "azurerm_virtual_machine_extension" "install_ad" {
  name = "install_ad"
  #  resource_group_name  = azurerm_resource_group.main.name
  virtual_machine_id   = azurerm_windows_virtual_machine.dc01.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<SETTINGS
  {    
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.ADDS.rendered)}')) | Out-File -filepath ADDS.ps1\" && powershell -ExecutionPolicy Unrestricted -File ADDS.ps1 -Domain_DNSName ${data.template_file.ADDS.vars.Domain_DNSName} -Domain_NETBIOSName ${data.template_file.ADDS.vars.Domain_NETBIOSName} -SafeModeAdministratorPassword ${data.template_file.ADDS.vars.SafeModeAdministratorPassword}"
  }
  SETTINGS
}

#Variable input for the ADDS.ps1 script
data "template_file" "ADDS" {
  template = file("ADDS.ps1")
  vars = {
    Domain_DNSName                = "${var.Domain_DNSName}"
    Domain_NETBIOSName            = "${var.netbios_name}"
    SafeModeAdministratorPassword = "${var.SafeModeAdministratorPassword}"
  }
}