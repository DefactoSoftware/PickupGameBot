Airbrake.configure do |config|
  config.ignore_environments = %w(development test)
  config.project_id = 1234
  config.project_key = '4321'
end
