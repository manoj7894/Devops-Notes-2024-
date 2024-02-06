# Use the official NGINX base image
FROM nginx:latest

# Create a directory inside the container that will serve as the mount point for the volume
RUN mkdir /app

# Set the working directory to the newly created directory
WORKDIR /app

RUN echo "hello world" > /app/file2

# Expose port 80
EXPOSE 80

# Define the volume mount point
VOLUME /appse


# Start NGINX when the container runs
CMD ["nginx", "-g", "daemon off;"]



