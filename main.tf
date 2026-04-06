# Cloudflare Pages project for the Astro site
resource "cloudflare_pages_project" "sybilsedge" {
  account_id        = var.cloudflare_account_id
  name              = var.pages_project_name
  production_branch = "main"
}

data "cloudflare_pages_project" "sybilsedge_project" {
  account_id   = var.cloudflare_account_id
  project_name = "sybilsedge"
}

# Link the sybilsedge.com domain to the Cloudflare Pages (Astro) project
resource "cloudflare_pages_domain" "sybilsedge_apex" {
  account_id   = var.cloudflare_account_id
  project_name = data.cloudflare_pages_project.sybilsedge_project.name
  name         = "sybilsedge.com"
}

resource "cloudflare_pages_domain" "sybilsedge_www" {
  account_id   = var.cloudflare_account_id
  project_name = data.cloudflare_pages_project.sybilsedge_project.name
  name         = "www.sybilsedge.com"
}

# DNS record for the apex domain pointing to Cloudflare Pages
# Cloudflare supports CNAME flattening at the apex when proxied = true;
# use "@" as the name to target the zone root.
resource "cloudflare_dns_record" "sybilsedge_apex" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "CNAME"
  content = "${var.pages_project_name}.pages.dev"
  ttl     = 86400
  proxied = true
}

# DNS record for the www subdomain pointing to Cloudflare Pages
resource "cloudflare_dns_record" "sybilsedge_www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "CNAME"
  content = "${var.pages_project_name}.pages.dev"
  ttl     = 86400
  proxied = true
}
