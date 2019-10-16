# ClientApi

[![Gem Version](https://badge.fury.io/rb/client-api.svg)](http://badge.fury.io/rb/client-api)
[![Build Status](https://travis-ci.org/prashanth-sams/client-api.svg?branch=master)](https://travis-ci.org/prashanth-sams/client-api)
> HTTP Rest Api client for RSpec test automation framework that binds within itself 

### Features
- [x] Custom Header, URL, and Timeout support
- [x] Datatype and key-pair value validation
- [x] Single key-pair response validation
- [x] Multi key-pair response validation
- [x] JSON schema validation
- [x] JSON structure validation
- [x] JSON template as body and schema
- [x] Support to store JSON responses of each tests for the current run
- [x] Logs support for debug
- [x] Custom logs remover
- [x] Auto-handle SSL for http(s) schemes

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
  # all these configs are optional; comment out the config if not required
  config.base_url = 'https://reqres.in'
  config.headers = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  config.basic_auth = {'Username' => 'ahamilton@apigee.com', 'Password' => 'myp@ssw0rd'}
  config.json_output = {'Dirname' => './output', 'Filename' => 'test'}
  config.time_out = 10  # in secs
  config.logger = {'Dirname' => './logs', 'Filename' => 'test', 'StoreFilesCount' => 2}
  
  # add this snippet only if the logger is enabled
  config.before(:each) do |scenario|
    ClientApi::Request.new(scenario)
  end
end
```
Create `client-api` object with custom variable
```ruby
api = ClientApi::Api.new
```

RSpec test scenarios look like,
```ruby
it "GET request" do
  api = ClientApi::Api.new
  
  api.get('/api/users')
  expect(api.status).to eq(200)
  expect(api.code).to eq(200)
  expect(api.message).to eq('OK')
end

it "POST request" do
  api.post('/api/users', {"name": "prashanth sams"})
  expect(api.status).to eq(201)
end

it "DELETE request" do
  api.delete('/api/users/3')
  expect(api.status).to eq(204)
end

it "PUT request" do
  api.put('/api/users/2', {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})
  expect(api.status).to eq(200)
end

it "PATCH request" do
  api.patch('/api/users/2', {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})
  expect(api.status).to eq(200)
end
```

> Using `json` template as body
```ruby
it "JSON template as body" do
  api.post('/api/users', payload("./data/request/post.json"))
  expect(api.status).to eq(201)
end
```

> Add custom header
```ruby
it "GET request with custom header" do
  api.get('/api/users', {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  expect(api.status).to eq(200)
end

it "PATCH request with custom header" do
  api.patch('/api/users/2', {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}}, {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  expect(api.status).to eq(200)
end
```
> Full url support
```ruby
it "full url", :post do
  api.post('https://api.enterprise.apigee.com/v1/organizations/ahamilton-eval',{},{'Authorization' => 'Basic YWhhbWlsdG9uQGFwaWdlZS5jb206bXlwYXNzdzByZAo'})
  expect(api.status).to eq(403)
end
```
> Basic Authentication 

```ruby
ClientApi.configure do |config|
  ...
  config.basic_auth = {'Username' => 'ahamilton@apigee.com', 'Password' => 'myp@ssw0rd'}
end
```
> Custom Timeout in secs 

```ruby
ClientApi.configure do |config|
  ...
  config.time_out = 10 # in secs
end
```
> Output as `json` template 

```ruby
ClientApi.configure do |config|
  ...
  config.json_output = {'Dirname' => './output', 'Filename' => 'sample'}
end
```

<img src="https://i.imgur.com/tQ46LgF.png" height="230" width="750">

### validation
> Validate .json response `values` and `datatype`; validates single key-pair values in the response
```ruby
validate( api.body,
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
validate( api.body,
    {
        "key": "name",
        "value": "prashanth sams",
        "operator": "==",
        "type": 'string'
    },
    {
        "key": "event",
        "operator": "eql?",
        "type": 'boolean'
    },
    {
         "key": "posts->1->enabled",
         "value": false,
         "operator": "!=",
         "type": 'boolean'
    },
    {
        "key": "profile->name->id",
        "value": 2,
        "operator": "==",
        "type": 'integer'
    },
    {
        "key": "profile->name->id",
        "value": 2,
        "operator": "<",
        "type": 'integer'
    },
    {
        "key": "profile->name->id",
        "operator": ">=",
        "value": 2,
    }
)
```
<img src="https://i.imgur.com/zQnhMUN.png" height="120" width="400">

###### Operator
| Type  |  options |
| ---      | ---         |
| Equal | `=`, `==`, `eql?`, `equal`, `equal?`         |
| Not Equal | `!`, `!=`, `!eql?`, `not equal`, `!equal?`         |
| Greater than | `>`, `>=`, `greater than`, `greater than or equal to`         |
| Less than | `<`, `<=`, `less than`, `less than or equal to`, `lesser than`, `lesser than or equal to`         |

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
| Falseclass | `falseclass`, `false`         |
| Trueclass | `trueclass`, `true`         |
| Bignum | `bignum`         |

### json schema validation
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
    api.body
)
```

### json structure validation
> json response structure value validation
```ruby
actual_body = {
    "posts":
        {
            "prashanth": {
                "id": 1,
                "title": "Post 1"
            },
            "sams": {
                "id": 2,
                "title": "Post 2"
            }
        },
    "profile":
        {
            "id": 44,
            "title": "Post 44"
        }
}

validate_json( actual_body,
{
    "posts":
        {
            "prashanth": {
                "id": 1,
                "title": "Post 1"
            },
            "sams": {
                "id": 2
            }
        },
    "profile":
        {
            "title": "Post 44"
        }
})
```
```ruby
validate_json( api.body,
  {
      "posts": [
          {
              "id": 2,
              "title": "Post 2"
          }
      ],
      "profile": {
          "name": "typicode"
      }
  }
)
```

### logs
> Logs are optional in this library; you can do so through config in `spec_helper.rb`. The param,`StoreFilesCount` will keep the custom files as logs; you can remove it, if not needed.

```ruby
ClientApi.configure do |config|
  ...
  config.logger = {'Dirname' => './logs', 'Filename' => 'test', 'StoreFilesCount' => 5}
  
  config.before(:each) do |scenario|
    ClientApi::Request.new(scenario)
  end
end
``` 

<img src="https://i.imgur.com/6k5lLrD.png" height="165" width="750">

#### Is there a demo available for this gem?
Yes, you can use this demo as an example, https://github.com/prashanth-sams/client-api
```
rake spec
```