require 'hash_gen'
class ApplicationController < ActionController::API
  include ErrorHelper::SafeActionHelper
  include ErrorHelper::ControllerErrors
  include RenderHelper
end
