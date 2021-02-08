module JsonHelpers
  def json
    JSON.parse(response.body).symbolize_keys
  end

  def response_data
    json[:data].symbolize_keys
  end
end