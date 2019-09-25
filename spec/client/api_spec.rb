RSpec.describe ClientApi do
  it "has a version number" do
    expect(ClientApi::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end

  it "validate response status for get request" do

    ClientApi.get('/api/users')

    expect(ClientApi.status).to eq(200)
    p ClientApi.body
  end
end
