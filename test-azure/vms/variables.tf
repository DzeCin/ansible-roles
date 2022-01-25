variable "nics" {
  type = list(object({
        name = string
        ipconfname   = string
    }))
}