describe 'JSON value validation' do

  it "json response value structure validator", :get do
    $api.get('https://my-json-server.typicode.com/typicode/demo/db')

    validate_json($api.body,
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
                    "title": "Post 1"
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

    validate_json(actual,
    {
        "posts":
            {
                "prashanth": {
                    "id": 1,
                    "title": "Post 1"
                },
                "heera": {
                    "id": 3
                }
            },
        "profile":
            {
                "id": 44,
                "title": "Post 44"
            }
    })
  end

end