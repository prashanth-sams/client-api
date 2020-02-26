describe 'http(s) validation', :focus do

  it "http scheme validator", :get do
    api = ClientApi::Api.new
    api.get('http://jservice.io/api/categories', {"Accept"=>"*/*"})
  end

  it "http scheme validator x2", :get do
    api = ClientApi::Api.new
    api.get('http://jservice.io/api/categories', {"Accept"=>"*/*"})
    expect(api.status).to eq(200)
  end

  it "http scheme validator x3", :get do
    api = ClientApi::Api.new
    api.get('http://jservice.io/api/categories', {"Accept"=>"*/*"})
    expect(api.status).to eq(201)
  end

  it "http scheme validator x4", :get do
    api = ClientApi::Api.new
    api.get('http://jservice.io/api/categories', {"Accept"=>"*/*"})
    expect(api.status).to eq(202)
  end

  it "http scheme validator x5", :get do
    api = ClientApi::Api.new
    api.get('http://jservice.io/api/categories', {"Accept"=>"*/*"})
    expect(api.status).to eq(200)
  end

end