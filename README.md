# StreamX Commerce Accelerator

## Overview

StreamX Commerce Accelerator is a project designed to streamline the setup of new e-commerce projects, enabling the rapid creation and deployment of commerce websites. The project structure is modular and organized into specific directories and files to facilitate development, deployment, and maintenance.

This documentation outlines the components of the project, the purpose of each folder, and instructions for local setup and deployment.

---

## Project Structure

### 1. **`env/`**
- Contains configuration settings for the runtime environment.
- Used to define environment variables and other project-specific settings.
- Contents:
   - Environment variables for local or production setups.
   - Additional files for env specific setup

### 2. **`pages/`**
- Contains the web pages of the project.
- Developers can organize pages into specific directories for maintainability.

### 3. **`templates/`**
- Stores dynamic templates written using **Pebble**.
- Enables the creation of dynamic content for the website.
- These templates are used to render dynamic parts of the site, such as product listings.

### 4. **`web-resources/`**
- Contains static resources such as:
   - CSS files.
   - JavaScript files.
   - Fonts.
- The project is built using **Tailwind CSS**, a utility-first CSS framework, for styling.

### 5. **`assets/`**
- Holds digital assets used by the website, such as images, videos, and other media.
- These resources are published and referenced on the site.

### 6. **`scripts/`**
- Includes a set of scripts to automate various tasks, such as:
   - Publishing assets and resources.
   - Deploying configurations to StreamX.
- Example key scripts:
   - `publish-all`: Publishes all data needed to launch the website.

### 7. **`configs/`**
- Stores service configuration files for the mesh.
- These define the operational settings of various services used by the project.

### 8. **`model/`**
- Unified data model schema
- All integrations should use this as the base


### 9. **`secrets/`**
- Contains sensitive secrets for the mesh, such as:
   - API keys.
   - Authentication credentials.

### 10. **`mesh.yaml`**
- Defines the overall structure and configuration of the mesh services.
- This file acts as the central configuration point for the mesh.


---

## Local Setup and Deployment

### Steps for Local Development


1. **Start StreamX:**
   - Run the StreamX instance:
     ```bash
     source env/local/.env.sh
     streamx run
     ```

2. **Run the Proxy:**
   - Start the local proxy for serving the website:
     ```bash
     sh env/local/run-proxy.sh
     ```

3. **Publish All Resources:**
   - Use the `publish-all` script to deploy all necessary data to StreamX:
     ```bash
     source env/local/.env.sh
     sh scripts/publish-all.sh
     ```

### Testing the Setup
- Open a browser and navigate to the local proxy's URL (typically `http://localhost:8080`).
- Verify the pages are loading correctly, and dynamic content from templates and assets is displayed as expected.
