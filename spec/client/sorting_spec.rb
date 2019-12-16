describe 'Soring validation' do

  it "json response sorting validator - ascending" do

    actual = {
        "posts": [
            {
                "id": 1,
                "int": "1",
                "title": "Post 1"
            },{
                "id": 2,
                "int": "2",
                "title": "Post 2"
            },{
                "id": 3,
                "int": "3",
                "title": "Post 3"
            },{
                "id": 4,
                "int": "4",
                "title": "Post 4"
            },{
                "id": 5,
                "int": "5",
                "title": "Post 5"
            }
        ],
        "profile": {
            "name": "typicode"
        }
    }

    validate_list(
      actual,
      {
          "key": "posts",
          "unit": "id",
          "sort": "ascending"
      },{
          "key": "posts",
          "unit": "int",
          "sort": "ascending"
      }
    )
    end

  it "json response sorting validator - descending" do

    actual = {
        "posts": [
            {
                "id": 5,
                "title": "Post 5"
            },{
                "id": 4,
                "title": "Post 4"
            },{
                "id": 3,
                "title": "Post 3"
            },{
                "id": 2,
                "title": "Post 2"
            },{
                "id": 1,
                "title": "Post 1"
            }
        ],
        "profile": {
            "name": "typicode"
        }
    }

    validate_list(
      actual,
      {
          "key": "posts",
          "unit": "id",
          "sort": "descending"
      },{
          "key": "posts",
          "unit": "id",
          "sort": "descending"
      }
    )
  end
end
