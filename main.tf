locals {
  active_project = var.pages_projects[var.pages_project_key]
}

# Cloudflare Pages project for the Astro site.
resource "cloudflare_pages_project" "sybilsedge_project" {
  account_id        = var.cloudflare_account_id
  name              = local.active_project.pages_project_name
  production_branch = local.active_project.production_branch
  source = {
    type = "github"
    config = {
      owner             = local.active_project.github_repo_owner
      repo_name         = local.active_project.github_repo_name
      production_branch = local.active_project.production_branch
    }
  }
}

# Preserve state continuity across provider v5 resource renames.
moved {
  from = cloudflare_record.sybilsedge_apex
  to   = cloudflare_dns_record.sybilsedge_apex
}

moved {
  from = cloudflare_record.sybilsedge_www
  to   = cloudflare_dns_record.sybilsedge_www
}

# Link the sybilsedge.com domain to the Cloudflare Pages (Astro) project
resource "cloudflare_pages_domain" "sybilsedge_apex" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.sybilsedge_project.name
  name         = "sybilsedge.com"
}

resource "cloudflare_pages_domain" "sybilsedge_www" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.sybilsedge_project.name
  name         = "www.sybilsedge.com"
}

# DNS record for the apex domain pointing to Cloudflare Pages
# Cloudflare supports CNAME flattening at the apex when proxied = true;
# use "@" as the name to target the zone root.
resource "cloudflare_dns_record" "sybilsedge_apex" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "CNAME"
  content = "${local.active_project.pages_project_name}.pages.dev"
  ttl     = 1
  proxied = true
}

# DNS record for the www subdomain pointing to Cloudflare Pages
resource "cloudflare_dns_record" "sybilsedge_www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "CNAME"
  content = "${local.active_project.pages_project_name}.pages.dev"
  ttl     = 1
  proxied = true
}
