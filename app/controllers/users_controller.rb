class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show create new)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  load_and_authorize_resource

  def index
    @users = User.where.not(confirmed_at: nil).paginate(page: params[:page])
  end

  def new; end

  def show
    return if @user

    flash[:danger] = t ".nonexist"
    redirect_to root_path && return unless @user.confirmed_at.nil?
  end

  def create; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".update_success"
      redirect_to @user
    else
      flash[:danger] = t ".update_failed"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_success"
    else
      flash[:danger] = t ".delete_failed"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :phone_number, :role,
                                 :password, :password_confirmation,
                                 picture_attributes: [:id,
                                 :link, :pictureable_id,
                                 :pictureable_type, :_destroy]
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if user_signed_in?

    store_location_for(:user, root_path)
    flash[:danger] = t ".please_login"
    redirect_to new_user_session_path
  end

  def correct_user
    @user = User.find(params[:id])
    return if (current_user? @user) || current_user&.admin?

    flash[:danger] = t "users.deny_1"
    redirect_to root_path
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.nonexist"
    redirect_to root_path
  end
end
