RSpec.describe ClientApi do

  it "{GET request} 200 response", :get do
    get('/api/users')

    expect(status).to eq(200)
    expect(code).to eq(200)
    expect(message).to eq('OK')
  end

  it "{POST request} 201 response", :post do
    post('/api/users', {"name": "prashanth sams"})

    expect(status).to eq(201)
  end

  it "{DELETE request} 204 response", :delete do
    delete('/api/users/3')

    expect(status).to eq(204)
  end

  it "{PUT request} 200 response", :put do
    put('/api/users/2', {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})

    expect(status).to eq(200)
  end

  it "{PATCH request} 200 response", :patch do
    patch('/api/users/2', {"data":{"email":"prashanth@mail.com","first_name":"Prashanth","last_name":"Sams"}})

    expect(status).to eq(200)
  end

end
