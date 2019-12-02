class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show create new)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    return if @user

    flash[:danger] = t ".nonexist"
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".create_success"
      log_in @user
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t(".update_success")
      redirect_to @user
    else
      flash[:danger] = t(".update_failed")
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t(".delete_success")
    else
      flash[:danger] = t(".delete_failed")
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :phone_number,
                                 :password, :password_confirmation
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t(".please_login")
    redirect_to login_url
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user? @user
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_path unless current_user.role == "admin"
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t(".nonexist")
    redirect_to root_path
  end
end
