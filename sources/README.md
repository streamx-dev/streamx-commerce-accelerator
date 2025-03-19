# PureSight & WKND in Dockerized AEM

The steps below show how to run locally an AEMaaCS image that has embedded PureSight, WKND, and the AEM Connector.

1. Download the `aem-author-cloud.tar.gz` file with the image from Google Drive: https://drive.google.com/file/d/1XJXIlGntz5h-cI0ltFPq-zrEjQNcPeMh/view?usp=drive_link.

2. Load the downloaded image:
   ```bash
   docker load < aem-author-cloud.tar.gz
   ```

3. Confirm the image loaded successfully:
   ```bash
   docker images | grep aem-author-cloud
   ```

4. Run the Docker container.  
   You can optionally pass a **StreamX client URL** as the first argument and a **StreamX client auth token** as the second argument.  
   - If the second argument is not provided, it defaults to an empty token (no authentication is attempted).  
   - You can also **explicitly** pass an empty token by placing `""` as the second argument.

   **Examples:**
   ```bash
   # Pass URL only, token is empty by default
   ./sources/start-aem.sh http://host.docker.internal:8080

   # Pass both URL and token
   ./sources/start-aem.sh https://my-streamx.example.com ABCD1234567

   # Pass a URL and an explicit empty token
   ./sources/start-aem.sh https://my-streamx.example.com ""
   ```

5. Once the AEM instance is running, it is accessible at:  
   ```text
   http://localhost:4502
   ```
