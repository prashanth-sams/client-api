describe 'Header validation' do

  it "validate headers", :get do
    api = ClientApi::Api.new
    api.get('https://my-json-server.typicode.com/typicode/demo/db')

    expect(api.status).to eq(200)

    validate_headers(
        api.response_headers,
        {
           key: "connection",
           operator: "!=",
           value: "open"
        },{
           key: "vary",
           operator: "==",
           value: "Origin, Accept-Encoding"
        }
    )
  end

end
