terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0" 
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

variable "ghcr_username" {
  type        = string
  description = ""
}

variable "ghcr_pat" {
  type        = string
  description = ""
  sensitive   = true
}


resource "azurerm_resource_group" "rg" {
  name     = "rg-portfolio-devops-novo"
  location = "East US 2"
}


resource "azurerm_container_group" "aci" {
  name                = "aci-portfolio-site"
  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  os_type         = "Linux"
  ip_address_type = "Public"
  
  dns_name_label  = "port-tf-2025" 

  image_registry_credential {
    server   = "ghcr.io"
    username = var.ghcr_username
    password = var.ghcr_pat
  }

  container {
    name   = "site-container"
    image  = "ghcr.io/gravity22222/startbootstrap-resume:master"
    cpu    = "0.5"
    memory = "0.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    environment = "portfolio"
    project     = "devops"
  }
}

output "site_url" {
  value = azurerm_container_group.aci.fqdn
}