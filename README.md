# StreamX Commerce Accelerator

## Overview

StreamX Commerce Accelerator is a project designed to streamline the setup of new e-commerce
projects, enabling the rapid creation and deployment of commerce websites. The project structure is
modular and organized into specific directories and files to facilitate development, deployment, and
maintenance.

This documentation outlines the components of the project, the purpose of each folder, and
instructions for local setup and deployment.

## Windows Specifics

In the case of Windows, all the commands outlined in this file should be run inside the Linux VM terminal, which hosts Docker, rather than in native Windows terminals (e.g., CMD or PowerShell). For instance, if Docker is used with WSL, the commands should be executed inside the WSL terminal.

## Local Setup

As a prerequisite, ensure that you have StreamX CLI installed in preview version:
  ```shell
  brew install streamx-dev/preview-tap/streamx
  ```

1. **Start StreamX**
    
   Run the StreamX instance (current setup requires `preview` version of StreamX CLI, see
      prerequisites):
      ```bash
      streamx run -f ./mesh/mesh.yaml
      ```

   > **Note:** For local development you can also use mesh-light.yaml which comes with the basic
   functionality only that allows to run on limited resources.

2. **Run the Proxy**

   Start the local proxy for serving the website:
      ```bash
      ./gateway/run-proxy.sh
      ```

3. **Publish All Resources**
   
   Use the `publish-all` script to deploy all necessary data to StreamX:
      ```bash
      ./scripts/publish-all.sh
      ```

---
## Cloud setup 
### Initial setup - Should be done only once
1. Create [`terraform/azure/.env`](terraform/azure/.env) file:
   ```shell
   echo "# Azurerm provider authentication
   ARM_CLIENT_ID=
   ARM_CLIENT_SECRET=
   ARM_TENANT_ID=
   ARM_SUBSCRIPTION_ID=" > terraform/azure/.env
   ```
