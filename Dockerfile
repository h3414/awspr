# Step 1: Build the Next.js app
FROM node:18 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock) to install dependencies
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the Next.js app
RUN npm run build

# Step 2: Production stage
FROM node:18 AS production

# Set the working directory inside the container
WORKDIR /app

# Copy the necessary files from the build stage
COPY --from=build /app/package.json /app/package-lock.json /app/.next /app/public /app/

# Install only production dependencies
RUN npm install --production

# Expose the port that the Next.js app will run on
EXPOSE 3000

# Start the Next.js app
CMD ["npm", "start"]
