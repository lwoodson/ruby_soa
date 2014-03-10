require 'bunny'

BUNNY = Bunny.new
BUNNY.start
at_exit do
  BUNNY.close
end

module Core
  module DistributedEventing
    QUEUE_NAME = "events"

    ##
    # Publish an event to the queue
    def publish(event)
      exchange.publish(event)
      nil
    end

    ##
    # Listen for an event from the queue
    def listen(&block)
      queue.bind(exchange).subscribe do |delivery_info, metadata, event|
        block.call(event)
      end
      nil
    end

    private
    def channel
      @channel ||= BUNNY.create_channel
    end

    ##
    # Queues are used to receive events
    def queue
      # Probably should be a UUID in the real world
      @queue ||= channel.queue(self.object_id.to_s)
    end

    ##
    # Exchanges are used to publish events
    def exchange
      @exchange ||= channel.fanout(QUEUE_NAME)
    end
  end
end
