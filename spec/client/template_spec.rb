RSpec.describe ClientApi do

  it "{POST request} template as body", :post do
    ClientApi.post('/api/users', body = json_body("./data/template/post.json"))

    expect(ClientApi.status).to eq(201)
    p ClientApi.body
  end

end
