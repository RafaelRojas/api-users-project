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
        path_params = event['pathParameters']

        if route_key == 'PUT /users/{id}':
            request_json = json.loads(event['body'])
            table_name = os.environ.get('USERS_TABLE')
            dynamo.put_item(
                TableName=table_name,
                Item={
                    'id': {'S': path_params['id']},
                    'firstName': {'S': request_json['firstName']},
                    'lastName': {'S': request_json['lastName']}
                }
            )
            body = f"Modified user: {path_params['id']}"
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
