variable "origin" {
  type = object({
    origin_id                = string,
    origin_access_control_id = optional(string)
    domain_name              = string
  })
  default = { origin_id = null, domain_name = null, origin_access_control_id = null }
}

variable "default_root_object" {
  type    = string
  default = null
}

variable "aliases" {
  type    = set(string)
  default = []
}

variable "acm_certificate_arn" {
  type    = string
  default = null
}

