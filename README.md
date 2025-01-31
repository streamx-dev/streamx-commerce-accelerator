# StreamX Commerce Accelerator

## Overview

StreamX Commerce Accelerator is a project designed to streamline the setup of new e-commerce projects, enabling the rapid creation and deployment of commerce websites. The project structure is modular and organized into specific directories and files to facilitate development, deployment, and maintenance.

This documentation outlines the components of the project, the purpose of each folder, and instructions for local setup and deployment.

---

## Local Setup

Prerequisites:
* StreamX CLI in preview version:
  ```shell
  brew install streamx-dev/preview-tap/streamx
  ```

1. **Start StreamX:**
   - Run the StreamX instance (current setup requires `preview` version of StreamX CLI see prerequisites):
     ```bash
     streamx run -f ./mesh/mesh.yaml
     ```

2. **Run the Proxy:**
   - Start the local proxy for serving the website:
     ```bash
     ./gateway/run-proxy.sh
     ```

3. **Publish All Resources:**
   - Use the `publish-all` script to deploy all necessary data to StreamX:
     ```bash
     ./scripts/publish-all.sh
     ```