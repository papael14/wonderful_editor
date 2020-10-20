class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # CSRF対策OFF
  protect_from_forgery with: :null_session
end
