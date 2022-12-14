#!/bin/bash
sudo exec > /home/devuser/nissan-api/file/nissan_configuration-logs$(date +%d-%m-%Y).log

echo "backup start"
sudo PGPASSWORD=5J8QZZmuqTB2Zbx5 pg_dump -U postgres -h nmipl-magnite-proddb.c9ijqfqikutm.ap-south-1.rds.amazonaws.com -p 5432 nissan_configuration > nissan_configuration-$(date +%d-%m-%Y).sql
echo "backup done"

echo "upload on s3"
sudo /usr/local/bin/aws s3 cp nissan_configuration-$(date +%d-%m-%Y).sql s3://nissan-prod-db-backup
echo "upload done"

echo "delete from local server"
#rm -rf nissan_configuration-$(date +%d-%m-%Y).sql
echo "delete done"
