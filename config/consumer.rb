channel = RabbitMq.channel
exchange = channel.default_exchange
queue = channel.queue('auth', durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  encoded_token = JSON(payload)['token']

  if encoded_token.present?
    client = AdsService::RpcClient.new
    result = client.authenticate(encoded_token)

    response = if result.success?
                 { meta: { user_id: result.user.id } }
               else
                 ErrorSerializer.from_message(result.errors)
               end

    exchange.publish(
      response.to_json,
      correlation_id: properties[:correlation_id],
      routing_key: properties[:reply_to]
    )
  end

  channel.ack(delivery_info.delivery_tag)
end