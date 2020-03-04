ActionDispatch::Request.parameter_parsers = ActionDispatch::Request.parameter_parsers.except(:json)
