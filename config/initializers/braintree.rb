Braintree::Configuration.environment = Rails.application.credentials.braintree[:environment].to_sym
Braintree::Configuration.merchant_id = Rails.application.credentials.braintree[:merchant_id]
Braintree::Configuration.private_key = Rails.application.credentials.braintree[:private_key]
Braintree::Configuration.public_key = Rails.application.credentials.braintree[:public_key]
