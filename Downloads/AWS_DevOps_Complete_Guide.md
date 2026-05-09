# AWS DevOps Masterclass - Complete Job-Ready Course
## Target Salary: 8-10 LPA for Freshers

---

## TABLE OF CONTENTS
1. Module 1: DevOps Fundamentals
2. Module 2: AWS Core Services
3. Module 3: Infrastructure as Code
4. Module 4: CI/CD Pipeline
5. Module 5: Containerization & Orchestration
6. Module 6: Monitoring & Logging
7. Module 7: Security in AWS
8. Module 8: Interview Preparation Guide

---

# MODULE 1: DEVOPS FUNDAMENTALS

## 1.1 What is DevOps?

**Definition:** DevOps is a set of practices, tools, and cultural philosophy that combines software development (Dev) and IT operations (Ops). It aims to shorten the software development lifecycle and provide continuous delivery with high software quality.

### Key Principles:
- **Collaboration:** Breaking silos between dev and ops teams
- **Automation:** Automating repetitive tasks to save time and reduce errors
- **Continuous Integration:** Frequent code commits and automated testing
- **Continuous Delivery:** Automated release process
- **Monitoring:** Continuous observation of systems
- **Feedback:** Using data to improve processes

## 1.2 DevOps Lifecycle

| Phase | Description | Tools & Activities |
|-------|-------------|-------------------|
| Plan | Planning and requirements gathering | JIRA, Confluence, Requirements analysis |
| Code | Writing and versioning code | Git, GitHub, GitLab, Bitbucket |
| Build | Compiling and packaging code | Maven, Gradle, Jenkins, CodeBuild |
| Test | Automated testing | JUnit, Selenium, SonarQube |
| Release | Deploying to production | Jenkins, AWS CodeDeploy |
| Monitor | Tracking performance and errors | CloudWatch, ELK, Prometheus |
| Feedback | Gathering metrics for improvement | Dashboards, Analytics |

## 1.3 Why AWS for DevOps?

- **Extensive DevOps services ecosystem:** AWS offers native tools for every part of the DevOps lifecycle
- **Scalability and reliability:** Auto-scaling, multi-AZ deployments
- **Cost-effective solutions:** Pay-as-you-go model, free tier for learning
- **Global infrastructure:** Data centers across multiple regions
- **Industry standard:** Most companies use AWS for infrastructure

---

# MODULE 2: AWS CORE SERVICES

## 2.1 Compute Services

### **EC2 (Elastic Compute Cloud)**
**Definition:** Provides resizable compute capacity as virtual machines in the cloud.

**Key Features:**
- Auto-scaling groups for handling traffic spikes
- Security groups for firewall rules
- Elastic IPs for static IP addresses
- Multiple instance types (t2, m5, c5, r5, etc.)
- Spot instances for cost savings

**Use Case:** Hosting web applications, running compute-intensive tasks, databases

**Interview Tip:** Know the difference between instance types:
- `t2` = Burstable (Dev/Test)
- `m5` = General purpose
- `c5` = CPU-optimized
- `r5` = Memory-optimized
- `p3` = GPU-optimized

---

### **Lambda**
**Definition:** Serverless compute service that runs code without provisioning or managing servers.

**Key Features:**
- Event-driven architecture
- Pay-per-use (no charges when not running)
- Auto-scaling handled automatically
- Multiple runtime support (Python, Node.js, Java, Go, .NET)
- Integration with S3, DynamoDB, API Gateway, etc.

**Use Case:** API backends, Data processing, Scheduled tasks, Real-time processing

**Interview Tip:** Explain why Lambda is cost-effective for unpredictable workloads and mention cold start issues.

---

### **ECS (Elastic Container Service)**
**Definition:** Container orchestration service for running Docker containers.

**Key Features:**
- Fargate (serverless) or EC2 launch types
- Task definitions for container configuration
- Auto-scaling based on metrics
- Load balancer integration
- CloudWatch logs integration

**Use Case:** Containerized microservices, Docker application deployment

**Interview Tip:** Differentiate between ECS and EKS, when to use which.

---

## 2.2 Storage Services

### **S3 (Simple Storage Service)**
**Definition:** Object storage service for storing and retrieving any amount of data.

**Key Features:**
- Unlimited storage capacity
- Versioning for recovery
- Encryption (server-side and client-side)
- Lifecycle policies to move old data to Glacier
- Access logging for compliance

**Use Case:** 
- Backup storage
- Website hosting
- Data archival
- Artifact storage for CI/CD pipelines

**Storage Classes:**
- **Standard:** Frequently accessed data
- **IA (Infrequent Access):** Accessed < once per month
- **Glacier:** Long-term archival
- **Deep Archive:** Rarely accessed, lowest cost

**Interview Tip:** Be ready to discuss how to optimize costs using lifecycle policies.

---

### **EBS (Elastic Block Store)**
**Definition:** Block-level storage volumes for use with EC2 instances (like hard drives).

