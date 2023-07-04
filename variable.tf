variable "region" {
  type        = string
  description = "Ohio"
  default     = "us-east-2"

}

variable "cloudFront_region" {
  type        = string
  description = "N. Virginia"
  default     = "us-east-1"
}

variable "domain_name" {
  type = string
  default = "marden.in"
}
