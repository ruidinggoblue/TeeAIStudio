# Pause AWS Resources to Avoid Idle Charges

Run these when you're not working on the project. Uses **us-west-1** and TeeStudio resource names.

---

## 1. Stop ECS tasks (Fargate)

Set the service desired count to **0** so no tasks run (no Fargate compute charges).

**AWS CLI:**

```bash
aws ecs update-service \
  --cluster teestudio-cluster \
  --service teestudio-service \
  --desired-count 0 \
  --region us-west-1
```

**Console:** ECS → Clusters → teestudio-cluster → teestudio-service → Update → Desired tasks: **0** → Update.

---

## 2. Stop RDS instance

Stopping the instance stops **instance** charges. You still pay for storage. The instance can be started again later.

**AWS CLI:**

```bash
aws rds stop-db-instance \
  --db-instance-identifier YOUR_RDS_INSTANCE_ID \
  --region us-west-1
```

Replace `YOUR_RDS_INSTANCE_ID` with your RDS instance identifier (e.g. from the RDS console; often something like `teestudio` or the name you gave when creating it).

**Console:** RDS → Databases → select your instance → Actions → **Stop**.

**Note:** After 7 days, AWS may auto-start the instance. To keep it stopped longer, stop it again or use a scheduled action.

---

## 3. What still incurs cost

- **Application Load Balancer (ALB)** – hourly charge while it exists. To stop: delete the CloudFormation stack `teestudio-stack` (this removes ALB, ECS service definition, target group, etc.). You can redeploy later with the same workflow.
- **ECR** – storage for Docker images (usually small).
- **RDS storage** – you pay for the allocated volume even when the instance is stopped.

---

## Resume when you start working again

1. **RDS:** RDS → Databases → select instance → Actions → **Start**. Wait until status is "Available".
2. **ECS:** Set desired count back to **1** (or use the deploy workflow which will start tasks with the new image):

   ```bash
   aws ecs update-service \
     --cluster teestudio-cluster \
     --service teestudio-service \
     --desired-count 1 \
     --region us-west-1
   ```