**Key Features:**
- Snapshots for backups
- Encryption at rest
- Multiple volume types (gp2, io1, st1, sc1)
- Performance optimization

**Use Case:** Database storage, Application root volumes, High-I/O databases

**Interview Tip:** Know the differences:
- `gp2` = General purpose (balance of price & performance)
- `io1` = High-performance (databases)
- `st1` = Throughput-optimized (big data)
- `sc1` = Cold storage (infrequently accessed)

---

## 2.3 Networking Services

### **VPC (Virtual Private Cloud)**
**Definition:** Isolated network environment where you can launch AWS resources.

**Key Components:**
- **Subnets:** Public (internet accessible) and Private (no internet access)
- **Route tables:** Determine traffic direction
- **Security groups:** Stateful firewall (inbound/outbound rules)
- **Network ACLs:** Stateless firewall at subnet level
- **NAT Gateway:** Allows private instances to access internet
- **Internet Gateway:** Allows traffic between VPC and internet

**Interview Tip:** Be prepared to design a VPC with public/private subnets:
- Public subnet: Web servers, NAT Gateway
- Private subnet: Databases, application servers
- Always place databases in private subnet for security

---

### **Load Balancing**
| Type | Layer | Use Case |
|------|-------|----------|
| ALB (Application Load Balancer) | Layer 7 (Application) | HTTP/HTTPS, microservices |
| NLB (Network Load Balancer) | Layer 4 (Transport) | Extreme performance, UDP, gaming |
| CLB (Classic Load Balancer) | Both Layer 4 & 7 | Legacy, not recommended |

---

## 2.4 Database Services

### **RDS (Relational Database Service)**
**Definition:** Managed database service supporting multiple database engines.

**Supported Databases:** MySQL, PostgreSQL, Oracle, SQL Server, MariaDB

**Key Features:**
- Automated backups and point-in-time recovery
- Multi-AZ for high availability (automatic failover)
- Read replicas for scaling read operations
- Encryption at rest and in transit
- Automated patching and maintenance

**Interview Tip:** Explain Multi-AZ vs Read Replicas:
- **Multi-AZ:** For high availability (same data, different AZ, automatic failover)
- **Read Replicas:** For scaling reads (different regions possible, manual failover)

---

### **DynamoDB**
**Definition:** Fully managed NoSQL database service for flexible data models.

**Key Features:**
- On-demand pricing (pay per request)
- Global tables for multi-region replication
- DAX caching for fast reads
- Point-in-time recovery
- Streams for capturing changes

**Use Case:** Real-time data, Mobile apps, IoT applications, Gaming

**Interview Tip:** Understand provisioned vs on-demand:
- **Provisioned:** Better for predictable workloads (specify read/write capacity)
- **On-demand:** Better for unpredictable workloads (pay per request)

---

# MODULE 3: INFRASTRUCTURE AS CODE (IaC)

## 3.1 What is Infrastructure as Code?

**Definition:** Managing and provisioning infrastructure through code instead of manual processes.

**Benefits:**
- Version control (track changes in Git)
- Reproducibility (create same infrastructure multiple times)
- Automation (reduce manual errors)
- Documentation (code is documentation)
- Cost estimation (know costs before deployment)

---

## 3.2 CloudFormation

**Definition:** AWS service for defining infrastructure using JSON or YAML templates.

### Key Concepts:
- **Templates:** JSON/YAML files describing resources
- **Stacks:** Collection of resources created from a template
- **Change Sets:** Preview changes before applying
- **Stack Policies:** Control who can modify resources

### Advantages:
- AWS-native (best integration with AWS services)
- Automatic rollback on failure
- Manages resource dependencies
- Free to use (pay only for created resources)

### Example Template Structure (YAML):
```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'EC2 instance template'

Parameters:
  InstanceType:
    Type: String
    Default: t2.micro
    
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-12345678
      InstanceType: !Ref InstanceType
      
Outputs:
  InstanceId:
    Value: !Ref MyInstance
    Description: ID of created instance
```

---

## 3.3 Terraform

**Definition:** Open-source IaC tool that supports multiple cloud providers (AWS, Azure, GCP, etc.).

### Advantages:
- **Multi-cloud support:** Write once, deploy anywhere
- **Easier syntax:** HCL (HashiCorp Configuration Language) is simpler than JSON
- **State management:** Explicit state file for tracking resources
- **Modularity:** Reusable modules for common patterns

### Key Components:
- **Provider:** Which cloud to use (aws, azure, gcp)
- **Resource:** What to create (EC2, RDS, S3, etc.)
- **Variables:** Input parameters
- **Outputs:** Values to display after creation
- **Modules:** Reusable Terraform configurations

### Example Resource:
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  
  tags = {
    Name = "MyServer"
  }
}

variable "instance_count" {
  default = 2
}

