terraform {
  required_version = ">=0.13.0"

  required_providers {
    aws = {}
    cloudflare = {
      source = "terraform-providers/cloudflare"
    }
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

resource "cloudflare_record" "staging" {
  count = var.staging_cname != "" ? 1 : 0

  zone_id = var.cloudflare_zone_id
  name    = "staging"
  value   = var.staging_cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "production" {
  count = var.production_cname != "" ? 1 : 0

  zone_id = var.cloudflare_zone_id
  name    = ""
  value   = var.production_cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "aws" {
  count = var.aws_cname != "" ? 1 : 0

  zone_id = var.cloudflare_zone_id
  name    = "aws"
  value   = var.aws_cname
  type    = "CNAME"
  proxied = true
}