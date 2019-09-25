module ClientApi

  def get(url, headers = nil)
    @output = get_request(url, headers: headers)
  end

  def post(url, body, headers = nil)
    @output = post_request(url, body: body, headers: headers)
  end

  def delete(url, headers = nil)
    @output = delete_request(url, headers: headers)
  end

  def status
    @output.code.to_i
  end

  def body
    JSON.parse(@output.body) unless @output.body.nil?
  end

end