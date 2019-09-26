RSpec.describe ClientApi do

  it "{GET request} 200 response", :get do
    ClientApi.get('/api/users')

    expect(ClientApi.status).to eq(200)
    p ClientApi.body
  end

  it "{POST request} 201 response", :post do
    ClientApi.post('/api/users', body = {"name": "prashanth sams"})

    expect(ClientApi.status).to eq(201)
    p ClientApi.body
  end

  it "{DELETE request} 204 response", :delete do
    ClientApi.delete('/api/users/3')

    expect(ClientApi.status).to eq(204)
  end

  it "{PUT request} 200 response", :put do
    ClientApi.put('/api/users/2', body = {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})

    expect(ClientApi.status).to eq(200)
    p ClientApi.body
  end

  it "{PATCH request} 200 response", :patch do
    ClientApi.patch('/api/users/2', body = {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})

    expect(ClientApi.status).to eq(200)
    p ClientApi.body
  end

end
