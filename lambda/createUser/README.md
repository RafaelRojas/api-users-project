## Create User python method

Sample payload for lambda:

~~~
{
  "body": "{\"id\":\"7\",\"firstName\":\"John\",\"lastName\":\"Doe\"}"
}

~~~

Sample payload restAPI

~~~
curl -X POST "{api endpoint}/dev/users" -H 'Content-Type: application/json' -d'
{
  "id": "1",
  "firstName": "somename",
  "lastName": "someLastName"
}
‘
~~~