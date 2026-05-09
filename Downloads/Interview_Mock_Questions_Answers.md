# DevOps Interview - 50+ Mock Questions & Answers
## Target Salary: 8-10 LPA for Freshers

---

## SECTION 1: FUNDAMENTAL CONCEPTS

### Q1: What is DevOps and why is it important?

**Expected Answer Structure:**
- Definition
- Problems it solves
- Benefits
- Real-world relevance

**Good Answer:**
"DevOps is a cultural and technical practice that combines software development and IT operations. It breaks down silos between teams.

Why important:
1. **Faster Deployments:** Automate repetitive tasks (testing, deployment)
2. **Better Quality:** Catch bugs early through continuous testing
3. **Reliability:** Monitoring catches issues before users do
4. **Cost Efficiency:** Automation reduces manual work
5. **Collaboration:** Developers and ops work together

Real example: Netflix uses DevOps to deploy thousands of times per day. Traditional approach would take months to deploy once."

**Follow-up Questions to Expect:**
- How does DevOps differ from Agile?
- What metrics measure DevOps success?

**Better Answer to Metrics:**
"Key DevOps metrics:
- **Deployment Frequency:** How often we deploy (goal: daily or more)
- **Lead Time:** Time from code commit to production
- **Mean Time to Recovery (MTTR):** Time to fix production issues
- **Change Failure Rate:** Percentage of deployments causing issues
- **System Uptime:** Application availability percentage (goal: 99.9% or higher)"

---

### Q2: Explain the difference between Continuous Integration, Continuous Delivery, and Continuous Deployment

