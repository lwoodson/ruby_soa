require 'core/distributed_eventing'

class AuditService
  include Core::DistributedEventing

  def initialize
    listen do |event|
      puts "#{self} received #{event}"
    end
  end
end
