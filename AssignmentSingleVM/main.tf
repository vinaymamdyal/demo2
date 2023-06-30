provider "azurerm" {
  features {
    
  }
}

resource "azurerm_resource_group" "RG" {
  name = "singlevm"
  location = "west us 3"
}
resource "azurerm_public_ip" "pip" {
    name = "single-pip"
    location = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
    allocation_method = "Dynamic"

}
resource "azurerm_virtual_network" "vnet" {
    name ="single-vnet"
    location = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
    address_space = ["172.30.0.0/16"]
  
}
resource "azurerm_subnet" "subnet" {
    name = "prod-subnet"
    resource_group_name = azurerm_resource_group.RG.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["172.30.1.0/24"]
  
}
resource "azurerm_network_interface" "nic" {
    name = "singlevm-nic"
    location = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
    ip_configuration {
      name ="internal"
      subnet_id = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Static"
      public_ip_address_id = azurerm_public_ip.pip.id
    }
}
resource "random_string" "randomstring" {
    length = 16
    upper = true 
    lower = true
    special = true 
     
  
}
resource "azurerm_windows_virtual_machine" "Vm" {
 name = "vm1"
 location = azurerm_resource_group.RG.location
 resource_group_name = azurerm_resource_group.RG.name
 size = "Standard_b2s"
 admin_username = "admin100"
 admin_password = random_string.randomstring.result
 network_interface_ids = [azurerm_network_interface.nic.id]
 
 os_disk {
   caching = "ReadWrite"
   storage_account_type = "Standard_LRS"
 }
source_image_reference  = {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-Datacenter"
    version = "lastest"

 }
  
}