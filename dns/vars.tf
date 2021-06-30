
variable "cloudflare_email" {}
variable "cloudflare_api_key" {}
variable "cloudflare_zone_id" {}

variable "staging_cname" {
  default = ""
}
variable "production_cname" {
  default = ""
}
variable "aws_cname" {
  default = ""
}
