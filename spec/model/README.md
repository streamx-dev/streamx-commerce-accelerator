# **StreamX Commerce Data Model**

## **SxProduct**

Representation of a base product item in the eCommerce system.

### JSON-Schema

ref: "#/definitions/SxProduct"

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
| price        | \[ SxPrice \]          | product price                                        |
| primaryImage | SxImage                | main picture of the product                          |
| gallery      | \[ SxImage \]          | product visual medias                                |
| categories   | \[ SxCategory \]       | product categorisation information                   |
| attributes   | \[ SxAttribute \]      | additional product characteristic data               |
| variants     | \[ SxProductVariant \] | base product different variant                       |
| quantity     | Number                 | property defines product stock information           |

## **SxProductVariant**

Represents different unique version of the base product.

### JSON-Schema

ref: "#/definitions/SxProductVariant"

### Model properties

| Field        | Type              | Description                                          |
|--------------|-------------------|------------------------------------------------------|
| id           | String *          | product unique identifier                            |
| sku          | String            | product variant business stock-keeping unit          |
| slug         | String *          | URL friendly name, uniquely identifying product item |
| name         | String *          | title of the product variant                         |
| label        | String            | label of the product variant                         |
| description  | String            | detail information about the product                 |
| price        | \[ SxPrice \]     | product variant price value                          |
| primaryImage | SxImage           | main picture of the product                          |
| gallery      | \[ SxImage \]     | product visual medias                                |
| attributes   | \[ SxAttribute \] | additional product variant characteristic data       |
| quantity     | Number            | property defines product stock information           |

## **SxImage**

Element represents digital media information, defined by required _url_ value and optionally media
_alt_ data.

### JSON-Schema

ref: "#/definitions/SxImage"

### Model properties

| Field | Type     | Description           |
|-------|----------|-----------------------|
| url   | String * | media URL             |
| alt   | String   | media alt information |    

## **SxCategory**

Element defined product categories and subcategories, that represents organized structure of
eCommerce product catalog.

### JSON-Schema

ref: "#/definitions/SxCategory"

### Model properties

| Field         | Type             | Description                                                             |
|---------------|------------------|-------------------------------------------------------------------------|
| id            | String *         | unique identifier of the category                                       |
| slug          | String *         | URL friendly name, uniquely identifying category item                   |    
| name          | String *         | title of the category                                                   |
| label         | String           | label of the category                                                   |
| parent        | SxCategory       | parent category data, limited to required values only                   |
| subcategories | \[ SxCategory \] | actual item sub-elements data (if any), limited to required values only |

## **SxPrice**

Product price

### JSON-Schema

ref: "#/definitions/SxPrice"

### Model properties

| Field           | Type     | Description                   |
|-----------------|----------|-------------------------------|
| value           | Number * | value of the price            |
| discountedValue | Number * | value of the discounted price |

## **SxAttribute**

It is defined additional product information data, that is characteristic to it.

### JSON-Schema

ref: "#/definitions/SxAttribute"

### Model properties

| Field   | Type                    | Description                                |
|---------|-------------------------|--------------------------------------------|
| name    | String *                | unique identifier of the attribute         |
| label   | String                  | attribute label                            |
| isFacet | Boolean                 | property enable filter criteria for search |
| values  | \[ SxAttributeValue \]  | values of the attribute                    |

## **SxAttributeValue**

Additional metadata information for an attribute.

### JSON-Schema

ref: "#/definitions/SxAttributeValue"

### Model properties

| Field  | Type                    | Description                       |
|--------|-------------------------|-----------------------------------|
| value  | String *                | value of the attribute value      |
| label  | String                  | attribute value label             |
| swatch | SxAttributeOptionSwatch | swatch information for the option |

## **SxAttributeOptionSwatch**

Additional metadata information for an attribute.

### JSON-Schema

ref: "#/definitions/SxAttributeOptionSwatch"

### Model properties

| Field | Type     | Description                          |
|-------|----------|--------------------------------------|
| type  | String * | type of the attribute option swatch  |
| value | String * | value of the attribute option swatch |

