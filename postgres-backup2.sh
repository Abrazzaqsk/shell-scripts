#!/bin/bash
sudo exec > /home/file/DBNAME-logs$(date +%d-%m-%Y).log

echo "backup start"
sudo PGPASSWORD=Password pg_dump -U postgres -h RDS-ENDPOINT -p 5432 DBNAME > DBNAME-$(date +%d-%m-%Y).sql
echo "backup done"

echo "upload on s3"
sudo /usr/local/bin/aws s3 cp DBNAME-$(date +%d-%m-%Y).sql s3://prod-db-backup
echo "upload done"

echo "delete from local server"
#rm -rf DBANME-$(date +%d-%m-%Y).sql
echo "delete done"
