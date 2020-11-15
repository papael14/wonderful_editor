class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # CSRF対策OFF
  protect_from_forgery with: :null_session

  skip_before_action :verify_authenticity_token, if: :devise_controller? # APIではCSRFチェックをしない

  # sign_up
  # before_action :configure_permitted_parameters, if: :devise_controller?

  # protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  # end
end
