# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize current_user
    if current_user.present?
      if current_user.admin?
        admin_permission
      else
        user_permission current_user
      end
    else
      guest_permission
    end
  end

  def guest_permission
    can :create, User
    can :read, [Category, TourDetail]
  end

  def user_permission current_user
    can [:create, :read, :destroy, :pay, :hook], Booking,
        user_id: current_user.id
    can :create, [Review, Comment]
    can :index, Review
    can :destroy, [Review, Comment], user_id: current_user.id
    can :destroy, Like, user_id: current_user.id
    can :update, User, id: current_user.id
    can :read, [Category, TourDetail]
  end

  def admin_permission
    can :manage, :all
    cannot :create, [Booking, User]
  end
end
