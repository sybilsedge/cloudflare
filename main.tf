resource "cloudflare_worker" "sybilsedge_worker" {
  account_id = var.cloudflare_account_id
    logpush        = false
    name           = "sybilsedge"
    observability  = {
        enabled            = true
        head_sampling_rate = 1
        logs               = {
            enabled            = true
            head_sampling_rate = 1
            invocation_logs    = true
        }
    }
    subdomain      = {
        enabled          = true
        previews_enabled = true
    }
    tags           = []
    tail_consumers = []
}

resource "cloudflare_dns_record" "sybilsedge_root" {
  zone_id = "023e105f4ecef8ad9ca31a8372d0c353"
  name = "sybilsedge.com"
  ttl = 3600
  type = "A"
  proxied = true
  settings = {
    ipv4_only = true
    ipv6_only = true
  }
}

# 
resource "cloudflare_workers_custom_domain" "sybilsedge_root" {
  account_id = var.cloudflare_account_id
  hostname = "sybilsedge.com"
  service = cloudflare_worker.sybilsedge_worker.name
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_workers_custom_domain" "sybilsedge_www" {
  account_id = var.cloudflare_account_id
  hostname = "www.sybilsedge.com"
  service = cloudflare_worker.sybilsedge_worker.name
  zone_id = var.cloudflare_zone_id
}