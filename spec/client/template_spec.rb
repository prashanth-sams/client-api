RSpec.describe ClientApi do

  it "{POST request} json template as body", :post do
    post('/api/users', payload("./data/request/post.json"))

    expect(status).to eq(201)
  end

  it "response validator", :post do
    post('/api/users', payload("./data/request/post.json"))

    expect(status).to eq(201)
    validate(
        {
            "key": "name",
            "value": "prashanth sams",
            "operator": "==",
            "type": 'string'
        }
    )

    validate( { "key": "id", "operator": "eql?", "type": 'string' } )
  end

end
