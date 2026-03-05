In an interview for a DevOps Engineer with 3 years of experience, especially in 2025, it’s important to test both their conceptual understanding and practical ability to write and implement Terraform scripts. The following set of questions includes both direct and scenario-based questions.

### 1. **Basic Infrastructure Setup**
   - **Script**: Write a Terraform script to provision an EC2 instance on AWS using an Amazon Linux AMI with a specific instance type (e.g., `t2.micro`) and attach a security group to it.
   - **Follow-up**: Explain the components of this script, and how would you modify it to use a custom AMI ID instead of the default?

### 2. **VPC Creation**
   - **Script**: Create a basic VPC with 2 public subnets, 2 private subnets, and an internet gateway in AWS using Terraform.
   - **Follow-up**: How would you ensure the private subnets do not have direct internet access?

### 3. **IAM Role and Policy**
   - **Script**: Write a Terraform script to create an IAM role with a custom policy that allows access to S3 and EC2 resources.
   - **Follow-up**: How would you attach this IAM role to an EC2 instance created by Terraform?

### 4. **Security Groups**
   - **Script**: Write a Terraform script to create a security group allowing HTTP, HTTPS, and SSH traffic on a specific EC2 instance in AWS.
   - **Follow-up**: How would you restrict the SSH access to only a specific IP range (e.g., your office IP)?

### 5. **S3 Bucket**
   - **Script**: Write a Terraform script to create an S3 bucket that is versioned and encrypted using AWS KMS.
   - **Follow-up**: How would you set up lifecycle rules for this S3 bucket to transition older objects to Glacier storage?

### 6. **Load Balancer and Auto Scaling**
   - **Script**: Write a Terraform script to set up an Application Load Balancer (ALB) in AWS with an Auto Scaling group for scaling EC2 instances.
   - **Follow-up**: How would you configure the health check for the ALB and Auto Scaling group?

### 7. **RDS Instance**
   - **Script**: Create a Terraform script to provision a PostgreSQL RDS instance in a private subnet within the VPC.
   - **Follow-up**: How would you configure RDS backups and multi-AZ deployment using Terraform?

### 8. **Terraform Modules**
   - **Scenario**: You have been tasked with reusing some of your Terraform resources in multiple environments (dev, staging, prod). How would you organize this using modules?
   - **Follow-up**: Can you demonstrate with an example of how you would write a module for creating an EC2 instance?

### 9. **Provisioners**
   - **Script**: Write a Terraform script to launch an EC2 instance and use a `remote-exec` provisioner to run a shell script on the instance after it is launched.
   - **Follow-up**: What are the potential drawbacks of using provisioners in Terraform, and how would you mitigate them?

### 10. **State Management**
   - **Scenario**: You are working in a team, and the Terraform state is stored remotely using an S3 bucket with DynamoDB for locking. How would you set this up in Terraform?
   - **Follow-up**: How do you handle sensitive data in the Terraform state file?

### 11. **CloudWatch Monitoring**
   - **Script**: Write a Terraform script to set up CloudWatch alarms for monitoring an EC2 instance’s CPU utilization, and trigger an alert if it exceeds 80% for 5 minutes.
   - **Follow-up**: How would you integrate this alert with an SNS topic to send notifications?

### 12. **Elastic File System (EFS)**
   - **Script**: Write a Terraform script to create an EFS file system in AWS and mount it to EC2 instances in a VPC.
   - **Follow-up**: How would you configure access points and security groups for EFS in this scenario?

### 13. **Terraform Workspaces**
   - **Scenario**: You are managing multiple environments (dev, staging, prod) and want to use Terraform workspaces for environment isolation. How would you configure this in your Terraform setup?
   - **Follow-up**: What are some potential issues with using workspaces for multi-environment deployments?

### 14. **Secrets Management**
   - **Script**: Write a Terraform script to securely fetch a secret from AWS Secrets Manager and pass it as an environment variable to an ECS task definition.
   - **Follow-up**: How would you handle sensitive data (e.g., API keys) using Terraform?

### 15. **Kubernetes Cluster Setup**
   - **Script**: Write a Terraform script to set up an EKS (Elastic Kubernetes Service) cluster with a node group.
   - **Follow-up**: How would you configure IAM permissions for your Kubernetes nodes to access other AWS services (e.g., S3, DynamoDB)?

