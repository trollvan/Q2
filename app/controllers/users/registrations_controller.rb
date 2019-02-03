module Users
  class RegistrationsController < ApplicationController
    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params.merge(password: Devise.friendly_token[0, 20]))
      if @user.save
        omniauth = session['devise.twitter_data']
        Auth.create(
          provider: omniauth[:provider],
          uid: omniauth[:uid],
          user: @user
        )
        sign_in @user
        redirect_to root_path
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
