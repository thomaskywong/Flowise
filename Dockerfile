# Stage 1: Build stage
FROM node:20-alpine AS build

<<<<<<< HEAD
USER root
=======
# Run image
# docker run -d -p 3000:3000 flowise

FROM node:20-alpine

# Install system dependencies and build tools
RUN apk update && \
    apk add --no-cache \
        libc6-compat \
        python3 \
        make \
        g++ \
        build-base \
        cairo-dev \
        pango-dev \
        chromium \
        curl && \
    npm install -g pnpm
>>>>>>> b5f7fac0155a13122fe85e6ee46f6204d087cb27

# Skip downloading Chrome for Puppeteer (saves build time)
ENV PUPPETEER_SKIP_DOWNLOAD=true

# Install latest Flowise globally (specific version can be set: flowise@1.0.0)
RUN npm install -g flowise

# Stage 2: Runtime stage
FROM node:20-alpine

# Install runtime dependencies
RUN apk add --no-cache chromium git python3 py3-pip make g++ build-base cairo-dev pango-dev curl

# Set the environment variable for Puppeteer to find Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Copy Flowise from the build stage
COPY --from=build /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=build /usr/local/bin /usr/local/bin

<<<<<<< HEAD
ENTRYPOINT ["flowise", "start"]
=======
WORKDIR /usr/src/flowise

# Copy app source
COPY . .

# Install dependencies and build
RUN pnpm install && \
    pnpm build

# Give the node user ownership of the application files
RUN chown -R node:node .

# Switch to non-root user (node user already exists in node:20-alpine)
USER node

EXPOSE 3000

CMD [ "pnpm", "start" ]
>>>>>>> b5f7fac0155a13122fe85e6ee46f6204d087cb27
