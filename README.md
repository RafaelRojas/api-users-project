# CRUD users API api_gateway

An api gateway that is linked to python lambda functions to do CRUD (Create, Read, Update, Delete) operations on a users table on DynamoDB. Everything is deployed and configured with terraform 1.15.4. Lambda scripts are in python 3.18.

Deploy.

run these commands:
~~~
chmod +x project.sh
./project.sh --deploy-all
~~~

To destroy eveerything:
~~~
./project.sh --destroy-all
~~~

--------

**Test units:**

* Create User

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

* Delete User.

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
curl -X DELETE {api_gateway_url}/dev/users/10
~~~

* List User.

Sample payload for lambda:

~~~
{
  "routeKey": "GET /users"
}
~~~

Sample payload restAPI

~~~
curl -X GET {api_gateway_url}/dev/users
~~~

* Modify User.

Sample payload for lambda:

~~~
{
  "routeKey": "PUT /users/{id}",
  "pathParameters": {
    "id": "8"
  },
  "body": "{\"firstName\": \"api-John\", \"lastName\": \"api-Doe\"}"
}

~~~

Sample payload restAPI

~~~
curl --location --request PUT '{api_gateway_url}/dev/users/8' \
--header 'Content-Type: application/json' \
--data '{
    "firstName": "api-update-john", 
    "lastName": "api-update-doe"
}'
~~~