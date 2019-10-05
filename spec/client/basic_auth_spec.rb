describe 'Basic authentication' do

  it "basic auth", :post do
    $api.post('https://api.enterprise.apigee.com/v1/organizations/ahamilton-eval',{})

    expect($api.status).to eq(403)
  end

end