**Common Mistake:**
Confusing CD (it's overloaded) or saying they're the same thing.

**Correct Answer:**
```
Continuous Integration (CI):
- Developers commit code frequently (multiple times per day)
- Automated tests run immediately
- Build happens automatically
- Feedback within minutes
- Goal: Catch integration issues early

Continuous Delivery (CD):
- Extension of CI
- Automated testing, building, and deployment preparation
- Manual approval required before production
- Deploy-ready code at all times
- Business decides when to deploy
- Example: AWS CodePipeline with manual approval stage

Continuous Deployment:
- Fully automated
- Every change that passes tests goes to production automatically
- No manual approval
- Highest frequency deployments
- Requires mature monitoring and rollback strategies
- Example: Facebook, Netflix

Visual:
CI: Merge → Test → Build
CD (Delivery): CI + Prepare for deploy + Wait for approval → Deploy
CD (Deployment): CI + Automatic deploy (no approval)
```

**Interview Tip:**
Mention that "CD" is ambiguous and always clarify which one you mean.

---

### Q3: What is Infrastructure as Code and why should we use it?

**Answer:**
"IaC means managing infrastructure through code instead of manual processes (clicking in console, running shell scripts).

Why IaC:
1. **Reproducibility:** Create identical infrastructure multiple times
2. **Version Control:** Track infrastructure changes like code
3. **Automation:** No manual steps = fewer errors
4. **Documentation:** Code IS documentation
5. **Cost Estimation:** Know infrastructure costs before deployment
6. **Rollback:** Easy to revert infrastructure changes
7. **Testing:** Infrastructure changes can be tested

Example: Without IaC, deploying to 5 regions takes hours of manual work. With IaC, it's automated and consistent.

Two main approaches:
- **Declarative (CloudFormation, Terraform):** Describe desired state
- **Imperative (Custom scripts):** Step-by-step instructions

Declarative is better (easier to understand, less error-prone)."

---

## SECTION 2: AWS SERVICES DEEP DIVE

### Q4: Compare EC2, Lambda, and ECS. When would you use each?

**Answer:**
"Each serves different use cases:

EC2 (Elastic Compute Cloud):
- Virtual machines you manage
- Full control over OS, networking, security
- Use when: Traditional applications, need specific OS/libraries
- Cost: Always paying (even idle)
- Example: Web servers, application servers, databases

Lambda (Serverless):
- No infrastructure management
- Pay only for execution time
- Limited to 15-minute execution
- Use when: Event-driven workloads, unpredictable traffic
- Cost: Cheapest for sporadic usage
- Example: API backends, scheduled tasks, event processing

ECS (Containerized):
- Run Docker containers
- Middle ground between EC2 and Lambda
- Manages container placement automatically
- Use when: Microservices, want containerization benefits
- Cost: Lower than EC2, more predictable than Lambda
- Example: Microservices architecture

Decision Tree:
- Need containers? → ECS or EKS
- Unpredictable traffic? → Lambda
- Long-running app? → EC2
- Traditional app? → EC2
- Microservices? → ECS/EKS

Company Scenario:
'For an e-commerce site, I'd use:
- EC2 with ASG for web servers
- RDS for database
- Lambda for order processing triggered by S3 events
- ECS for microservices (inventory, payment, shipping)
- CloudFront for static assets'"

---

### Q5: What is RDS Multi-AZ vs Read Replicas?

**This is a VERY common question. Get it right!**

**Wrong Answer:**
"Both provide redundancy" (too vague)

**Correct Answer:**
```
Multi-AZ (Availability Zone):
- Two identical databases in different AZs
- Synchronous replication (data immediately copied)
- Automatic failover (< 2 minutes downtime)
- Same region
- Use for: HIGH AVAILABILITY (no downtime on failure)
- Cost: 2x database cost

Read Replicas:
- Read-only copy of database
- Asynchronous replication (slight delay possible)
- Manual failover (need to update connection string)
- Can be different region or AZ
- Use for: SCALING READS (spread read load)
- Cost: Replica charges, but can reduce costs via read scaling

Visual:
Multi-AZ:
Primary (AZ-A) ←→ Standby (AZ-B)
Both identical, synchronous

Read Replica:
Primary (AZ-A) → Read Replica 1 (AZ-B)
              → Read Replica 2 (Region-B)

Can combine: Primary with Multi-AZ + Read Replicas

Example Architecture:
- E-commerce site with high reads
- Primary in AZ-A with Multi-AZ standby in AZ-B
- Read replicas in AZ-C for reporting (heavy queries)
- Read replicas in us-west region for global users
```

**Follow-up: How would you fail over?**
"Multi-AZ: Automatic, AWS handles it
Read Replicas: Promote replica to standalone database, update application connection string"

---

### Q6: Explain S3 storage classes and when to use each

**Answer:**
```
Standard:
- Frequently accessed data
- Cost: Higher per GB
- Retrieval: Immediate
- Use: Websites, databases, content distribution
- Minimum storage: None

Intelligent-Tiering:
- Access patterns unknown
- Automatically moves between tiers
- Cost: Similar to Standard (with small management fee)
- Use: Unknown or changing access patterns
- Minimum storage: 30 days

Standard-IA (Infrequent Access):
- Accessed < once per month
- Cost: Lower per GB, higher retrieval fee
- Retrieval: Immediate
- Minimum storage: 30 days
- Use: Backups, disaster recovery
- Example: Application logs older than 30 days

One Zone-IA:
- Like Standard-IA but single AZ (no redundancy)
- Cost: Cheapest of frequently available classes
- Use: Secondary backups (already have primary backup)

Glacier:
- Long-term archival (months/years)
- Cost: Very cheap per GB
- Retrieval: 1-5 minutes (Standard), 3-5 hours (Bulk)
- Minimum storage: 90 days
- Use: Compliance archival, rarely accessed data

Deep Archive:
- Long-term archival (7-10 years)
- Cost: Cheapest option
- Retrieval: 12 hours (Standard), 48 hours (Bulk)
- Minimum storage: 180 days
- Use: Regulatory archival

Cost Example (per GB/month, US East):
- Standard: $0.023
- Intelligent-Tiering: $0.0125 (avg)
- Standard-IA: $0.0125 (+ retrieval fee)
- Glacier: $0.004
- Deep Archive: $0.00099

Real Example:
1. Day 1-30: User downloads logs → Standard
2. Day 30-90: Weekly access → Standard-IA
3. Day 90+: Compliance archival → Glacier
(Use S3 Lifecycle policies to automate)
```

---

### Q7: What is a Security Group vs Network ACL?

**Answer:**
```
Security Group:
- Stateful firewall (remembers connections)
- Applied to EC2 instances
- Inbound: Default DENY (explicit allow required)
- Outbound: Default ALLOW
- Rules processed in order (all matching rules apply)
- Changes take effect immediately

Network ACL:
- Stateless firewall (doesn't remember)
- Applied to subnets
- Inbound: Default DENY
- Outbound: Default DENY
- Rules processed in order (first match wins)
- Changes take effect immediately

Difference Example:
Traffic: 10.0.1.100:50000 → 10.0.2.100:443

Security Group:
1. Inbound: Allow port 443 → PASS
2. Remembers connection
3. Outbound response: Allowed (stateful)

NACL:
1. Inbound: Allow port 443 (rule 100) → PASS
2. Outbound: Must explicitly allow ephemeral ports (1024-65535)
3. If outbound rule denies, response blocked

When to Use:
- Security Groups: 99% of cases (instance-level security)
- NACLs: Edge cases like blocking specific IP ranges

Common Mistake:
Allowing port 443 inbound but blocking ephemeral ports outbound
(outbound responses fail silently)
```

---

## SECTION 3: CI/CD & DEPLOYMENT

### Q8: Design a CI/CD pipeline for a microservices application

**Answer Structure:**
1. Overview
2. Tools at each stage
3. Automation details
4. Failure handling
5. Monitoring

**Good Answer:**
```
Pipeline Stages:

1. SOURCE (Trigger)
   - GitHub webhook on push to main branch
   - Checkout code
   - Identify changes (which services modified)

2. BUILD
   - CodeBuild (concurrent builds for each service)
   - For each service:
     * Unit tests (JUnit, pytest)
     * Code quality (SonarQube)
     * Build Docker image
     * Push to ECR
   - Fail fast on test failures

3. SECURITY SCAN
   - Container image scan (ECR scan)
   - Secrets scan (TruffleHog)
   - Infrastructure scan (Snyk)
   - Fail if critical vulnerabilities

4. DEPLOY STAGING
   - Deploy to staging ECS cluster
   - Run smoke tests
   - Run integration tests
   - Performance tests
   - Security tests (OWASP)

5. APPROVAL
   - Manual approval from team lead
   - Can review logs, metrics, test results
   - Can abort or proceed

6. DEPLOY PRODUCTION (Blue/Green)
   - Blue: Current version (traffic)
   - Green: New version (no traffic)
   - 5-minute health check on Green
   - Canary: 10% traffic to Green for 30 min
   - Full rollout: 100% traffic to Green
   - Monitoring: Watch for errors/latency

7. ROLLBACK
   - If error rate > 5%: Auto-rollback to Blue
   - If latency > 500ms: Auto-rollback to Blue
   - Manual rollback available anytime

8. MONITORING
   - CloudWatch metrics
   - X-Ray tracing
   - Real User Monitoring (RUM)
   - Alerts to on-call team

Artifacts:
- Code: GitHub
- Builds: ECR (Docker images)
- Config: Parameter Store/Secrets Manager
- Logs: CloudWatch Logs
- Metrics: CloudWatch

Tools:
- CodePipeline: Orchestration
- CodeBuild: Build & test
- CodeDeploy: Deployment
- CloudWatch: Monitoring
- SNS: Notifications

Expected Results:
- Deploy frequency: Daily or multiple times per day
- Lead time: < 1 hour code to production
- MTTR: < 15 minutes for critical issues
- Change failure rate: < 10%
```

---

### Q9: What is Blue/Green deployment and what are alternatives?

**Answer:**
```
BLUE/GREEN DEPLOYMENT:

Concept:
- Blue: Current version (production, receiving traffic)
- Green: New version (production, no traffic)
- Instant switch at load balancer

Process:
1. Deploy new code to Green environment
2. Run smoke tests on Green
3. Switch load balancer to Green (instant)
4. Monitor Green for 15-30 minutes
5. If issues detected, switch back to Blue

Advantages:
✓ Zero downtime
✓ Quick rollback (switch back to Blue)
✓ No traffic loss
✓ Full testing before going live
✓ Easy A/B testing

Disadvantages:
✗ Requires 2x infrastructure costs
✗ More complex setup
✗ Database migration challenges

---

CANARY DEPLOYMENT:

Concept:
- Route small percentage of traffic to new version
- Monitor errors and latency
- Gradually increase traffic

Process:
1. Deploy new version
2. Send 10% traffic for 30 minutes (canary)
3. Monitor error rate and latency
4. If good, increase to 25%, then 50%, then 100%
5. If bad, rollback immediately

Advantages:
✓ Reduces risk (only 10% exposed)
✓ Real user monitoring
✓ Early detection of issues
✓ Lower infrastructure cost

Disadvantages:
✗ Slower rollout (30-60 minutes)
✗ Complexity (traffic splitting)
✗ Stateful apps difficult

---

ROLLING DEPLOYMENT:

Concept:
- Replace instances gradually

Process:
1. Remove 1 instance from load balancer
2. Deploy new version to instance
3. Add back to load balancer
4. Repeat for each instance

Advantages:
✓ No downtime
✓ Gradual transition
✓ Reduced infrastructure cost

Disadvantages:
✗ Slower deployment
✗ Database compatibility issues difficult
✗ Traffic momentarily reduced

---

SHADOW DEPLOYMENT:

Concept:
- New version runs in parallel
- Traffic mirrored to new version
- Errors don't affect users

Use: Test in production safely

---

MY CHOICE:

For microservices: Blue/Green + Canary
- Deploy to Green (Blue/Green)
- Send 10% traffic (Canary)
- Gradually increase traffic
- Full rollback if issues

For database migrations: Rolling deployment
(incompatible schema changes need special handling)
```

---

### Q10: How would you handle database migrations in CI/CD?

**Answer:**
```
Challenge:
Database changes often can't be rolled back easily.
Need to support both old and new code simultaneously.

SOLUTIONS:

1. EXPAND-CONTRACT PATTERN:

Phase 1 (Expand): Add new column
- Old code: Uses old column
- New code: Uses both old and new column
- Data copied to new column

Phase 2 (Contract): Remove old column
- New code: Uses only new column
- Wait 1 release to ensure all old code gone
- Remove old column

Example:
- Release 1: Add email_new column, migrate data
- Release 2: Switch code to use email_new
- Release 3: Delete email column

Advantages:
✓ Zero-downtime migration
✓ Easy rollback (old column still there)
✓ Handles code/db mismatch

2. BLUE/GREEN DEPLOYMENTS:

Use separate databases for Blue/Green
- Run migration on Green database
- Test thoroughly
- Switch database connection in code
- Quick rollback to Blue database

Challenges:
✗ Database size doubles
✗ Data sync during transition
✗ Expensive for large databases

3. FEATURE FLAGS:

New code hidden behind feature flag
```
boolean useNewSchema = featureFlags.get("newSchema");
```
- Database change deployed silently
- Gradually enable feature flag
- Easy rollback (disable flag)

4. VERSIONED ENDPOINTS:

Use API versioning
- Old code: /api/v1/users
- New code: /api/v2/users
- Support both simultaneously
- Migrate clients gradually

5. MIGRATION SCRIPTS IN CODE:

Include migration scripts in deployments
- Liquibase or Flyway for Java
- Alembic for Python
- Version migrations
- Automatic rollback on failure

Example (Alembic):
```
def upgrade():
    op.add_column('users', Column('email_new', String))
    
def downgrade():
    op.drop_column('users', 'email_new')
```

BEST PRACTICE:

Use Expand-Contract + Feature Flags:
1. Deploy code with feature flag OFF
2. Expand database (add column)
3. Migrate data
4. Enable feature flag (gradual rollout)
5. Monitor for issues
6. Contract database (remove old column) next release

This ensures:
- Zero downtime
- Easy rollback
- No code/database mismatch
- Gradual migration
```

---

## SECTION 4: CONTAINERS & ORCHESTRATION

### Q11: Explain Docker, ECS, and EKS. Which would you choose and why?

**Answer:**
```
DOCKER:

What: Container runtime
Solves: "Works on my machine" problem
Packages: App + Dependencies + Config
Benefits:
- Lightweight (MB, not GB)
- Fast startup (seconds)
- Consistent across environments
- Isolation from other containers

Dockerfile Example:
```
FROM python:3.9-slim
COPY app.py /app/
WORKDIR /app
RUN pip install flask
CMD ["python", "app.py"]
```

Build: docker build -t myapp:1.0 .
Run: docker run -p 5000:5000 myapp:1.0

---

ECS (Elastic Container Service):

What: AWS container orchestration
Manages: Running containers, scaling, networking
How it works:
1. Create task definition (Docker config)
2. Create service (how many tasks, load balancer)
3. ECS schedules tasks on cluster
4. Auto-scales based on metrics

Launch Types:
- EC2: Run on EC2 instances you manage
- Fargate: Serverless, AWS manages infrastructure

Pros:
✓ AWS-native (good integration)
✓ Simple to use
✓ Cheaper than EKS
✓ Less operational overhead

Cons:
✗ AWS-only
✗ Less flexibility than Kubernetes
✗ Smaller community

Use: Single cloud, AWS-only teams

---

EKS (Elastic Kubernetes Service):

What: Managed Kubernetes on AWS
Industry standard orchestration platform
Kubernetes handles: Scheduling, scaling, networking, storage

Concepts:
- Pod: Smallest unit (usually 1 container)
- Deployment: Describes desired state
- Service: Exposes pods to network
- Namespace: Logical cluster partition

Manifest Example:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: myapp
        image: myapp:1.0
        ports:
        - containerPort: 5000
```

Pros:
✓ Industry standard
✓ Multi-cloud (AWS, Azure, GCP)
✓ Powerful features (auto-scaling, self-healing)
✓ Huge community

Cons:
✗ Complexity (steep learning curve)
✗ More expensive than ECS
✗ Operational overhead (must manage control plane)

Use: Multi-cloud, large-scale, complex requirements

---

MY CHOICE:

For a startup (1-50 engineers):
→ Use ECS (simplicity, cost, speed to market)

For a large company (100+ engineers):
→ Use EKS (standardization, multi-cloud)

For multi-cloud requirements:
→ Use EKS (not tied to AWS)

For unpredictable workloads:
→ Use ECS Fargate (serverless)

For cost optimization:
→ Use ECS EC2 (cheaper)

Decision Flow:
```
AWS-only? → YES → Use ECS
Multi-cloud? → Use EKS
Need serverless? → Use Fargate
Cost critical? → Use ECS EC2
```

Fargate special:
```
ECS Fargate = ECS + Serverless
- Don't manage EC2 instances
- Pay per task (CPU/memory)
- Good for:
  * Unpredictable traffic
  * Microservices (many small tasks)
  * Don't want ops overhead
```
```

---

### Q12: How would you monitor containerized applications?

**Answer:**
```
Multi-layer monitoring:

1. CONTAINER METRICS:

CloudWatch:
- CPU utilization
- Memory utilization
- Network I/O
- Disk I/O

Container Insights:
- Container-level metrics
- Pod CPU/memory (EKS)
- Task CPU/memory (ECS)

2. APPLICATION METRICS:

Custom metrics:
- Request count
- Response time
- Error rate
- Business metrics (orders, revenue)

Push to CloudWatch:
```python
import boto3
cloudwatch = boto3.client('cloudwatch')
cloudwatch.put_metric_data(
    Namespace='MyApp',
    MetricData=[{
        'MetricName': 'OrderCount',
        'Value': 42,
        'Unit': 'Count'
    }]
)
```

3. LOGS:

CloudWatch Logs:
- Centralize container logs
- CloudWatch Logs Insights for querying
- Log groups per service
- Retention policies

Example query:
```
fields @timestamp, @message, status_code
| stats count() as errors by status_code
| filter status_code >= 500
```

ELK Stack (alternative):
- Elasticsearch: Store logs
- Logstash: Process logs
- Kibana: Visualize logs

4. DISTRIBUTED TRACING:

X-Ray:
- Track requests across services
- Visualize service dependencies
- Measure latency per service
- Identify bottlenecks

Jaeger (open source alternative):
- Similar to X-Ray
- Good for multi-cloud

5. HEALTH CHECKS:

Container level:
```yaml
healthCheck:
  command: ["CMD", "curl", "-f", "http://localhost:5000/health"]
  interval: 30s
  timeout: 3s
  retries: 3
```

Application level:
- /health endpoint (returns status)
- Readiness probe (ready to accept traffic)
- Liveness probe (app still working)

6. ALERTING:

CloudWatch Alarms:
- CPU > 80% → scale up
- Error rate > 5% → page on-call
- Latency > 1s → investigate

SNS notifications:
- Email alerts
- Slack notifications
- PagerDuty integration

7. DASHBOARDS:

CloudWatch Dashboard:
```json
{
  "widgets": [
    {
      "type": "metric",
      "properties": {
        "metrics": [
          [ "AWS/ECS", "CPUUtilization", {"stat": "Average"} ],
          [ "AWS/ECS", "MemoryUtilization", {"stat": "Average"} ]
        ]
      }
    }
  ]
}
```

Grafana:
- Pull metrics from Prometheus/CloudWatch
- Beautiful dashboards
- Alert rules

COMPLETE MONITORING STACK:

Metrics: CloudWatch + Prometheus
Logs: CloudWatch Logs + ELK
Traces: X-Ray + Jaeger
Alerts: CloudWatch Alarms + PagerDuty
Dashboard: CloudWatch + Grafana

Cost optimization:
- Aggregate logs to reduce ingestion cost
- Use CloudWatch Logs Insights (cheaper than storing all logs)
- Set retention policies (delete old logs)
```

---

## SECTION 5: SECURITY & BEST PRACTICES

### Q13: How would you secure a production VPC?

**Answer:**
```
VPC ARCHITECTURE:

                           Internet
                              ↑
                        Internet Gateway
                              ↑
        ────────────────── Public Subnet ──────────────────
        │                                                    │
        │  ALB (Port 80, 443)                               │
        │  NAT Gateway (for private outbound)               │
        │                                                    │
        ──────────────────────────────────────────────────────
                              ↑
        ────────────────── Private Subnet ──────────────────
        │                                                    │
        │  Application Servers (Port 5000)                  │
        │  Auto-scaling Group                               │
        │                                                    │
        ──────────────────────────────────────────────────────
                              ↑
        ────────────────── Private Subnet ──────────────────
        │                                                    │
        │  RDS Database (Port 3306)                         │
        │  No internet access                               │
        │                                                    │
        ──────────────────────────────────────────────────────

SECURITY LAYERS:

1. NETWORK LEVEL:

VPC Segmentation:
- Public subnet: NAT Gateway, ALB (always on)
- Private subnet: Application servers (no internet)
- Private subnet: Databases (no internet)

Security Groups:
```
ALB Security Group:
- Inbound: HTTP (80), HTTPS (443) from 0.0.0.0/0
- Outbound: To application servers

App Server Security Group:
- Inbound: Only from ALB
- Outbound: To databases, RDS, S3, CloudWatch

Database Security Group:
- Inbound: Only from app servers (port 3306)
- Outbound: None (databases don't initiate connections)
```

Network ACLs:
- Stateless firewall at subnet level
- Usually not needed if security groups are correct
- Emergency use: Block specific IP ranges

2. IAM LEVEL:

Roles for each component:
```
EC2 instances:
- Role: AllowS3Read, AllowSecretsManager
- Can read from S3
- Can retrieve database password from Secrets Manager
- Cannot delete databases, modify other resources

Lambda functions:
- Role: AllowDynamoDB, AllowCloudWatch
- Can read/write to specific DynamoDB table
- Can write logs to CloudWatch
- Nothing else

RDS:
- Encrypted with KMS
- Automated backups
- Multi-AZ for high availability
- Backup encryption enabled
```

Principle of Least Privilege:
```json
{
  "Effect": "Allow",
  "Action": "s3:GetObject",
  "Resource": "arn:aws:s3:::mybucket/app-data/*"
}
```
NOT:
```json
{
  "Effect": "Allow",
  "Action": "*",
  "Resource": "*"
}
```

3. DATA LEVEL:

Encryption at Rest:
- EBS volumes: Enabled by default
- RDS: Enable encryption
- S3: Server-side encryption (AES-256)
- DynamoDB: Enable encryption

Encryption in Transit:
- HTTPS only (TLS 1.2+)
- RDS: Use SSL/TLS connections
- VPC endpoints for S3, DynamoDB (no internet exposure)

Secrets Management:
```
Never: Hardcode credentials in code or configs
Use: AWS Secrets Manager

Example:
```python
import boto3
secrets = boto3.client('secretsmanager')
secret = secrets.get_secret_value(SecretId='db-password')
password = secret['SecretString']
```

Secrets Manager handles:
- Password rotation (automatic)
- Encryption (with KMS)
- Audit trail (CloudTrail)
- Fine-grained access control (IAM)

4. MONITORING & AUDITING:

CloudTrail:
- Log all API calls
- Who, what, when, where
- Compliance auditing
- Send logs to S3

CloudWatch:
- Monitor for suspicious activity
- Alarm on failed login attempts
- Track security group changes

VPC Flow Logs:
- Network traffic logs
- Detect unusual patterns
- Troubleshoot connectivity

5. COMPLIANCE:

WAF (Web Application Firewall):
- Protect against SQL injection
- Protect against XSS
- Rate limiting (prevent abuse)
- Geographic blocking

Config Rules:
- Ensure security group allows only known IPs
- Ensure S3 versioning enabled
- Ensure RDS encryption enabled

MFA:
- Root account: Enable MFA
- All users: Encourage MFA

6. INCIDENT RESPONSE:

Security Group Hardening:
- Audit regularly (who has access)
- Restrict to least privilege
- Remove unused rules

Secrets Rotation:
- Database passwords: Rotate every 30 days
- API keys: Rotate every 90 days
- Automated rotation (Secrets Manager)

Backup & Recovery:
- RDS: Daily automated backups (35 days retention)
- S3: Versioning enabled
- Cross-region backups for disaster recovery

CHECKLIST:

✓ VPC with public/private subnets
✓ NAT Gateway in public subnet
✓ Security groups (least privilege)
✓ NACLs for additional security
✓ Encryption at rest (KMS)
✓ Encryption in transit (TLS)
✓ Secrets Manager for credentials
✓ IAM roles (least privilege)
✓ CloudTrail logging
✓ CloudWatch monitoring
✓ VPC Flow Logs
✓ WAF for web applications
✓ MFA for all users
✓ Automated backups
✓ Regular security audits
```

---

### Q14: What is a common security mistake and how would you fix it?

**Answer:**
```
COMMON MISTAKE #1: Security Group Too Permissive

Problem:
```
Inbound: 0.0.0.0/0 on port 22 (SSH)
Inbound: 0.0.0.0/0 on port 3306 (MySQL)
```

Risk:
- Anyone can SSH into server
- Anyone can connect to database
- Brute force attacks
- Data theft

Fix:
```
Inbound SSH: Only from bastion host (specific IP)
Inbound MySQL: Only from app servers (security group)
```

---

COMMON MISTAKE #2: Hardcoded Credentials

Problem:
```python
# In code repository
DB_PASSWORD = "my-secret-password-123"
API_KEY = "sk_live_xxxxxxxxxxxx"
```

Risk:
- Credentials in Git history forever
- Anyone with repo access gets credentials
- Leaked in GitHub (scanners find these)
- Difficult to rotate

Fix:
```python
# Use Secrets Manager
import boto3
secrets = boto3.client('secretsmanager')
db_password = secrets.get_secret_value(
    SecretId='rds-password'
)['SecretString']
```

---

COMMON MISTAKE #3: Database Without Encryption

Problem:
```
RDS instance created without encryption
S3 bucket with public read access
```

Risk:
- Data exposed if storage device stolen
- Compliance violation (GDPR, HIPAA)
- Difficult to enable later

Fix:
```
Enable encryption by default:
- RDS: Check "Encrypt" when creating
- S3: Enable default encryption
- EBS: Enable encryption
```

---

COMMON MISTAKE #4: No Backup Strategy

Problem:
```
No automated backups
Manual backups rarely done
```

Risk:
- Data loss from accidental deletion
- No recovery from ransomware
- Compliance violation
- Business continuity disaster

Fix:
```
Automated backups:
- RDS: 35-day automated backups
- S3: Versioning enabled
- Cross-region backups
- Regular restore tests
```

---

COMMON MISTAKE #5: Over-privileged IAM

Problem:
```json
{
  "Effect": "Allow",
  "Action": "*",
  "Resource": "*"
}
```

Risk:
- If credentials compromised, attacker has full access
- Developer can accidentally delete production
- No audit trail of who did what

Fix:
```json
{
  "Effect": "Allow",
  "Action": [
    "s3:GetObject",
    "s3:ListBucket"
  ],
  "Resource": "arn:aws:s3:::my-bucket/*"
}
```

---

COMMON MISTAKE #6: No Monitoring

Problem:
```
No alerts for security events
No audit logging
```

Risk:
- Breach goes unnoticed for weeks
- Compliance audits fail
- No forensic evidence

Fix:
```
Enable:
- CloudTrail (log all API calls)
- CloudWatch alarms (suspicious activity)
- VPC Flow Logs (network activity)
- Config rules (configuration compliance)
```

---

COMMON MISTAKE #7: Public Database

Problem:
```
RDS database publicly accessible
Allow inbound from 0.0.0.0/0
```

Risk:
- Database exposed to internet
- Brute force attacks
- Data theft

Fix:
```
- Disable public accessibility
- Place in private subnet
- Access only through bastion host
- Use Security Groups to restrict access
```

---

COMMON MISTAKE #8: No MFA on Root Account

Problem:
```
Root account has only password
```

Risk:
- If password compromised, attacker has full access
- Can delete all resources
- Can change billing

Fix:
```
- Enable MFA on root account
- Use hardware MFA key (not phone)
- Store backup codes safely
- Avoid using root account for daily tasks
```

---

COMMON MISTAKE #9: Logging Disabled

Problem:
```
CloudTrail not enabled
VPC Flow Logs not configured
```

Risk:
- No audit trail
- Can't troubleshoot issues
- Compliance violation
- Forensic investigation impossible

Fix:
```
Enable:
- CloudTrail → S3 bucket
- CloudWatch Logs retention
- VPC Flow Logs → CloudWatch/S3
- S3 access logs
```

---

COMMON MISTAKE #10: Unencrypted Data in Transit

Problem:
```
HTTP instead of HTTPS
Unencrypted RDS connections
```

Risk:
- Data interceptable on network
- Man-in-the-middle attacks

Fix:
```
- Enforce HTTPS only
- Use TLS 1.2+
- RDS: Use SSL/TLS connections
- VPC endpoints (no internet exposure)
```
```

---

## SECTION 6: TROUBLESHOOTING

### Q15: CodePipeline deployment failed. How would you troubleshoot?

**Answer:**
```
SYSTEMATIC APPROACH:

Step 1: IDENTIFY WHICH STAGE FAILED

Check CodePipeline console:
- Source? Build? Test? Approval? Deploy?
- Look at failure message

Step 2: CHECK LOGS FOR THAT STAGE

Build Failure:
- CodeBuild → Check build logs in CloudWatch
- Look for error message (compilation error, test failure)
- Example: "npm test failed: 3 tests failed"

Deploy Failure:
- CodeDeploy → Check deployment logs on EC2
- SSH into instance:
  ```bash
  tail -f /var/log/codedeploy-agent/deployments/*/logs/scripts.log
  ```

Step 3: CHECK IAM PERMISSIONS

Common issue:
- CodeDeploy lacks permission to write to S3
- CodeBuild lacks permission to push to ECR
- Lambda lacks permission to access DynamoDB

Fix:
```
Verify IAM role has required permissions:
- CodeBuild role: Can push to ECR, read from S3
- CodeDeploy role: Can read artifacts from S3
- Lambda role: Can access required services
```

Step 4: CHECK SECURITY GROUPS

Can deployment instance reach:
- Database? (port 3306)
- API endpoint? (port 5000)
- S3? (use VPC endpoint)

Fix:
```
aws ec2 authorize-security-group-ingress \
  --group-id sg-xxx \
  --protocol tcp \
  --port 3306 \
  --source-security-group-id sg-yyy
```

Step 5: CHECK APPLICATION LOGS

On deployed instance:
```bash
# Check application is running
ps aux | grep python

# Check logs
tail -f /var/log/app.log

# Check connectivity
curl http://localhost:5000/health
```

Step 6: COMMON CAUSES & FIXES

Build Failure:
- Missing dependencies: Add to buildspec.yml
- Tests failing: Fix code, re-run pipeline
- Docker build: Check Dockerfile syntax

Deploy Failure:
- Health check failing: Check application logs
- Insufficient disk space: Clean up old files
- Permission denied: Fix file permissions

Approval Waiting:
- Manual approval stuck: Check if approver exists
- Wrong email: Verify SNS topic

Step 7: RERUN & VERIFY

Rerun failed stage:
- Click "Release change" in CodePipeline console

Verify deployment:
```bash
# SSH into instance
ssh -i key.pem ec2-user@instance-ip

# Check application
ps aux | grep app
curl http://localhost:5000/health

# Check logs
tail -f /var/log/app.log
```

TROUBLESHOOTING CHECKLIST:

✓ Which stage failed?
✓ Check that stage's logs
✓ Verify IAM permissions
✓ Check security groups
✓ Check application logs
✓ Verify database connectivity
✓ Check disk space
✓ Verify artifact existence in S3
✓ Check buildspec.yml syntax
✓ Check appspec.yml syntax
✓ Manual approval email sent?
```

---

### Q16: Application performance degraded. How would you diagnose?

**Answer:**
```
PERFORMANCE DIAGNOSIS:

Step 1: GATHER BASELINE

What's normal?
- Response time: < 200ms
- Error rate: < 1%
- CPU: < 70%
- Memory: < 80%

What's the problem?
- Response time: > 1000ms
- Error rate: > 5%
- CPU: > 90%
- Memory: > 95%

Step 2: CHECK INFRASTRUCTURE METRICS

CloudWatch:
```
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-01T01:00:00Z \
  --period 300 \
  --statistics Average
```

If CPU/Memory high:
→ Scaling issue? Out-of-memory leak? Bad code?

If Network I/O high:
→ Large data transfer? DDoS attack? Inefficient queries?

Step 3: CHECK APPLICATION METRICS

CloudWatch Logs Insights:
```
fields @timestamp, request_time, status_code
| stats avg(request_time) as avg_time, 
         max(request_time) as max_time,
         pct(request_time, 95) as p95
by status_code
```

Results:
- Is one endpoint slow? (database query?)
- Are all endpoints slow? (infrastructure?)
- Specific time pattern? (scheduled task?)

Step 4: CHECK DATABASE PERFORMANCE

RDS Performance Insights:
```
Shows:
- Active sessions
- Slow SQL queries
- Lock contention
- I/O usage
```

Query logs:
```sql
-- Slow queries
SELECT * FROM mysql.slow_log ORDER BY query_time DESC LIMIT 10;

-- Check for locks
SHOW ENGINE INNODB STATUS;
```

Step 5: CHECK EXTERNAL DEPENDENCIES

Are external APIs slow?
```
fields @timestamp, endpoint, latency
| filter endpoint like /external-api/
| stats avg(latency) by endpoint
```

Steps:
- Check third-party API status page
- Measure latency to external service
- Implement timeout and retry logic

Step 6: DISTRIBUTED TRACING

X-Ray service map:
- Which service is slow?
- Where is the bottleneck?

Example:
```
Request → ALB (5ms) → App (10ms) → Database (450ms) → Response
              ↑              ↑          ↑
           Normal        Normal    SLOW - investigate
```

Solution: Optimize database query or add caching

Step 7: ANALYZE LOGS

Common patterns:
```
Error in logs: "Connection refused" → Database down?
Error: "Timeout" → External API slow?
Error: "Out of memory" → Memory leak?
Error: "Too many open files" → Resource leak?
```

Step 8: COMMON CAUSES & FIXES

Database Query Slow:
→ Add index on frequently filtered columns
→ Use EXPLAIN to analyze query
→ Consider caching (Redis)

External API Slow:
→ Implement timeout
→ Implement retry with exponential backoff
→ Cache responses
→ Use circuit breaker pattern

Memory Leak:
→ Check for unclosed connections
→ Profile application (memory snapshots)
→ Review recent code changes
→ Increase memory allocation (temporary fix)

High CPU:
→ Inefficient algorithm? Use profiler
→ N+1 queries? Fix query logic
→ Infinite loop? Review recent code
→ Scale horizontally (add more instances)

Step 9: IMPLEMENT FIXES

Database optimization:
```sql
-- Add index
CREATE INDEX idx_user_email ON users(email);

-- Analyze query
EXPLAIN SELECT * FROM orders WHERE customer_id = 123;
```

Application optimization:
```python
# Before: 1 query per user (N+1 problem)
for user in users:
    orders = get_orders(user.id)

# After: 1 query for all
orders = get_all_orders(user_ids)
```

Caching:
```python
# Cache database query
@cache.cached(timeout=300)  # 5 minutes
def get_user(user_id):
    return User.query.get(user_id)
```

Step 10: MONITOR IMPROVEMENTS

Check if fixes worked:
```
aws cloudwatch get-metric-statistics \
  --namespace MyApp \
  --metric-name ResponseTime \
  --start-time (after fix) \
  --period 300
```

DIAGNOSIS CHECKLIST:

✓ What metrics are abnormal?
✓ When did it start? (time correlation)
✓ Is it infrastructure or application?
✓ Is it database or external dependency?
✓ Are there error patterns in logs?
✓ What changed recently?
✓ Run distributed tracing (X-Ray)
✓ Review slow query logs
✓ Check for resource leaks
✓ Implement fix
✓ Verify improvement
✓ Update monitoring/alerts
```

---

## SECTION 7: FINAL TIPS

### Interview Success Tips

1. **Structure Your Answers**
   - Problem statement
   - Solution approach
   - Implementation details
   - Expected outcomes

2. **Use Examples**
   - From projects you've built
   - From case studies (Netflix, Uber, etc.)
   - Specific tools and configurations

3. **Show Depth**
   - Don't just list tools
   - Explain trade-offs and decisions
   - Discuss alternative approaches

4. **Ask Clarifying Questions**
   - "What's the scale of the application?"
   - "How many transactions per second?"
   - "What's the team size?"

5. **Think About Operations**
   - Not just deployment, but monitoring
   - Not just automation, but rollback
   - Not just performance, but cost

6. **Be Honest About Gaps**
   - "I haven't used Kubernetes in production, but I understand the concepts"
   - "I'd need to refresh on that syntax"

7. **Show Continuous Learning**
   - "I've been learning about..."
   - "I recently completed AWS certification"
   - "I contribute to open source projects"

---

**Good luck with your interviews! Remember: DevOps is about collaboration, automation, and continuous improvement. Show these values in how you answer questions.** 🚀

---

# FINAL CHECKLIST

Before your interview:
- [ ] Can explain DevOps fundamentals clearly
- [ ] Understand all AWS services mentioned
- [ ] Have designed a complete CI/CD pipeline
- [ ] Know how to troubleshoot common issues
- [ ] Understand security best practices
- [ ] Can explain your projects in detail
- [ ] Prepared 2-3 STAR examples
- [ ] Researched the company
- [ ] Tested your internet connection
- [ ] Have questions prepared for the interviewer
