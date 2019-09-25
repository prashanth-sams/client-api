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
    p ClientApi.body
  end

end
