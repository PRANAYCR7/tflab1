variable "rgname" {
    type = string
    description = "used for naming the resource group"
}
variable "rglocation" {
    type = string
    description = "used to select the location"
    default = "eastus"
}
variable "vnet" {
    type = string
    description = "used to select the vnet"
}
variable "subnet" {
    type = string
    description = "used to create a subnet"
}
variable "vnet_address_space" {
   type = string
   description = "used to select the vnet address space"
}
variable "subnet_address_space" {
   type = string
   description = "used to create the subnet address space"
}

