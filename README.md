# cloud-labs-vpn

PiVPN (WireGuard) server on AWS, provisioned via Packer + Terraform.

## Usage

```sh
# 1. Build the AMI
cd packer/
packer init pivpn.pkr.hcl
packer build pivpn.pkr.hcl

# 2. Deploy the infrastructure
cd ../terraform/aws/
terraform init
terraform plan
terraform apply
```

The AMI is built with PiVPN pre-installed (unattended). Terraform
then launches an EC2 instance from that AMI with a public Elastic
IP, security group, and auto-generated SSH key.

See [AGENTS.md](AGENTS.md) for detailed prerequisites and quirks.
