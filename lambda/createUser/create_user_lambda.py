import logging
import boto3
import json
import os

session = boto3.Session(region_name=os.environ['REGION'])
dynamodb_client = session.client('dynamodb')

def lambda_handler(event, context):
    try:
        print("event ->" + str(event))
        
        route_key = event.get('routeKey')
        
        if route_key == 'POST /users':
            payload = json.loads(event["body"])
            print("payload ->" + str(payload))
            dynamodb_response = dynamodb_client.put_item(
                TableName=os.environ["USERS_TABLE"],
                Item={
                    "id": {
                        "S": payload["id"]
                    },
                    "firstName": {
                        "S": payload["firstName"]
                    },
                    "lastName": {
                        "S": payload["lastName"]
                    }
                }
            )
            print(dynamodb_response)
            return {
                'statusCode': 201,
                'body': '{"status":"User created"}'
            }
        else:
            return {
                'statusCode': 400,
                'body': '{"status":"Bad Request", "error":"Unsupported route"}'
            }
    except Exception as e:
        logging.error(e)
        return {
            'statusCode': 500,
            'body': '{"status":"Server error"}'
        }
