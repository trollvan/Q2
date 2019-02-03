# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      user = User.from_omniauth(omniauth)
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end

    def twitter
      p omniauth
      user = User.from_omniauth(omniauth)
      p user
      session['devise.facebook_data'] = {
        provider: omniauth.provider,
        uid: omniauth.uid
      }
      p session
      redirect_to new_user_registration_url
    end

    def vkontakte
      Rails.logger.error(omniauth.inspect)
      Rails.logger.error(omniauth.info.inspect)
      Rails.logger.error(omniauth.info.email.inspect)
      user = User.from_omniauth(omniauth)
      Rails.logger.error(user)
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vk') if is_navigational_format?
      redirect_to root_path
    end

    private

    def omniauth
      @omniauth ||= request.env['omniauth.auth']
    end
  end
end
