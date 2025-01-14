# **StreamX Commerce Data Model**

## **SXProduct**

Representation of a base product item in the eCommerce system.

### JSON-Schema

ref: "#/definitions/SXProduct"

### Model properties

| Field        | Type                   | Description                                          |
|--------------|------------------------|------------------------------------------------------|
| id           | String *               | product unique identifier                            |
| sku          | String *               | business stock-keeping unit                          |
| lang         | String                 | language identifier                                  |
| slug         | String *               | URL friendly name, uniquely identifying product item |
| name         | String *               | title of the product                                 |
| label        | String                 | label of the product                                 |
| description  | String                 | detail information about the product                 |
| primaryImage | SXImage                | main picture of the product                          |
| gallery      | \[ SXImage \]          | product visual medias                                |
| categories   | \[ SXCategory \]       | product categorisation information                   |
| attributes   | \[ SXAttribute \]      | additional product characteristic data               |
| variants     | \[ SXProductVariant \] | base product different variant                       |

## **SXProductVariant**

Represents different unique version of the base product.

### JSON-Schema

ref: "#/definitions/SXProductVariant"

### Model properties

| Field      | Type              | Description                                          |
|------------|-------------------|------------------------------------------------------|
| id         | String *          | product unique identifier                            |
| sku        | String            | product variant business stock-keeping unit          |
| slug       | String *          | URL friendly name, uniquely identifying product item |
| name       | String *          | title of the product variant                         |
| label      | String            | label of the product variant                         |
| attributes | \[ SXAttribute \] | additional product variant characteristic data       |

## **SXImage**

Element represents digital media information, defined by required _url_ value and optionally media _alt_ data.

### JSON-Schema

ref: "#/definitions/SXImage"

### Model properties

| Field | Type     | Description           |
|-------|----------|-----------------------|
| url   | String * | media URL             |
| alt   | String   | media alt information |    

## **SXCategory**

Element defined product categories and subcategories, that represents organized structure of eCommerce product catalog.

### JSON-Schema

ref: "#/definitions/SXCategory"

### Model properties

| Field         | Type             | Description                                                             |
|---------------|------------------|-------------------------------------------------------------------------|
| id            | String *         | unique identifier of the category                                       |
| slug          | String *         | URL friendly name, uniquely identifying category item                   |    
| name          | String *         | title of the category                                                   |
| label         | String           | label of the category                                                   |
| parent        | SXCategory       | parent category data, limited to required values only                   |
| subcategories | \[ SXCategory \] | actual item sub-elements data (if any), limited to required values only |

## **SXAttribute**

It is defined additional product information data, that is characteristic to it.

### JSON-Schema

ref: "#/definitions/SXAttribute"

### Model properties

| Field      | Type     | Description                                |
|------------|----------|--------------------------------------------|
| name       | String * | unique identifier of the attribute         |
| label      | String   | attribute label                            |
| value      | String * | value of the attribute                     |
| valueLabel | String   | attribute value label                      |
| isFacet    | Boolean  | property enable filter criteria for search |
| isSelected | Boolean  | property toggle element as preselected     |

