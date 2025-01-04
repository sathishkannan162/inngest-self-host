# Use an official Node.js image as a base
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Install inngest-cli globally
RUN npm install -g inngest-cli

# Copy necessary files (if you have additional configuration or scripts)
# COPY . .

# Expose the default port used by Inngest (if applicable)
# Adjust if your configuration requires a different port
EXPOSE 8288


# Set environment variables (optional, replace with your values or use runtime args)
# ENV EVENT_KEY=your-event-key
# ENV SIGNING_KEY=your-signing-key
# ENV REDIS_URI=redis://your-redis-uri

# Command to start Inngest with arguments passed during runtime
CMD inngest start --event-key $EVENT_KEY --signing-key $SIGNING_KEY --redis-uri $REDIS_URI
