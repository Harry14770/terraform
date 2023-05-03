resource "azurerm_public_ip" "mediawiki_public_ip" {
  name                = "mediawiki-public-ip"
  location            = azurerm_resource_group.mediawiki_rg.location
  resource_group_name = azurerm_resource_group.mediawiki_rg.name
  allocation_method   = "Static"
}

resource "azurerm_network
