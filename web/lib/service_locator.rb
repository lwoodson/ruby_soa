##
# Maintains a registry of services and metamagically
# crafts accessor methods for each service within
# any classes that include ServiceLocator
module ServiceLocator
  @services = {}
  class << self
    ##
    # Register a service
    def register(name, klass)
      @services[name] = klass
    end

    ##
    # Return the names of all services
    def service_names
      @services.keys
    end

    ##
    # Locate a service by name
    def locate(service_name)
      klass = @services[service_name]
      raise "Unknown service: #{service_name}" unless klass
      klass.new
    end

    ##
    # Creates a [service_name]_service accessor method on
    # any classes that include the service locator
    def included(base)
      @services.keys.each do |service_name|
        base.class_exec do
          define_method("#{service_name}_service") do
            ServiceLocator.locate(service_name)
          end
        end
      end
    end
  end
 
  ##
  # returns all service accessor methods
  def services
    ServiceLocator.service_names.map{|name| "#{name}_service".to_sym}
  end
end
