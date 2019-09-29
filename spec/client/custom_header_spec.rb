RSpec.describe ClientApi do

  it "custom header", :post do
    post('https://api.enterprise.apigee.com/v1/organizations/ahamilton-eval',{},{'Authorization' => 'Basic YWhhbWlsdG9uQGFwaWdlZS5jb206bXlwYXNzdzByZAo'})

    expect(status).to eq(403)
  end

end
