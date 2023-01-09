
variable "firewall_rules" {
  description = "Network Firewall Rule"
  type        = map(
    object({
      fw_rule_name                     = string
      fw_rule_description              = optional(string, "")
      fw_rule_direction                = optional(string, "INGRESS")
      fw_rule_destination_ranges       = optional(list(string))
      fw_rule_logging_config           = optional(string)
      fw_rule_priority                 = optional(number, 1000)
      fw_rule_type                     = string # allow or deny
      fw_rules                         = optional(list(
        object({
          fw_rule_ports                = optional(list(string))
          fw_rule_protocol             = string
        })))
      fw_rule_source_ranges            = optional(list(string))
      fw_rule_source_service_accounts  = optional(list(string))
      fw_rule_source_tags              = optional(list(string))
      fw_rule_target_service_accounts  = optional(list(string))
      fw_rule_target_tags              = optional(list(string))
    })
  )
}

variable "gcp_project" {
  description = "The ID of the GCP project"
  type        = string
}

variable "gcp_region" {
  description = "The region of the GCP project"
  type        = string
}

variable "network_auto_subnets" {
  description = "Create subnets automatically (boolean)"
  type        = bool
  default     = true
}

variable "network_delete_default_routes" {
  description = "If set to true, default routes (0.0.0.0/0) will be deleted immediately after network creation"
  type        = bool
  default     = false
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

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "network_routes" {
  description = "VPC networking routes"
  default = {}
  type = map(
    object({
      route_name              = string
      route_description       = optional(string)
      route_dest_range        = string
      route_next_hop_gateway  = optional(string)
      route_next_hop_instance = optional(string)
      route_next_hop_ip       = optional(string)
      route_priority          = optional(number, 1000)
      route_tags              = optional(list(string))
    })
  )
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
  description = "List of subnets configurations"
  type = map(
    object({
      subnet_name                    = string
      subnet_description             = optional(string, "")
      subnet_cidr                    = string
      subnet_purpose                 = optional(string, "PRIVATE")
      subnet_region                  = string
      subnet_role                    = optional(string, null)
      private_ip_google_access       = optional(bool, false)
      flow_logs_enabled              = optional(bool, false)
      flow_logs_aggregation_interval = optional(string, "INTERVAL_1_MIN")
      flow_logs_sampling_rate        = optional(number, 0.5)
      flow_logs_metadata             = optional(string, "EXCLUDE_ALL_METADATA")
      flow_logs_metadata_fields      = optional(list(string), [])
      flow_logs_filter_expr          = optional(string, "true")
      secondary_ip_ranges            = optional(list(object({
        secondary_ip_range_name = string
        secondary_ip_range_cidr = string
      })))
    })
  )
}
