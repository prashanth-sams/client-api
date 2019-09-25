RSpec.describe ClientApi do
  it "has a version number" do
    expect(ClientApi::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end

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

end
