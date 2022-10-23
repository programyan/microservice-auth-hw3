module AdsService
  module RpcApi
    def authenticate(encoded_tocken)
      extracted_tocken = begin
                           JwtEncoder.decode(encoded_tocken)
                         rescue JWT::DecodeError
                           {}
                         end

      Auth::FetchUser.call(uuid: extracted_tocken['uuid'])
    end
  end
end