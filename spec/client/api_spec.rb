RSpec.describe ClientAPI do
  it "has a version number" do
    expect(ClientAPI::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end

  it "validate response status for get request" do
    get '/api/users'

    expect(@status).to eq(200)
  end
end
