# cloudflare

This repository contains Terraform configuration for managing **Cloudflare** resources for the `sybilsedge.com` domain.

## What this repo does

- Provisions a **Cloudflare Worker** (`sybilsedge`) with observability and worker subdomain enabled.
- Attaches `sybilsedge.com` and `www.sybilsedge.com` as **custom domains** routed to that Worker in the `production` environment.

> **Note:** This repository manages infrastructure only — the Worker script itself is deployed separately (e.g., via the [Astro](https://astro.build) Cloudflare Workers adapter and its own CI pipeline).

## Repository structure

```
.
├── main.tf           # Cloudflare Worker + custom domain bindings
├── providers.tf      # Cloudflare provider configuration
├── variables.tf      # Input variable declarations
├── versions.tf       # Terraform / provider version constraints + Terraform Cloud workspace
├── .terraform.lock.hcl
└── .github/
    └── workflows/
        └── terraform-ci.yml   # CI: tflint, terraform fmt, terraform validate
```

## Resources managed

| Resource | Type | Description |
|----------|------|-------------|
| `cloudflare_worker.sybilsedge_worker` | Worker | The `sybilsedge` Worker with observability and subdomain enabled |
| `cloudflare_workers_custom_domain.sybilsedge_root` | Custom Domain | Routes `sybilsedge.com` → Worker (production) |
| `cloudflare_workers_custom_domain.sybilsedge_www` | Custom Domain | Routes `www.sybilsedge.com` → Worker (production) |

## Provider

Uses the [cloudflare/cloudflare](https://registry.terraform.io/providers/cloudflare/cloudflare/latest) Terraform provider `~> 5.0`, authenticated via API token.

## State backend

State is managed by **Terraform Cloud** in the `sybilsedge-terraform` organization, `cloudflare` workspace.

## CI / CD

GitHub Actions runs the following checks on every push and pull request:

| Step | Tool | Purpose |
|------|------|---------|
| Lint | [TFLint](https://github.com/terraform-linters/tflint) | Catch Terraform anti-patterns and provider-specific errors |
| Format | `terraform fmt -check` | Enforce consistent HCL formatting |
| Validate | `terraform validate` | Verify the configuration is syntactically valid |

**Plan and Apply** are executed inside [Terraform Cloud](https://app.terraform.io). The GitHub Actions workflow authenticates to Terraform Cloud via the `TF_API_TOKEN` repository secret.

## Required secrets

| Secret | Description |
|--------|-------------|
| `TF_API_TOKEN` | Terraform Cloud API token — used by CI and by Terraform Cloud to run plan/apply |

## Required Terraform variables

Set these in your **Terraform Cloud** workspace:

| Variable | Sensitive | Description |
|----------|-----------|-------------|
| `cloudflare_api_token` | ✅ Yes | Cloudflare API token with Workers and Zone permissions |
| `cloudflare_zone_id` | No | Zone ID for `sybilsedge.com` (found in the Cloudflare dashboard) |
| `cloudflare_account_id` | No | Cloudflare account ID |

## Getting started

1. Connect this repository to a Terraform Cloud workspace (`sybilsedge-terraform / cloudflare`).
2. Add the variables listed above to the workspace.
3. Add the `TF_API_TOKEN` secret to this GitHub repository.
4. Push to `main` — Terraform Cloud will run plan/apply automatically.
