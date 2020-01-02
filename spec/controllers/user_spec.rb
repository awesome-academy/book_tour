require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let! :user_param do
    {
      name: Faker::Name.name,
      email: "user@suntour.com",
      password: "johndoe123",
      password_confirmation: "johndoe123",
    }
  end

  describe "GET #index: " do

    context "user is admin" do
      login_admin
      before do
        get :index
      end
      it {should respond_with :ok}
      it {should render_template :index}
    end

    context "user is not admin" do
      login_user
      before do
        get :index
      end
      it {should redirect_to(root_path)}
    end
  end

  describe "GET #show: " do
    context "when user is existed" do
      login_user
      before do
        get :show, params: {id: subject.current_user.id}
      end
      it {should respond_with :ok}
      it {should render_template :show}
    end

    context "when user is not existed" do
      before {get :show, params: {id: 0}}
      it {should set_flash[:danger]}
      it {should redirect_to(root_path)}
    end
  end

  describe "GET #edit: " do
    context "when logged in" do
      login_user
      before do
        get :edit, params: {id: subject.current_user.id}
      end

      it {should render_template :edit}
    end

    context "when not logged in" do
      before do
        get :edit, params: {id: 333}
      end

      it {should redirect_to(new_user_session_path)}
    end

    context "when it is not the correct user" do
      login_user
      before do
        subject.current_user.id -= 1
        get :edit, params: {id: subject.current_user.id}
      end
      it {should set_flash[:danger]}
      it {should redirect_to(root_path)}
    end
  end

  describe "PUT update: " do
    context "when update is successful" do
      login_user
      before do
        user_param[:name] = "John Doe"
        user_param[:email] = "johndoe@gmail.com"
        user_param[:password] = "password"
        user_param[:password_confirmation] = "password"
        patch :update, params: {id: subject.current_user.id, user: user_param}
      end

      it {should set_flash[:success]}
      it {should redirect_to subject.current_user}
    end

    context "when update is failed" do
      login_user
      before do
        user_param[:name] = ""
        user_param[:email] = "johndoe@gmailcom"
        user_param[:password] = "password"
        user_param[:password_confirmation] = "password1"
        patch :update, params: {id: subject.current_user.id, user: user_param}
      end

      it {should set_flash[:danger]}
      it "return some error messages" do
        expect(assigns(:user).errors.full_messages.count).to be >= 3
      end
      it {should render_template :edit}
    end
  end

  describe "DELETE #destroy: " do
    context "user is admin" do
      login_admin
      before do
        delete :destroy, params: {id: subject.current_user.id}
      end

      it {redirect_to users_path}
      it {should set_flash[:success]}
    end

    context "user is not admin" do
      login_user
      before do
        delete :destroy, params: {id: subject.current_user.id}
      end
      it {should redirect_to(root_path)}
      it {should set_flash[:warning]}
    end
  end
end