output "instance_ids" {
  value = aws_instance.example.*.id
}
```

---

## 3.4 CloudFormation vs Terraform

| Aspect | CloudFormation | Terraform |
|--------|---|---|
| **Provider** | AWS-only | Multi-cloud |
| **Language** | JSON/YAML | HCL |
| **State Management** | AWS-managed (simple) | Manual (state file) |
| **Learning Curve** | Steeper | Gentler |
| **Community** | AWS-backed | Large open-source |
| **When to Use** | AWS-only projects | Multi-cloud or complex IaC |

**Interview Guidance:** Use CloudFormation for AWS-only projects (faster to market), Terraform for multi-cloud or when you need more flexibility.

---

# MODULE 4: CI/CD PIPELINE

## 4.1 Continuous Integration (CI)

**Definition:** Practice of automatically integrating code changes and running tests frequently.

**Benefits:**
- Early bug detection (catch issues before they spread)
- Faster feedback (developers know results in minutes)
- Improved code quality (automated testing)
- Reduced integration issues

**Typical Flow:**
```
Code commit → Git hook triggers build → Build code → Run unit tests → 
Code analysis (SonarQube) → Run integration tests → Build artifacts
```

---

## 4.2 Continuous Delivery vs Continuous Deployment

**Continuous Delivery (CD):**
- Automated build, test, and deployment process
- Manual approval required before production deployment
- Deploy-ready code at all times
- Reduces risk by testing everything

**Continuous Deployment:**
- Automatically deploy to production without manual approval
- Every commit that passes tests goes to production
- Requires mature testing and monitoring

---

## 4.3 AWS CodePipeline

**Definition:** Fully managed continuous delivery service orchestrating build, test, and deploy phases.

**Architecture:**
```
Source (CodeCommit/GitHub) 
  → Build (CodeBuild) 
  → Test (CodeBuild/Third-party)
  → Manual Approval 
  → Deploy (CodeDeploy)
  → Monitoring (CloudWatch)
```

**Key Components:**
- **Source:** CodeCommit, GitHub, Bitbucket, S3
- **Build:** CodeBuild, Jenkins, TeamCity
- **Deploy:** CodeDeploy, CloudFormation, AppConfig
- **Approval:** Manual approval stage (team review)

**Features:**
- Integration with third-party tools
- Manual approval stages for control
- Artifact storage in S3
- Notifications via SNS/CloudWatch

---

## 4.4 AWS CodeBuild

**Definition:** Fully managed build service that compiles code, runs tests, and produces deployable packages.

**Buildspec File (buildspec.yml):**
```yaml
version: 0.2

phases:
  install:
    commands:
      - echo "Installing dependencies..."
      - npm install
      
  pre_build:
    commands:
      - echo "Running tests..."
      - npm test
      
  build:
    commands:
      - echo "Building application..."
      - npm run build
      
  post_build:
    commands:
      - echo "Creating Docker image..."
      - aws ecr get-login-password | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
      - docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
      - docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG

artifacts:
  files:
    - '**/*'
    
reports:
  CodeCoverageReport:
    files:
      - 'coverage/cobertura-coverage.xml'
```

**Supported Languages:** Java, Python, Node.js, Ruby, Go, .NET, PHP, Docker

---

## 4.5 AWS CodeDeploy

**Definition:** Automated deployment service for EC2, on-premises servers, or Lambda.

**AppSpec File (appspec.yml):**
```yaml
version: 0.0
Resources:
  - TargetService:
      Type: AWS::ApiGateway::Stage
      Properties:
        DeploymentId: !Ref ApiGatewayDeployment
        RestApiId: !Ref ApiGateway
        StageName: prod
        
Hooks:
  - BeforeAllowTraffic: "PreTrafficHook"
  - AfterAllowTraffic: "PostTrafficHook"
