# ---- build stage ----
FROM node:18-alpine AS builder
WORKDIR /app

# speed up install: copy lockfile first
COPY package.json package-lock.json* yarn.lock* ./

# If you use npm:
RUN npm ci --silent

# If you use yarn, replace above with:
# RUN yarn install --frozen-lockfile --silent

# Copy source and build
COPY . .

# If it's a pure server (no frontend build), you might skip build step.
# If you have a build step (e.g. bundling, transpile), run it:
RUN npm run build

# ---- production stage ----
FROM node:18-alpine AS runner
WORKDIR /app

# create non-root user for safety
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
ENV NODE_ENV=production
# copy only needed files from builder
COPY --from=builder /app/package.json /app/package-lock.json* ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
# if your app entry is index.js in root, adjust accordingly:
# COPY --from=builder /app/index.js ./index.js

# set permissions
RUN chown -R appuser:appgroup /app
USER appuser

# set the port your app listens on
EXPOSE 3000

# start command - use the production start script
CMD ["npm", "start"]
