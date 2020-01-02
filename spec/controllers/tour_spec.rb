require "rails_helper"

RSpec.describe ToursController, type: :controller do
  let!(:category) {FactoryBot.create :category}
  let!(:tour_clone) {FactoryBot.create :tour, category: category}
  let! :tour_param do
    {
      name: Faker::Name.name,
      description: Faker::Lorem.paragraph,
      category_id: category.id
    }
  end

  describe "GET #index: " do
    context "user is admin" do
      login_admin
      before {get :index}
      it {should respond_with :ok}
      it {should render_template :index}
    end

    context "user is not admin" do
      login_user
      before {get :index}
      it {should set_flash[:warning]}
      it {should redirect_to(root_path)}
    end
  end

  describe "GET #new: " do
    context "user is admin" do
      login_admin
      before {get :new}
      it {should respond_with :ok}
      it {should render_template :new}
    end

    context "user is not admin" do
      login_user
      before {get :new}
      it {should set_flash[:warning]}
      it {should redirect_to(root_path)}
    end
  end

  describe "POST #create: " do
    login_admin
    context "with valid attributes" do
      before {post :create, params: {tour: tour_param}}
      it {should set_flash[:success]}
      it do
        tour = Tour.last
        should redirect_to tour
      end 
    end

    context "with invalid attributes" do
      before do
        tour_param[:name] = ""
        tour_param[:description] = ""
        post :create, params: {tour: tour_param}
      end
      it {should set_flash[:danger]}
      it {should render_template :new}
    end
  end

  describe "DELETE #destroy: " do
    context "user is admin" do
      login_admin
      before {delete :destroy, params: {id: tour_clone.id}}
      it {redirect_to tours_path}
      it {should set_flash[:success]}
      it "set deleted_at field as deletion time" do
        expect(Tour.find_by(id: tour_clone.id).deleted_at.class).to be(ActiveSupport::TimeWithZone)
      end
    end

    context "user is not admin" do
      login_user
      before {delete :destroy, params: {id: Tour.last.id}}
      it {redirect_to root_path}
      it {should set_flash[:warning]}
    end
  end

  describe "DELETE #purge: " do
    context "user is admin" do
      login_admin
      before {delete :purge, params: {id: tour_clone.id}}
      it {redirect_to tours_path}
      it {should set_flash[:success]}
      it "should delete the tour" do
        expect(Tour.find_by id: tour_clone.id).to be_nil
      end
    end

    context "user is not admin" do
      login_user
      before {delete :purge, params: {id: tour_clone.id}}
      it {redirect_to root_path}
      it {should set_flash[:warning]}
    end
  end

  describe "PUT #recover: " do
    context "user is admin" do
      login_admin
      before do
        delete :destroy, params: {id: tour_clone.id}
        put :recover, params: {id: tour_clone.id}
      end
      it {redirect_to tours_path}
      it {should set_flash[:success]}
      it "set deleted_at field as nil" do
        expect(Tour.find_by(id: tour_clone.id).deleted_at).to be_nil
      end
    end

    context "user is not admin" do
      login_user
      before do
        delete :destroy, params: {id: tour_clone.id}
        put :recover, params: {id: tour_clone.id}
      end
      it {redirect_to root_path}
      it {should set_flash[:warning]}
    end
  end

  describe "GET #edit: " do
    context "user is admin" do
      login_admin
      before {get :edit, params: {id: tour_clone.id}}

      it {should respond_with :ok}
      it {should render_template :edit}
    end

    context "user is not admin" do
      login_user
      before {get :edit, params: {id: tour_clone.id}}
      it {should set_flash[:warning]}
      it {should redirect_to(root_path)}
    end
  end

  describe "PUT #update: " do
    context "user is admin and update with valid attributes" do
      login_admin
      before {put :update, params: {id: tour_clone.id, tour: tour_param}}
      
      it {should set_flash[:success]}
      it {should redirect_to tour_clone}
    end

    context "user is admin and update with invalid attributes" do
      login_admin
      before do
        tour_param[:name] = ""
        tour_param[:description] = ""
        put :update, params: {id: tour_clone.id, tour: tour_param}
      end
      it {should set_flash[:danger]}
      it {should render_template :edit}
    end

    context "user is not admin" do
      login_user
      before do
        tour_param[:name] = ""
        tour_param[:description] = ""
        put :update, params: {id: tour_clone.id, tour: tour_param}
      end
      it {should set_flash[:warning]}
      it {should redirect_to root_path}
    end
  end
end
