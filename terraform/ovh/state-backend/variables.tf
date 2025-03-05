variable "service_name" {
  description = "The id of the public OVH cloud project"
  type        = string
}

variable "region" {
  default = "waw"
  description = "S3 bucket location from [list](https://help.ovhcloud.com/csm/en-ie-public-cloud-storage-s3-location?id=kb_article_view&sysparm_article=KB0047393)"
  type = string
}

variable "s3_endpoint" {
  default = "https://s3.waw.io.cloud.ovh.net/"
  description = "OVH S3 endpoint from  from [list](https://help.ovhcloud.com/csm/en-ie-public-cloud-storage-s3-location?id=kb_article_view&sysparm_article=KB0047393)"
  type = string
}

variable "bucket_name" {
  default = "streamx-commerce-accelerator-bucket"
  description = "S3 bucket name"
  type = string
}
