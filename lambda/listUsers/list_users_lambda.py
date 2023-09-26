import json
import boto3
import os

# Assign a variable to the boto3 API client to query DynamoDB
dynamo = boto3.client('dynamodb')

def lambda_handler(event, context):
    body = None
    statusCode = 200
    headers = {
        'Content-Type': 'application/json'
    }
    try:
        route_key = event['routeKey']

        if route_key == 'GET /users':
            table_name = os.environ.get('USERS_TABLE')
            response = dynamo.scan(
                TableName=table_name
            )
            items = response.get('Items', [])
            body = items
        else:
            raise ValueError(f"Unsupported route: '{route_key}'")
    except Exception as err:
        statusCode = 400
        body = str(err)
    finally:
        body = json.dumps(body)

    return {
        'statusCode': statusCode,
        'body': body,
        'headers': headers
    }
