require 'core/distributed_eventing'
require 'mongo/driver'
require 'json'

MONGO = Mongo::Connection.new.db('ruby_soa')

class AuditService
  include Core::DistributedEventing

  def initialize
    listen do |event|
      puts "#{self.class.name} received: #{event}"
      converted_event = JSON.parse(event)
      collection.save(converted_event)
      puts "#{self.class.name} stored: #{converted_event}"
    end
  end

  private
  def collection
    @collection ||= MONGO.collection('audits')
  end
end
