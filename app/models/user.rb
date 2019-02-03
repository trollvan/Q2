# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable, :omniauthable

  has_many :auths

  def self.from_omniauth(auth)
    auth = Auth.where(provider: auth.provider, uid: auth.uid).first_or_create
    Rails.logger.error(auth.inspect)
    if auth.new_record?
      auth.user = User.create(
        email: auth.info.email,
        password: Devise.friendly_token[0, 20]
      )
      auth.save!
    end
    auth.user
  end
end
