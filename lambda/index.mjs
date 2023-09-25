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
  let requestJSON = null;
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
        const users = await dynamo.send(
          new ScanCommand({ TableName: tableName })
        );
        body = users.Items; 
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
        //
      case "POST /users":
        const postrequestJSON = JSON.parse(event.body); 
        //const requestJSON = JSON.parse(event.body);
        // Generate an incrementally increasing ID
        const nextId = await getNextId();
        
        const newUser = {
          id: nextId,
          firstName: postrequestJSON.firstName,
          lastName: postrequestJSON.lastName,
        };
        
        await dynamo.send(
          new PutCommand({
            TableName: tableName,
            Item: newUser,
          })
        );
      
        body = `Created user with ID: ${nextId}`;
        break;
        //
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

// Helper function to get the next available user ID
async function getNextId() {
  const users = await dynamo.send(
    new ScanCommand({ TableName: tableName })
  );
  
  // Find the maximum existing ID and increment it
  let maxId = 0;
  for (const user of users.Items) {
    const userId = parseInt(user.id, 10); // Convert user.id to a number
    if (!isNaN(userId) && userId > maxId) {
      maxId = userId;
    }
  }
  return (maxId + 1).toString();
  //
}