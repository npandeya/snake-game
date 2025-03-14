# ===========================================
# 1) Build Stage
# ===========================================
FROM node:16-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY app/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app source (HTML, CSS, JS, Webpack config)
COPY app/ .

# Run the Webpack build (creates dist/bundle.js)
RUN npm run build

# ===========================================
# 2) Production Stage (Nginx)
# ===========================================
FROM nginx:alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy built artifacts from build stage
COPY --from=build /app/dist /usr/share/nginx/html/dist

# Also copy index.html, style.css, and static assets
COPY --from=build /app/index.html /usr/share/nginx/html/index.html
COPY --from=build /app/style.css /usr/share/nginx/html/style.css

# COPY --from=build app/license.json /usr/share/nginx/html/license.json
# # Ensure proper permissions (read access)
# RUN chmod 644 /usr/share/nginx/html/license.json
# Expose port 80
EXPOSE 80

# Default Nginx start command
CMD ["nginx", "-g", "daemon off;"]
