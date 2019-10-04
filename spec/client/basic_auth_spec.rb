RSpec.describe 'Basic authentication' do

  it "basic auth", :post do
    post('https://api.enterprise.apigee.com/v1/organizations/ahamilton-eval',{})

    expect(status).to eq(403)
  end

end