```

**Deployment Options:**
- **In-place:** Stop old version, deploy new (downtime)
- **Blue/Green:** Run two versions simultaneously, switch traffic (zero downtime)

**Blue/Green Deployment Process:**
```
1. Blue environment running (production)
2. Green environment deployed (new version)
3. Run tests on Green
4. Switch load balancer to Green
5. If issues, switch back to Blue (quick rollback)
```

---

## 4.6 Jenkins (Open Source CI/CD Tool)

**Definition:** Popular open-source automation server for building CI/CD pipelines.

**Features:**
- Distributed builds (run jobs on multiple machines)
- Pipeline as Code (Jenkinsfile for version control)
- Extensive plugin ecosystem (4000+ plugins)
- Integration with AWS, GitHub, Docker, Kubernetes

### Jenkins Pipeline Example (Jenkinsfile):
```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/user/repo.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('Deploy to AWS') {
            steps {
                sh 'aws s3 cp target/app.jar s3://bucket/app.jar'
            }
        }
    }
    
    post {
        always {
            junit 'target/surefire-reports/**/*.xml'
        }
    }
}
```

---

## 4.7 Complete CI/CD Pipeline Example

| Stage | Tool | Action | Duration |
|-------|------|--------|----------|
| Source | GitHub | Code commit triggers pipeline | Immediate |
| Build | CodeBuild | `npm install` → `npm run build` | 2-5 min |
| Unit Tests | CodeBuild | `npm test` | 1-3 min |
| Code Quality | CodeBuild + SonarQube | Check code metrics | 2 min |
| Manual Approval | CodePipeline | Team reviews build | Variable |
| Deploy Dev | CodeDeploy | Deploy to dev environment | 2 min |
| Smoke Tests | CodeBuild | Run quick tests | 2 min |
| Deploy Prod | CodeDeploy (Blue/Green) | Deploy to production | 5 min |
| Monitor | CloudWatch | Check metrics and logs | Continuous |

---

# MODULE 5: CONTAINERIZATION & ORCHESTRATION

## 5.1 Docker Basics

**Definition:** Containerization platform that packages applications with all dependencies.

### Core Concepts:
- **Image:** Blueprint of a container (read-only template)
  - Base OS + Application + Dependencies
  - Stored in registries (Docker Hub, ECR)
  
- **Container:** Running instance of an image
  - Isolated environment
  - Lightweight (shares host OS kernel)
  - Consistent across machines
  
- **Registry:** Repository for storing images
  - Docker Hub (public)
  - ECR (AWS private registry)
  
- **Dockerfile:** Text file with instructions to build image

### Dockerfile Example:
```dockerfile
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy application
COPY app.py /app/
COPY requirements.txt /app/

# Set working directory
WORKDIR /app

# Install Python dependencies
RUN pip install -r requirements.txt

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:5000/health || exit 1

# Run application
CMD ["python3", "app.py"]
```

### Common Docker Commands:
```bash
# Build image
docker build -t myapp:1.0 .

# Run container
docker run -d -p 5000:5000 --name myapp myapp:1.0

# View logs
docker logs myapp

# Push to registry
docker tag myapp:1.0 123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
docker push 123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
```

---

## 5.2 AWS ECR (Elastic Container Registry)

**Definition:** AWS's private Docker registry for storing and managing container images.

**Benefits:**
- Security (private, IAM controlled)
- Integration with ECS/EKS
- Lifecycle policies (auto-delete old images)
- Image scanning for vulnerabilities
- Encryption at rest

**Workflow:**
```
1. Build Docker image locally
2. Tag image with ECR URI
3. Login to ECR
4. Push image to ECR
5. ECS/EKS pulls from ECR
```

### Example:
```bash
# Get login credentials
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  123456789.dkr.ecr.us-east-1.amazonaws.com

# Tag image
docker tag myapp:1.0 \
  123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0

# Push to ECR
docker push \
  123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
