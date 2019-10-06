describe 'JSON value validation' do

  it "json response value structure validator", :get do
    api = ClientApi::Api.new
    api.get('https://my-json-server.typicode.com/typicode/demo/db')

    validate_json(
        api.body,
        {
            "posts": [
                {
                    "id": 2,
                    "title": "Post 2"
                }
            ],
            "profile": {
                "name": "typicode"
            }
        }
    )

    actual = {
        "posts":
            {
                "prashanth": {
                    "id": 1,
                    "title": [
                        {
                            "post": 1,
                            "ref": "ref-1"
                        },
                        {
                            "post": 2,
                            "ref": "ref-2"
                        },
                        {
                            "post": 3,
                            "ref": "ref-3"
                        }
                    ]
                },
                "sams": {
                    "id": 2,
                    "title": "Post 2"
                },
                "heera": {
                    "id": 3,
                    "title": "Post 3"
                }
            },
        "profile":
            {
                "id": 44,
                "title": "Post 44"
            }
    }

    validate_json(
        actual,
        {
            "posts":
                {
                    "prashanth": {
                        "id": 1,
                        "title": [
                            {
                                "post": 1
                            },
                            {
                                "post": 2,
                                "ref": "ref-2"
                            }
                        ]
                    },
                    "heera": {
                        "id": 3,
                        "title": "Post 3"
                    }
                },
            "profile":
                {
                    "id": 44,
                    "title": "Post 44"
                }
        }
    )
  end

end