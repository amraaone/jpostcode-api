# Use the official Node.js image as a base with the specified version
ARG NODE_VERSION=18.16.1
FROM node:${NODE_VERSION}-slim as base

LABEL fly_launch_runtime="Node.js/Prisma"

# Node.js/Prisma app lives here
WORKDIR /app

# Set production environment
ENV NODE_ENV=production

# Throw-away build stage to reduce the size of the final image
FROM base as build

# Install packages needed to build node modules
# Add 'ca-certificates' to handle SSL/TLS certificates
RUN apt-get update -qq && \
    apt-get install -y python-is-python3 pkg-config build-essential openssl ca-certificates

# Install node modules
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production=false

# Copy .env.sample and rename it to .env
COPY .env.sample .env

# Generate Prisma Client
COPY prisma .
RUN npx prisma generate

# Copy application code
COPY . .

# Build application
RUN yarn build

# Remove development dependencies and clean up
RUN yarn install --production=true && \
    apt-get remove -y build-essential pkg-config && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Final stage for the app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y openssl && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built application from the build stage
COPY --from=build /app /app

# Entrypoint prepares the database.
ENTRYPOINT [ "/app/docker-entrypoint.js" ]

# Expose the port that your app listens on (adjust this if needed)
EXPOSE 3000

# Start the server by default, this can be overwritten at runtime
CMD [ "yarn", "start" ]
