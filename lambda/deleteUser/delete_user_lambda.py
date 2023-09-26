import logging
import boto3
import json
import os

# Initialize a DynamoDB client
dynamodb_client = boto3.client('dynamodb')

def lambda_handler(event, context):
    try:
        print("event ->" + str(event))
        user_id = event.get("id")
        
        if not user_id:
            return {
                'statusCode': 400,
                'body': json.dumps({"status": "Bad Request", "error": "Missing user ID"})
            }
        
        # Check if the user with the specified ID exists
        response = dynamodb_client.get_item(
            TableName=os.environ["USERS_TABLE"],
            Key={"id": {"S": user_id}}
        )
        
        if 'Item' not in response:
            return {
                'statusCode': 404,
                'body': json.dumps({"status": "Not Found", "error": "User ID does not exist"})
            }
        
        # Delete the user with the specified ID
        dynamodb_response = dynamodb_client.delete_item(
            TableName=os.environ["USERS_TABLE"],
            Key={"id": {"S": user_id}}
        )

        return {
            'statusCode': 200,
            'body': json.dumps({"status": "User deleted"})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({"status": "Server error", "error": str(e)})
        }
