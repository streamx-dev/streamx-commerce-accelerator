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


## Setting up autocomplete js
As part of Streamx Accelerator we deliver an option to setup initial search via Algolia JS plugin called autocomplete-js.

https://www.algolia.com/doc/ui-libraries/autocomplete/api-reference/autocomplete-js/autocomplete/

It's a simple and isolated plugin with minimal setup. In orderd for it to work we need:
- HTML element with an id of "autocomplete"(make sure to place it within desired area, ex: navigation bar):
```bash
   <div id="autocomplete"></div>
```

- Import required JS and CSS. For that we have 2 options either reuse minified versions of it from our repo:
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

Our custom autocomplete-init.js contains all of the required JS for the plugin to work. Alternatively you can follow the instructions from the setup section of autocomplete-js for higher level of control over it:

https://www.algolia.com/doc/ui-libraries/autocomplete/api-reference/autocomplete-js/autocomplete/