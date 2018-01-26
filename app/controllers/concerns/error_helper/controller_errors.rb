require 'response_codes'
module ErrorHelper
  module ControllerErrors
    extend ActiveSupport::Concern
    include ErrorHelper::ErrorTypes
    included do
      rescue_from FrontEndError, with: :render_json_error
      rescue_from ServerError, with: :render_json_error
    end
    def render_json_error(exp)
      render json: exp.err_obj.to_json, status: exp.err_obj[:status]
    end
    def log_error(label, message, trace = nil)
      Rails.logger.error "#{label}: #{message}"
      Rails.logger.error "#{label}: #{trace.inspect}" unless trace.blank?
    end
  end
end
