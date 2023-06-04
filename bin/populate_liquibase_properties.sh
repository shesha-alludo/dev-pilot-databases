#!/bin/bash

echo "Preparing Liquibase Properties for DB Engine - $2 and DB Name - $3 in path $1"

export secret_id="dev/aurora-pg/pg1/postgres"

python - <<EOF
import boto3
import json
import os
client = boto3.client('secretsmanager')
response = client.get_secret_value(SecretId=os.getenv('secret_id'))
secret_value = response['SecretString']
secrets = json.loads(secret_value)
print(secrets['host'])
print(secrets['username'])
print(secrets['password'])

os.environ['DB_DRIVER'] = 'org.postgresql.Driver'
os.environ['DB_JDBC_URL'] = secrets['host']
os.environ['DB_USERNAME'] = secrets['username']
os.environ['DB_PASSWORD'] = secrets['password']
EOF


echo driver: ${DB_DRIVER}	 	    > $1
echo url: ${DB_JDBC_URL} 		    >> $1
echo username: ${DB_USERNAME} 	>> $1
echo password: ${DB_PASSWORD} 	>> $1
echo liquibaseSchemaName=public >> $1
cat $1
