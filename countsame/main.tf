resource "azurerm_resource_group" "rg" {
    name = "IBM"
    location = "east us"
  
}
resource "azurerm_virtual_network" "vnet" {
    name ="IBM-vnet"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space = ["172.30.0.0/16"]
    dns_servers = ["10.0.0.4","10.0.0.5"]
}
resource "azurerm_subnet" "subnet" {
 name = "prodsubnet" 
resource_group_name = azurerm_resource_group.rg.name
virtual_network_name = azurerm_virtual_network.vnet.name
address_prefixes = ["172.30.1.0/24"]
}
resource "azurerm_network_interface" "nic" {
    count = 2
    name = "nic${count.index}"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
      name="internal"
      subnet_id = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
    }
}
resource "azurerm_windows_virtual_machine" "vm" {
    count = 2
    name= "myVM${count.index}"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = "Standard_b2S"
    admin_username = "admin100"
    admin_password = "Welcome@1234"
    network_interface_ids = [azurerm_network_interface.nic.*.id[count.index],]
                            
  
  os_disk {
    caching = "ReadWrite"
    storage_account_type="Standard_LRS"
  }
  source_image_reference {
    publisher = "Microsoftwindowsserver"
    offer = "windowsserver"
    sku = "2022-Datacenter"
    version = "latest"
  }
}
