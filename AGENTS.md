# cloud-labs-vpn

PiVPN (WireGuard) server on AWS, provisioned via Packer + Terraform.

## Structure

- `packer/` — Packer HCL that builds a `pivpn-base` AMI
  (Ubuntu 22.04 + PiVPN unattended install via `options.conf`).
- `terraform/aws/` — Terraform config that deploys an EC2
  instance from the `pivpn-base` AMI, with a security group
  (SSH 22 + WireGuard 51820/UDP), an Elastic IP, and an
  auto-generated SSH key pair.

## Prerequisites

- AWS credentials configured (env vars or `~/.aws/credentials`)
- Existing VPC tagged `Name=cloud-labs-vpc` with a public
  subnet `10.0.101.0/24` tagged `Tier=Public`
- Terraform backend S3 bucket `pedrin-clabs-tfmodule-kk1`
  and DynamoDB table `pedrin-clterraform-locks` must exist

## Commands

```sh
# 1. Build the AMI (from packer/)
packer init pivpn.pkr.hcl
packer build pivpn.pkr.hcl

# 2. Deploy infrastructure (from terraform/aws/)
terraform init
terraform plan
terraform apply
```

## Important quirks

- `.tfvars` files are gitignored (secrets). Create a
  `terraform/aws/terraform.tfvars` locally to override defaults.
- SSH private key is written to
  `/home/pedroramos/Workspace/ssh_keys/pivpn-key.pem` by a
  `local-exec` provisioner. The path is user-specific —
  adjust if running elsewhere.
- Terraform data sources reference a VPC and subnet by
  specific tags and CIDR. They will fail if the networking
  layout differs.
- PiVPN config is patched at instance boot via `user_data`
  to replace `127.0.0.1` with the instance's public IP.
- Packer source AMI filter picks the latest
  `ubuntu-jammy-22.04` official image owned by
  Canonical (`099720109477`).

## Style conventions

- HashiCorp HCL with `~>` version constraints.
- Resources prefixed with `pivpn_` for naming consistency.
