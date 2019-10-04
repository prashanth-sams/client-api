RSpec.describe 'JSON template as body' do

  it "{POST request} json template as body", :post do
    post('/api/users', payload("./data/request/post.json"))

    expect(status).to eq(201)
  end
end