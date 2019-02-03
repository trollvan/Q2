module Users
  class RegistrationsController < ApplicationController
    skip_before_action :authenticate_user!

    def new
      @user = User.new
    end

    def create
      @user = User.where(user_params).first_or_create
      if @user.new_record?
        @user.password = Devise.friendly_token[0, 20]
        @user.save
        omniauth = session['devise.twitter_data']
        Auth.create(
          provider: omniauth.fetch('provider'),
          uid: omniauth.fetch('uid'),
          user_id: @user.id
        )
        sign_in_and_redirect @user, event: :authentication
      elsif @user.persisted?
        omniauth = session['devise.twitter_data']
        Auth.create(
          provider: omniauth.fetch('provider'),
          uid: omniauth.fetch('uid'),
          user_id: @user.id
        )
        sign_in_and_redirect @user, event: :authentication
      else
        render :new
      end
    end

    private

    def user_params
      params.require(:user).permit(:email)
    end
  end
end
