FROM ubuntu:20.04

# Set the working directory
WORKDIR /coduo-server

# Update the package repository
RUN apt-get update

# Add i386 architecture
RUN dpkg --add-architecture i386 && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y curl wget file tar bzip2 gzip unzip \
      bsdmainutils python3 util-linux ca-certificates \
      binutils bc jq tmux netcat lib32gcc1 lib32stdc++6 libstdc++5:i386 \
      cpio distro-info cron

# Purge any existing node install
RUN apt remove --purge -y nodejs npm && \
    apt clean && \
    apt autoclean && \
    apt install -f && \
    apt autoremove -y

# Install Node.js 16
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt update && \
    apt install -y nodejs

# Install gamedig and update
RUN npm install gamedig -g && \
    npm update -g

# Add user coduoserver
RUN adduser --disabled-password --gecos "" coduoserver

# Change ownership of the /coduo-server directory
RUN chown -R coduoserver:coduoserver /coduo-server

# Switch to the coduoserver user
USER coduoserver

RUN wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh coduoserver

# Install the server
RUN yes yes | ./coduoserver install
# RUN ./coduoserver start
# RUN ./coduoserver stop

# Update server name
RUN pwd
RUN ls
RUN sed -i '1c\\set sv_hostname \"hells_raiders\"' serverfiles/uo/coduoserver.cfg

COPY update_crontab.sh /coduo-server/

# Run the setup script
RUN /coduo-server/update_crontab.sh

# Expose any required ports (optional)
EXPOSE 28960

# Set the default command for the container
CMD ["sh", "-c", "./coduoserver start && yes yes | ./coduoserver console"]
