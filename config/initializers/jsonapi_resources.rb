JSONAPI.configure do |config|
  # See full list of options here (v0.9): https://jsonapi-resources.com/v0.9/guide/configuration.html#Defaults
  config.json_key_format = :camelized_key

  config.default_paginator = :paged

  config.default_page_size = 20
  config.maximum_page_size = 100

  config.exception_class_whitelist = [Pundit::NotAuthorizedError]
end