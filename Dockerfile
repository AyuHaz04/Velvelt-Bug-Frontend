# Stage 1 - Build the React app
FROM node:18-alpine as build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .

# Accept API URL as a build argument
ARG VITE_BASE_URL
ENV VITE_BASE_URL=$VITE_BASE_URL

RUN npm run build

# Stage 2 - Serve with Nginx
FROM nginx:1.23-alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
