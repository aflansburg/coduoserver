# Set the base image
FROM ubuntu:16.04

# Update the package repository and install any necessary packages
RUN apt-get update && apt-get upgrade -y

# Set the working directory
WORKDIR /coduo-server

# Copy the setup script into the image
COPY setup.sh /coduo-server/
COPY update_crontab.sh /coduo-server/

# Run the setup script
RUN chmod +x /coduo-server/setup.sh && /coduo-server/setup.sh
RUN chmod +x /coduo-server/update_crontab.sh && /coduo-server/update_crontab.sh

# Expose any required ports (optional)
EXPOSE 28960

# Switch to the coduoserver user
USER coduoserver

# Set the default command for the container
CMD ["./coduoserver", "start"]
