#!/bin/bash PostgrSQL 12 Supported 
exec > /var/lib/pgsql/DBNAME-$(date +%d-%m-%Y).log
echo "go to postgres default location"
cd /var/lib/pgsql/

echo "pulling backup dump from s3 "
aws s3 cp s3://prod-db-backup/DBNAME-$(date +%d-%m-%Y).sql DBNAME-$(date +%d-%m-%Y).sql
echo "pull done"

echo "terminate existing connections"
PGPASSWORD=PASSWORD-OF_DB psql -U postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid)FROM pg_stat_activity WHERE pg_stat_activity.datname = 'stg_reports';"

echo "DROP Exiting database"
PGPASSWORD=PASSWORD psql -U postgres -c 'DROP DATABASE IF EXISTS DBNAME;'
echo "Droping done"

echo "create database"
PGPASSWORD=PASSWORD psql -U postgres -c 'create database DBNAME;'
echo "creation database done"

echo "restore database"
PGPASSWORD=PASSWORD psql -U postgres DBNAME < DBNAME-$(date +%d-%m-%Y).sql
echo "restore database completed "


echo "delete from local server"
rm -rf DBNAME-$(date +%d-%m-%Y).sql
echo "delete from server done"
