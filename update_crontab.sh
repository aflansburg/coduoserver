#!/bin/bash

# Backup existing crontab
crontab -l > backup_crontab.txt

# Merge existing crontab with new jobs using a heredoc
cat backup_crontab.txt /dev/stdin > new_crontab.txt << EOL
*/5 * * * * /home/coduoserver/coduoserver monitor > /dev/null 2>&1
0 0 * * 0 /home/coduoserver/coduoserver update-lgsm > /dev/null 2>&1
EOL

# Install new crontab
crontab new_crontab.txt
