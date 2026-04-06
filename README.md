# cloudflare

This repository contains Terraform configuration for managing **Cloudflare** resources for the `sybilsedge.com` domain.

## What this repo does

- Attaches `sybilsedge.com` and `www.sybilsedge.com` as custom domains on a **Cloudflare Pages** project that hosts an [Astro](https://astro.build) site.
- Creates the required **DNS records** (proxied CNAME with Cloudflare CNAME-flattening for the apex domain).

## Repository structure

```
.
├── main.tf                          # Cloudflare resources (DNS, Pages domains)
└── .github/workflows/
    └── terraform-ci.yml             # CI: tflint, terraform fmt, terraform validate
```

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
| `TF_API_TOKEN` | Terraform Cloud API token — used by the CI workflow and by Terraform Cloud to run plan/apply |

## Required Terraform variables

These variables must be set in your **Terraform Cloud** workspace:

| Variable | Description |
|----------|-------------|
| `cloudflare_api_token` | Cloudflare API token with Zone and Pages permissions (mark as *sensitive*) |
| `cloudflare_zone_id` | Zone ID for `sybilsedge.com` (found in the Cloudflare dashboard) |
| `cloudflare_account_id` | Cloudflare account ID |
| `pages_project_name` | Cloudflare Pages project name (defaults to `sybilsedge`) |

## Getting started

1. Connect this repository to a Terraform Cloud workspace.
2. Add the variables listed above to the workspace.
3. Add the `TF_API_TOKEN` secret to this GitHub repository.
4. Push to `main` — Terraform Cloud will run plan/apply automatically.