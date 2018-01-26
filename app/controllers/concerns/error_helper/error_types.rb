module ErrorHelper
  module ErrorTypes
    class ServerError < StandardError
      attr_reader :err_obj
      def initialize
        @err_obj = @err_obj.nil? ? {
          message: "Unexpected Server Error",
          status: ResponseCodes::ServerErrors::InternalServerError,
          pointer: '/',
        } : @err_obj
        super
      end
    end
    class FrontEndError < StandardError
      attr_reader :err_obj
      def initialize(message = "Unknown front-end error", source = "/")
        @err_obj = @err_obj.nil? ? {
          message: message,
          status: ResponseCodes::ClientErrors::BadRequest,
          pointer: source,
        } : @err_obj
        super(message)
      end
    end
    class InvalidJson < FrontEndError
      def initialize(message = "Invalid Request", source = "/")
        super
      end
    end
  end
end
