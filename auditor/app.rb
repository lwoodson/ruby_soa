$stdout.sync = true
$: << 'lib'

puts "Starting audit service..."

6.times do
  begin
    load 'service.rb'
    AuditService.new
  rescue Bunny::TCPConnectionFailed
    sleep(5)
    puts "Retrying to connect to RabbitMQ"
  end
  puts "Connected to RabbitMQ"
end

while true do
  sleep(10)
end
