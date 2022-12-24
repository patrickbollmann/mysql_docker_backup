# mysql_docker_backup
Backup Script for easy backup of sql databases running in docker.

## Setup
* Configure the names of your databases in the "databases" array and set the container name. 
* Set up a cronjob for this script, e.g.: 0 5 * * 1 /home/scripts/backup-databases.sh (this will execute the script every day at 5am)

## Restore
* unzip the .gz backup file
* execute the sql script
