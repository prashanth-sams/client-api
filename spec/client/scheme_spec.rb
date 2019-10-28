describe 'http(s) validation' do

  it "http scheme validator", :get do
    api = ClientApi::Api.new
    api.get('http://jservice.io/api/categories', {"Accept"=>"*/*"})

    expect(api.status).to eq(200)
    validate(
        api.body,
        {
            "key": "0->id",
            "operator": "==",
            "type": 'int'
        }
    )
  end

end