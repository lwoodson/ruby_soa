##
# Service that allows publishing of distributed events using some
# messaging middleware.  In this case, it will be RabbitMQ.
class EventPublishingService
  def publish(event_name, event)
    raise 'test'
  end
end
