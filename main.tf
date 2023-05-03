provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "mediawiki_rg" {
  name     = "mediawiki-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "mediawiki_vnet" {
  name                = "mediawiki-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mediawiki_rg.location
  resource_group_name = azurerm_resource_group.mediawiki_rg.name
}

resource "azurerm_subnet" "mediawiki_subnet" {
  name                 = "mediawiki-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.mediawiki_vnet.name
  resource_group_name  = azurerm_resource_group.mediawiki_rg.name
}

resource "azurerm_network_security_group" "mediawiki_nsg" {
  name                = "mediawiki-nsg"
  location            = azurerm_resource_group.mediawiki_rg.location
  resource_group_name = azurerm_resource_group.mediawiki_rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "mediawiki_public_ip" {
  name                = "mediawiki-public-ip"
  location            = azurerm_resource_group.mediawiki_rg.location
  resource_group_name = azurerm_resource_group.mediawiki_rg.name
  allocation_method   = "Static"
}

resource "azurerm_network
