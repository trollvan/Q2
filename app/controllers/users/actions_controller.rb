module Users
  class ActionsController < ApplicationController
    def create
      p params
      p actions_params
      users = User.where(id: actions_params[:user_ids])
      User.transaction do
        users.each do |user|
          send(action, user)
        end
      end
      redirect_to root_path
    end

    private

    def actions_params
      params.fetch(:actions, {})
    end

    def unlock(user)
      user.locked = false
      user.save
    end

    def lock(user)
      user.locked = true
      user.save
    end

    def delete(user)
      user&.destroy
    end

    def action
      case params[:commit]
      when 'Lock'
        :lock
      when 'Unlock'
        :unlock
      when 'Delete'
        :delete
      else
        :unknown
      end
    end
  end
end
