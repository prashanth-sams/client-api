describe 'Default validation' do

  it "boolean datatype validator", :get do
    api = ClientApi::Api.new
    api.get('https://jsonplaceholder.typicode.com/todos/1')

    expect(api.status).to eq(200)
    validate(
        api.body,
        {
            "key": "completed",
            "value": false,
            "operator": "==",
            "type": 'boolean'
        }
    )
  end

  it "multi key-pair response validator", :post do
    api = ClientApi::Api.new
    api.post('/api/users', schema_from_json("./data/request/post.json"))

    expect(api.status).to eq(201)
    validate(
        api.body,
        {
            "key": "name",
            "value": "prashanth sams",
            "operator": "==",
            "type": 'string'
        },
        {
            "key": "id",
            "operator": "!=",
            "type": 'integer'
        }
    )

    validate({"key": "id", "operator": "eql?", "type": 'string'})
  end

  it "multi key-pair response validator - json tree", :get do
    api = ClientApi::Api.new
    api.get('https://my-json-server.typicode.com/typicode/demo/db')

    expect(api.status).to eq(200)
    validate(
        api.body,
        {
            "key": "profile->name",
            "value": "typicode",
            "operator": "==",
            "type": 'string'
        },
        {
            "key": "posts->1->id",
            "value": 2,
            "operator": "==",
            "type": 'integer'
        }
    )
  end

end
