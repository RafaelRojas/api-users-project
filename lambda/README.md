## Lambda users script test cases




* Create user (PUT)
~~~
{
  "routeKey": "PUT /users/{id}",
  "pathParameters": {
    "id": "4"
  },
  "body": "{\"firstName\": \"testUpdate\", \"lastName\": \"lastTestUpdate\"}"
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

* Delete User (DELETE ?users/{id})
~~~
{
  "routeKey": "DELETE /users/{id}",
  "pathParameters": {
    "id": "4"
  }
}
~~~
