variable "vpc_id" {
}

variable "sg_name" {
}

variable "description" {
}

variable "rules" {
  description = "Maps of Ingress Rules"
  type        = any
  default     = {}
}
