describe 'Empty validation' do

  it "json response value empty? validator" do

    actual =
        [
            {
                "id": 11510,
                "title": "",
                "clues_count": 5
            },
            {
                "id": 11531,
                "title": "mixed bag",
                "clues_count": 5.0
            }
        ]

    validate(
      actual,
      {
          "key": "0->title",
          "empty": true
      },
      {
          "key": "1->title",
          "empty": false
      },
      {
          "key": "1->title",
          "operator": "==",
          "type": "string",
          "empty": false
      },
      {
          "key": "1->title",
          "operator": "==",
          "value": "mixed bag",
          "empty": false
      },
      {
          "key": "1->title",
          "operator": "==",
          "type": "string",
          "value": "mixed bag",
          "empty": false
      },
      {
          "key": "1->title",
          "operator": "==",
          "type": "string",
          "value": "mixed bag",
          "size": 0,
          "empty": false
      },
      {
          "key": "1",
          "empty": false
      },
      {
          "key": "1->id",
          "empty": false
      },
      {
          "key": "",
          "empty": false
      },
      {
          "key": "1->clues_count",
          "empty": false
      }
    )

  end

end