### Bonus Questions (Advanced)

- **Version Control & CI/CD Integration**: How would you integrate Terraform with a CI/CD pipeline (e.g., GitLab, GitHub Actions, or Jenkins) for automated infrastructure deployment?
  
- **State Locking and Collaboration**: How would you manage Terraform state when multiple engineers are working on the same project, ensuring no race conditions occur when applying changes?

These questions cover a range of Terraform-related topics such as infrastructure provisioning, security, scalability, and collaboration. They should help assess the candidate’s technical skills, problem-solving abilities, and experience in a real-world environment.



### 1. **Basic EC2 Instance Creation**

**Module Structure**:
```bash
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    └── ec2_instance/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

**`modules/ec2_instance/main.tf`**:
```hcl
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  security_groups = var.security_groups

  tags = {
    Name = var.instance_name
  }
}

```

**`variables.tf`**:
```hcl
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "security_groups" {
  description = "List of security groups"
  type        = list(string)
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}
```

**`main.tf`**:
```hcl
module "ec2_instance" {
  source         = "./modules/ec2_instance"
  ami_id         = "ami-0abcdef1234567890"
  instance_type  = "t2.micro"
  security_groups = ["default"]
  instance_name  = "my-instance"
}
```

### 2. **VPC Creation**

**`modules/vpc/main.tf`**:
```hcl
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true
}
```

**`variables.tf`**:
```hcl
variable "cidr_block" {
  type        = string
  description = "CIDR block for VPC"
}

variable "public_subnet_1_cidr" {
  type        = string
  description = "CIDR block for public subnet 1"
}

variable "public_subnet_2_cidr" {
  type        = string
  description = "CIDR block for public subnet 2"
}

variable "az1" {
  type        = string
  description = "Availability Zone 1"
}

variable "az2" {
  type        = string
  description = "Availability Zone 2"
}
```

**`main.tf`**:
```hcl
module "vpc" {
  source                    = "./modules/vpc"
  cidr_block                = "10.0.0.0/16"
  public_subnet_1_cidr      = "10.0.1.0/24"
  public_subnet_2_cidr      = "10.0.2.0/24"
  az1                       = "us-east-1a"
  az2                       = "us-east-1b"
}
```

### 3. **IAM Role and Policy**

**`modules/iam_role/main.tf`**:
```hcl
resource "aws_iam_role" "example" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "example" {
  name        = var.policy_name
  description = var.policy_description
  policy      = var.policy_document
}

resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = aws_iam_policy.example.arn
  role       = aws_iam_role.example.name
}
```

**`variables.tf`**:
```hcl
variable "role_name" {
  type        = string
  description = "IAM Role name"
}

variable "assume_role_policy" {
  type        = string
  description = "The trust relationship policy"
}

variable "policy_name" {
  type        = string
  description = "IAM Policy name"
}

variable "policy_description" {
  type        = string
  description = "IAM Policy description"
}

