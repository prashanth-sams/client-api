RSpec.describe 'JSON schema validation' do

  it "json response schema validator", :get do
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
