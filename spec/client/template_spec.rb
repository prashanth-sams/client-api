RSpec.describe ClientApi do

  it "{POST request} json template as body", :post do
    post('/api/users', payload("./data/request/post.json"))

    expect(status).to eq(201)
  end

  it "schema validator", :post do
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

    validate( { "key": "id", "value": 976, "operator": "eql?", "type": 'integer' } )

  end

end
