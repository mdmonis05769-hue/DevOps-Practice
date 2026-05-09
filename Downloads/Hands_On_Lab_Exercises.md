# AWS DevOps Hands-On Lab Exercises
## Practice Labs for Freshers - 8-10 LPA Target

---

## LAB 1: Infrastructure as Code with CloudFormation

### Objective
Create a VPC with EC2 instance using CloudFormation template

### Prerequisites
- AWS Account
- Basic JSON/YAML knowledge
- AWS CLI installed

### Step-by-Step Lab

**Step 1: Create CloudFormation Template**

Create file `vpc-ec2-template.yaml`:

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'VPC with EC2 instance for DevOps practice'

Parameters:
  InstanceType:
    Type: String
    Default: t2.micro
    AllowedValues:
      - t2.micro
      - t2.small
      - t2.medium
    Description: EC2 instance type

Resources:
  # VPC
  MyVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      EnableDnsHostnames: true
      EnableDnsSupport: true
      Tags:
        - Key: Name
          Value: DevOps-VPC

  # Public Subnet
  PublicSubnet:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: 10.0.1.0/24
      AvailabilityZone: !Select [0, !GetAZs '']
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: Public-Subnet-1

  # Internet Gateway
  InternetGateway:
    Type: AWS::EC2::InternetGateway
    Properties:
      Tags:
        - Key: Name
          Value: DevOps-IGW

  AttachGateway:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref MyVPC
      InternetGatewayId: !Ref InternetGateway

  # Route Table
  PublicRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref MyVPC
      Tags:
        - Key: Name
          Value: Public-RT

  PublicRoute:
    Type: AWS::EC2::Route
    DependsOn: AttachGateway
    Properties:
      RouteTableId: !Ref PublicRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref InternetGateway

  SubnetRouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnet
      RouteTableId: !Ref PublicRouteTable

  # Security Group
  WebServerSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Security group for web servers
      VpcId: !Ref MyVPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
          Description: SSH access
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0
          Description: HTTP access
        - IpProtocol: tcp
          FromPort: 443
          ToPort: 443
          CidrIp: 0.0.0.0/0
          Description: HTTPS access
      SecurityGroupEgress:
        - IpProtocol: -1
          CidrIp: 0.0.0.0/0
          Description: All outbound traffic
      Tags:
        - Key: Name
          Value: WebServer-SG

  # EC2 Instance
  WebServerInstance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-0c55b159cbfafe1f0  # Amazon Linux 2 (update for your region)
      InstanceType: !Ref InstanceType
      SubnetId: !Ref PublicSubnet
      SecurityGroupIds:
        - !Ref WebServerSecurityGroup
      UserData:
        Fn::Base64: |
          #!/bin/bash
          yum update -y
          yum install -y httpd
          systemctl start httpd
          systemctl enable httpd
          echo "<h1>Hello from DevOps Lab</h1>" > /var/www/html/index.html
      Tags:
        - Key: Name
          Value: DevOps-WebServer

Outputs:
  VPCId:
    Description: VPC ID
    Value: !Ref MyVPC
    Export:
      Name: DevOps-VPC-ID

  PublicSubnetId:
    Description: Public Subnet ID
    Value: !Ref PublicSubnet
    Export:
      Name: DevOps-Public-Subnet-ID

  WebServerPublicIP:
    Description: Public IP of web server
    Value: !GetAtt WebServerInstance.PublicIp
    Export:
      Name: DevOps-WebServer-IP

  WebServerURL:
    Description: URL of web server
    Value: !Sub 'http://${WebServerInstance.PublicIp}'
```

**Step 2: Deploy Stack**

```bash
# Validate template
aws cloudformation validate-template \
  --template-body file://vpc-ec2-template.yaml

# Create stack
aws cloudformation create-stack \
  --stack-name devops-lab-stack \
  --template-body file://vpc-ec2-template.yaml \
  --parameters ParameterKey=InstanceType,ParameterValue=t2.micro

# Monitor stack creation
aws cloudformation describe-stacks \
  --stack-name devops-lab-stack \
  --query 'Stacks[0].StackStatus'

