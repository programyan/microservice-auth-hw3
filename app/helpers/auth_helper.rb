module AuthHelper
  AUTH_TOKEN = %r{\ABearer (?<token>.+)\z}

  def extracted_token
    JwtEncoder.decode(matched_token)
  rescue JWT::DecodeError
    {}
  end

  def matched_token
    result = env['HTTP_AUTHORIZATION']&.match(AUTH_TOKEN)
    return if result.blank?

    result[:token]
  end
end
