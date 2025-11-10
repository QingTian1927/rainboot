FROM node:20-alpine AS base
RUN corepack enable && corepack prepare pnpm@8.15.0 --activate

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

# No separate runner stage - run from builder
WORKDIR /app/apps/backend
ENV NODE_ENV=production

EXPOSE 4000
CMD ["node", "dist/main.js"]
