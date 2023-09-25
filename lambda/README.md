## Lambda users script test cases




* Create user (PUT). It creates a user with an incremental user id, no need to define user id.

~~~
{
  "routeKey": "POST /users",
  "body": "{\"firstName\": \"John\", \"lastName\": \"Doe\"}"
}

~~~

* Modify an existing user. It takes a valid ID as parameter
~~~
{
  "routeKey": "PUT /users/{id}",
  "pathParameters": {
    "id": "3" // Replace with the user ID you want to modify
  },
  "body": "{\"firstName\": \"UpdatedFirstName\", \"lastName\": \"UpdatedLastName\"}"
}

~~~

* Get User (GET /users/{id})

~~~
{
  "routeKey": "GET /users/{id}",
  "pathParameters": {
    "id": "3"
  }
}
~~~

* Get Users (GET /users/)
~~~
{
  "routeKey": "GET /users"
}
~~~

* Delete User (DELETE /users/{id})
~~~
{
  "routeKey": "DELETE /users/{id}",
  "pathParameters": {
    "id": "4"
  }
}
~~~
