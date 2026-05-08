# Terraform AWS Infrastructure

Production-style AWS infrastructure provisioning using Terraform with dynamic variables, data sources, locals, lifecycle rules, outputs, and reusable configurations.

---

# 🚀 Features

- Custom VPC creation
- Public subnet provisioning
- Internet Gateway and Route Table setup
- Security Group with dynamic ingress rules
- EC2 instance deployment
- Dynamic Amazon Linux 2 AMI lookup using data sources
- Availability Zone discovery
- Terraform variables and tfvars support
- Locals for reusable naming and tagging
- Conditional expressions for environment-specific configurations
- Terraform outputs
- Lifecycle rules (`create_before_destroy`)
- Explicit and implicit dependency management
- Dynamic tagging strategy
- S3 bucket creation for application logs

---

# 🏗️ Infrastructure Architecture

```text
VPC
│
├── Public Subnet
│
├── Internet Gateway
│
├── Route Table
│
├── Security Group
│
├── EC2 Instance
│
└── S3 Bucket
```

---

# 📁 Project Structure

```text
terraform-aws-infra/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── providers.tf
├── terraform.tfvars
├── .gitignore
└── README.md
```

---

# ⚙️ Technologies Used

- Terraform
- AWS EC2
- AWS VPC
- AWS S3
- AWS Security Groups
- AWS Route Tables

---

# 📌 Terraform Concepts Covered

## Variables

- String variables
- List variables
- Map variables
- Default values
- Environment-specific configurations

## Data Sources

- `aws_ami`
- `aws_availability_zones`

## Locals

- Reusable naming patterns
- Common tagging strategies

## Functions

- `merge()`
- `lookup()`
- `format()`
- `join()`
- `cidrsubnet()`

## Conditional Expressions

```hcl
instance_type = var.environment == "prod" ? "t3.small" : "t2.micro"
```

## Lifecycle Rules

```hcl
lifecycle {
  create_before_destroy = true
}
```

## Dependency Management

- Implicit dependencies
- Explicit dependencies using `depends_on`

---

# 🔧 Prerequisites

Before running this project, ensure you have:

- AWS Account
- Terraform installed
- AWS CLI configured
- Git installed

---

# 📥 Installation

## Clone Repository

```bash
git clone https://github.com/teja-afk/terraform-aws-infra.git

cd terraform-aws-infra
```

---

# 🔑 Configure AWS Credentials

```bash
aws configure
```

Provide:

- AWS Access Key
- AWS Secret Key
- Region
- Output format

---

# 🛠️ Initialize Terraform

```bash
terraform init
```

---

# 📋 Validate Configuration

```bash
terraform validate
```

---

# 🔍 Preview Infrastructure Changes

```bash
terraform plan
```

---

# 🚀 Deploy Infrastructure

```bash
terraform apply
```

---

# 🧹 Destroy Infrastructure

```bash
terraform destroy
```

---

# 📤 Terraform Outputs

After deployment:

```bash
terraform output
```

Example outputs:

- VPC ID
- Subnet ID
- EC2 Public IP
- Security Group ID
- Public DNS

---

# 📄 Example terraform.tfvars

```hcl
project_name = "terraweek"

environment = "dev"

region = "ap-south-1"

extra_tags = {
  Owner = "Teja"
  Team  = "DevOps"
}
```

---

# 🏷️ Tagging Strategy

Every resource is tagged consistently using locals.

Example:

```text
Project     = terraweek
Environment = dev
ManagedBy   = Terraform
```

---

# 🔒 Security Notes

This repository ignores:

- `.terraform/`
- `*.tfstate`
- `*.tfvars`

using `.gitignore` to avoid leaking:

- credentials
- provider binaries
- infrastructure state

---

# 📚 Learning Outcomes

Through this project, I practiced:

- Infrastructure as Code (IaC)
- Terraform workflows
- Dynamic Terraform configurations
- AWS networking fundamentals
- Dependency management
- Terraform lifecycle rules
- Modular and reusable infrastructure design

---

# 📌 Future Improvements

- Multi-AZ deployment
- Auto Scaling Group
- Load Balancer
- RDS integration
- Remote Terraform state using S3 + DynamoDB
- Terraform modules
- CI/CD integration with GitHub Actions

---

# 🔗 GitHub Repository

[terraform-aws-infra](https://github.com/teja-afk/terraform-aws-infra)

---

# 👨‍💻 Author

### Teja Poosa

Learning and building in:

- DevOps
- Cloud Computing
- Terraform
- Kubernetes
- AWS
