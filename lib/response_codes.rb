module ResponseCodes
  module ClientErrors
    BadRequest = "400".freeze
    Forbidden = "403".freeze
    NotFound = "404".freeze
  end
  module ServerErrors
    InternalServerError = "500".freeze
  end
  module SuccessCodes
    Ok = "200".freeze
    Created = "201".freeze
  end
end
