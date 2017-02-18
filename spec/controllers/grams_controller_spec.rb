require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  let(:user1) {User.create(
      email:                 'fakeuser@gmail.com',
      password:              'secretPassword',
      password_confirmation: 'secretPassword'
    )}

  describe "grams#index action" do
    it "successfully loads the page" do
      get :index
      expect(response).to have_http_status(:success) 
    end
  end

  describe "grams#new action" do
    it "successfully loads new message form" do
      sign_in user1
      get :new
      expect(response).to have_http_status(200)
    end

    it "requires user to be logged in to add gram" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "grams#create action" do
    it "successfully creates a gram and saves to DB" do
      sign_in user1
      post :create, gram: {message: "Test gram check check"}
      expect(response).to redirect_to root_path
      gram = Gram.last
      expect(gram.message).to eq("Test gram check check")
      expect(gram.user).to eq(user1)
    end

    it "requires users to be signed in" do
      post :create, gram: {messae: "I'm not logged in."}
      expect(response).to redirect_to new_user_session_path
    end
 
    it "will not process invalid entries" do
      sign_in user1
      precount = Gram.count
      post :create, gram: {message: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq(precount)
    end
  end
end
