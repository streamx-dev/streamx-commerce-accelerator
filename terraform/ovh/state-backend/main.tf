# Copyright 2025 Dynamic Solutions Sp. z o.o. sp.k.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


module "tf_state_backend" {
  source ="/Users/andrzej/repo/terraform-ovh-platform/modules/state-backend"
  ovh_public_cloud_project_id            = var.service_name
  region = var.region
  bucket_name=var.bucket_name
  s3_endpoint=var.s3_endpoint
  tf_backends = {
    "platform.tfstate" : "${path.module}/../platform/backend.tf"
    "network.tfstate" : "${path.module}/../network/backend.tf"
  }
}
