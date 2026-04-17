resource "cloudflare_worker" "sybilsedge_worker" {
    account_id     = var.cloudflare_account_id
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

# $ terraform import cloudflare_workers_custom_domain.sybilsedge_root '/<domain_id>'
resource "cloudflare_workers_custom_domain" "sybilsedge_root" {
  account_id = var.cloudflare_account_id
  hostname = "sybilsedge.com"
  service = "sybilsedge"
  zone_id = var.cloudflare_zone_id
  environment = "production"
}