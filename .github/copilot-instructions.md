# Rainboot AI Coding Instructions

## Project Overview

**Rainboot** is a personal finance tracking application built as a **pnpm monorepo** with:
- **Frontend**: Next.js 16 (App Router, React 19, Zustand, React Query, Shadcn UI)
- **Backend**: NestJS 11 (REST API, Supabase, Redis caching, Winston logging)
- **Shared**: TypeScript types and constants exported to both apps
- **Docker**: Development and production multi-stage builds

The monorepo workspace is defined in `pnpm-workspace.yaml` with packages in `apps/*` and `packages/*`.

## Build Order & Dependency Graph

**Critical**: Shared packages must build before dependent apps.

```
@rainboot/shared (TypeScript transpilation only)
├── @rainboot/backend (imports shared types)
└── @rainboot/frontend (imports shared types)
```

When modifying shared code, always rebuild shared first:
```bash
pnpm --filter @rainboot/shared build
```

## Key Directories & Patterns

### Shared Package (`packages/shared/src`)
- **index.ts**: Central export file - all exports here are re-exported to apps
- **types.ts**: TypeScript interfaces (e.g., `User`) - import in both backend/frontend
- **constants.ts**: App-wide constants like `APP_NAME`
- **Build output**: TypeScript → CommonJS in `dist/` with type declarations (`*.d.ts`)

### Backend (`apps/backend/src`)
- **app.module.ts**: Root NestJS module - import external providers here (Supabase, Redis, etc.)
- **main.ts**: Bootstrap entry point - configures port (default 4000)
- **Controllers/Services**: Standard NestJS patterns
- **Test structure**: `*.spec.ts` files; E2E tests in `test/jest-e2e.json`
- **Port**: 4000 (configurable via `PORT` env var)
- **Key dependencies**: `@nestjs/throttler` for rate limiting, `ioredis` for caching, `@supabase/supabase-js`

### Frontend (`apps/frontend/src`)
- **app/**: Next.js App Router directory
- **app/layout.tsx**: Root layout (metadata, fonts)
- **app/page.tsx**: Home page component
- **app/api/**: Route handlers (e.g., `healthcheck/route.ts`)
- **lib/utils.ts**: Utility functions
- **Styling**: Tailwind CSS v4 with PostCSS, custom CSS variables in `globals.css`
- **Port**: 3000 (Next.js default)
- **API communication**: Uses `NEXT_PUBLIC_API_URL` env var (set to backend URL)

## Environment Variables

### Backend (`apps/backend`)
- `PORT`: Server port (default: 4000)
- `NODE_ENV`: development/production
- `SUPABASE_URL`: Supabase project URL
- `SUPABASE_KEY`: Supabase API key
- `REDIS_URL`: Redis connection URL

### Frontend (`apps/frontend`)
- `NEXT_PUBLIC_API_URL`: Backend API endpoint (must be prefixed with `NEXT_PUBLIC_`)
- `NODE_ENV`: development/production

### Docker Compose
See `docker/docker-compose.yml` for environment setup. Use `.env` file for secrets.

## Development Workflows

### Local Development (No Docker)
```bash
pnpm install           # Install all dependencies
pnpm dev               # Run frontend + backend in parallel (watch mode)
pnpm build             # Build all packages (shared → backend → frontend)
pnpm lint              # ESLint all apps
pnpm test              # Jest tests across all apps
```

### Docker Development
```bash
cd docker
docker-compose up --build          # Start frontend, backend, Redis
docker-compose logs -f backend     # Monitor backend logs
docker-compose up --build backend  # Rebuild single service
docker-compose down -v             # Teardown with volume cleanup
```

**Key insight**: Docker volumes mount source directories for hot reload. Changes to `apps/backend/src` reflect immediately in container without rebuilding.

### Adding Dependencies
- **Workspace package**: Use `workspace:*` in package.json (already configured)
- **Cross-package imports**: Use `import { } from '@rainboot/shared'`
- **Install root**: `pnpm add -w <pkg>` (workspace root)
- **Filter to app**: `pnpm --filter @rainboot/frontend add <pkg>`

## Testing & Linting

### Backend
- **Jest config**: `rootDir: "src"`, tests match `*.spec.ts` pattern
- **Run**: `pnpm --filter @rainboot/backend test`
- **E2E**: `pnpm --filter @rainboot/backend test:e2e`

### Frontend
- **ESLint config**: `eslint.config.mjs` (Next.js preset)
- **No Jest setup yet**: Placeholder project
- **Run**: `pnpm --filter @rainboot/frontend lint`

### Root workspace
- `pnpm lint`: Parallel linting across all apps
- `pnpm test`: Parallel testing across all apps

## Project-Specific Conventions

1. **TypeScript first**: All source code is TypeScript; strict mode enabled via `tsconfig.json`
2. **Monorepo imports**: Always use `@rainboot/shared` path alias, never relative imports across packages
3. **Module filter syntax**: Commands use `--filter @rainboot/<app>` (not shorthand like `backend`)
4. **Shared types are authority**: Backend and frontend must align on types from `@rainboot/shared`
5. **ESLint + Prettier**: Configured per-app; use `pnpm lint` to auto-fix
6. **Docker multi-stage**: Development stage for hot reload; Production stage for optimized build (see `backend.Dockerfile`)

## Critical Integration Points

- **Frontend ↔ Backend**: REST API via `NEXT_PUBLIC_API_URL` env var
- **Backend ↔ Supabase**: Auth and data persistence via `@supabase/supabase-js`
- **Backend ↔ Redis**: Caching layer via `ioredis` (local: `redis://localhost:6379`)
- **Shared ↔ Apps**: Import types from `@rainboot/shared`; rebuild shared after type changes

## Common Pitfalls

1. **Forgot to build shared**: Changes to `packages/shared` won't reflect in apps until `pnpm --filter @rainboot/shared build`
2. **Relative imports across packages**: Use `import { } from '@rainboot/shared'`, not `../../../packages/shared`
3. **Environment variables not prefixed**: Frontend vars must start with `NEXT_PUBLIC_` to be available in browser
4. **Port conflicts**: Ensure 3000 (frontend) and 4000 (backend) are free; Docker requires Docker daemon running
5. **Node/pnpm versions**: Project requires Node ≥20.0.0 and pnpm ≥10.0.0 (Docker uses node:20-alpine, corepack)

## File References for Patterns

- **Monorepo setup**: `pnpm-workspace.yaml`, `package.json` (root workspace scripts)
- **NestJS bootstrap**: `apps/backend/src/main.ts`, `apps/backend/src/app.module.ts`
- **Next.js structure**: `apps/frontend/src/app/layout.tsx`, `apps/frontend/next.config.ts`
- **Shared exports**: `packages/shared/src/index.ts`
- **Docker development**: `docker/docker-compose.yml`
- **Build pipeline**: Root `package.json` scripts (build order: shared → backend/frontend)
