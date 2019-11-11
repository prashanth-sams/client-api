# ClientApi

[![Gem Version](https://badge.fury.io/rb/client-api.svg)](http://badge.fury.io/rb/client-api)
[![Build Status](https://travis-ci.org/prashanth-sams/client-api.svg?branch=master)](https://travis-ci.org/prashanth-sams/client-api)
> HTTP REST API client for testing application APIs based on the ruby’s RSpec framework that binds a complete api automation framework setup within itself 

### Features
- [x] Custom Header, URL, and Timeout support
- [x] Datatype and key-pair value validation
- [x] Single key-pair response validation
- [x] Multi key-pair response validation
- [x] JSON response schema validation
- [x] JSON response content validation
- [x] JSON response size validation
- [x] JSON response is empty? validation
- [x] JSON response has specific key? validation
- [x] Response headers validation
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

## #Usage outline

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

# For exceptional cases with body in the GET request
it "GET request with JSON body" do
  api.get_with_body('/api/users', { "count": 2 })
  expect(api.status).to eq(200)
end

# For POST request with multi-form as body
it "POST request with multi-form as body" do
  api.post('/api/upload',
     payload(
         'type' => 'multipart/form-data',
         'data' => {
             :file => './data/request/upload.png'
         }
     )
  )

  expect(api.code).to eq(200)
end
```

## Validation shortcuts

#### Default validation

> key features
- datatype validation
- key-pair value validation
- value size validation
- is value empty validation
- key exist or not-exist validation
- single key-pair validation
- multi key-pair validation

<table>
    <tr>
        <th>
            General Syntax
        </th>
        <th>
            Syntax | Model 2
        </th>
        <th>
            Syntax | Model 3
        </th>
        <th>
            Syntax | Model 4
        </th>
        <th>
            Syntax | Model 5
        </th>
        <th>
            Syntax | Model 6
        </th>
    </tr>
    <tr>
        <td>
            <pre>
validate(
    api.body,
    {
        key: '',
        operator: '', 
        value: '', 
        type: ''
    }
)
            </pre>
        </td>
        <td>
            <pre>
validate(
    api.body,
    {
        key: '', 
        size: 0
    }
)
            </pre>
        </td>
        <td>
            <pre>
validate(
    api.body,
    {
        key: '', 
        empty: true
    }
)
            </pre>
        </td>
        <td>
            <pre>
validate(
    api.body,
    {
        key: '', 
        has_key: true
    }
)
            </pre>
        </td>
        <td>
            <pre>
validate(
    api.body,
    {
        key: '',
        operator: '', 
        value: '', 
        type: '', 
        size: 2,
        empty: true,
        has_key: false
    }
)
            </pre>
        </td>
        <td>
            <pre>
validate(
    api.body,
    {
        key: '', 
        operator: '', 
        type: ''
    },
    {
        key: '', 
        operator: '', 
        value: ''
    }
)
            </pre>
        </td>
    </tr>
</table>

#### JSON response content validation

> key benefits
- the most recommended validation for fixed / static JSON responses
- validates each JSON content value

> what to know?
- replace `null` with `nil` in the expected json (whenever applicable); cos, ruby don't know what is `null`


<table>
    <tr>
        <th>
            General Syntax
        </th>
        <th>
            Syntax | Model 2
        </th>
    </tr>
    <tr>
        <td>
            <pre>
validate_json(
    {
        "data":
            {
                "id": 2,
                "first_name": "Prashanth",
                "last_name": "Sams",
            }
    },
    {
        "data":
            {
                "id": 2,
                "first_name": "Prashanth",
                "last_name": "Sams",
            }
    }
)
            </pre>
        </td>
        <td>
            <pre>
validate_json(
    api.body,
    {
        "data":
            {
                "id": 2,
                "first_name": "Prashanth",
                "last_name": "Sams",
                "link": nil
            }
    }
)
            </pre>
        </td>
    </tr>
</table>

#### JSON response headers validation

> key benefits
- validates any response headers

<table>
    <tr>
        <th>
            General Syntax
        </th>
        <th>
            Syntax | Model 2
        </th>
    </tr>
    <tr>
        <td>
            <pre>
validate_headers(
    api.response_headers,
    {
       key: '',
       operator: '',
       value: ''
    }
)
            </pre>
        </td>
        <td>
            <pre>
validate_headers(
    api.response_headers,
    {
       key: "connection",
       operator: "!=",
       value: "open"
    },{
       key: "vary",
       operator: "==",
       value: "Origin, Accept-Encoding"
    }
)
            </pre>
        </td>
    </tr>
</table>

## #General usage

Using `json` template as body
```ruby
it "JSON template as body" do
  api.post('/api/users', payload("./data/request/post.json"))
  expect(api.status).to eq(201)
end
```
Add custom header
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
Full url support
```ruby
it "full url", :post do
  api.post('https://api.enterprise.apigee.com/v1/organizations/ahamilton-eval',{},{'Authorization' => 'Basic YWhhbWlsdG9uQGFwaWdlZS5jb206bXlwYXNzdzByZAo'})
  expect(api.status).to eq(403)
end
```
Basic Authentication 
```ruby
ClientApi.configure do |config|
  ...
  config.basic_auth = {'Username' => 'ahamilton@apigee.com', 'Password' => 'myp@ssw0rd'}
end
```
Custom Timeout in secs 
```ruby
ClientApi.configure do |config|
  ...
  config.time_out = 10 # in secs
end
```
Output as `json` template 
```ruby
ClientApi.configure do |config|
  ...
  config.json_output = {'Dirname' => './output', 'Filename' => 'sample'}
end
```
<img src="https://i.imgur.com/tQ46LgF.png" height="230" width="750">

## Logs
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

## #Validation | more info.

> Single key-pair value JSON response validator

Validates JSON response `value`, `datatype`, `size`, `is value empty?`, and `key exist?` 
```ruby
validate(
    api.body,
    {
        "key": "name",
        "value": "prashanth sams",
        "operator": "==",
        "type": 'string'
    }
)
``` 
> Multi key-pair values response validator

Validates more than one key-pair values
```ruby
validate(
    api.body,
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
    },
    {
        "key": "post1->0->name",
        "operator": "contains",
        "value": "Sams"
    },
    {
        "key": "post2->0->id",
        "operator": "include",
        "value": 34,
        "type": 'integer'
    },
    {
        "key": "post1->0->available",
        "value": true,
        "operator": "not contains",
        "type": "boolean"
    }
)
```
> JSON response size validator

Validates the total size of the JSON array
```ruby
validate(
    api.body,
    {
        "key": "name",
        "size": 2
    },
    {
        "key": "name",
        "operator": "==",
        "value": "Sams",
        "type": "string",
        "has_key": true,
        "empty": false,
        "size": 2
    }
)
```
> JSON response value empty? validator

Validates if the key has empty value or not
```ruby
validate(
    api.body,
    {
        "key": "0->name",
        "empty": false
    },
    {
        "key": "name",
        "operator": "==",
        "value": "Sams",
        "type": "string",
        "size": 2,
        "has_key": true,
        "empty": false
    }
)
```
> JSON response has specific key? validator

Validates if the key exist or not
```ruby
validate(
    api.body,
    {
        "key": "0->name",
        "has_key": true
    },
    {
        "key": "name",
        "operator": "==",
        "value": "",
        "type": "string",
        "size": 2,
        "empty": true,
        "has_key": true
    }
)
```

###### Operator
| Type  |  options |
| ---      | ---         |
| Equal | `=`, `==`, `eql`, `eql?`, `equal`, `equal?`         |
| Not Equal | `!`, `!=`, `!eql`, `!eql?`, `not eql`, `not equal`, `!equal?`         |
| Greater than | `>`, `>=`, `greater than`, `greater than or equal to`         |
| Less than | `<`, `<=`, `less than`, `less than or equal to`, `lesser than`, `lesser than or equal to`         |
| Contains | `contains`, `has`, `contains?`, `has?`, `include`, `include?`         |
| Not Contains | `not contains`, `!contains`, `not include`, `!include`         |

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

#### JSON response schema validation
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

#### JSON response content validation
> json response content value validation as a structure
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

#### Response headers validation
```ruby
validate_headers(
  api.response_headers,
  {
    key: "connection",
    operator: "!=",
    value: "open"
  },
  {
    key: "vary",
    operator: "==",
    value: "Origin, Accept-Encoding"
  }
)
```

#### Is there a demo available for this gem?
Yes, you can use this demo as an example, https://github.com/prashanth-sams/client-api
```
rake spec
```