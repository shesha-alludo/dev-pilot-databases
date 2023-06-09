import json
import boto3
import sys

client = boto3.client('secretsmanager')
response = client.get_secret_value(SecretId=sys.argv[2])
secret_value = response['SecretString']
secrets = json.loads(secret_value)

file = open(sys.argv[1], "w")
file.write("driver: org.postgresql.Driver\n")
file.write("username: "+secrets['username']+"\n")
file.write("password: "+secrets['password']+"\n")
file.write("url: jdbc:postgresql://"+secrets['host']+":"+str(secrets['port'])+"/"+sys.argv[4]+"\n")
file.close
print("Arg start")
print(sys.argv[0])
print(sys.argv[1])
print(sys.argv[2])
print(sys.argv[3])
print(sys.argv[4])
print("Arg end")
