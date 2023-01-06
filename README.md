# Terraform Module for GCP Compute Network/VPC

This is a Terraform module for easily creating GCP networking resources.

## Usage
```hcl
module "vpc" {
  source = "github.com/rockpenguin/terraform-gcp-compute-network"

  gcp_project             = "my-cool-project"
  gcp_region              = "us-central1"

  network_name            = "my-net-core"
  network_description     = "A cool network"
  network_auto_subnets    = false
  network_routing_mode    = "REGIONAL"
  # network_mtu           = 1460

  shared_vpc_host_project = true

  subnets = {
    # The name of each subnet map will be the Terraform resource name, and so
    # should follow the naming conventions for resource names, i.e. underscores, etc.
    subnet_use4_10_30_75 = {
      subnet_name                    = "subnet-use4-10-30-75"
      subnet_description             = "Subnet in us-east4"
      subnet_cidr                    = "10.30.75.0/22"
      subnet_region                  = "us-east4"
      private_ip_google_access       = true
      flow_logs_enabled              = true
      flow_logs_aggregation_interval = "INTERVAL_10_MIN"
      flow_logs_sampling_rate        = 0.7
      flow_logs_metadata             = "INCLUDE_ALL_METADATA"
      flow_logs_filter_expr          = "true"
    },
    subnet_02 = {
      subnet_name                    = "subnet-02"
      subnet_description             = "Subnet #2"
      subnet_cidr                    = "10.15.20.0/22"
      subnet_region                  = "us-west1"
      flow_logs_enabled              = false
      subnet_purpose                 = "PRIVATE"
      secondary_ip_ranges = [
        {
          secondary_ip_range_name = "secondary-cidr-01"
          secondary_ip_range_cidr = "192.168.81.0/24"
        },
        {
          secondary_ip_range_name = "secondary-cidr-02"
          secondary_ip_range_cidr = "192.168.82.0/24"
        }
      ]
    }
  }
}
```

## Module Global Variables
| Variable                | Description                                  | Type             | Default      | Required |
|-------------------------|----------------------------------------------|------------------|--------------|----------|
| gcp_project             | The ID of the GCP project                    | string           | (required)   | yes      |
| gcp_region              | The region of the GCP project                | string           | (required)   | yes      |
| network_name            | The name of the VPC network                  | string           | (required)   | yes      |
| network_auto_subnets    | Create subnets automatically                 | bool             | true         | no       |
| network_description     | Description of the VPC network               | string           | ""           | no       |
| network_mtu             | Network MTU                                  | number           | 1460         | no       |
| network_routing_mode    | Network routing mode (REGIONAL or GLOBAL)    | string           | REGIONAL     | no       |
| shared_vpc_host_project | Shared VPC host project status               | bool             | false        | no       |
| subnets                 | Map of subnet settings (see above for usage) | complex          | (required if **network_auto_subnets** = false) | no |

## Subnet Variables
| Variable                       | Description                                             | Type             | Default                | Required |
|--------------------------------|---------------------------------------------------------|------------------|------------------------|----------|
| subnet_cidr                    | Subnet IPv4 CIDR                                        | string           |                        | yes      |
| subnet_description             | Description of subnet                                   | string           | ""                     | no       |
| subnet_name                    | Name of the subnet                                      | string           |                        | yes      |
| subnet_purpose                 | Purpose of the subnet (see below)                       | string           | "PRIVATE"              | no       |
| subnet_region                  | Region of the subnet                                    | string           | (required)             | yes      |
| subnet_role                    | Role of the subnet (see below)                          | string           |                        | no       |
| private_ip_google_access       | Enables/disables private access to Google APIs          | bool             | false                  | no       |
| flow_logs_enabled              | Enables/disables subnet flow logging (see below)        | bool             | false                  | no       |
| flow_logs_aggregation_interval | Interval for collecting aggregated flow logs            | string           | "INTERVAL_5_SEC"       | no       |
| flow_logs_sampling_rate        | Sampling rate for log collection (0.0 - 1.0)            | number           | 0.5                    | no       |
| flow_logs_metadata             | Which metadata fields should be added to collected logs | string           | "EXCLUDE_ALL_METADATA" | no       |
| flow_logs_metadata_fields      | Flow logs metadata fields to include                    | list             |                        | no       |
| flow_logs_filter_expr          | Filter expression                                       | string           | "true"                 | no       |
| secondary_ip_ranges            | Secondary IP ranges (CIDRs) for the subnet              | list(maps)       | []                     | no       |
| secondary_ip_range_name        | Name of secondary IP range                              | string           | (see usage example)    | no       |
| secondary_ip_range_cidr        | CIDR range of secondary IP range                        | string           | (see usage example)    | no       |

### subnet_purpose

Possible values (see [docs](https://cloud.google.com/vpc/docs/subnets#purpose)):
* **INTERNAL_HTTPS_LOAD_BALANCER** => Reserved for Internal HTTP(S) Load Balancing.
* **PRIVATE** => Regular user created or automatically created subnet.
* **PRIVATE_SERVICE_CONNECT** => Reserved for Private Service Connect Internal Load Balancing.
* **REGIONAL_MANAGED_PROXY** => Reserved for Regional HTTP(S) Load Balancing.

### subnet_role

The role of subnetwork. This field is required when **subnet_purpose** is set to "REGIONAL_MANAGED_PROXY" or "INTERNAL_HTTPS_LOAD_BALANCER". **subnet_role** must be one of:
* **ACTIVE** The ACTIVE subnet that is currently used.
* **BACKUP** The BACKUP subnet that could be promoted to ACTIVE.

### flow_logs_enabled

Enables/disables [subnet flow logging](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#nested_log_config).

* **flow_logs_metadata** - Possible values are "CUSTOM_METADATA", "EXCLUDE_ALL_METADATA" (default), "INCLUDE_ALL_METADATA".
* **flow_logs_metadata_fields** - If **flow_logs_metadata** is "CUSTOM_METADATA" then provide list of metadata fields to be added to collected logs. See [flow log docs](https://cloud.google.com/vpc/docs/flow-logs#metadata)
* **flow_logs_filter_expr** - Export filter used to define which VPC flow logs should be logged (see [examples](https://cloud.google.com/vpc/docs/flow-logs#filtering))

## Requirements

| Name | Version |
|------|---------|
| [terraform](https://www.terraform.io/) | >= 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| [Google Terraform provider](https://registry.terraform.io/providers/hashicorp/google/) | >= 4.45.0 |
