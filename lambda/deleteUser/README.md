## Delete User python method

Sample payload for lambda:

~~~
{
  "routeKey": "DELETE /users/{id}",
  "pathParameters": {
    "id": "10"
  }
}
~~~

Sample payload restAPI

~~~
curl -X DELETE https://yzglz1vwqe.execute-api.us-east-1.amazonaws.com/dev/users/10
~~~