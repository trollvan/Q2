# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # DELETE /resource/sign_out
  def destroy
    current_user.last_sign_out_at = Time.zone.now
    current_user.save
    super
  end
end
