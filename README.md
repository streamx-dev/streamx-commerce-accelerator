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


---

### Setting up autocomplete js
As part of Streamx Accelerator we deliver an option to setup initial search via Algolia JS plugin called autocomplete-js.

https://www.algolia.com/doc/ui-libraries/autocomplete/api-reference/autocomplete-js/autocomplete/

It's a simple and isolated plugin with minimal setup. In orderd for it to work we need:
- HTML element with an id of "autocomplete"(make sure to place it within desired area, ex: navigation bar):
    <div id="autocomplete"></div>

- Import required JS and CSS. For that we have 2 options either reuse minified versions of it from our repo:
    <link rel="stylesheet" href="../web-resources/css/algolia.theme.min.css" />
    <script src="../web-resources/js/autocomplete-js.js"></script>

    or directly from CDN:

    <script src="https://cdn.jsdelivr.net/npm/@algolia/autocomplete-js@1.18.0/dist/umd/index.production.js" integrity="sha256-Aav0vWau7GAZPPaOM/j8Jm5ySx1f4BCIlUFIPyTRkUM=" crossorigin="anonymous"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@algolia/autocomplete-theme-classic@1.17.9/dist/theme.min.css" integrity="sha256-7xmjOBJDAoCNWP1SMykTUwfikKl5pHkl2apKOyXLqYM=" crossorigin="anonymous"/>

- Attach our custom main.publish.js to initialize it:
    <script defer src="../web-resources/js/autocomplete-init.js"></script>

Our custom autocomplete-init.js contains all of the required JS for the plugin to work. Alternatively you can follow the instructions from the setup section of autocomplete-js for higher level of control over it:

https://www.algolia.com/doc/ui-libraries/autocomplete/api-reference/autocomplete-js/autocomplete/