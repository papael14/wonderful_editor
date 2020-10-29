class Api::V1::BaseApiController < ApplicationController
  def current_user
    # user = User.new(
    #   id: '9999',
    #   name: Faker::Name.name,
    #   email: Faker::Internet.email
    # )
    # current_user = user
    user = User.first
  end
end
