module ClientApi

  def get(url, headers = nil)
    @output = client_request(:get, url, headers: headers)
  end

  def status
    @output.code.to_i
  end

  def body
    @output.body
  end

end