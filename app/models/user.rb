# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable, :omniauthable

  has_many :auths

  def self.from_omniauth(omniauth)
    auth = Auth.where(provider: omniauth.provider, uid: omniauth.uid).first_or_create
    Rails.logger.error(auth.inspect)
    if auth.new_record?
      Rails.logger.error('new record')
      password = Devise.friendly_token[0, 20]
      auth.user = User.create(
        email: omniauth.info.email,
        password: password,
        password_confirmation: password
      )
      auth.save!
      Rails.logger.error('auth')
    end
    auth.user
  end
end
