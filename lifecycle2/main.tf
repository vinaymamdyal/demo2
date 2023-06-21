provider "azurerm" {
    features {
      
    }
  
}

resource "azurerm_resource_group" "rg" {
    name = "powerrabnger"
    location = "east us"
    lifecycle {
      create_before_destroy = true
    }
  
}