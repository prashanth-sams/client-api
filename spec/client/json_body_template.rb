describe 'JSON template as body' do

  it "{POST request} json template as body", :post do
    @api = ClientApi::Api.new
    @api.post('/api/users', payload("./data/request/post.json"))

    expect(@api.status).to eq(201)
  end
end