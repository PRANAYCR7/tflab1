variable "rgname" {
    type = string
    description = "used for naming the resource group"
}

variable "rglocation" {
    type = string
    description = "used to select the location"
    defualt = "eastus"
}
variable "pranayvnet" {
    type = string
    description = "used to select the vnet"
}
variable "pranaysubnet" {
    type = string
    description = "used to create a subnet"
}
