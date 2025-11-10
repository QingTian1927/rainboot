# Rainboot

**Rainboot** is a personal finance and budgeting web application designed for everyday users in Vietnam.

This repository hosts the **entire monorepo**, including the **frontend (Next.js)**, **backend (NestJS)**, and **shared packages**.

## Overview

The project aims to create a simple, trustworthy, and localized tool to help individuals and small families manage their daily expenses, track budgets, and gain better financial awareness — all without unnecessary complexity.

Rainboot focuses on:
* ✨ **Ease of use** – frictionless expense logging and budget tracking
* ☁️ **Cloud sync** – data accessible across devices
* 🇻🇳 **Vietnam-first experience** – localized currency, language, and UX
* 🔍 **Transparency & insight** – clear visual reports and spending summaries

### Project Structure

```
rainboot/
├── apps/
│ ├── backend/ # NestJS API server
│ └── frontend/ # Next.js client application
├── packages/
│ └── shared/ # Shared types, constants, utilities
├── docker/ # Docker setup for local and production environments
├── .github/ # CI/CD workflows
├── pnpm-workspace.yaml
└── package.json
```

### Core Technologies

| Area | Stack |
|------|-------|
| **Frontend** | Next.js 14, React 18, Tailwind CSS, Zustand, React Query, Shadcn UI |
| **Backend** | NestJS 10, Supabase, Redis (ioredis), Winston, Sentry |
| **Shared** | TypeScript types and constants |
| **Tooling** | pnpm, Docker, GitHub Actions, ESLint, Prettier |

---

## Development Setup

This project uses a **pnpm monorepo workspace**.
You can run the entire stack locally or through Docker.

### 1. Create the Workspace

``` bash
# Clone the repository
git clone https://github.com/QingTian1927/rainboot.git
cd rainboot

# Install dependencies
pnpm install
```

### 2. Configure the Workspace

Ensure your root pnpm-workspace.yaml includes:

``` yaml
packages:
  - 'apps/*'
  - 'packages/*'
```

### 3. Run the Development Environment

#### Option A - Local Development (No Docker)

``` bash
pnpm dev
```

#### Option B - Docker Development

``` bash
cd docker
cp .env.example .env
# Fill in environment variables (Supabase, Sentry, etc.)
docker-compose up --build
```

You can monitor logs with:

``` bash
docker-compose logs -f backend
docker-compose logs -f frontend
```

To rebuild a single service:

``` bash
docker-compose up --build backend
```

### Developer Commands

``` bash
# Install dependencies
pnpm install

# Run both frontend and backend
pnpm dev

# Build all packages
pnpm build

# Run tests
pnpm test

# Clean build outputs
pnpm clean

# Lint all workspaces
pnpm lint
```

---

## Project Modules

### Frontend (`apps/frontend`)

* Framework: Next.js (App Router, TypeScript, TailwindCSS)
* UI System: Shadcn UI + custom design tokens
* State: Zustand & React Query
* Commands:

``` bash
pnpm --filter @rainboot/frontend dev
pnpm --filter @rainboot/frontend build
```

### Backend (apps/backend)

* Framework: NestJS 10
* Features: REST API, throttling, Redis caching, Supabase integration
* Logging: Winston + Sentry integration
* Commands:

``` bash
pnpm --filter @rainboot/backend dev
pnpm --filter @rainboot/backend build
```

### Shared (packages/shared)

* Purpose: Shared types, interfaces, and constants between frontend and backend.
* Commands:

``` bash
pnpm --filter @rainboot/shared build
pnpm --filter @rainboot/shared dev
```

### Docker Configuration

* Development: `docker/docker-compose.yml`
* Production: `docker/docker-compose.prod.yml`

Run development environment:

``` bash
cd docker
docker-compose up --build
```

Tear down:

``` bash
docker-compose down -v
```

### Continuous Integration

GitHub Actions (`.github/workflows/ci.yml`) automatically runs:

* Linting
* Build
* Unit tests

``` yaml
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
```

---

## Contributing

1. Fork the repository
1. Create your feature branch (`git checkout -b feature/my-feature`)
1. Commit your changes (`git commit -m 'Add new feature'`)
1. Push to the branch (`git push origin feature/my-feature`)
1. Open a Pull Request