# Get outputs
aws cloudformation describe-stacks \
  --stack-name devops-lab-stack \
  --query 'Stacks[0].Outputs'
```

**Step 3: Test Infrastructure**

```bash
# Get instance IP
INSTANCE_IP=$(aws cloudformation describe-stacks \
  --stack-name devops-lab-stack \
  --query 'Stacks[0].Outputs[?OutputKey==`WebServerPublicIP`].OutputValue' \
  --output text)

# Test connectivity
curl http://$INSTANCE_IP
```

**Step 4: Update Stack**

```bash
# Modify template (change instance type to t2.small)
aws cloudformation update-stack \
  --stack-name devops-lab-stack \
  --template-body file://vpc-ec2-template.yaml \
  --parameters ParameterKey=InstanceType,ParameterValue=t2.small
```

**Step 5: Delete Stack**

```bash
# Delete all resources
aws cloudformation delete-stack \
  --stack-name devops-lab-stack

# Verify deletion
aws cloudformation describe-stacks \
  --stack-name devops-lab-stack \
  --query 'Stacks[0].StackStatus'
```

### What You Learned
✓ CloudFormation templates structure
✓ Resource creation and relationships
✓ Parameter usage
✓ Stack operations (create, update, delete)
✓ Outputs and exports
✓ DependsOn and Ref functions

---

## LAB 2: Docker & Container Basics

### Objective
Create a Docker image, push to ECR, and run on local system

### Prerequisites
- Docker installed
- AWS Account with ECR permission
- AWS CLI configured

### Step-by-Step Lab

**Step 1: Create Application**

Create `app.py`:

```python
from flask import Flask, jsonify
import socket
import os

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        'status': 'healthy',
        'hostname': socket.gethostname(),
        'environment': os.getenv('ENV', 'local')
    }), 200

@app.route('/api/hello', methods=['GET'])
def hello():
    return jsonify({
        'message': 'Hello from DevOps Lab',
        'hostname': socket.gethostname()
    }), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
```

Create `requirements.txt`:

```
Flask==2.3.0
Werkzeug==2.3.0
```

**Step 2: Create Dockerfile**

Create `Dockerfile`:

```dockerfile
# Multi-stage build
FROM python:3.9-slim as builder

WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Final stage
FROM python:3.9-slim

WORKDIR /app

# Copy from builder
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application
COPY app.py .

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:5000/health')" || exit 1

# Expose port
EXPOSE 5000

# Run application
CMD ["python", "app.py"]
```

**Step 3: Build Docker Image**

```bash
# Build image
docker build -t devops-lab:1.0 .

# List images
docker images | grep devops-lab

# Test image locally
docker run -d -p 5000:5000 --name devops-app devops-lab:1.0

# Test application
curl http://localhost:5000/health

# View logs
docker logs devops-app

# Stop container
docker stop devops-app
```

**Step 4: Create ECR Repository**

```bash
# Create repository
aws ecr create-repository \
  --repository-name devops-lab \
  --region us-east-1

# Get repository URI
REPO_URI=$(aws ecr describe-repositories \
  --repository-names devops-lab \
  --region us-east-1 \
  --query 'repositories[0].repositoryUri' \
  --output text)

echo $REPO_URI  # Example: 123456789.dkr.ecr.us-east-1.amazonaws.com/devops-lab
```

**Step 5: Push Image to ECR**

```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin $REPO_URI

# Tag image
docker tag devops-lab:1.0 $REPO_URI:1.0
docker tag devops-lab:1.0 $REPO_URI:latest

# Push image
docker push $REPO_URI:1.0
docker push $REPO_URI:latest

# Verify in ECR
aws ecr describe-images \
  --repository-name devops-lab \
  --region us-east-1
```

**Step 6: Run from ECR**

```bash
# Pull from ECR
docker pull $REPO_URI:1.0

# Run from ECR
docker run -d -p 5001:5000 --name devops-app-ecr $REPO_URI:1.0

# Test
curl http://localhost:5001/health

