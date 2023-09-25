import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  ScanCommand,
  PutCommand,
  GetCommand,
  DeleteCommand,
} from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});

const dynamo = DynamoDBDocumentClient.from(client);

const tableName = "users";

export const handler = async (event, context) => {
  let body;
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json",
  };

  try {
    switch (event.routeKey) {
      case "DELETE /users/{id}":
        await dynamo.send(
          new DeleteCommand({
            TableName: tableName,
            Key: {
              id: event.pathParameters.id,
            },
          })
        );
        body = `Deleted item ${event.pathParameters.id}`;
        break;
      case "GET /users/{id}":
        body = await dynamo.send(
          new GetCommand({
            TableName: tableName,
            Key: {
              id: event.pathParameters.id,
            },
          })
        );
        body = body.Item;
        break;
      case "GET /users":
        body = await dynamo.send(
          new ScanCommand({ TableName: tableName })
        );
        body = body.users;
        break;
      case "PUT /users/{id}":
        const requestJSON = JSON.parse(event.body);
        const userId = event.pathParameters.id;
      
        // Check if the user with the specified ID exists
        const existingUser = await dynamo.send(
          new GetCommand({
            TableName: tableName,
            Key: {
              id: userId,
            },
          })
        );
      
        if (!existingUser.Item) {
          statusCode = 404;
          body = `User with ID ${userId} not found.`;
          break;
        }
      
        // Perform the update
        const updatedUser = {
          id: userId,
          firstName: requestJSON.firstName,
          lastName: requestJSON.lastName,
        };
      
        await dynamo.send(
          new PutCommand({
            TableName: tableName,
            Item: updatedUser,
          })
        );
      
        body = `Updated user ${userId}`;
        break;
      default:
        throw new Error(`Unsupported route: "${event.routeKey}"`);
    }
  } catch (err) {
    statusCode = 400;
    body = err.message;
  } finally {
    body = JSON.stringify(body);
  }

  return {
    statusCode,
    body,
    headers,
  };
};