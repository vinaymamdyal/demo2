resource "azurerm_resource_group" "rg" {
    name = "newresource"
    location = "east us"
  
}

resource "azurerm_public_ip" "publicip" {
    name = "publicip"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    allocation_method = "Static"
  
}
resource "azurerm_virtual_network" "vnet" {
    name ="newresource-vnet"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space = ["172.26.0.0/16"]
    dns_servers = ["10.0.0.4","10.0.0.5"]
}
resource "azurerm_subnet" "subnet" {
    name ="prod-subnet"
    virtual_network_name=azurerm_virtual_network.vnet.name
    resource_group_name = azurerm_resource_group.rg.name
    address_prefixes=["172.26.1.0/24"]
    
}

resource "azurerm_subnet" "subnet1" {
    name = "test-subnet"
    virtual_network_name=azurerm_virtual_network.vnet.name
    resource_group_name = azurerm_resource_group.rg.name
    address_prefixes = ["172.26.2.0/24"]
}

resource "azurerm_network_interface" "Nic" {
    name = "nicfornewresource"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    ip_configuration {
      name ="internal"
      subnet_id = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
    }
}
resource "azurerm_windows_virtual_machine" "vm1" {
    name = "virtualmachine"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = "Standard_b2s"
    admin_username = "vinay"
    admin_password = "Welcome@1234"
    network_interface_ids = [azurerm_network_interface.Nic.id,]
  

os_disk{
    caching="ReadWrite"
    storage_account_type="Standard_LRS"

}
source_image_reference{
    publisher="MicrosoftWindowsServer"
    offer="WindowsServer"
    sku="2022-Datacenter"
    version="latest"
}
}
resource "azurerm_managed_disk" "datadisk" {
    name ="datadisk"
    location=azurerm_resource_group.rg.location
    resource_group_name=azurerm_resource_group.rg.name
    storage_account_type="Standard_LRS"
    create_option="Empty"
      disk_size_gb= 20
}
resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
    managed_disk_id = azurerm_managed_disk.datadisk.id
    virtual_machine_id = azurerm_windows_virtual_machine.vm1.id
    lun = "0"
    caching = "ReadWrite"

}