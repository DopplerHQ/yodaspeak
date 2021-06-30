#! /usr/bin/env bash

# usage: doppler run ./bin/update-dns.sh

# Presumes you have initialized Terraform and configured Doppler using a service token

rm -f terraform.tfvars

echo cloudflare_email = \"${CLOUDFLARE_EMAIL}\" >> terraform.tfvars
echo cloudflare_api_key = \"${CLOUDFLARE_API_KEY}\" >> terraform.tfvars
echo cloudflare_zone_id = \"${CLOUDFLARE_ZONE_ID}\" >> terraform.tfvars

echo aws_cname = \"${AWS_CNAME}\" >> terraform.tfvars
echo staging_cname = \"${STAGING_CNAME}\" >> terraform.tfvars
echo production_cname = \"${PRODUCTION_CNAME}\" >> terraform.tfvars

terraform validate
terraform plan -var-file terraform.tfvars
terraform apply -var-file terraform.tfvars -auto-approve
terraform output

rm -f terraform.tfvars