# Cleanup
docker stop devops-app-ecr
docker rm devops-app-ecr
```

### What You Learned
✓ Dockerfile creation and best practices
✓ Multi-stage builds for optimization
✓ Health checks in containers
✓ Docker image building and testing
✓ ECR repository creation and management
✓ Pushing and pulling images from ECR

---

## LAB 3: CI/CD Pipeline with CodePipeline

### Objective
Create automated CI/CD pipeline: GitHub → CodeBuild → CodeDeploy → EC2

### Prerequisites
- GitHub account and repository
- AWS Account with CodePipeline, CodeBuild, CodeDeploy permissions
- EC2 instance with CodeDeploy agent

### Step-by-Step Lab

**Step 1: Prepare CodeBuild Project**

Create `buildspec.yml` in GitHub repository:

```yaml
version: 0.2

env:
  variables:
    AWS_ACCOUNT_ID: "123456789"
    AWS_DEFAULT_REGION: "us-east-1"
    IMAGE_REPO_NAME: "devops-lab"
    IMAGE_TAG: "latest"

phases:
  pre_build:
    commands:
      - echo "Logging in to Amazon ECR..."
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
      - REPOSITORY_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=${COMMIT_HASH:=latest}

  build:
    commands:
      - echo "Building Docker image..."
      - docker build -t $REPOSITORY_URI:$IMAGE_TAG .
      - docker tag $REPOSITORY_URI:$IMAGE_TAG $REPOSITORY_URI:latest

  post_build:
    commands:
      - echo "Pushing Docker image..."
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - docker push $REPOSITORY_URI:latest
      - echo "Writing image definitions file..."
      - printf '[{"name":"devops-app","imageUri":"%s"}]' $REPOSITORY_URI:$IMAGE_TAG > imagedefinitions.json

artifacts:
  files:
    - imagedefinitions.json
    - appspec.yaml

cache:
  paths:
    - '/root/.cache/pip/**/*'
```

Create `appspec.yaml` for CodeDeploy:

```yaml
version: 0.0
Resources:
  - TargetService:
      Type: AWS::EC2::Instance
      Properties:
        ImageId: ami-xxxxxxxxx
        InstanceType: t2.micro

Hooks:
  - BeforeInstall: BeforeInstall
  - ApplicationStart: ApplicationStart
  - ApplicationStop: ApplicationStop
```

Create deployment scripts in `scripts/` directory:

**scripts/install_dependencies.sh:**
```bash
#!/bin/bash
set -e

echo "Installing dependencies..."

# Install Docker
if ! command -v docker &> /dev/null; then
  yum update -y
  yum install -y docker
  systemctl start docker
  systemctl enable docker
fi

# Add ec2-user to docker group
usermod -a -G docker ec2-user
```

**scripts/start_server.sh:**
```bash
#!/bin/bash
set -e

echo "Starting application..."

# Stop existing container
docker stop devops-app || true
docker rm devops-app || true

# Run new container
docker run -d \
  --name devops-app \
  -p 80:5000 \
  -e ENV=production \
  123456789.dkr.ecr.us-east-1.amazonaws.com/devops-lab:latest

# Wait for container to be healthy
sleep 5
curl http://localhost/health || exit 1

echo "Application started successfully"
```

**Step 2: Create CodeBuild Project**

```bash
# Create IAM role for CodeBuild
aws iam create-role \
  --role-name CodeBuildRole \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "codebuild.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }'

# Attach policies
aws iam attach-role-policy \
  --role-name CodeBuildRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser

aws iam attach-role-policy \
  --role-name CodeBuildRole \
  --policy-arn arn:aws:iam::aws:policy/CloudWatchLogsFullAccess
```

**Step 3: Create CodePipeline**

```bash
# Create S3 bucket for artifacts
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET_NAME="devops-pipeline-artifacts-${ACCOUNT_ID}"

aws s3 mb s3://$BUCKET_NAME --region us-east-1

# Create pipeline role
aws iam create-role \
  --role-name CodePipelineRole \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "codepipeline.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }'

