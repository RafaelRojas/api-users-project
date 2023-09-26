## Create User python method

Sample payload for lambda:

~~~
{
  "routeKey": "POST /users",
  "body": "{\"id\":\"10\",\"firstName\":\"John\",\"lastName\":\"Doe\"}"
}
~~~

Sample payload restAPI

~~~
curl --location '{api_url}/{dev/prod}/users' \
--header 'Content-Type: application/json' \
--data '{"id": "10", "firstName": "John-apigw", "lastName": "doe-apigw" }'
~~~