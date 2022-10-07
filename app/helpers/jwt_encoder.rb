module JwtEncoder
  module_function

  HMAC_SECRET = ENV.fetch('SECRET_KEY_BASE')

  def encode(payload)
    JWT.encode(payload, HMAC_SECRET)
  end

  def decode(token)
    JWT.decode(token, HMAC_SECRET).first
  end
end
