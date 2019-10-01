# ClientApi

[![Gem Version](https://badge.fury.io/rb/client-api.svg)](http://badge.fury.io/rb/client-api)
[![Build Status](https://travis-ci.org/prashanth-sams/client-api.svg?branch=master)](https://travis-ci.org/prashanth-sams/client-api)
> HTTP Rest API Client for RSpec

### Features
- [x] Custom Header support
- [x] Custom URL support
- [x] Datatype and key-Pair Validation
- [x] Single Key-Pair response validation
- [x] Multi Key-Pair response validation
- [x] Schema Validation
- [x] JSON template as body and schema
- [x] Logger support

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'client-api'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install client-api
```   

Import the library in your env file
```ruby
require 'client-api'
```

## Usage

Add this config snippet in the `spec_helper.rb` file:
```ruby
ClientApi.configure do |config|
  config.base_url = 'https://reqres.in'
  config.headers = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
end
```

RSpec test scenarios look like,
```ruby
it "GET request" do
  get('/api/users')
  expect(status).to eq(200)
  expect(code).to eq(200)
  expect(message).to eq('OK')
end

it "POST request" do
  post('/api/users', {"name": "prashanth sams"})
  expect(status).to eq(201)
end

it "DELETE request" do
  delete('/api/users/3')
  expect(status).to eq(204)
end

it "PUT request" do
  put('/api/users/2', {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})
  expect(status).to eq(200)
end

it "PATCH request" do
  patch('/api/users/2', {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})
  expect(status).to eq(200)
end
```

> Using `json` template as body
```ruby
it "JSON template as body" do
  post('/api/users', payload("./data/request/post.json"))
  expect(status).to eq(201)
end
```

> Add custom header
```ruby
it "GET request with custom header" do
  get('/api/users', {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  expect(status).to eq(200)
end

it "PATCH request with custom header" do
  patch('/api/users/2', {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}}, {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  expect(status).to eq(200)
end
```
> Full url support
```ruby
it "full url", :post do
  post('https://api.enterprise.apigee.com/v1/organizations/ahamilton-eval',{},{'Authorization' => 'Basic YWhhbWlsdG9uQGFwaWdlZS5jb206bXlwYXNzdzByZAo'})
  expect(status).to eq(403)
end
```
> Basic Authentication 

```ruby
ClientApi.configure do |config|
  ...
  config.basic_auth = {'Username' => 'ahamilton@apigee.com', 'Password' => 'myp@ssw0rd'}
end
```
> Output as `json` template 

```ruby
ClientApi.configure do |config|
  ...
  config.json_output = {'Dirname' => './output', 'Filename' => 'sample'}
end
```

<img src="https://i.imgur.com/j21B9gC.png" height="200" width="400">

### validation
> Validate .json response `values` and `datatype`; validates single key-pair values in the response
```ruby
validate(
    {
        "key": "name",
        "value": "prashanth sams",
        "operator": "==",
        "type": 'string'
    }
)
``` 
> Multi key-pair values response validator
```ruby
validate(
    {
        "key": "name",
        "value": "prashanth sams",
        "operator": "==",
        "type": 'string'
    },
    {
        "key": "id",
        "operator": "!=",
        "type": 'integer'
    }
)
```

###### Operator
| Type  |  options |
| ---      | ---         |
| Equal | `=`, `==`, `eql?`, `equal`, `equal?`         |
| Not Equal | `!`, `!=`, `!eql?`, `not equal`, `!equal?`         |

###### Datatype
| Type  |  options |
| ---      | ---         |
| String | `string`, `str`         |
| Integer | `integer`, `int`         |
| Symbol | `symbol`, `sym`         |
| Boolean | `boolean`, `bool`         |
| Array | `array`, `arr`         |
| Object | `object`, `obj`         |
| Float | `float`         |
| Hash | `hash`         |
| Complex | `complex`         |
| Rational | `rational`         |
| Fixnum | `fixnum`         |
| Falseclass | `falseclass`         |
| Trueclass | `trueclass`         |
| Bignum | `bignum`         |

### schema validation
```ruby
validate_schema(
  schema_from_json('./data/schema/get_user_schema.json'),
  {
    "data":
        {
            "id": 2,
            "email": "janet.weaver@reqres.in",
            "firstd_name": "Janet",
            "last_name": "Weaver",
            "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/josephstein/128.jpg"
        }
  }
)
```
```ruby
validate_schema(
    {
        "required": [
            "data"
        ],
        "type": "object",
        "properties": {
            "data": {
                "type": "object",
                "required": [
                    "id", "email", "first_name", "last_name", "avatar"
                ],
                "properties": {
                    "id": {
                        "type": "integer"
                    },
                    "email": {
                        "type": "string"
                    },
                    "first_name": {
                        "type": "string"
                    },
                    "last_name": {
                        "type": "string"
                    },
                    "avatar": {
                        "type": "string"
                    }
                }
            }
        }
    },
  {
    "data":
        {
            "id": 2,
            "email": "janet.weaver@reqres.in",
            "first_name": "Janet",
            "last_name": "Weaver",
            "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/josephstein/128.jpg"
        }
  }
)
```
```ruby
validate_schema(
    schema_from_json('./data/schema/get_user_schema.json'),
    body
)
```

### logs
> Logs are optional in this library; you can do so through config in `spec_helper.rb`. The param,`StoreFilesCount` will keep the custom files as logs; you can remove it, if not needed.

```ruby
ClientApi.configure do |config|
  ...
  config.before(:suite) do
    config.logger = {'Dirname' => './logs', 'Filename' => 'test', 'StoreFilesCount' => 5}
  end
end
``` 

<img src="https://i.imgur.com/5yf1G3N.png" height="120" width="500">

#### Is there a demo available for this gem?
Yes, you can use this demo as an example, https://github.com/prashanth-sams/client-api
```
rake spec
```