# Attach policies
aws iam attach-role-policy \
  --role-name CodePipelineRole \
  --policy-arn arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess

aws iam attach-role-policy \
  --role-name CodePipelineRole \
  --policy-arn arn:aws:iam::aws:policy/AWSCodeDeployRoleForEC2

aws iam attach-role-policy \
  --role-name CodePipelineRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
```

**Step 4: Monitor Pipeline**

```bash
# Watch pipeline execution
aws codepipeline get-pipeline-state \
  --name devops-pipeline \
  --region us-east-1

# View CodeBuild logs
aws logs tail /aws/codebuild/devops-lab-build --follow

# SSH into EC2 and check
ssh -i key.pem ec2-user@instance-ip

# Check Docker container
docker ps

# View application logs
docker logs -f devops-app

# Test endpoint
curl http://instance-ip/health
```

### What You Learned
✓ CI/CD pipeline architecture
✓ buildspec.yml and appspec.yaml configuration
✓ CodeBuild project setup
✓ CodeDeploy integration
✓ Artifact management
✓ IAM roles and permissions
✓ Deployment automation

---

## LAB 4: Monitoring with CloudWatch

### Objective
Set up CloudWatch metrics, logs, alarms, and dashboards

### Prerequisites
- CloudWatch access
- Running application (from Lab 3)
- SNS topic for alarms

**Step 1: Create SNS Topic for Alerts**

```bash
aws sns create-topic --name devops-alerts

# Subscribe email
aws sns subscribe \
  --topic-arn arn:aws:sns:us-east-1:ACCOUNT_ID:devops-alerts \
  --protocol email \
  --notification-endpoint your-email@example.com
```

**Step 2: Create CloudWatch Alarms**

```bash
# High CPU alarm
aws cloudwatch put-metric-alarm \
  --alarm-name devops-high-cpu \
  --alarm-description "Alert when CPU > 80%" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2 \
  --alarm-actions arn:aws:sns:us-east-1:ACCOUNT_ID:devops-alerts

# High error rate alarm
aws cloudwatch put-metric-alarm \
  --alarm-name devops-high-error-rate \
  --alarm-description "Alert when errors > 5%" \
  --metric-name ErrorCount \
  --namespace MyApp \
  --statistic Sum \
  --period 60 \
  --threshold 50 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 1 \
  --alarm-actions arn:aws:sns:us-east-1:ACCOUNT_ID:devops-alerts
```

**Step 3: Create Custom Metrics**

Application code to push metrics:

```python
import boto3
from datetime import datetime

cloudwatch = boto3.client('cloudwatch')

def record_metric(metric_name, value, unit='None'):
    cloudwatch.put_metric_data(
        Namespace='MyApp',
        MetricData=[
            {
                'MetricName': metric_name,
                'Value': value,
                'Unit': unit,
                'Timestamp': datetime.utcnow()
            }
        ]
    )

# In your Flask app
@app.route('/api/hello', methods=['GET'])
def hello():
    record_metric('RequestCount', 1, 'Count')
    record_metric('ResponseTime', 0.05, 'Seconds')
    
    return jsonify({
        'message': 'Hello from DevOps Lab'
    }), 200
```

**Step 4: Create CloudWatch Log Group**

```bash
# Create log group
aws logs create-log-group \
  --log-group-name /aws/devops-lab

# Set retention
aws logs put-retention-policy \
  --log-group-name /aws/devops-lab \
  --retention-in-days 7