```

---

## 5.3 AWS ECS (Elastic Container Service)

**Definition:** Fully managed container orchestration service (AWS-native alternative to Kubernetes).

### Key Components:

**Task Definition:**
```json
{
  "family": "my-app",
  "containerDefinitions": [
    {
      "name": "my-app",
      "image": "123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0",
      "memory": 512,
      "cpu": 256,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 5000,
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/my-app",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
```

**Service:**
- Long-running collection of tasks
- Auto-scaling based on metrics
- Load balancer integration
- Updates with rolling deployments

**Launch Types:**
- **EC2:** Manage EC2 instances, more control, lower cost
- **Fargate:** Serverless, AWS manages infrastructure, easier to use

### ECS Deployment Process:
```
1. Create cluster (EC2 instances or Fargate)
2. Create task definition (container configuration)
3. Create service (run tasks with auto-scaling)
4. Attach load balancer
5. Scale based on metrics (CPU, memory)
```

---

## 5.4 AWS EKS (Elastic Kubernetes Service)

**Definition:** Managed Kubernetes service for deploying and managing containerized applications.

**Why Kubernetes?**
- Industry standard orchestration platform
- Multi-cloud capability
- Powerful auto-scaling and self-healing
- Large community

**EKS Architecture:**
```
Control Plane (AWS-managed)
  ↓
Worker Nodes (EC2 instances you manage)
  ↓
Pods (smallest unit, contain containers)
```

**Key Kubernetes Concepts:**
- **Pod:** Smallest deployable unit (usually 1 container)
- **Deployment:** Describes desired state of pods
- **Service:** Exposes pods to network
- **Namespace:** Logical cluster partition

### Example Kubernetes Manifest:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: 123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
        ports:
        - containerPort: 5000
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
---
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 5000
  selector:
    app: myapp
```

---

## 5.5 ECS vs EKS vs Fargate Comparison

| Aspect | ECS | EKS | Fargate |
|--------|-----|-----|---------|
| **Orchestrator** | AWS-native | Kubernetes | AWS-native |
| **Complexity** | Simple | Complex | Simple |
| **Multi-cloud** | No | Yes | No |
| **Cost** | Lower | Higher | Medium |
| **Community** | AWS-backed | Large K8s | AWS-backed |
| **Best For** | AWS-only microservices | Multi-cloud Kubernetes | Serverless containers |
| **Learning Curve** | Gentle | Steep | Gentle |

---

# MODULE 6: MONITORING & LOGGING

## 6.1 CloudWatch

**Definition:** AWS monitoring and observability service for tracking metrics, logs, and events.

### Metrics:
- CPU utilization, Memory, Network I/O, Disk I/O
- Granularity: 1-minute (detailed) or 5-minute (basic)
- Custom metrics from applications

### Logs:
- Application logs from EC2, Lambda, ECS
- System logs (Apache, Nginx)
- Custom metrics from applications
- Log Insights for querying (SQL-like syntax)

### Alarms:
- Trigger actions on threshold breach
- Send SNS notifications
- Auto-scale resources
- Stop/reboot instances

### Dashboards:
- Visual representation of metrics
- Real-time monitoring
- Multiple metrics in one view

### Example CloudWatch Metrics Query:
```
fields @timestamp, @message, status_code
| stats count(*) as error_count by status_code
| filter status_code >= 400
| sort error_count desc
```

---

## 6.2 AWS X-Ray

**Definition:** Distributed tracing service for analyzing microservices.

**Features:**
- **Service Maps:** Visualize dependencies between services
- **Traces:** Track request paths through services
- **Segments:** Measure latency of each service call
- **Error Analysis:** Identify slow/failing services

**Example X-Ray Instrumentation (Python):**
```python
from aws_xray_sdk.core import xray_recorder
from aws_xray_sdk.core import patch_all

patch_all()

@xray_recorder.capture('process_data')
def process_data(data):
    # Your code here
    return result
```

---

## 6.3 CloudTrail

**Definition:** Service for auditing and compliance; logs all API calls.

**Records:**
- Who performed the action (user/role)
- What action was performed (API call)
- When it happened (timestamp)
- Where it came from (IP address)
- Details (request/response)

**Use Case:**
- Security auditing
- Compliance reporting (PCI, HIPAA)
- Troubleshooting configuration changes
- Detect unauthorized access

---

## 6.4 Prometheus & Grafana (Open Source)

**Prometheus:**
- Time-series database for metrics
- Pull-based model (scrapes metrics from targets)
- Query language (PromQL)
- Alerting capability

**Grafana:**
- Visualization tool for dashboards
- Works with Prometheus, Elasticsearch, Datadog
- Custom dashboards
- Alert notifications

---

## 6.5 ELK Stack (Open Source)

**Elasticsearch:** Log indexing and search
**Logstash:** Log processing, filtering, enrichment
**Kibana:** Log visualization and analysis

**Use Case:**
- Centralized logging
- Log aggregation from multiple sources
- Full-text search
- Visualization and analysis

---

# MODULE 7: SECURITY IN AWS

## 7.1 Identity and Access Management (IAM)

**Definition:** Service for managing access to AWS resources securely.

### Components:

**Users:** Individual accounts with credentials
```
• AWS Management Console access
• Programmatic access (Access Key ID + Secret)
```

**Roles:** Collections of permissions
```
• Assumable by services (EC2, Lambda, ECS)
• Temporary credentials (STS)
• Cross-account access
```

**Policies:** JSON documents defining permissions
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::my-bucket/*"
    },
    {
      "Effect": "Deny",
      "Action": "s3:DeleteBucket",
      "Resource": "*"
    }
  ]
}
```

**Groups:** Collection of users with shared permissions

### Best Practices:
- **Principle of Least Privilege:** Grant minimum necessary permissions
- **Use Roles:** Don't embed credentials in applications
- **Enable MFA:** Multi-factor authentication for root account
- **Regular Audits:** Review permissions quarterly
- **No Wildcards:** Specify exact resources in policies

---

## 7.2 VPC Security

**Security Groups:** (Stateful firewall)
```
• Inbound rules (what traffic enters)
• Outbound rules (what traffic exits)
• Applied to EC2 instances
• Default: Deny all inbound, Allow all outbound
```

**Network ACLs:** (Stateless firewall)
```
• Applied to subnets
• Rules processed in order (first match wins)
• More granular than security groups
```

**VPC Endpoints:**
```
• Private connection to AWS services
• No internet gateway needed
• Enhanced security (no internet exposure)
• Examples: S3, DynamoDB, SNS endpoints
```

---

## 7.3 Data Protection

**Encryption at Rest:**
- EBS volumes (enabled by default for new volumes)
- RDS databases (enable encryption)
- S3 objects (server-side encryption)
- DynamoDB (enable encryption)

**Encryption in Transit:**
- TLS/SSL for all connections
- Certificates for HTTPS
- VPN for on-premises connections

**AWS KMS (Key Management Service):**
- Centralized key management
- Encrypt/decrypt API
- Automatic key rotation
- Audit trail (CloudTrail)

**AWS Secrets Manager:**
- Store database passwords
- Rotate credentials automatically
- Audit access
- Fine-grained IAM permissions

---

## 7.4 Web Application Firewall (WAF)

**Definition:** Protection against common web exploits.

**Protection Against:**
- SQL injection
- Cross-site scripting (XSS)
- DDoS attacks
- Bot traffic

**Integration:**
- Application Load Balancer (ALB)
- CloudFront
- API Gateway

---

## 7.5 AWS Config

**Definition:** Service for assessing and auditing configurations.

**Features:**
- Configuration snapshots
- Change tracking
- Compliance rules
- Notifications on changes

**Example Rules:**
- EC2 instances must have specific security groups
- S3 buckets must have versioning enabled
- RDS must have backup enabled
- All resources must be encrypted

---

# MODULE 8: INTERVIEW PREPARATION GUIDE

## 8.1 Core Concepts You MUST Know

### Infrastructure as Code

**Be prepared to explain:**
- What is IaC and why it's important
- CloudFormation vs Terraform differences
- When to use each tool
- How to handle state and rollbacks
- Dry-run/change set concept

**Sample Answer:**
"CloudFormation is AWS's native IaC tool using JSON/YAML templates. It manages resource creation through stacks, and if deployment fails, it automatically rolls back changes. Terraform is cloud-agnostic using HCL and maintains state separately, making it flexible for multi-cloud environments. I'd use CloudFormation for AWS-only projects for simplicity, and Terraform for multi-cloud or when working with existing infrastructure."

---

### CI/CD Pipeline

**Be prepared to explain:**
- Design a complete pipeline from code to production
- Stages and tools at each stage
- Failure recovery and rollback
- Blue/Green vs Canary deployments
- Security in CI/CD

**Sample Answer:**
"A typical CodePipeline has:
1. Source (GitHub) - trigger on code commit
2. Build (CodeBuild) - compile, run unit tests, create artifacts
3. Test (CodeBuild) - integration tests, code quality checks
4. Approval - manual review before production
5. Deploy (CodeDeploy) - use Blue/Green deployment

Blue/Green means running two identical environments. We deploy new version to Green, run tests, then switch traffic. If issues occur, we quickly switch back to Blue."

---

### Container Orchestration

**Be prepared to explain:**
- Docker, ECS, EKS, Fargate
- When to use each
- How auto-scaling works
- Service discovery
- Container networking

**Sample Answer:**
"ECS is AWS-native and simpler, best for AWS-only microservices. EKS is Kubernetes standard, suitable for multi-cloud environments. Fargate is serverless containers for unpredictable workloads. I'd choose:
- ECS for rapid AWS deployments
- Fargate for unpredictable or small workloads
- EKS for multi-cloud or large Kubernetes deployments"

---

### Monitoring and Logging

**Be prepared to explain:**
- CloudWatch metrics, logs, alarms
- Centralized logging strategy
- Distributed tracing (X-Ray)
- Alert design and notification
- Dashboard creation

**Sample Answer:**
"CloudWatch aggregates metrics from all AWS services. I create custom metrics from application logs. Alarms trigger SNS notifications for critical events. For detailed analysis, I use CloudWatch Logs Insights with SQL-like queries. For microservices, X-Ray provides distributed tracing showing service dependencies and latencies."

---

### Security

**Be prepared to explain:**
- VPC design (public/private subnets)
- Security groups and NACLs
- IAM roles and policies
- Encryption (rest and transit)
- Secrets management

**Sample Answer:**
"I design VPCs with separate public and private subnets. Public subnet contains NAT Gateway for outbound traffic. Private subnet has no internet access (databases). IAM follows least privilege - no wildcards in resources. All data encrypted with KMS. Sensitive credentials stored in Secrets Manager with automatic rotation."

---

## 8.2 Common Interview Questions & Sample Answers

### Q1: Explain how you would set up a CI/CD pipeline from scratch

**A:** "I would:
1. Set up CodeCommit/GitHub repository with branching strategy (main, dev, feature branches)
2. Create CodeBuild project with buildspec.yml for automated testing and artifact creation
3. Use CodePipeline to orchestrate stages: Source → Build → Test → Approval → Deploy
4. Implement CodeDeploy with Blue/Green deployments for zero-downtime deployments
5. Integrate CloudWatch for monitoring application and pipeline metrics
6. Set up SNS notifications for pipeline failures
7. Enable automated rollback on deployment failure

This ensures automated, repeatable deployments with quick rollback capability and full auditability."

---

### Q2: How would you ensure high availability for an application?

**A:** "I would implement:
1. Multi-AZ deployment: RDS Multi-AZ, Auto Scaling Group across AZs
2. Load balancing: Application Load Balancer with health checks
3. Auto-scaling: Scale based on CPU/memory metrics
4. Backup strategy: Automated RDS snapshots, S3 versioning
5. Disaster recovery: Cross-region failover for critical systems
6. Health checks: Configure health checks to detect failures quickly
7. Monitoring: CloudWatch alarms for critical metrics

This ensures application stays available even if an AZ fails."

---

### Q3: How do you manage secrets and credentials securely?

**A:** "I never commit secrets to code repositories. I use:
1. AWS Secrets Manager for database passwords and API keys - handles automatic rotation
2. Parameter Store for non-sensitive configuration
3. IAM roles for EC2 instances instead of hardcoded credentials
4. Environment variables injected at runtime
5. KMS encryption for data at rest
6. VPC endpoints for private access to AWS services without internet exposure

This prevents credential leakage and enables automatic rotation."

---

### Q4: Explain CloudFormation vs Terraform

**A:** "CloudFormation:
- AWS-native, simpler for AWS-only projects
- Managed by AWS (no state file to manage)
- Uses JSON/YAML
- Better integration with AWS services

Terraform:
- Cloud-agnostic (AWS, Azure, GCP, etc.)
- Uses HCL (easier syntax)
- Explicit state management (store in S3)
- Better for multi-cloud strategies

I'd choose CloudFormation for AWS-only rapid prototyping, Terraform for enterprise multi-cloud environments."

---

### Q5: How would you troubleshoot a failed CodePipeline deployment?

**A:** "I would:
1. Check CodePipeline execution history to identify failed stage
2. View CodeBuild logs in CloudWatch for build errors
3. Check CodeDeploy agent logs on EC2 instances (/var/log/codedeploy-agent/)
4. Verify IAM roles have correct permissions for each service
5. Check security groups and network ACLs for connectivity issues
6. Review buildspec.yml and appspec.yml for syntax errors
7. Test deployment manually on a test instance
8. Check CloudWatch Logs for application-level errors
9. Review environment variables and parameter store values

This systematic approach isolates the issue quickly."

---

### Q6: What is blue/green deployment?

**A:** "Blue/Green involves running two identical production environments:
- Blue: Current version (receiving traffic)
- Green: New version (being tested)

Process:
1. Deploy new code to Green environment
2. Run smoke tests on Green
3. Switch load balancer to Green (instant)
4. If issues, switch back to Blue (immediate rollback)

Advantages:
- Zero downtime deployment
- Quick rollback (switch back to Blue)
- Minimal traffic loss
- Thorough testing before switching
- Easy A/B testing"

---

### Q7: How would you implement monitoring for microservices?

**A:** "I would:
1. CloudWatch: Collect metrics from EC2, ECS, Lambda
2. X-Ray: Distributed tracing to visualize service dependencies and latencies
3. CloudWatch Logs: Centralize logs with log groups for each service
4. CloudWatch Logs Insights: Query logs for troubleshooting
5. Alarms: Create alarms for critical metrics (error rate > 5%, latency > 1s)
6. SNS: Send notifications to on-call team
7. Dashboards: Create dashboards for ops teams showing key metrics
8. Custom Metrics: Publish application-specific metrics (order count, processing time)

This provides complete visibility into system health and performance."

---

### Q8: Explain IAM's principle of least privilege

**A:** "Principle of Least Privilege means:
- Grant users only minimum permissions needed for their job
- Example: Developer shouldn't delete RDS databases

Implementation:
- Use specific resource ARNs, never wildcards (*)
- Create separate roles for different job functions
- Use conditions (IP restrictions, time-based)
- Regularly audit and remove unnecessary permissions
- Enable CloudTrail for audit trail

Example policy:
```json
{
  "Effect": "Allow",
  "Action": "s3:GetObject",
  "Resource": "arn:aws:s3:::my-bucket/app-logs/*"
}
```

This reduces security risk if credentials are compromised."

---

## 8.3 Hands-On Projects to Showcase

### Project 1: Complete CI/CD Pipeline
**Build:**
- GitHub repository with Node.js/Python application
- CodeBuild buildspec.yml with tests and Docker build
- CodePipeline with 5+ stages (Source, Build, Test, Approval, Deploy)
- CodeDeploy with Blue/Green deployment to EC2
- CloudWatch alarms and SNS notifications

**Showcase:**
- Commit code change and show deployment
- Demonstrate rollback capability
- Show CloudWatch logs and metrics

---

### Project 2: Infrastructure as Code
**Build:**
- CloudFormation template or Terraform configuration
- VPC with public/private subnets
- EC2 instances, RDS database, S3 bucket
- Load balancer with auto-scaling group
- Security groups and IAM roles

**Showcase:**
- Deploy infrastructure from code
- Show resource creation in AWS console
- Demonstrate infrastructure destruction
- Explain each component's purpose

---

### Project 3: Containerized Microservices
**Build:**
- Docker image of microservice
- Push to ECR (Elastic Container Registry)
- Deploy to ECS Fargate or EKS
- Configure service discovery and load balancing
- Set up auto-scaling based on metrics

**Showcase:**
- Show Docker image in ECR
- Demonstrate deployment and scaling
- Show logs from CloudWatch
- Explain why containers are better

---

### Project 4: Monitoring & Observability
**Build:**
- Deploy application with CloudWatch metrics
- Create custom metrics from application logs
- Set up CloudWatch Logs Insights queries
- Create alarms and SNS notifications
- Build CloudWatch dashboards
- Implement X-Ray tracing

**Showcase:**
- Show CloudWatch metrics and alarms
- Run logs insights query to find errors
- Demonstrate X-Ray service map
- Explain observability strategy

---

## 8.4 Technical Interview Tips

1. **Think out loud:** Explain reasoning as you solve problems
2. **Ask clarifying questions:** Understand requirements before diving in
3. **Start with high-level design:** Architecture first, details later
4. **Consider trade-offs:** Discuss pros/cons of different approaches
5. **Mention security:** Show mature thinking about security concerns
6. **Use real examples:** Reference projects you've built
7. **Ask about their environment:** Show genuine interest
8. **Be honest about gaps:** "I haven't worked with that, but here's how I'd approach it"

---

## 8.5 Behavioral Interview Tips

**STAR Method:** Situation, Task, Action, Result

**Examples to prepare:**
- Challenge you overcame
- How you handled disagreement with team
- Time you improved process
- Failure and what you learned
- How you helped someone
- Proudest accomplishment

**Show:**
- Learning mindset
- Collaboration skills
- Problem-solving ability
- Responsibility and ownership
- Adaptability

---

## 8.6 Salary Negotiation (8-10 LPA Range)

**Market Research:**
- Glassdoor: Average 7.5-11 LPA for DevOps freshers
- AmbitionBox: Comparable data for India
- LinkedIn Salary: Industry standards

**Your Value Proposition:**
- AWS expertise (in-demand skill)
- CI/CD pipeline design (valuable for efficiency)
- IaC experience (reproducibility)
- Monitoring & security knowledge

**Negotiation Strategy:**
1. Don't mention first - let them make offer
2. Ask about total compensation (salary + bonus + stocks + benefits)
3. Research company - startup vs enterprise
4. Negotiate professionally: "Based on my skills and market rates, I'd like X"
5. Consider other factors: Remote, learning budget, team culture
6. Be prepared to walk if offer is below 8 LPA for your experience level

---

## 8.7 Red Flags to Avoid

- Don't claim expertise in tools you haven't used
- Avoid negative comments about previous employers
- Don't be too rigid: "This is the only way"
- Avoid oversharing personal problems
- Don't ask only about salary and benefits
- Don't be late or unprofessional

---

## 8.8 Post-Interview

1. **Send thank-you email within 24 hours**
2. **Mention specific topics discussed**
3. **Reiterate your interest** in the role
4. **Ask timeline for next steps**
5. **Follow up after a week** if no response

---

## 8.9 AWS Certifications to Consider

| Certification | Relevance | Difficulty |
|---|---|---|
| Cloud Practitioner | Foundation (optional) | Easy |
| Solutions Architect - Associate | Highly relevant | Medium |
| Developer - Associate | Very relevant for DevOps | Medium |
| DevOps Engineer - Professional | Ultimate credential | Hard |

---

## 8.10 Learning Resources

**Online Courses:**
- A Cloud Guru (AWS courses)
- Linux Academy (DevOps tools)
- Udemy (specific topics)
- Pluralsight (comprehensive)

**Documentation:**
- AWS Official Documentation (read thoroughly)
- Man pages for Linux commands
- GitHub repositories for code examples

**YouTube Channels:**
- Techworld with Nana (DevOps)
- TechGuruYT (AWS)
- Linux Academy

**Practice:**
- LeetCode/HackerRank (coding)
- AWS Console (hands-on practice)
- Build projects (GitHub portfolio)

---

## Final Checklist for Interview Readiness

- [ ] Can explain DevOps principles clearly
- [ ] Understand CloudFormation vs Terraform
- [ ] Can design a CI/CD pipeline end-to-end
- [ ] Know Docker, ECS, EKS differences
- [ ] Understand VPC security (public/private subnets)
- [ ] Know IAM policies and least privilege
- [ ] Can troubleshoot common issues
- [ ] Have 3-4 completed projects to showcase
- [ ] Can explain your projects in detail
- [ ] Prepared STAR examples for behavioral questions
- [ ] Know market rates and can negotiate
- [ ] Practice articulating your thoughts clearly
- [ ] Research the company thoroughly
- [ ] Test your video/audio setup (for remote interviews)

---

# GOOD LUCK WITH YOUR DEVOPS CAREER! 🚀

Remember:
- DevOps is about collaboration and automation
- Practice is key to mastery
- Build projects to solidify learning
- Keep learning as technology evolves
- Network with other DevOps professionals

**You've got this! 💪**
