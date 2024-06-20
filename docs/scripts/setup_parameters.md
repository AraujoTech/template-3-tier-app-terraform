## Script: Manage Environment Variables in AWS SSM Parameter Store (scripts/setup_parameters.sh)

This section explains the functionality of the `scripts/setup_parameters.sh` script, which helps manage environment variables stored in AWS SSM Parameter Store.

**Script Functionality:**

The script offers two modes:

1. **Create Mode:**
   - Allows users to create new environment variables.
   - Users can choose between:
      - **Single Mode:** Define a single variable interactively.
      - **Batch Mode (from .env file):** Define multiple variables from a `.env` file format (one variable per line in the format `NAME=VALUE`).

2. **Delete Mode:**
   - Allows users to delete existing environment variables.
   - Users can choose between:
      - **Single Mode:** Delete a single variable interactively (optional interactive confirmation).
      - **Batch Mode (from .env file):** Delete all variables associated with the application and tier defined in the `.env` file.

**Script Workflow (Create Mode - Single Variable):**

1. Prompts the user for:
   - AWS region (defaults to `us-east-1`)
   - AWS profile (defaults to `default`)
   - Application name
   - Environment tier (e.g., `backend`)
   - Environment variable name
   - Environment variable value
   - Parameter type (String or SecureString)

2. Stores the variable in the Parameter Store path: `/application_name/tier/environment_variable_name` with the chosen type.

**Script Workflow (Create Mode - Batch Mode):**

1. Reads variables from the specified `.env` file (one variable per line in the format `NAME=VALUE`).
2. Iterates through each line and extracts the variable name and value.
3. Stores each variable in the Parameter Store path: `/application_name/tier/environment_variable_name` with the String type (since batch mode doesn't support SecureString).

**Script Workflow (Delete Mode - Single Variable):**

1. Offers the option for interactive mode or direct deletion.
2. In interactive mode, prompts the user for:
   - AWS region (defaults to `us-east-1`)
   - AWS profile (defaults to `default`)
   - Application name
   - Environment tier
   - Environment variable name (optional confirmation before deletion).
3. In direct deletion mode, requires the user to specify the complete parameter name (e.g., `/application_name/tier/environment_variable_name`).
4. Deletes the specified environment variable from the Parameter Store.

**Script Workflow (Delete Mode - Batch Mode):**

1. Reads variables from the specified `.env` file.
2. Iterates through each line and extracts the variable name.
3. Constructs the complete parameter name using the application name, tier, and variable name from the `.env` file.
4. Deletes each variable from the Parameter Store.

**Overall, this script simplifies the process of managing environment variables in AWS SSM Parameter Store, offering a user-friendly interface for both creating and deleting variables.**
