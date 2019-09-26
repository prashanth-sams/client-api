RSpec.describe ClientApi do

  it "{GET request} response validation", :get do
    ClientApi.get('/api/users')

    expect(ClientApi.status).to eq(200)
    p ClientApi.body
  end

  it "{POST request} response validation", :post do
    ClientApi.post('/api/users', body = {"name": "prashanth sams"})

    expect(ClientApi.status).to eq(201)
    p ClientApi.body
  end

  it "{DELETE request} response validation", :delete do
    ClientApi.delete('/api/users/3')

    expect(ClientApi.status).to eq(204)
  end

  it "{PUT request} response validation", :put do
    ClientApi.put('/api/users/2', body = {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})

    expect(ClientApi.status).to eq(200)
    p ClientApi.body
  end

  it "{PATCH request} response validation", :patch do
    ClientApi.patch('/api/users/2', body = {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})

    expect(ClientApi.status).to eq(200)
    p ClientApi.body
  end

end
