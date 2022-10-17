module RabbitMq
  extend self

  @mutex = Mutex.new

  def channel
    Thread.current[:rabbitmq_channel] ||= connection.create_channel
  end

  def connection
    @mutex.synchronize do
      @connection ||= Bunny.new.start
    end
  end
end