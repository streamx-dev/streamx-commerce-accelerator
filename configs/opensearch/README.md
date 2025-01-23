# StreamX Commerce Accelerator - OpenSearch configuration

## Overview

StreamX Commerce Accelerator allow to have a commerce search index feature, based on OpenSearch server (see https://opensearch.org/).

---

## Module Structure

### 1. **`configuration/`**
- Contains files used for easy and human readable search templates development.
- Script `format-search-templates` transform formated search template into http format file and save it in service-init directory.

### 2. **`service-init/`**
- Contains initialisation requests that configure search index for commerce purposes.
- Example key requests:
    - `update_default_index`: Updates default search index, initialised from **`streamx-blueprints/opensearch-delivery-service`** module.
    - `update_default_index_mapping`: Updates default search index schema mapping.
    - `update_default_index_default_pipeline`: Updates pipeline required for ingested commerce data
- Contains formated search templates output

---

## Local Setup and Deployment

### Steps for Local Development

1. **Start OpenSearch Dashboard application:**
    - Run the OpenSearch Dashboard instance:
      ```bash
      docker run -ti -e OPENSEARCH_HOSTS='["http://host.docker.internal:9201"]' -e DISABLE_SECURITY_DASHBOARDS_PLUGIN=true -p 5601:5601 --rm --name opensearch-dashbard opensearchproject/opensearch-dashboards:2.16.0
      ```

2. **OpenSearch Dashboard dev-tools console:**
   - Open DEV-TOOLS console page:
      ```http request
      http://localhost:5601/app/dev_tools#/console
      ```
OpenSearch Dashboards is the user interface that lets you visualize your OpenSearch data and run and scale your OpenSearch clusters.
Review [documentation](https://opensearch.org/docs/latest/dashboards/) for more details about this application.

For our development purpose we would use mainly use the DEV-TOOLS console ([documentation](https://opensearch.org/docs/latest/dashboards/dev-tools/index-dev/))

3. **Execute OpenSearch Dashboard configuration requests:**
    - Show default index settings configuration:
      ```http request 
      GET default/_settings
      
      {

      }
      ```
    - Show default index mappings:
      ```http request
      GET default/_mapping
      
      {

      }
      ```
    - Show default index pipelines:
      ```http request
      GET _ingest/pipeline
      
      {
      
      }
      ```
4. **Execute OpenSearch Dashboard search requests:**
    - Search recently ingested index documents:
      ```http request
      GET _search
      {
        "query": {
          "match_all": {}
        },
        "sort": [
          {
            "payload.ingested": {
              "order": "desc"
            }
          }
        ]
      }
      ```
    - Search products with query term:
      ```http request
      GET default/_search/template         
      {
        "id": "products",
        "params": {
          "from": 0,
          "size": 12,
          "query": "chair",
          "facets": {
            "fields": [
              {
                "name": "ft_height",
                "size": 20,
                "last": false
              },
              {
                "name": "ft_weight",
                "size": 20,
                "last": false
              },
              {
                "name": "ft_length",
                "size": 20,
                "last": true
              }
            ]
          }
        }
      }
      ```
   - Search products with query term and filter by category:
     ```http request 
     GET default/_search/template            
     {
       "id": "products",
       "params": {
         "from": 0,
         "size": 12,
         "query": "chair",
         "filter_category": {
           "fields": [ 
             "Chairs" 
           ]
         }, 
         "facets": {
           "fields": [
             {
               "name": "ft_height",
               "size": 20,
               "last": false
             },
             {
               "name": "ft_weight",
               "size": 20,
               "last": false
             },
             {
               "name": "ft_length",
               "size": 20,
               "last": true
             }
           ]
         }
       }
     }
     ```
   - Search products with query term, filter by category and by facets:
     ```http request
     GET default/_search/template
     {
       "id": "products",
       "params": {
         "from": 0,
         "size": 12,
         "query": "chair",
         "filter_category": {
           "fields": [
             "Chairs"
           ]
         },
         "filter_query": {
           "fields": [
             {
               "name": "ft_length",
               "values": [
                 "30.0",
                 "33.0",
                 "37.0",
                 "38.0"
               ],
               "last": false
             },
             {
               "name": "ft_height",
               "values": [
                 "30.0",
                 "35.0",
                 "39.0",
                 "43.0"
               ],
               "last": true
             }
           ]
         },
         "facets": {
           "fields": [
             {
               "name": "ft_height",
               "size": 20,
               "last": false
             },
             {
               "name": "ft_weight",
               "size": 20,
               "last": false
             },
             {
               "name": "ft_length",
               "size": 20,
               "last": true
             }
           ]
         }
       }
     }
     ```
