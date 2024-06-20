## Production Deployment Pipeline with GitHub Actions

This section details the automated workflow for deploying infrastructure changes to the production environment using Terraform and GitHub Actions. This pipeline is triggered on two events:

- Push events to the `main` branch.
- Pull request events targeting the `main` branch (e.g., creation, merge).

**Key Difference from Staging Pipeline:**

- The production pipeline utilizes a matrix strategy to deploy infrastructure for multiple customers. Each customer deployment leverages a dedicated Terraform workspace and a unique set of AWS credentials stored in AWS Secrets Manager.

**Workflow Breakdown:**

The `terraform` job within this workflow executes a series of tasks, similar to the staging pipeline, but with considerations for multiple customer deployments:

1. **Checkout:** Downloads the project code from the GitHub repository to the runner.
2. **Configure Terraform:** Sets up the Terraform environment on the runner.
3. **Configure AWS Credentials:** Uses the `aws-actions/configure-aws-credentials` action to configure AWS credentials specifically for the targeted customer. The credential secret name is dynamically retrieved based on the `matrix.account` variable defined in the workflow.
4. **Generate Terraform Variables:** Executes a custom script (`./scripts/generate_tfvars.sh`) to generate environment-specific variables for the targeted customer deployment.
5. **Terraform fmt:** Runs `terraform fmt` with the `-check` flag to verify code formatting and style. This step continues even if formatting errors are found.
6. **Terraform Init:** Initializes the Terraform workspace for the specific customer (`TF_WORKSPACE` environment variable).
7. **Terraform Validate:** Validates the Terraform configuration to ensure its syntax and structure are correct.
8. **Terraform Plan:** Generates an execution plan for the infrastructure changes. This plan is saved to a file named `plan`.
9. **Plan Output (Pull Requests):**
   - If triggered by a pull request event:
      - Parses the Terraform plan output and formats it into a user-friendly comment.
      - Posts the comment to the pull request containing details on the deployment, including:
        - Terraform code formatting check status.
        - Targeted workspace (`TF_WORKSPACE`).
        - Terraform initialization and validation results.
        - The detailed Terraform plan for review.
        - Information about the pull request pusher and event type.
10. **Terraform Apply Plan (Pushes):**
   - If triggered by a push event to the `main` branch:
      - Applies the previously generated Terraform plan to provision the infrastructure changes in the production environment for the targeted customer.

**Overall, this automated workflow ensures a secure and controlled approach to deploying infrastructure changes to production environments for multiple customers.**
