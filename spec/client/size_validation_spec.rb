describe 'Size validation' do

  it "json response size validator" do

    actual =
        {
            "posts": [
                {
                    "id": 1,
                    "title": "Post 1"
                },
                {
                    "id": 2,
                    "title": "Post 2"
                },
                {
                    "id": 3,
                    "title": "Post 3"
                }
            ],
            "profile": {
                "name": [
                    {
                        "type": "new",
                        "more": [
                            "created": [
                                "really": {
                                    "finally": true
                                }
                            ],
                            "created2": [
                                "really": {
                                    "finally": false
                                }
                            ]
                        ]
                    }
                ]
            }
        }

    validate(
      actual,
      {
          "key": "posts->0",
          "operator": "==",
          "size": 2,
          "type": 'hash'
      },
      {
          "key": "posts->0->id",
          "operator": "==",
          "value": 1,
          "size": 0
      },
      {
          "key": "posts->0->id",
          "operator": "not contains",
          "size": 1
      },
      {
          "key": "posts->0->id",
          "operator": "contains",
          "size": 0
      },
      {
          "key": "posts->1",
          "operator": "==",
          "type": "hash",
          "size": 2
      },
      {
          "key": "posts->1",
          "operator": "<=",
          "type": "hash",
          "size": 2
      }
    )

  end

  it "json response size validator x2" do

    actual =
        [
            {
                "id": 11510,
                "title": "pair of dice, lost",
                "clues_count": 5
            },
            {
                "id": 11531,
                "title": "mixed bag",
                "clues_count": 5
            }
        ]


    validate(
      actual,
      {
          "key": "",
          "operator": "==",
          "size": 2
      },
      {
          "key": "1->title",
          "size": 0
      }
    )

  end

end
