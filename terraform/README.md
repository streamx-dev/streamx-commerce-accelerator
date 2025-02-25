## Cloud setup
All commands in this document should be executed from the terraform directory. 

### Prerquisites:

* Azure Subscription with following registered [Resource
  providers](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider) :
    + Microsoft.Storage - required to create storage for terraform state backend
    + Microsoft.Network - optional if static public IP is required
    + Microsoft.ContainerService - required for AKS setup
    + Microsoft.Quota - for vCPU quotas adjustments
    + Microsoft.Compute - for AKS setup
* [Azure Enterprise Application](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#creating-a-service-principal-in-the-azure-portal) for Azure resources setup by terraform scripts with following roles:
    + Contributor (from Privileged Administrator Roles) - Grants full access to manage all resources, but does not allow you to assign roles in Azure RBAC, manage assignments in Azure Blueprints, or share image galleries.
    +
* [Azure Resource Group](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal#create-resource-groups) This group should be used across all cloud setup steps
* [Azure Managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-azp#create-a-user-assigned-managed-identity) with following roles:
    + Network Contributor - Required to create public static IP. Lets you manage networks, but not access to them.
* GH Repository secrets and configs admin account
* StreamX CLI in preview version

### StreamX Platform settings setup - Should be done only once

1. Create [`azure/.env`](azure/.env) file:
   ```shell
   echo "# Azurerm provider authentication
   ARM_CLIENT_ID=
   ARM_CLIENT_SECRET=
   ARM_TENANT_ID=
   ARM_SUBSCRIPTION_ID=" > azure/.env
   ```
2. Configure [Terraform Azurerm provider authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#configuring-the-service-principal-in-terraform)
   data in [`azure/.env`](azure/.env).

3. Append common Azure platform Terraform variables
   to [`azure/.env`](azure/.env):
   ```shell
   echo "# Common variables
   TF_VAR_user_identity_id=
   TF_VAR_resource_group_name=
   TF_VAR_location=" >> azure/.env
   ```
4. Configure common Azure platform Terraform variables
   in [`azure/.env`](azure/.env)
   > **Variables:**
   > * `TF_VAR_user_identity_id` - Azure Managed Identity ID used by Terraform script as AKS cluster User Managed Identity. If not set System Managed Identity will
       be used and no static public IP could be used. On Azure Managed Identity Overview (identity from prerequisite) switch to JSON view and copy Resource ID.
   > * `TF_VAR_resource_group_name` - Azure Resource Group name which was created as prerequisite
   > * `TF_VAR_location` - Azure location used for all resources created by Terraform scripts from
       this repository.
5. Setup [Azure based Terraform state backend](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage)
   using [Terraform script](azure/state-backend)
    1. Load Azurerm provider authentication data:
       ```shell 
       source scripts/read-infra-env.sh azure/.env
       ```
    2. Optional: Provide custom Azure Storage Container name (Default value
       is `streamx-commerce-accelerator-tfstate`):
       ```shell
       export TF_VAR_azurerm_storage_container_name="<YOUR_CUSTOM_NAME>"
       ```
    3. Initialize Terraform script:
       ```shell
       terraform -chdir="azure/state-backend" init
       ```
    4. Apply Terraform script:
       ```shell
       terraform -chdir="azure/state-backend" apply
       ```
    5. Configure Azure Storage Container's access key for Terraform state backend by appending it
       to [`azure/.env`](azure/.env):
       ```shell
       echo "# Azurerm Terraform state backend authentication
       ARM_ACCESS_KEY=$(terraform -chdir=azure/state-backend output -raw arm_access_key)" >> azure/.env
       ```
    6. Commit and push [platform backend.tf](azure/platform/backend.tf) and [network backend.tf](azure/network/backend.tf) files.
   > ⚠️ **Important:** `backend.tf` files has to be pushed to GitHub origin remote before
   > lunching `Azure: Deploy StreamX` action. Otherwise, Terraform will use local state backend
   > which will be deleted together with GH Action runner instance. That will lead to situation in
   > which terraform script will be detached from created resources. That can be fixed
   > by [terraform import](https://developer.hashicorp.com/terraform/cli/import) after successful
   > azure backend setup.
6. Optionally: Append and configure custom hosts in [application-cloud.properties](../config/application-cloud.properties):
   ```shell
   echo "streamx.accelerator.ingestion.host=
   streamx.accelerator.web.host=" >> ../config/application-cloud.properties
   ```
   > **Properties:**
   > * `streamx.accelerator.ingestion.host` - Custom StreamX REST Ingestion API host. Default value is `ingestion.${streamx.accelerator.ip}.nip.io`.
   > * `streamx.accelerator.web.host` - Custom StreamX WEB Delivery Service host. Default value is `web.${streamx.accelerator.ip}.nip.io`.
7. Optionally: Setup public static ip address. If you skip this step dynamic IP will be used
    1. Provide your prefix for fully qualified domain on azure. By default, it's `streamx`.
       ```shell
       export TF_VAR_dns_label="<YOUR_DNS_LABEL>"
       ```
    2. Load Azurerm provider authentication data:
       ```shell
       source scripts/read-infra-env.sh azure/.env
       ```    
    3. Initialize Terraform script:
        ```shell
        terraform -chdir="azure/network" init
        ```
    4. Apply Terraform script:
       ```shell
       terraform -chdir="azure/network" apply
       ```
    5. Configure network related variables
       ```shell
        echo "TF_VAR_public_ip_address=$(terraform -chdir=azure/network output -raw public_ip_address)" >> azure/.env
        echo "TF_VAR_public_ip_id=$(terraform -chdir=azure/network output -raw public_ip_id)" >> azure/.env 
        echo "Your fully qualified domain for Azure cluster - $(terraform -chdir=azure/network output -raw domain_name)"
        ```
    6. > ⚠️ **Important:** Use newly generated public ip address or the fully qualified domain name to update your domain zone with the entries form previous step (`streamx.accelerator.ingestion.host` and `streamx.accelerator.web.host`)
       with the new ip/cname
8. Append StreamX Platform related variables to [`azure/.env`](azure/.env):
    ```shell
    echo "# StreamX platform Artifact Registry authentication
    TF_VAR_streamx_operator_image_pull_secret_registry_email=
    TF_VAR_streamx_operator_image_pull_secret_registry_password=

    # Cert Manager - user email used by Let's Encrypt server for expiration notifications
    TF_VAR_cert_manager_lets_encrypt_issuer_acme_email=" >> azure/.env
    ```
9. Configure StreamX Platform related variables in [`azure/.env`](azure/.env):
   > **Variables:**
   > * `TF_VAR_STREAMX_OPERATOR_IMAGE_PULL_SECRET_REGISTRY_EMAIL` - email provided by Dynamic
       Solutions used for authentication
   > * `TF_VAR_STREAMX_OPERATOR_IMAGE_PULL_SECRET_REGISTRY_PASSWORD` - key provided by Dynamic
       Solutions used for authentication
   > * `TF_VAR_CERT_MANAGER_LETS_ENCRYPT_ISSUER_ACME_EMAIL` - Cert Manager passes that email to
       Let's Encrypt server.
10. Optionally: Setup production Let's Encrypt certificate issuer append `TF_VAR_cert_manager_lets_encrypt_issuer_prod_letsencrypt_server=true`
     ```shell
    echo "# Cert Manager - use Let's Encrypt production cert issuer
    TF_VAR_cert_manager_lets_encrypt_issuer_prod_letsencrypt_server=true" >> azure/.env
    ```
11. Setup GH
    Action [variables](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/store-information-in-variables)
    and [secrets](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions)
    on repository level.
     * ***required***:
         * variables:
             * `TF_VAR_CERT_MANAGER_LETS_ENCRYPT_ISSUER_ACME_EMAIL`
             * `TF_VAR_STREAMX_OPERATOR_IMAGE_PULL_SECRET_REGISTRY_EMAIL`
             * `TF_VAR_RESOURCE_GROUP_NAME`
             * `TF_VAR_LOCATION`
         * secrets:
             * `ARM_ACCESS_KEY`
             * `ARM_CLIENT_ID`
             * `ARM_CLIENT_SECRET`
             * `ARM_TENANT_ID`
             * `ARM_SUBSCRIPTION_ID`
             * `TF_VAR_STREAMX_OPERATOR_IMAGE_PULL_SECRET_REGISTRY_PASSWORD`
     * ***optional***:
         * variables:
             * `TF_VAR_USER_IDENTITY_ID`
             * `TF_VAR_PUBLIC_IP_ADDRESS`
             * `TF_VAR_PUBLIC_IP_ID`
             * `TF_VAR_CERT_MANAGER_LETS_ENCRYPT_ISSUER_PROD_LETSENCRYPT_SERVER`
         * secrets:
           *  `SX_SEC_AUTH_PRIVATE_KEY`
           *  `BLUEPRINT_WEB_TLS_CERT`
           *  `BLUEPRINT_SEARCH_TLS_CERT`
           *  `REST_INGESTION_TLS_CERT`
   > **Note:** This step can be done manually using values from
   > [`azure/.env`](azure/.env) or using
   > [set-repo-secrets.sh](.github/scripts/set-repo-secrets.sh)
   > and [set-repo-variables.sh](.github/scripts/set-repo-variables.sh) scripts which are based
    on [GH CLI](https://cli.github.com/).
   > ```shell
   > source scripts/read-infra-env.sh azure/.env
   > scripts/set-repo-secrets.sh
   > ```
   > ```shell
   > source scripts/read-infra-env.sh azure/.env
   > scripts/set-repo-variables.sh
   > ```
11. Store and share variables.
    Once your cloud setup is done anyone who has access to variables from .env file will be able to work with cloud instance using his local instance. In order to do that variables should be shared with all interested parties.

## Cloud deploy

Cloud deployment can be done using StreamX CLI from local host or GitHub Action. Both
options are interchangeable.

To preserve generation of TLS secrets place all secrets used by your mesh inside `gateway/tls` and `mesh/auth` folders. Please be aware that this files should be in YAML format. After first mesh deployment 
these certificates will be generated and can be copied from Azure. In mesh/auth folder private key used by mesh should be placed.

> **Note:** Do NOT commit any secrets to GH repository

### Deploy from local

Prerequisites:

* .env file variables. Ask your administrator to share .env variables with you
* [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
* [StreamX CLI](https://www.streamx.dev/guides/streamx-command-line-interface-reference.html) in
  preview version.
  ```shell
  brew install streamx-dev/preview-tap/streamx
  ```

1. Run deploy StreamX script. It will modify [`.env`](../.env) file in your project. That file contains
   ingestion tokens.

   *Do not commit these changes!*
   ```shell
   ./scripts/deploy-streamx.sh
   ```
2. Store and share [`.env`](../.env) with your team members. Values from this file are required for manual Cloud setup and Cloud data ingestion described in [README](../README.md).
3. Publish data to cloud.
   ```shell
   ./scripts/cloud-publish-all.sh
   ```

### Undeploy from local

1. Run [undeploy-streamx.sh](scripts/undeploy-streamx.sh) script.
   ```shell
   ./scripts/undeploy-streamx.sh
   ```

### Deploy using GH Action

1. Select `Azure: Deploy StreamX` GH Action.
2. Click `Run workflow`
3. Select branch which should be used for deployment.
4. Click `Run workflow`
5. After successful deployment check GH Action Summary for site URL.

> **Note:** This GitHub Action can be run multiple times without issues. It ensures that your
> infrastructure and StreamX Mesh are always up to date.
>
> What It Does:
> * Creates or updates infrastructure on Azure
> * Creates or updates StreamX Mesh
> * Ingests all data from the source code
>
> This action is idempotent, meaning you can run it repeatedly to apply the latest changes without
> duplications or conflicts.

### Undeploym using GH Action

1. Select `Azure: Undeploy StreamX` GH Action.
2. Click `Run workflow`
3. Select branch which should be used for deployment.
4. Click `Run workflow`
