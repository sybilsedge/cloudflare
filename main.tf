terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for sybilsedge.com"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "pages_project_name" {
  description = "Cloudflare Pages project name for the Astro site"
  type        = string
  default     = "sybilsedge"
}

# Link the sybilsedge.com domain to the Cloudflare Pages (Astro) project
resource "cloudflare_pages_domain" "sybilsedge_apex" {
  account_id   = var.cloudflare_account_id
  project_name = var.pages_project_name
  domain       = "sybilsedge.com"
}

resource "cloudflare_pages_domain" "sybilsedge_www" {
  account_id   = var.cloudflare_account_id
  project_name = var.pages_project_name
  domain       = "www.sybilsedge.com"
}

# DNS record for the apex domain pointing to Cloudflare Pages
# Cloudflare supports CNAME flattening at the apex when proxied = true;
# use "@" as the name to target the zone root.
resource "cloudflare_record" "sybilsedge_apex" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "CNAME"
  value   = "${var.pages_project_name}.pages.dev"
  proxied = true
}

# DNS record for the www subdomain pointing to Cloudflare Pages
resource "cloudflare_record" "sybilsedge_www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "CNAME"
  value   = "${var.pages_project_name}.pages.dev"
  proxied = true
}
