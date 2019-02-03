# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable, :omniauthable

  has_many :auths

  def self.from_omniauth(omniauth)
    auth = Auth.where(provider: omniauth.provider, uid: omniauth.uid).first_or_create
    if auth.new_record? && omniauth.provider != 'twitter'
      auth.user = User.create(
        email: omniauth.info.email,
        password: Devise.friendly_token[0, 20]
      )
      auth.save!
    end
    auth.user
  end
end
