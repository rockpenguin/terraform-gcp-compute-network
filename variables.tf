variable "gcp_project" {
  description = "The ID of the GCP project"
  type        = string
}

variable "gcp_region" {
  description = "The region of the GCP project"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "network_auto_subnets" {
  description = "Create subnets automatically (boolean)"
  type        = bool
  default     = true
}

variable "network_description" {
  description = "Description of the VPC network"
  type        = string
}

variable "network_mtu" {
  description = "Network MTU"
  type        = number
  default     = 1460
}

variable "network_routing_mode" {
  description = "Network routing mode (REGIONAL or GLOBAL)"
  type        = string
  default     = "REGIONAL"
}

variable "shared_vpc_host_project" {
  description = ""
  type        = bool
  default     = false
}

variable "subnets" {
  description = "List of subnets"
  type = map(
    object({
      subnet_name                    = string
      subnet_description             = optional(string, "")
      subnet_cidr                    = string
      subnet_region                  = string
      private_ip_google_access       = optional(bool, false)
      flow_logs_enabled              = bool
      flow_logs_aggregation_interval = optional(string, "INTERVAL_1_MIN")
      flow_logs_sampling_rate        = optional(number, 0.5)
      flow_logs_metadata             = optional(string, "INCLUDE_ALL_METADATA")
      flow_logs_metadata_fields      = optional(list(string), [])
      flow_logs_filter_expr          = optional(string, "true")
    })
  )
}

variable "subnet_secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used within subnets"
  default     = {}
}
