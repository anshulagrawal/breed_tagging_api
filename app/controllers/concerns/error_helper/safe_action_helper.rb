module ErrorHelper::SafeActionHelper
  extend ActiveSupport::Concern
  
  def safe_whitelist
    begin
      yield
    rescue => e
      log_error("Param Whitelisting Error:", e.inspect, e.backtrace)
      log_error("Param Whitelisting Error: Params", params.inspect)
      raise ErrorHelper::ErrorTypes::InvalidJson.new("Invalid request format")
    end
  end
  def safe_persist
    begin
      ActiveRecord::Base.transaction do
        yield
      end
    rescue => e
      log_error("ActiveRecord Error:", e.inspect, e.backtrace)
      raise ErrorHelper::ErrorTypes::ServerError.new
    end
  end
end
