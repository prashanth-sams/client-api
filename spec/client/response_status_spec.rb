describe 'Response and status validation' do

  it "{GET request} 200 response", :get do
    api = ClientApi::Api.new
    api.get('/api/users')

    expect(api.status).to eq(200)
    expect(api.code).to eq(200)
    expect(api.message).to eq('OK')
  end

  it "{POST request} 201 response", :post do
    api = ClientApi::Api.new
    api.post('/api/users', {"name": "prashanth sams"})

    expect(api.status).to eq(201)
  end

  it "{DELETE request} 204 response", :delete do
    api = ClientApi::Api.new
    api.delete('/api/users/3')

    expect(api.status).to eq(204)
  end

  it "{PUT request} 200 response", :put do
    api = ClientApi::Api.new
    api.put('/api/users/2', {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})

    expect(api.status).to eq(200)
  end

  it "{PATCH request} 200 response", :patch do
    api = ClientApi::Api.new
    api.patch('/api/users/2', {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})

    expect(api.status).to eq(200)
  end

end
