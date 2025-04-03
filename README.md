This is a red team tool that completes bash commands (currently set to disable FTP), check for a copy of itself existing anywhere in /tmp and then generates a copy of itself in a random part of the /tmp directory and spins up a cronjob to run it if it does not already exist. 
The copy it generates will also check for its original's location to exist and if not will generate a copy of itself in a random part of the /tmp directory and spins up a cronjob to run it.

This script just needs you to place it in /usr/local/bin/ give it execute permissions with 
"chmod +x /path/to/deathandtaxes.sh"

And to schedule it with cron with
"crontab -e"
"*/10 * * * * /usr/local/bin/deathandtaxes.sh"
