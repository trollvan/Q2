# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      user = User.from_omniauth(omniauth)
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end

    def twitter
      user = User.from_omniauth(omniauth)
      if user.present?
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
      else
        session['devise.twitter_data'] = {
          provider: omniauth.provider,
          uid: omniauth.uid
        }
        Rails.logger.error(session.to_h)
        redirect_to new_users_registrations_path
      end
    end

    def vkontakte
      user = User.from_omniauth(omniauth)
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vk') if is_navigational_format?
    end

    private

    def omniauth
      @omniauth ||= request.env['omniauth.auth']
    end
  end
end
