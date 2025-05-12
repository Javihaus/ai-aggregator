FROM node:18-alpine as build

# Create app directory
WORKDIR /app

# Copy package.json files
COPY package*.json ./
COPY client/package*.json ./client/

# Install dependencies
RUN npm ci
RUN cd client && npm ci

# Copy source code
COPY . .

# Build the React app
RUN cd client && npm run build

# Production stage
FROM node:18-alpine

WORKDIR /app

# Copy package.json and built client
COPY --from=build /app/package*.json ./
COPY --from=build /app/client/build ./client/build
COPY --from=build /app/server ./server

# Install production dependencies only
RUN npm ci --omit=dev

# Create volume for persistent data
VOLUME /app/server/data

# Expose the API port
EXPOSE 3001

# Start the server
CMD ["npm", "start"]
