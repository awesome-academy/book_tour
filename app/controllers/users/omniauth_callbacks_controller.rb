class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    user = User.from_omniauth(request.env["omniauth.auth"], current_user)
    if user.persisted?
      flash[:success] = t ".success"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to login_path
    end
  end

  def from_omniauth auth, current_user
    identity = Identity.where(provider: auth[:provider], uid: auth[:uid])
                       .first_or_initialize
    if identity.user.blank?
      user = current_user || User.find_by("email = ?", auth[:info][:email])
      user = create_user auth if user.blank?

      identity.user_id = user.id
      return if identity.save

      flash[:danger] = t ".oauth_fail"
      redirect_to login_path
    end
    identity.user
  end

  def create_user auth
    user = User.new
    user.password = Devise.friendly_token[0, 10]
    user.name = auth[:info][:name]
    user.email = auth[:info][:email]
    user.save validate: false if auth[:provider] == Settings.twitter
    return user if user.save

    flash[:danger] = t ".oauth_fail"
    redirect_to login_path
  end

  alias facebook all
  alias twitter all
  alias google_oauth2 all
end
