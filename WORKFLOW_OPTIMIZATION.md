# GitHub Workflows & Timezone Override Documentation

## Overview

This document explains the consolidated multi-platform build workflows and how to override the timezone at build time.

## Changes Made

### 1. **Unified Multi-Platform Builds**
Previously, separate jobs ran on `ubuntu-latest` (amd64) and `ubuntu-24.04-arm` (arm64), creating duplicate builds and inconsistency. Now all images build for both platforms in a single job using Docker Buildx.

**Before:**
```yaml
jobs:
  build-amd64:
    runs-on: ubuntu-latest
    ...
    platforms: linux/amd64
    tags: image:latest

  build-arm64:
    runs-on: ubuntu-24.04-arm
    ...
    platforms: linux/arm64
    tags: image:arm64
```

**After:**
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    ...
    platforms: linux/amd64,linux/arm64
    tags: |
      image:latest
      image:${{ github.sha }}
```

**Benefits:**
- Single unified image tag for both architectures (Docker automatically selects the right one)
- Faster CI/CD (no duplicate build infrastructure needed)
- Consistent image hashes across platforms
- Eliminates confusion with separate `arm64` tags

### 2. **Timezone as Build ARG**

All PHP containers now accept `TZ` as a build argument with sensible defaults:

**Updated Dockerfiles:**
- `php82-fpm/Dockerfile` — default: `Europe/Amsterdam`
- `php83-fpm/Dockerfile` — default: `Europe/Amsterdam`
- `php84-nginx-azure/Dockerfile` — default: `Europe/Amsterdam`
- `php84-nginx-azure/ast/Dockerfile` — default: `America/Glace_Bay`

**Dockerfile Changes:**
```dockerfile
ARG TZ="Europe/Amsterdam"

FROM php:8.2-fpm
ENV TZ="${TZ}"

RUN echo "date.timezone=${TZ}" >> /usr/local/etc/php/conf.d/docker-php-timezone.ini
```

### 3. **Using Timezone Override in Workflows**

For images with multiple timezone variants (like php84-nginx-azure), use matrix strategy:

```yaml
jobs:
  build:
    strategy:
      matrix:
        include:
          - variant: default
            dockerfile: ./php84-nginx-azure/Dockerfile
            tags: ghcr.io/jield-webdev/docker-repos/php8.4-nginx-azure:latest
            build_args: TZ=Europe/Amsterdam

          - variant: ast-time
            dockerfile: ./php84-nginx-azure/ast/Dockerfile
            tags: ghcr.io/jield-webdev/docker-repos/php8.4-nginx-azure:ast-time
            build_args: TZ=America/Glace_Bay
```

## Using Timezone Override When Building Locally

### Override timezone at build time:
```bash
docker build --build-arg TZ="America/New_York" -t myapp . -f php82-fpm/Dockerfile
```

### Use in FROM statements (nested dockerfiles):
```dockerfile
ARG BASE_TZ="Europe/Amsterdam"

FROM ghcr.io/jield-webdev/docker-repos/php8.2-fpm:latest AS base

# Or with timezone override:
FROM ghcr.io/jield-webdev/docker-repos/php8.2-fpm:latest as builder

FROM php:8.2-fpm
ARG TZ="${BASE_TZ}"
ENV TZ="${TZ}"

RUN echo "date.timezone=${TZ}" >> /usr/local/etc/php/conf.d/docker-php-timezone.ini
```

## Timezone Options

Common timezone values:

**Europe:**
- `Europe/Amsterdam` (default for most containers)
- `Europe/London`
- `Europe/Paris`
- `Europe/Berlin`

**Americas:**
- `America/New_York`
- `America/Los_Angeles`
- `America/Toronto`
- `America/Glace_Bay` (Atlantic)

**Asia:**
- `Asia/Shanghai`
- `Asia/Tokyo`
- `Asia/Dubai`

**Australia:**
- `Australia/Sydney`
- `Australia/Melbourne`

See [IANA Timezone Database](https://www.iana.org/time-zones) for complete list.

## Runtime Environment Override

Even with a build-time TZ arg, you can override the timezone at runtime:

```bash
docker run -e TZ="Asia/Tokyo" ghcr.io/jield-webdev/docker-repos/php8.2-fpm:latest
```

Or in docker-compose:

```yaml
services:
  php:
    image: ghcr.io/jield-webdev/docker-repos/php8.2-fpm:latest
    environment:
      TZ: "Asia/Tokyo"
```

## Consolidated Workflows

All 20 workflows have been consolidated:

| Workflow | Platform Support | Build Args | Status |
|----------|------------------|-----------|--------|
| php82-fpm | amd64, arm64 | TZ | ✓ Multi-arch |
| php83-fpm | amd64, arm64 | TZ | ✓ Multi-arch |
| php84-fpm-dev | amd64, arm64 | TZ | ✓ Multi-arch |
| php85-fpm-dev | amd64, arm64 | TZ | ✓ Multi-arch |
| php82-cli-dev | amd64, arm64 | TZ | ✓ Multi-arch |
| php83-cli-dev | amd64, arm64 | TZ | ✓ Multi-arch |
| php84-cli-dev | amd64, arm64 | TZ | ✓ Multi-arch |
| php85-cli-dev | amd64, arm64 | TZ | ✓ Multi-arch |
| php82-worker | amd64, arm64 | TZ | ✓ Multi-arch |
| php83-worker | amd64, arm64 | TZ | ✓ Multi-arch |
| php84-worker | amd64, arm64 | TZ | ✓ Multi-arch |
| php82-nginx-azure | amd64, arm64 | TZ | ✓ Multi-arch |
| php83-nginx-azure | amd64, arm64 | TZ | ✓ Multi-arch |
| php84-nginx-azure | amd64, arm64 | TZ (matrix) | ✓ Multi-arch + variants |
| php85-nginx-azure | amd64, arm64 | TZ | ✓ Multi-arch |
| nginx-azure | amd64, arm64 | — | ✓ Multi-arch |
| mysql | amd64, arm64 | — | ✓ Multi-arch |

## Reusable Workflow Template

A reusable workflow template is available at `.github/workflows/docker-build-reusable.yml` for future standardization.

Usage:
```yaml
jobs:
  build:
    uses: ./.github/workflows/docker-build-reusable.yml
    with:
      image_name: "php8.2-fpm"
      context: "./php82-fpm"
      tags: "ghcr.io/jield-webdev/docker-repos/php8.2-fpm:latest"
      platforms: "linux/amd64,linux/arm64"
```

## Automatic Image Selection (Multi-arch)

Docker automatically selects the correct architecture when you pull:

```bash
# On amd64 machine:
docker pull ghcr.io/jield-webdev/docker-repos/php8.2-fpm:latest
# → Pulls linux/amd64 variant

# On arm64 machine (M1/M2 Mac, Raspberry Pi):
docker pull ghcr.io/jield-webdev/docker-repos/php8.2-fpm:latest
# → Pulls linux/arm64 variant
```

No need to manually specify `:arm64` tags anymore!

## Key Improvements Summary

- **Single unified image tags** (Docker selects architecture automatically)
- **Timezone customizable at build time** via `--build-arg TZ=...`
- **Timezone customizable at runtime** via `TZ` environment variable
- **20 workflows consolidated** from 2-3 jobs each to single multi-arch job
- **Consistent builds** across architectures
- **Faster CI/CD** (parallel single-job builds instead of sequential runners)
- **No breaking changes** to existing images (defaults unchanged)
