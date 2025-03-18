# StreamX Commerce Accelerator

## Overview

The PureSight demo showcases an example usage of StreamX as a complete web solution.

![Demo Architecture](./assets/demo.png "Demo Architecture")

Source systems setup may be out of scope of this repository.
The repo is based on StreamX Commerce Accelerator.

StreamX Commerce Accelerator is a project designed to streamline the setup of new e-commerce
projects, enabling the rapid creation and deployment of commerce websites. The project structure is
modular and organized into specific directories and files to facilitate development, deployment, and
maintenance.

This documentation outlines the components of the project, the purpose of each folder, and
instructions for local setup and deployment.

## Windows Specifics

In the case of Windows, all the commands outlined in this file should be run inside the Linux VM terminal, which hosts Docker, rather than in native Windows terminals (e.g., CMD or PowerShell). For instance, if Docker is used with WSL, the commands should be executed inside the WSL terminal.

## Local Setup

As a prerequisite, ensure that you have StreamX CLI installed in latest preview version:
  ```shell
  brew upgrade streamx-dev/preview-tap/streamx
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
      ./gateway/local/run-apisix.sh
      ```

   > **Note:** You can run proxy with APISIX Dashboard for easy routes administration by adding `dashboard-enabled=true`param to above script
   > **Note:** The started proxy server connects to the network created by the `streamx run` command.
   If the running mesh is restarted, the proxy must be restarted too. Otherwise `502. Message: Bad Gateway` will occur when calling endpoints exposed by the proxy.

3. **Publish All Resources**
   
   Use the `publish-all` script to deploy all necessary data to StreamX:
      ```bash
      ./scripts/publish-all.sh
      ```
---

## Cloud setup
### Automated setup using Terraform
Follow steps described in [README](terraform/README.md).
### Manual setup
1. Optionally: Append and configure custom hosts in [application-cloud.properties](config/application-cloud.properties):
   ```shell
   echo "streamx.accelerator.ingestion.host=
   streamx.accelerator.web.host=" >> config/application-cloud.properties
   ```
   > **Properties:**
   > * `streamx.accelerator.ingestion.host` - Custom StreamX REST Ingestion API host. Default value is `ingestion.${streamx.accelerator.ip}.nip.io`.
   > * `streamx.accelerator.web.host` - Custom StreamX WEB Delivery Service host. Default value is `web.${streamx.accelerator.ip}.nip.io`.
2. Configure StreamX properties in `.env` file:
   ```bash
   echo "#%cloud.streamx.accelerator.ip=
   %cms.streamx.ingestion.auth-token=
   %pim.streamx.ingestion.auth-token=" > .env
   ```
   > **Properties:**
   > * `%cloud.streamx.accelerator.ip` - Kubernetes cluster Load Balancer IP. Uncomment and set this property value if `streamx.accelerator.ingestion.host` or `streamx.accelerator.web.host` contains `${streamx.accelerator.ip}` placeholder.
   > * `%cms.streamx.ingestion.auth-token` - CMS source authentication token. Value should be taken from Kubernetes cluster `sx-sec-auth-jwt-cms` secret.
   > * `%pim.streamx.ingestion.auth-token` - PIM source authentication token. Value should be taken from Kubernetes cluster `sx-sec-auth-jwt-pim` secret.
3. Deploy Accelerator StreamX Mesh:
   ```bash
   export KUBECONFIG=<path_to_kubeconfig> && export QUARKUS_PROFILE=cloud && streamx --accept-license deploy -f mesh/mesh.yaml
   ```
   > **Note:**
   > 
   > Replace `<path_to_kubeconfig>` with path to kubeconfig file stored on your local file system.
4. Publish all resources
   ```bash
   export QUARKUS_PROFILE=cloud,cms && streamx batch publish data
   export QUARKUS_PROFILE=cloud,pim && streamx stream data data/catalog/products.stream
   export QUARKUS_PROFILE=cloud,pim && streamx stream data data/catalog/categories.stream
   ```

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
