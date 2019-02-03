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
      session['devise.facebook_data'] = {
        provider: omniauth.provider,
        uid: omniauth.uid
      }
      redirect_to new_user_registration_url
    end

    def vkontakte
      
    end

    private

    def omniauth
      @omniauth ||= request.env['omniauth.auth']
    end
  end
end
