#!/bin/bash PostgrSQL 12 Supported 
exec > /var/lib/pgsql/nissan_configuration-$(date +%d-%m-%Y).log
echo "go to postgres default location"
cd /var/lib/pgsql/

echo "pulling backup dump from s3 "
aws s3 cp s3://nissan-prod-db-backup/nissan_configuration-$(date +%d-%m-%Y).sql nissan_configuration-$(date +%d-%m-%Y).sql
echo "pull done"

echo "terminate existing connections"
PGPASSWORD=Network@18 psql -U postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid)FROM pg_stat_activity WHERE pg_stat_activity.datname = 'stg_nissanreports';"

echo "DROP Exiting database"
PGPASSWORD=Network@18 psql -U postgres -c 'DROP DATABASE IF EXISTS stg_nissanreports;'
echo "Droping done"

echo "create database"
PGPASSWORD=Network@18 psql -U postgres -c 'create database stg_nissanreports;'
echo "creation database done"

echo "restore database"
PGPASSWORD=Network@18 psql -U postgres stg_nissanreports < nissan_configuration-$(date +%d-%m-%Y).sql
echo "restore database completed "


echo "delete from local server"
rm -rf nissan_configuration-$(date +%d-%m-%Y).sql
echo "delete from server done"
