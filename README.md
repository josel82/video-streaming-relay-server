# video-streaming-relay

Terraform configuration to deploy an AWS EC2 instance optimized for video streaming tasks. This setup automatically installs ffmpeg, srt-tools, and librist via a startup script.

  
## 🚀 Features

- **EC2 Instance**: Deploys a t2.small instance (Amazon Linux/Ubuntu based on AMI).
- **Video Toolset**: Pre-configured with ffmpeg, srt-tools, and librist.
- **Security**: Automated Security Group creation with specific ingress rules for streaming protocols.
- **Automated Key Management**: Generates an RSA 4096-bit SSH key pair locally.

## 🛠 Prerequisites

- Terraform installed.
- AWS CLI configured with appropriate permissions.
- An existing VPC in your target AWS region.

  
## 📂 Project Structure

- `providers.tf`: Defines the plugins that enable Terraform to interact with AWS
- `ec2.tf`: Defines the instance, security groups, and SSH keys.
- `variables.tf`: Variable definitions (e.g., vpc_id).
- `instance-init.sh`: Shell script to install streaming dependencies.
- `terraform.tfvars`: (Local only) Used to store your specific VPC ID.

## 🚦 Getting Started

1. Initialize Terraform

```bash
terraform init
```

  
2. Configure Variables

Create a terraform.tfvars file in the root directory and add your VPC ID:

```terraform
vpc_id = "vpc-your-id-here"
```


3. Deploy

```bash
terraform apply
```

4. Access the Instance

Terraform will generate a local file named video-relay (the private key). Use it to SSH into your instance:


```bash
chmod 400 video-relay
ssh -i "video-relay" ec2-user@<instance-public-ip>
```

## 🔒 Security & Ports

The following ports are opened by default:

- 22 (TCP): SSH Access.
- 5000 (UDP): General Purpose Inbound Stream.
- 5022 (UDP): Secondary Inbound Stream / Management.