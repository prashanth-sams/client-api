describe 'JSON template as body' do

  it "{POST request} json template as body" do
    api = ClientApi::Api.new
    api.post('/api/users', payload("./data/request/post.json"))

    expect(api.status).to eq(201)
  end

  it "{POST request} json template as body x2" do
    api = ClientApi::Api.new
    api.post('/api/users',
       {
                "name": "prashanth sams"
            }
    )
    expect(api.status).to eq(201)
  end
end