variable "policy_document" {
  type        = string
  description = "IAM policy document in JSON format"
}
```

**`main.tf`**:
```hcl
module "iam_role" {
  source                = "./modules/iam_role"
  role_name             = "my-role"
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  policy_name           = "my-policy"
  policy_description    = "Allows EC2 and S3 access"
  policy_document       = data.aws_iam_policy_document.allow_ec2_s3.json
}
```

### 4. **Security Group**

**`modules/security_group/main.tf`**:
```hcl
resource "aws_security_group" "example" {
  name_prefix = var.sg_name

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_access_cidr
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

**`variables.tf`**:
```hcl
variable "sg_name" {
  type        = string
  description = "Security group name prefix"
}

variable "ssh_access_cidr" {
  type        = list(string)
  description = "CIDR block for SSH access"
}
```

**`main.tf`**:
```hcl
module "security_group" {
  source             = "./modules/security_group"
  sg_name            = "web-sg"
  ssh_access_cidr    = ["10.0.0.0/24"]
}
```

### 5. **S3 Bucket**

**`modules/s3_bucket/main.tf`**:
```hcl
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
```

**`variables.tf`**:
```hcl
variable "bucket_name" {
  type        = string
  description = "S3 Bucket name"
}
```

**`main.tf`**:
```hcl
module "s3_bucket" {
  source       = "./modules/s3_bucket"
  bucket_name  = "my-secure-bucket"
}
```

### 6. **Load Balancer & Auto Scaling**

**`modules/alb_and_asg/main.tf`**:
```hcl
resource "aws_lb" "example" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
}

resource "aws_autoscaling_group" "example" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  launch_configuration = aws_launch_configuration.example.id
}
```

**`variables.tf`**:
```hcl
variable "lb_name" {
  description = "Load balancer name"
  type        = string
}

variable "security_groups" {
  description = "Security group IDs"
  type        = list(string)
}

variable "subnets" {
  description = "Subnets for the load balancer"
  type        = list(string)
}
```

**`main.tf`**:
```hcl
module "alb_and_asg" {
  source          = "./modules/alb_and_asg"
  lb_name         = "my-app-lb"
  security_groups = ["sg-01234567"]
  subnets         = ["subnet-01234567", "subnet-01234568"]
}
```

---

### 7. **RDS Instance**

**`modules/rds_instance/main.tf`**:
```hcl
resource "aws_db_instance" "example" {
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  db_instance_class    = var.db_instance_class
  engine               = "postgres"
  engine_version       = var.engine_version
  db_name              = var.db_name
  username             = var.username
  password             = var.password
  backup_retention_period = var.backup_retention_period
  multi_az             = var.multi_az
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name = var.db_subnet_group_name
  tags = {
    Name = var.db_name
  }
}
```

**`variables.tf`**:
```hcl
variable "allocated_storage" {
  description = "The size of the DB instance storage (in GB)"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "The storage type"
  type        = string
  default     = "gp2"
}

variable "db_instance_class" {
  description = "The DB instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "13.3"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "username" {
  description = "The master username for the database"
  type        = string
}

variable "password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
}

variable "backup_retention_period" {
  description = "The backup retention period in days"
  type        = number
  default     = 7
}

variable "multi_az" {
  description = "Whether to create a Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "Security groups for the DB instance"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "The DB subnet group name"
  type        = string
}
```

**`main.tf`**:
```hcl
module "rds_instance" {
  source                  = "./modules/rds_instance"
  db_name                 = "mydb"
  username                = "admin"
  password                = "supersecret"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_instance_class       = "db.t3.micro"
  engine_version          = "13.3"
  multi_az                = true
  backup_retention_period = 7
  security_group_ids      = ["sg-01234567"]
  db_subnet_group_name    = "my-db-subnet-group"
}
```

### 8. **Terraform Modules**

In this scenario, let's create reusable modules for creating resources like EC2 instances and VPC, which can be reused across multiple environments.

**`modules/vpc/main.tf`**:
```hcl
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
}
```

**`variables.tf`**:
```hcl
variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}
```

**`main.tf`** (Reusable EC2 module):
```hcl
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}
```

### 9. **Provisioners**

**`modules/ec2_with_provisioner/main.tf`**:
```hcl
resource "aws_instance" "example" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = var.security_groups

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello, World!' > /tmp/hello.txt"
    ]

    connection {
      host = aws_instance.example.public_ip
      type = "ssh"
      user = "ec2-user"
      private_key = var.private_key
    }
  }

  tags = {
    Name = var.instance_name
  }
}
```

**`variables.tf`**:
```hcl
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "security_groups" {
  description = "Security groups"
  type        = list(string)
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "private_key" {
  description = "Private key to connect to the EC2 instance"
  type        = string
  sensitive   = true
}
```

**`main.tf`**:
```hcl
module "ec2_with_provisioner" {
  source         = "./modules/ec2_with_provisioner"
  ami_id         = "ami-0abcdef1234567890"
  instance_type  = "t2.micro"
  security_groups = ["default"]
  instance_name  = "my-ec2-instance"
  private_key    = file("~/.ssh/my-private-key.pem")
}
```

### 10. **State Management**

**`modules/s3_backend/main.tf`**:
```hcl
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}

resource "aws_dynamodb_table" "example" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
```

**`variables.tf`**:
```hcl
variable "bucket_name" {
  description = "The S3 bucket name"
  type        = string
}

variable "table_name" {
  description = "The DynamoDB table name"
  type        = string
}
```

**`main.tf`**:
```hcl
module "s3_backend" {
  source      = "./modules/s3_backend"
  bucket_name = "my-terraform-state-bucket"
  table_name  = "terraform-lock-table"
}
```

### 11. **CloudWatch Monitoring**

**`modules/cloudwatch_alarm/main.tf`**:
```hcl
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = var.alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors high CPU utilization"
  dimensions = {
    InstanceId = var.instance_id
  }

  actions_enabled = true
}

resource "aws_sns_topic" "example" {
  name = var.sns_topic_name
}
```

**`variables.tf`**:
```hcl
variable "alarm_name" {
  description = "The name of the CloudWatch alarm"
  type        = string
}

variable "instance_id" {
  description = "The EC2 instance ID to monitor"
  type        = string
}

variable "sns_topic_name" {
  description = "SNS topic name for notifications"
  type        = string
}
```

**`main.tf`**:
```hcl
module "cloudwatch_alarm" {
  source          = "./modules/cloudwatch_alarm"
  alarm_name      = "High-CPU-Utilization"
  instance_id     = "i-0123456789abcdef0"
  sns_topic_name  = "high-cpu-alerts"
}
```

### 12. **Elastic File System (EFS)**

**`modules/efs/main.tf`**:
```hcl
resource "aws_efs_file_system" "example" {
  creation_token = var.creation_token
  performance_mode = "generalPurpose"
}

resource "aws_security_group" "efs_sg" {
  name_prefix = var.security_group_name
}

resource "aws_security_group_rule" "efs_ingress" {
  type        = "ingress"
  from_port   = 2049
  to_port     = 2049
  protocol    = "tcp"
  cidr_blocks = var.cidr_blocks
  security_group_id = aws_security_group.efs_sg.id
}
```

**`variables.tf`**:
```hcl
variable "creation_token" {
  description = "Unique creation token"
  type        = string
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
}

variable "cidr_blocks" {
  description = "List of CIDR blocks for EFS access"
  type        = list(string)
}
```

**`main.tf`**:
```hcl
module "efs" {
  source           = "./modules/efs"
  creation_token   = "my-efs-token"
  security_group_name = "efs-sg"
  cidr_blocks      = ["10.0.0.0/24"]
}
```

### 13. **Terraform Workspaces**

**`modules/workspace_setup/main.tf`**:
```hcl
resource "aws_s3_bucket" "workspace" {
  bucket = "terraform-workspace-${terraform.workspace}"
}
```

**`main.tf`**:
```hcl
module "workspace_setup" {
  source = "./modules/workspace_setup"
}

terraform {
  backend "s3" {
    bucket = "my-terraform-workspace"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}
```

### 14. **Secrets Management**

**`modules/secrets_manager/main.tf`**:
```hcl
resource "aws_secretsmanager_secret" "example" {
  name        = var.secret_name
  description = "My secret API key"
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = var.secret_string
}
```

**`variables.tf`**:
```hcl
variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "secret_string" {
  description = "The secret value"
  type        = string
  sensitive   = true
}
```

**`main.tf`**:
```hcl
module "secrets_manager" {
  source         = "./modules/secrets_manager"
  secret_name    = "my-api-key"
  secret_string  = "super-secret-api-key-value"
}
```

### 15. **Kubernetes Cluster Setup**

**`modules/eks/main.tf`**:
```hcl
resource "aws_eks_cluster" "example" {
  name     = var.cluster_name
  role_arn = var.role_arn
  vpc_config {
    subnet_ids = var.subnet_ids
  }
}
```

**`variables.tf`**:
```hcl
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets to associate with the EKS cluster"
  type        = list(string)
}
```

**`main.tf`**:
```hcl
module "eks" {
  source      = "./modules/eks"
  cluster_name = "my-eks-cluster"
  role_arn    = "arn:aws:iam::123456789012:role/EKSClusterRole"
  subnet_ids  = ["subnet-01234567", "subnet-01234568"]
}
```

---

With these 15 Terraform modules, you can provision a wide range of infrastructure components. The goal here is to create reusable, modular configurations that will work across multiple environments and scenarios. Feel free to adjust variables, resources, and configurations based on your specific infrastructure needs!