2. Configure [Terraform Azurerm provider authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#configuring-the-service-principal-in-terraform) data in [`terraform/azure/.env`](terraform/azure/.env).
3. Append common Azure platform Terraform variables to [`terraform/azure/.env`](terraform/azure/.env):
   ```shell
   echo "# Common variables
   TF_VAR_resource_group_name=
   TF_VAR_location=" >> terraform/azure/.env
   ```
4. Configure common Azure platform Terraform variables in [`terraform/azure/.env`](terraform/azure/.env)
   > **Variables:**
   > * `TF_VAR_resource_group_name` - Azure Resource Group name used for all resources created by Terraform scripts from this repository.
   > * `TF_VAR_location` - Azure location used for all resources created by Terraform scripts from this repository.
5. Setup Azure Resource Group used for StreamX Platform deployment using [Terraform script](terraform/azure/resource-group).
   > **Note:** This step is optional. Resource group can be created manually by Azure Administrator.
    1. Load Azurerm provider authentication data:
       ```shell
       source scripts/env/cloud/read-infra-env.sh terraform/azure/.env
       ```
    2. Initialize Terraform script:
       ```shell
       terraform -chdir="terraform/azure/resource-group" init
       ```
    3. Apply Terraform script:
       ```shell
       terraform -chdir="terraform/azure/resource-group" apply
       ```
6. Setup [Azure based Terraform state backend](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage) using [Terraform script](terraform/azure/state-backend)
    1. Load Azurerm provider authentication data:
       ```shell
       source scripts/env/cloud/read-infra-env.sh terraform/azure/.env
       ```
    2. Optional: Provide custom Azure Storage Container name (Default value is `streamx-commerce-accelerator-tfstate`):
       ```shell
       export TF_VAR_azurerm_storage_container_name="<YOUR_CUSTOM_NAME>"
       ```
    3. Initialize Terraform script:
       ```shell
       terraform -chdir="terraform/azure/state-backend" init
       ```
    4. Apply Terraform script:
       ```shell
       terraform -chdir="terraform/azure/state-backend" apply
       ```
    5. Configure Azure Storage Container's access key for Terraform state backend by appending it to [`terraform/azure/.env`](terraform/azure/.env):
       ```shell
       echo "# Azurerm Terraform state backend authentication
       ARM_ACCESS_KEY=$(terraform -chdir=terraform/azure/state-backend output -raw arm_access_key)" >> terraform/azure/.env
       ```
    6. Commit and push [backend.tf](terraform/azure/platform/backend.tf) file.
       > ⚠️ **Important:** `backend.tf` file has to be pushed to GitHub origin remote before lunching `Azure: Deploy StreamX` action. Otherwise, Terraform will use local state backend which will be deleted together with GH Action runner instance. That will lead to situation in which terraform script will be detached from created resources. That can be fixed by [terraform import](https://developer.hashicorp.com/terraform/cli/import) after successful azure backend setup.
7. Append StreamX Platform related variables to [`terraform/azure/.env`](terraform/azure/.env):
    ```shell
    echo "# StreamX platform Artifact Registry authentication
    TF_VAR_streamx_operator_image_pull_secret_registry_email=
    TF_VAR_streamx_operator_image_pull_secret_registry_password=

    # Cert Manager - user email used by Let's Encrypt server for expiration notifications
    TF_VAR_cert_manager_lets_encrypt_issuer_acme_email=
   
    # Optional: StreamX Mesh domains configuration - defaults: INGESTION_HOST=ingestion.{STREAMX_INGRESS_IP}.nip.io, WEB_HOST=puresight.{STREAMX_INGRESS_IP}.nip.io
    INGESTION_HOST=
    WEB_HOST=" >> terraform/azure/.env
    ```
8. Configure StreamX Platform related variables in [`terraform/azure/.env`](terraform/azure/.env):
    > **Variables:**
    > * `TF_VAR_STREAMX_OPERATOR_IMAGE_PULL_SECRET_REGISTRY_EMAIL` - email provided by Dynamic Solutions used for authentication
    > * `TF_VAR_STREAMX_OPERATOR_IMAGE_PULL_SECRET_REGISTRY_PASSWORD` - key provided by Dynamic Solutions used for authentication
    > * `TF_VAR_CERT_MANAGER_LETS_ENCRYPT_ISSUER_ACME_EMAIL` - Cert Manager passes that email to Let's Encrypt server.
    > * `INGESTION_HOST` - StreamX Mesh Ingestion REST API host. Host can contain `{STREAMX_INGRESS_IP}` placeholder which will be later resolved to Kubernetes Cluster Load Balancer's IP. e.g. `ingestion-test.{STREAMX_INGRESS_IP}.nip.io`. If not set `ingestion.{STREAMX_INGRESS_IP}.nip.io` is used.
    > * `WEB_HOST` - StreamX Mesh WEB DELIVERY host. Host can contain `{STREAMX_INGRESS_IP}` placeholder which will be later resolved to Kubernetes Cluster Load Balancer's IP. e.g. `web-test.{STREAMX_INGRESS_IP}.nip.io`. If not set `puresight.{STREAMX_INGRESS_IP}.nip.io` is used.
9. Setup GH
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
        * `INGESTION_HOST`
        * `WEB_HOST`
   > **Note:** This step can be done manually using values from 
   > [`terraform/azure/.env`](terraform/azure/.env) or using
   > [set-repo-secrets.sh](.github/scripts/set-repo-secrets.sh)
   > and [set-repo-variables.sh](.github/scripts/set-repo-variables.sh) scripts which are based on [GH CLI](https://cli.github.com/).
   > ```shell
   > source scripts/env/cloud/read-infra-env.sh terraform/azure/.env
   > .github/scripts/set-repo-secrets.sh
   > ```
   > ```shell
   > source scripts/env/cloud/read-infra-env.sh terraform/azure/.env
   > .github/scripts/set-repo-variables.sh
   > ```
     

## Cloud deploy

Cloud deployment can be done using bash script launched from local host or GitHub Action. Both options are interchangeable.

### Deploy from local
Prerequisites:

* [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
* [StreamX CLI](https://www.streamx.dev/guides/streamx-command-line-interface-reference.html) in preview version.
  ```shell
  brew install streamx-dev/preview-tap/streamx
  ```

1. Set `QUARKUS_PROFILE` to `CLOUD`
   ```shell
   export QUARKUS_PROFILE=CLOUD
   ```
2. Run env setup script. It will modify `.env` file in your project. That file contains ingestion tokens.

   *Do not commit these changes!*
   ```shell
   ./scripts/env/cloud/setup-env.sh
   ```
3. Publish data to cloud.
   ```shell
   ./scripts/publish-all.sh
   ```
4. After successful ingestion script will print WEB URL with your site.

### Undeploy from local

1. Run [destroy-env.sh](scripts/env/cloud/destroy-env.sh) script.
   ```shell
   ./scripts/env/cloud/destroy-env.sh
   ```

### Deploy using GH Action

1. Select `Azure: Deploy StreamX` GH Action.
2. Click `Run workflow`
3. Select branch which should be used for deployment.
4. Click `Run workflow`
5. After successful deployment check GH Action Summary for site URL.

> **Note:** This GitHub Action can be run multiple times without issues. It ensures that your infrastructure and StreamX Mesh are always up to date.
>
> What It Does: 
> * Creates or updates infrastructure on Azure
> * Creates or updates StreamX Mesh
> * Ingests all data from the source code
>
> This action is idempotent, meaning you can run it repeatedly to apply the latest changes without duplications or conflicts.

### Undeploym using GH Action

1. Select `Azure: Undeploy StreamX` GH Action.
2. Click `Run workflow`
3. Select branch which should be used for deployment.
4. Click `Run workflow`
---

## 📁 Project Directory Documentation

#### 📂 `data/`

Contains all the **sample data** needed to be ingested for the website to be functional. It stores:

- Layouts
- Dynamic templates
- Static pages
- Page fragments
- **CSS, JS** files
- Product and category data

This is the **place where we simulate source systems** such as **CMS, PIM, etc.**

---

#### 📂 `gateway/`

Contains the **configuration and script** for running the proxy that handles the traffic between
system components.

---

#### 📂 `mesh/`

Definition of the **StreamX Mesh** and all its associated **configurations and secrets**.

---

#### 📂 `scripts/`

Collection of **scripts** responsible for:

- **Ingesting data**
- **Setting up environments**

---

#### 📂 `spec/`

Contains the **data model definition**, which serves as the **contract** between the website and the
source systems.

---

#### 📂 `terraform/`

Everything required to **create the infrastructure** on cloud

---

## How to integrate into your project

### Setting up search

As part of Streamx Accelerator we deliver an option to setup initial search via Algolia JS plugin
called autocomplete-js.

https://www.algolia.com/doc/ui-libraries/autocomplete/api-reference/autocomplete-js/autocomplete/

It's a simple and isolated plugin with minimal setup. In orderd for it to work we need:

- HTML element with an id of "autocomplete"(make sure to place it within desired area, ex:
  navigation bar):

```bash
   <div id="autocomplete"></div>
```

- Import required JS and CSS. For that we have 2 options either reuse minified versions of it from
  our repo:

```bash
    <link rel="stylesheet" href="../web-resources/css/algolia.theme.min.css" />
```

```bash
    <script src="../web-resources/js/autocomplete-js.js"></script>
```

    or directly from CDN:

```bash
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@algolia/autocomplete-theme-classic@1.17.9/dist/theme.min.css" integrity="sha256-7xmjOBJDAoCNWP1SMykTUwfikKl5pHkl2apKOyXLqYM=" crossorigin="anonymous"/>
```

```bash
    <script src="https://cdn.jsdelivr.net/npm/@algolia/autocomplete-js@1.18.0/dist/umd/index.production.js" integrity="sha256-Aav0vWau7GAZPPaOM/j8Jm5ySx1f4BCIlUFIPyTRkUM=" crossorigin="anonymous"></script>
```

- Attach our custom autocomplete-init.js to initialize it:

```bash
    <script defer src="../web-resources/js/autocomplete-init.js"></script>
```

Our custom autocomplete-init.js contains all of the required JS for the plugin to work.
Alternatively you can follow the instructions from the setup section of autocomplete-js for higher
level of control over it:

https://www.algolia.com/doc/ui-libraries/autocomplete/api-reference/autocomplete-js/autocomplete/
