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

  it "get with json input", :get do
    api = ClientApi::Api.new
    api.get_with_body('http://jservice.io/api/categories', { "count": 2 }, {'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    expect(api.status).to eq(200)
    validate(
        api.body,
        {
            "key": "1->id",
            "operator": "==",
            "type": 'integer'
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

  it "has_key? validator - json tree", :get do
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
            "key": "post1",
            "has_key": true
        },
        {
            "key": "posts1",
            "has_key": false
        },
        {
            "key": "post1->0",
            "has_key": true
        },
        {
            "key": "post1->2",
            "has_key": false
        },
        {
            "key": "post1->1->0->name",
            "has_key": false
        },
        {
            "key": "post1->1->name",
            "has_key": false
        },
        {
            "key": "post1->0->name",
            "operator": "==",
            "value": "Prashanth Sams",
            "has_key": true
        },
        {
            "key": "post1->0->name",
            "operator": "==",
            "value": "Prashanth Sams",
            "type": "string",
            "has_key": true
        },
        {
            "key": "post1->0->name",
            "operator": "==",
            "value": "Prashanth Sams",
            "type": "string",
            "size": 0,
            "has_key": true
        },
        {
            "key": "post1->0->name",
            "operator": "==",
            "value": "Prashanth Sams",
            "type": "string",
            "size": 0,
            "empty": false,
            "has_key": true
        }
    )
  end


end
