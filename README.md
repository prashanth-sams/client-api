# ClientApi

[![Gem Version](https://badge.fury.io/rb/client-api.svg)](http://badge.fury.io/rb/client-api)
> HTTP Rest API Client

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
it "GET request", :get do
  get('/api/users')
  expect(status).to eq(200)
  expect(code).to eq(200)
  expect(message).to eq('OK')
end

it "POST request", :post do
  post('/api/users', {"name": "prashanth sams"})
  expect(status).to eq(201)
end

it "DELETE request", :delete do
  delete('/api/users/3')
  expect(status).to eq(204)
end

it "PUT request", :put do
  put('/api/users/2', {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})
  expect(status).to eq(200)
end

it "PATCH request", :patch do
  patch('/api/users/2', {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})
  expect(status).to eq(200)
end
```

> Using `json` template as body
```ruby
it "JSON template as body", :post do
  post('/api/users', payload("./data/request/post.json"))
  expect(status).to eq(201)
end
```

> Output as `json` template 

```ruby
ClientApi.configure do |config|
  ...
  config.json_output = {'Dirname' => './output', 'Filename' => 'sample'}
end
```

### validation
> Validate .json response `values` and `datatype`
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

<img src="https://i.imgur.com/j21B9gC.png" height="200" width="400"> 

#### Is there a demo available for this gem?
Yes, you can use this demo as an example, https://github.com/prashanth-sams/client-api
```
rake spec
```