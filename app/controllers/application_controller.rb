class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  respond_to :json

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
