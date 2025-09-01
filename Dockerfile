# Stage 1 - Build the React app
FROM node:18-alpine as build

WORKDIR /app

# Copy package.json and lock file first (for better caching)
COPY package.json package-lock.json ./

RUN npm install

# Copy the rest of the source code
COPY . .

# Build the project
RUN npm run build

# Stage 2 - Serve with Nginx
FROM nginx:1.23-alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy build output from the previous stage
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]