# frozen_string_literal: true

if user_signed_in?
  json.user do
    json.(current_user, :id, :email)
  end
end
