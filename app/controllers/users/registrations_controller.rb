module Users
  class RegistrationsController < ApplicationController
    skip_before_action :authenticate_user!

    def new
      @user = User.new
    end

    def create
      Rails.logger.error(session.to_h)
      @user = User.where(user_params).first_or_create
      if @user.new_record?
        @user.password = Devise.friendly_token[0, 20]
        @user.save
        omniauth = session['devise.twitter_data']
        Rails.logger.error(omniauth)
        auth = Auth.create(
          provider: omniauth['provider'],
          uid: omniauth['uid'],
          user: @user
        )
        Rails.logger.error(auth)
        sign_in_and_redirect @user, event: :authentication
      elsif @user.persisted?
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
