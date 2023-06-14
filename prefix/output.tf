output "rg" {

    value = azurerm_resource_group.rg.id
  
}

output "vnet" {

    value = azurerm_virtual_network.vnet.id
  
}

output "snet" {

    value = azurerm_subnet.subnet.name
  
}