# video-streaming-relay

Terraform and Ansible configuration to deploy an AWS EC2 instance optimized for video SRT Streaming. This setup automatically installs srt-tools and creates an "SRT relay" service with the provided parameters. 

  
## 🚀 Features

- **EC2 Instance**: Deploys a t3.small instance (Amazon Linux/Ubuntu based on AMI).
- **Video Toolset**: Configured with srt-tools.
- **Networking**: Creates a VPC on a given Region, subnet, routing table and attaches the EC2 instance to it.
- **Security**: Automated Security Group creation with specific ingress rules for streaming protocols.
- **Automated Key Management**: Generates an RSA 4096-bit SSH key pair locally.
---

## 🛠 Prerequisites

- Terraform installed. [Install terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- Ansible installed. Install python dependencies in `requirements.txt`.
- AWS CLI configured with appropriate permissions.
---

## 📂 Project Structure

- `providers.tf`: Defines the plugins that enable Terraform to interact with AWS
- `ec2.tf`: Defines the instance.
- `vpc.tf`: Defines VPC, subnet, internet gateway, routing table, security groups, and SSH keys.
- `requirements.txt`: Python packages required for this project.
- `ansible/srt-relay`: Ansible playbook which update packet cache, installs srt-tools and creates the "SRT Relay" service.
- `ansible/aws_ec2.yml`: AWS Dynamic Inventory.
- `ansible/ansible.cfg`: Local ansible configuration.
- `ansible/templates/srt-relay.service.j2`: Defines the "SRT Relay" systemd service.
- `ansible/templates/srt-relay.sh.j2`: Defines the script the systemd service run when started.
---

## 🚦 Getting Started

### Setup virtual environment
1. Create virtual environment
```
python -m venv venv
```

2. Activate virtual environment
```
source venv/bin/activate
```

3. Install dependencies
```
pip install -r requirements.txt
```
---

### 🔧 Run Terraform
1. Initialize Terraform

```bash
terraform init
```
  
2. Plan the deployment

```bash
terraform plan -out=srt-relay
```

3. Deploy

```bash
terraform apply srt-relay
```

4. Access the Instance (Do this before running the Ansible playbook)

Terraform will generate a local file named video-relay (the private key). Use it to SSH into your instance:
```bash
chmod 400 video-relay
```
---

## 🔒 Run Ansible Playbook

1. **Test the connection**:

```bash
cd ansible
ansible-inventory -i aws_ec2.yml --graph
```

2. **Run the playbook**:

```bash
ansible-playbook -i aws_ec2.yml srt-relay.yml
```

**Run with specific user** (if different from ubuntu):

```bash
ansible-playbook -i aws_ec2.yml srt-relay.yml -u ec2-user
```

3. **Check service status after deployment**:

```bash
ansible tag_Video_stream_relay -i aws_ec2.yml -m shell -a "systemctl status srt-relay"
```

## 🧹 Clean up
After testing you infrastructure make sure you destroy it to avoid a fat bill.
run the following command inside the main directory:
```bash
terraform destroy -auto-approve
```