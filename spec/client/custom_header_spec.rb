describe 'Custom header' do

  it "custom header", :post do
    $api.post('https://api.enterprise.apigee.com/v1/organizations/ahamilton-eval',{},{'Authorization' => 'Basic YWhhbWlsdG9uQGFwaWdlZS5jb206bXlwYXNzdzByZAo'})

    expect($api.status).to eq(403)
  end

end
