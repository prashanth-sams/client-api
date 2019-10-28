describe 'Default validation' do
  # TODO: Add Get Test case with json body

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
    api.post('/api/users', payload("./data/request/post.json"))

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

  it "greater/lesser than response validator - json tree", :get do
    actual =
        {
            "posts": [
                {
                    "id": 3,
                    "title": "Post 3"
                }
            ],
            "profile": {
                "name": "typicode"
            }
        }

    validate(
        actual,
        {
            "key": "posts->0->id",
            "operator": "<=",
            "value": 5,
            "type": "integer"
        }
    )
  end

  it "not contains/contains response validator - json tree", :get do
    actual =
        {
            "post1": [
                {
                    "name": "Prashanth Sams",
                    "title": "Post 1",
                    "available": true
                }
            ],
            "post2": [
                {
                    "id": 434,
                    "title": "Post 2"
                }
            ]
        }

    validate(
        actual,
        {
            "key": "post1->0->name",
            "operator": "contains",
            "value": "Sams"
        },{
            "key": "post1->0->name",
            "operator": "include",
            "value": "Sams"
        },
        {
            "key": "post2->0->id",
            "operator": "contains",
            "value": 34,
            "type": 'integer'
        },
        {
            "key": "post1->0->name",
            "operator": "not contains",
            "value": "Samuel"
        },
        {
            "key": "post2->0->id",
            "operator": "!include",
            "value": 33,
            "type": "string"
        },
        {
            "key": "post1->0->available",
            "value": true,
            "operator": "contains",
            "type": "boolean"
        }
    )
  end

end
