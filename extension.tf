# Azure Monitor Agent - will eventually completely replace the legacy Log Analytics Agent
resource "azurerm_virtual_machine_extension" "vmext_ama" {
  #   count                      = length(azurerm_windows_virtual_machine.avd_vm)
  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.dc01.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
  #   depends_on                 = [
  #     azurerm_virtual_machine_extension.vmext_guest,
  #     azurerm_virtual_machine_extension.vmext_oms,
  #   ]
  lifecycle {
    ignore_changes = [tags]
  }

  tags = {
    ambiente = "SC-300"
  }
}