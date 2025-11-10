FROM node:20-alpine AS base
RUN corepack enable && corepack prepare pnpm@10.21.0 --activate

# Development stage
FROM base AS development
WORKDIR /app

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/backend/package.json ./apps/backend/
COPY packages/shared/package.json ./packages/shared/

RUN pnpm install --frozen-lockfile

EXPOSE 4000
CMD ["pnpm", "--filter", "@rainboot/backend", "dev"]

# Builder stage
FROM base AS builder
WORKDIR /app

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/backend/package.json ./apps/backend/
COPY packages/shared/package.json ./packages/shared/

RUN pnpm install --frozen-lockfile

COPY packages/shared ./packages/shared
COPY apps/backend ./apps/backend

RUN pnpm --filter @rainboot/shared build
RUN pnpm --filter @rainboot/backend build

# Production stage
FROM base AS production
WORKDIR /app

COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/pnpm-workspace.yaml ./pnpm-workspace.yaml
COPY --from=builder /app/pnpm-lock.yaml ./pnpm-lock.yaml
COPY --from=builder /app/apps/backend/package.json ./apps/backend/package.json
COPY --from=builder /app/packages/shared/package.json ./packages/shared/package.json
COPY --from=builder /app/packages/shared/dist ./packages/shared/dist

# Install production dependencies only
RUN pnpm install --prod --frozen-lockfile --filter @rainboot/backend...

# Copy built backend
COPY --from=builder /app/apps/backend/dist ./apps/backend/dist

ENV NODE_ENV=production
EXPOSE 4000
CMD ["node", "apps/backend/dist/main.js"]
