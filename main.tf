################################################################################
# Local vars
################################################################################
locals {}

################################################################################
# Set project as a Shared VPC Host project
################################################################################
resource "google_compute_shared_vpc_host_project" "self" {
  count   = var.shared_vpc_host_project ? 1 : 0
  project = var.gcp_project
}

################################################################################
# Network / VPC
################################################################################
resource "google_compute_network" "self" {
  name                            = var.network_name
  project                         = var.gcp_project
  description                     = var.network_description
  auto_create_subnetworks         = var.network_auto_subnets
  routing_mode                    = var.network_routing_mode
  mtu                             = var.network_mtu
  delete_default_routes_on_create = var.network_delete_default_routes
}

################################################################################
# Subnets
################################################################################
resource "google_compute_subnetwork" "subnet" {
  # If network_auto_subnets == false then loop through the subnets
  for_each                  = var.network_auto_subnets == false ? var.subnets : {}
  description               = each.value.subnet_description
  ip_cidr_range             = each.value.subnet_cidr
  name                      = each.value.subnet_name
  network                   = google_compute_network.self.id
  private_ip_google_access  = each.value.private_ip_google_access
  project                   = var.gcp_project
  purpose                   = each.value.subnet_purpose
  region                    = each.value.subnet_region
  role                      = each.value.subnet_role

  dynamic "log_config" {
    for_each = each.value.flow_logs_enabled ? [1] : []
    content {
      aggregation_interval = each.value.flow_logs_aggregation_interval
      flow_sampling        = each.value.flow_logs_sampling_rate
      metadata             = each.value.flow_logs_metadata
      metadata_fields      = each.value.flow_logs_metadata_fields
      filter_expr          = each.value.flow_logs_filter_expr
    }
  }

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_ranges == null ? [] : each.value.secondary_ip_ranges
    content {
      range_name = secondary_ip_range.value["secondary_ip_range_name"]
      ip_cidr_range = secondary_ip_range.value["secondary_ip_range_cidr"]
    }
  }

}

################################################################################
# Routes
################################################################################
resource "google_compute_route" "route" {
  for_each = var.network_routes

  name              = each.value.route_name
  description       = each.value.route_description
  dest_range        = each.value.route_dest_range
  network           = google_compute_network.self.id
  next_hop_gateway  = each.value.route_next_hop_gateway
  next_hop_instance = each.value.route_next_hop_instance
  next_hop_ip       = each.value.route_next_hop_ip
  priority          = each.value.route_priority
  project           = var.gcp_project
  tags              = each.value.route_tags
}

################################################################################
# Firewall Rules
################################################################################
resource "google_compute_firewall" "firewall_rule" {
  for_each = var.firewall_rules

  name = each.value.fw_rule_name
  description = each.value.fw_rule_description
  direction = each.value.fw_rule_direction
  network = google_compute_network.self.id
  priority = each.value.fw_rule_priority
  project = var.gcp_project

  # Ranges
  destination_ranges = each.value.fw_rule_destination_ranges
  source_ranges = each.value.fw_rule_source_ranges
  # Tags
  source_tags = each.value.fw_rule_source_tags
  target_tags = each.value.fw_rule_target_tags

  dynamic "allow" {
    for_each = each.value.fw_rule_type == "allow" ? each.value.fw_rules : []
    content {
      ports    = allow.value["fw_rule_ports"]
      protocol = allow.value["fw_rule_protocol"]
    }
  }

  dynamic "deny" {
    for_each = each.value.fw_rule_type == "deny" ? each.value.fw_rules : []
    content {
      ports    = allow.value["fw_rule_ports"]
      protocol = allow.value["fw_rule_protocol"]
    }
  }

  dynamic "log_config" {
    for_each = each.value.fw_rule_logging_config != null ? [1] : []
    content {
      metadata = each.value.fw_rule_logging_config
    }
  }
}
