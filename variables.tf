variable "rgname" {
    type = string
    description = "used for naming the resource group"
}

variable "rglocation" {
    type = string
    description = "used to select the location"
    defualt = "eastus"
}
variable "vnet" {
    type = string
    description = "used to select the vnet"
}
variable "subnet" {
    type = string
    description = "used to create a subnet"
}
