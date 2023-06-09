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
      cpio distro-info cron expect

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

RUN (crontab -l 2>/dev/null; echo "*/5 * * * * /home/*server monitor > /dev/null 2>&1") | crontab -
RUN (crontab -l 2>/dev/null; echo "*/30 * * * * /home/*server update > /dev/null 2>&1") | crontab -
RUN (crontab -l 2>/dev/null; echo "0 1 * * 0 /home/*server update-lgsm > /dev/null 2>&1") | crontab -

# Expose any required ports (optional)
# EXPOSE 28960

COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
