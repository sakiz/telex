Routes = Rack::Builder.new do
  use Pliny::Middleware::RescueErrors, raise: Config.raise_errors?
  use Pliny::Middleware::CORS
  use Pliny::Middleware::RequestID
  use Pliny::Middleware::RequestStore, store: Pliny::RequestStore
  use Pliny::Middleware::Timeout, timeout: Config.timeout.to_i if Config.timeout.to_i > 0
  use Pliny::Middleware::Versioning,
      default: Config.versioning_default,
      app_name: Config.versioning_app_name if Config.versioning?
  use Rack::Deflater
  use Rack::MethodOverride
  use Rack::SSL if Config.force_ssl?

  use Pliny::Router do
    # mount all endpoints here
  end

  # root app; but will also handle some defaults like 404
  run Endpoints::Root
end
