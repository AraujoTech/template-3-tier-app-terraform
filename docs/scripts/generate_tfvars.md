## Script: Generate Terraform Variables (scripts/generate_tfvars.sh)

This section explains the functionality of the `scripts/generate_tfvars.sh` script used in the deployment pipelines. This script dynamically generates environment-specific Terraform variables based on AWS SSM Parameter Store.

**Script Breakdown:**

1. **Input Argument:**
   - The script expects a single argument, which is the target deployment environment (e.g., `staging`, `customer_name`). This environment name is stored in the `STAGE` variable.

2. **AWS Region:**
   - The script assumes all infrastructure resources are deployed in the `us-east-1` region. This is defined in the `REGION` variable.

3. **Get Parameter Counts:**
   - The script uses the `aws ssm get-parameters-by-path` command to retrieve the number of parameters stored under specific paths in AWS SSM Parameter Store for each environment section (e.g., `/staging/aws/`, `/staging/vpc/`). These counts are stored in variables named after the section appended with `_LEN` (e.g., `AWS_LEN`, `VPC_LEN`).

4. **Generate Terraform Variable File:**
   - The script creates a new Terraform variable file named `${STAGE}.tfvars` inside the `terraform` directory.

5. **Looping Through Environment Sections:**
   - The script iterates through five sections (`aws`, `vpc`, `opensearch`, `general`, `eks`) to retrieve and store their corresponding parameters.

    - **Get Parameter Names and Values:**
      - Within each section loop, the script retrieves the names and values of all parameters using `aws ssm get-parameters-by-path`.
      - The script separates the parameter name from the full path using `awk`.
      - Decrypted values are retrieved using the `--with-decryption` flag (if applicable).

    - **Write to Terraform Variable File:**
      - The script writes the parameter name and value in the Terraform variable assignment format (e.g., `<name> = "<value>"`) to the `${STAGE}.tfvars` file.
      - A special handling is applied to the `cidr_ip` parameter within the `vpc` section to ensure it's enclosed in double quotes.

**Overall, this script automates the process of generating environment-specific Terraform variables from AWS SSM Parameter Store, simplifying infrastructure configuration management.**
