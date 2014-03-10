Her::API.setup url: 'http://localhost:9393' do |config|
  config.use Faraday::Request::UrlEncoded
  config.use Her::Middleware::DefaultParseJSON
  config.use Faraday::Adapter::NetHttp
end
