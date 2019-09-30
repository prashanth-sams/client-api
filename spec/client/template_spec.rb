RSpec.describe ClientApi do

  it "{POST request} json template as body", :post do
    post('/api/users', schema_from_json("./data/request/post.json"))

    expect(status).to eq(201)
  end

  it "boolean datatype validator", :get do
    get('https://jsonplaceholder.typicode.com/todos/1')

    expect(status).to eq(200)
    validate(
        {
            "key": "completed",
            "value": false,
            "operator": "==",
            "type": 'boolean'
        }
    )
  end

  it "single key-pair response validator", :post do
    post('/api/users', schema_from_json("./data/request/post.json"))

    expect(status).to eq(201)
    validate(
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

  it "json schema validator", :get do
    get('/api/users/2')

    expect(status).to eq(200)
    validate_schema(
        {
            "required": [
                "data"
            ],
            "type": "object",
            "properties": {
                "data": {
                    "type": "object",
                    "required": [
                        "id", "email", "first_name", "last_name", "avatar"
                    ],
                    "properties": {
                        "id": {
                            "type": "integer"
                        },
                        "email": {
                            "type": "string"
                        },
                        "first_name": {
                            "type": "string"
                        },
                        "last_name": {
                            "type": "string"
                        },
                        "avatar": {
                            "type": "string"
                        }
                    }
                }
            }
        },
      {
        "data":
            {
                "id": 2,
                "email": "janet.weaver@reqres.in",
                "first_name": "Janet",
                "last_name": "Weaver",
                "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/josephstein/128.jpg"
            }
      }
    )

    validate_schema(
        schema_from_json('./data/schema/get_user_schema.json'),
        body
    )
  end

end
