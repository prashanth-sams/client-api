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
```

#### Is there a demo available for this gem?
Yes, you can use this demo as an example, https://github.com/prashanth-sams/client-api
```
rake spec
```