```

**Step 5: Create Dashboard**

```bash
# Create dashboard JSON
cat > dashboard.json << 'EOF'
{
  "widgets": [
    {
      "type": "metric",
      "properties": {
        "metrics": [
          [ "AWS/EC2", "CPUUtilization" ],
          [ ".", "NetworkIn" ],
          [ "MyApp", "RequestCount" ],
          [ ".", "ErrorCount" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "DevOps Lab Metrics"
      }
    }
  ]
}
EOF

# Create dashboard
aws cloudwatch put-dashboard \
  --dashboard-name DevOps-Lab \
  --dashboard-body file://dashboard.json
```

**Step 6: Query CloudWatch Logs**

```bash
# Simple query
aws logs start-query \
  --log-group-name /aws/devops-lab \
  --start-time $(date -d '1 hour ago' +%s) \
  --end-time $(date +%s) \
  --query-string "fields @timestamp, @message | stats count() by @message"
```

### What You Learned
✓ CloudWatch metrics (system and custom)
✓ CloudWatch Logs for centralized logging
✓ Alarms and notifications
✓ Dashboard creation
✓ Logs Insights for querying
✓ SNS integration

---

## LAB 5: Infrastructure as Code with Terraform

### Objective
Deploy same infrastructure as Lab 1 but using Terraform

### Prerequisites
- Terraform installed
- AWS Account with appropriate permissions
- AWS CLI configured

**Step 1: Create Terraform Files**

Create `main.tf`:

```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "devops-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "devops-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "devops-public-subnet"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = {
    Name = "devops-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "web" {
  name   = "devops-web-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-web-sg"
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    environment = var.environment
  }))

  tags = {
    Name = "devops-web-server"
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
```

Create `variables.tf`:

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
```

Create `outputs.tf`:

```hcl
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "web_server_public_ip" {
  description = "Web server public IP"
  value       = aws_instance.web.public_ip
}

output "web_server_url" {
  description = "Web server URL"
  value       = "http://${aws_instance.web.public_ip}"
}
```

Create `user_data.sh`:

```bash
#!/bin/bash
yum update -y
yum install -y httpd

systemctl start httpd
systemctl enable httpd

echo "<h1>DevOps Lab - Environment: ${environment}</h1>" > /var/www/html/index.html
```

**Step 2: Deploy with Terraform**

```bash
# Initialize Terraform
terraform init

# Format and validate
terraform fmt
terraform validate

# Plan deployment
terraform plan -out=tfplan

# Review plan
cat tfplan

# Apply
terraform apply tfplan

# View outputs
terraform output

# Specific output
terraform output web_server_url
```

**Step 3: Modify Infrastructure**

```bash
# Update variable
terraform apply -var="instance_type=t2.small"

# View changes
terraform plan -var="instance_type=t2.small"
```

**Step 4: Destroy Infrastructure**

```bash
# Plan destruction
terraform plan -destroy

# Destroy
terraform destroy
```

**Step 5: Use Modules (Advanced)**

Create `modules/vpc/main.tf`:

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  
  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.name}-igw"
  }
}
```

Use module in main:

```hcl
module "vpc" {
  source = "./modules/vpc"
  
  cidr_block = "10.0.0.0/16"
  name       = "devops-vpc"
}
```

### What You Learned
✓ Terraform file structure
✓ Variable declaration and usage
✓ Resources and data sources
✓ Outputs
✓ State management
✓ Plan and apply workflow
✓ Modules for reusability
✓ Terraform best practices

---

## Lab Completion Checklist

After completing all labs:

- [ ] Lab 1: CloudFormation template deployed successfully
- [ ] Lab 2: Docker image pushed to ECR and tested
- [ ] Lab 3: CI/CD pipeline automated code to EC2
- [ ] Lab 4: CloudWatch metrics, logs, and alarms configured
- [ ] Lab 5: Terraform deployed same infrastructure as Lab 1
- [ ] Documented all steps taken
- [ ] Created GitHub repository with all code
- [ ] Prepared portfolio examples

---

## Next Steps

1. **Extend Labs:**
   - Add RDS database to infrastructure
   - Implement ECS container deployment
   - Add monitoring with Prometheus/Grafana

2. **Build Real Project:**
   - Create CI/CD for actual application
   - Deploy to production
   - Set up proper monitoring

3. **Learn More:**
   - Read AWS documentation
   - Take AWS certification exams
   - Contribute to open-source

4. **Portfolio:**
   - Document your learning
   - Create GitHub repos with code
   - Write blog posts explaining solutions
   - Link to your portfolio in interviews

---

**Good luck with your hands-on learning! These labs are key to getting that 8-10 LPA job!** 🚀
