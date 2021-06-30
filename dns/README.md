# Manage DNS in Cloudflare using Terraform with Doppler as the source of truth

We want to easily update and manage DNS using Terraform and Cloudflare without having to hard-code a Terraform vars file with secrets locally.

To achieve this, we'll use Doppler in conjunction with a simple script that will fetch our DNS values from Doppler, create a temporary vars file for Terraform to consume, then delete it.

## Doppler as the source of truth for DNS

So we can avoid editing Cloudflare manually, we'll use Terraform to manage all DNS records.

We'll then use Doppler as the source of truth for all DNS records. This is a much nicer solution as opposed to directy editing in Cloudflare, as:

-   Doppler is the single source of truth for Cloudflare access secrets and DNS records
-   Doppler provides tight access control for who can change secrets
-   Doppler provides auditing to track who is making changes and when
-   Doppler provides rollback functionality

# How it works

A Doppler project config is created to house only the variables required for updating Cloudflare DNS.

The secrets stored in the Doppler project config are:

```sh
AWS_CNAME=""
CLOUDFLARE_API_KEY=""
CLOUDFLARE_EMAIL=""
CLOUDFLARE_ZONE_ID=""
PRODUCTION_CNAME=""
STAGING_CNAME=""
```

To be able to access these secrets:

-   Create a service token in Doppler for the Cloudflare DNS specific config
-   Open a terminal and change into the `dns` directory
-   Usig the service token you just created, run `doppler setup --token dp.st.xxxx` to gain read access to the secrets

Now that you can access the secrets, you can execute the `update-dns.sh` script which will pull the secrets from Doppler, store then in `terraform.tfvars`, apply the changes with Terraform, thyen remove `terraform.tfvars` upon completion.

```sh
doppler run ./bin/update-dns.sh
```
