resource "azurerm_resource_group" "rg" {
    name ="${var.prefix}-rg" 
    location = var.location
}
resource "azurerm_public_ip" "publicip" {
    name="${var.prefix}-publicip"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    allocation_method = "Static"
  
}

resource "azurerm_virtual_network" "vnet" {
    name = "${var.prefix}-vnet"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space = ["172.30.0.0/16"]
    dns_servers = ["10.0.0.4" , "10.0.0.5"]
  
}

resource "azurerm_subnet" "subnet" {
    name = "${var.prefix}-prodsubnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["172.30.1.0/24"]

}
resource "azurerm_network_interface" "nic" {
    name = "${var.prefix}-nic"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
ip_configuration {
  name = "internal"
  subnet_id = azurerm_subnet.subnet.id
  private_ip_address_allocation="Dynamic"
}
}
resource "azurerm_network_security_group" "nsg" {
    name="${var.prefix}-nsg"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
  
}
resource "azurerm_network_interface_security_group_association" "nicassocation" {
    network_interface_id = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_windows_virtual_machine" "vm" {
    name = "${var.prefix}-vm"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = "Standard_b2s"
    admin_username = "vinay"
    admin_password = "Welcome@123"
    network_interface_ids = [azurerm_network_interface.nic.id,]


os_disk {
    caching="ReadWrite"
    storage_account_type="Standard_LRS"
}
source_image_reference {
   publisher= "MicrosoftWindowsServer"
    offer ="WindowsServer"
    sku = "2022-Datacenter"
    version = "latest"
}
}