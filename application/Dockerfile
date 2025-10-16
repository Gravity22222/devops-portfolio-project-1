# --- STAGE 1: Build the project using its native scripts ---
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files first to leverage Docker's layer caching
COPY package*.json ./

# Install all the necessary developer dependencies
RUN npm install

# Copy the rest of the source code
COPY . .

# Run the official build script from package.json
# This will create a final '/app/dist' folder with the complete website
RUN npm run build


# --- STAGE 2: Serve the final build output with Nginx ---
FROM nginx:alpine

# The key step: Copy the *entire content* of the /dist folder from the builder stage
# into the Nginx web root directory.
COPY --from=builder /app/dist /usr/share/nginx/html