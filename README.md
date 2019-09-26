# ClientApi

[![Gem Version](https://badge.fury.io/rb/client-api.svg)](http://badge.fury.io/rb/client-api)
> HTTP Rest API Client

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'client-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install client-api

Import the library in your env file
```
require 'client-api'
```

## Usage

Add this config snippet in the `spec_helper.rb` file:
```bash
ClientApi.configure do |config|
  config.base_url = 'https://reqres.in'
  config.headers = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
end
```

RSpec test scenarios look like,
```bash
it "{GET request} response validation", :get do
    ClientApi.get('/api/users')
    expect(ClientApi.status).to eq(200)
end

it "{POST request} response validation", :post do
    ClientApi.post('/api/users', body = {"name": "prashanth sams"})
    expect(ClientApi.status).to eq(201)
end

it "{DELETE request} response validation", :delete do
    ClientApi.delete('/api/users/3')
    expect(ClientApi.status).to eq(204)
end

it "{PUT request} response validation", :put do
    ClientApi.put('/api/users/2', body = {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})
    expect(ClientApi.status).to eq(200)
end

it "{PATCH request} response validation", :patch do
    ClientApi.patch('/api/users/2', body = {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})
    expect(ClientApi.status).to eq(200)
end
```

#### Is there a demo available for this gem?
Yes, you can use this demo as an example, https://github.com/prashanth-sams/client-api
```
rake spec
```