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
  ClientApi.get('/api/users')
  expect(ClientApi.status).to eq(200)
  expect(ClientApi.code).to eq(200)
  expect(ClientApi.message).to eq('OK')
end

it "POST request", :post do
  ClientApi.post('/api/users', body = {"name": "prashanth sams"})
  expect(ClientApi.status).to eq(201)
end

it "DELETE request", :delete do
  ClientApi.delete('/api/users/3')
  expect(ClientApi.status).to eq(204)
end

it "PUT request", :put do
  ClientApi.put('/api/users/2', body = {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})
  expect(ClientApi.status).to eq(200)
end

it "PATCH request", :patch do
  ClientApi.patch('/api/users/2', body = {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})
  expect(ClientApi.status).to eq(200)
end
```

> Using `json` template as body
```ruby
it "JSON template as body", :post do
  ClientApi.post('/api/users', body = json_body("./data/template/post.json"))
  expect(ClientApi.status).to eq(201)
end
```

> Output as `json` template 

```ruby
ClientApi.configure do |config|
  ...
  config.output = {'Dirname' => './output', 'Filename' => 'sample'}
end
```

<img src="https://i.imgur.com/j21B9gC.png" height="170" width="330"> 

#### Is there a demo available for this gem?
Yes, you can use this demo as an example, https://github.com/prashanth-sams/client-api
```
rake spec
```