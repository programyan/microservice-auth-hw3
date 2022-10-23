module AdsService
  class RpcClient
    extend Dry::Initializer[undefined: false]
    include RpcApi

    option :queue, default: proc { create_queue }

    private

    def create_queue
      channel = RabbitMq.channel
      channel.queue('auth', durable: true)
    end

    def publish(payload, opts = {})
      @queue.publish(
        payload,
        opts.merge(app_id: 'auth')
      )
    end
  end
end