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

variable "pages_project_key" {
  description = "Key of the project entry to deploy from pages_projects"
  type        = string
  default     = "sybilsedge-pages"
}

variable "pages_projects" {
  description = "Map of Pages project definitions keyed by project id"
  type = map(object({
    pages_project_name = string
    github_repo_owner  = string
    github_repo_name   = string
    production_branch  = optional(string, "main")
  }))
  default = {
    sybilsedge-pages = {
      pages_project_name = "sybilsedge-pages"
      github_repo_owner  = "sybilsedge"
      github_repo_name   = "sybilsedge"
      production_branch  = "main"
    }
  }
}
