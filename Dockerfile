# Use the official Node.js image as the base image
FROM node

# Create and change to the app directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json /app

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . /app

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["node", "src/app.js"]