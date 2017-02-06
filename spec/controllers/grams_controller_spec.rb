require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams#index action" do
    it "successfully loads the page" do
      get :index
      expect(response).to have_http_status(:success) 
    end
  end

  describe "grams#new action" do
    it "successfully loads new message form" do
      get :new
      expect(response).to have_http_status(200)
    end
  end

  describe "grams#create action" do
    it "successfully creates a gram and saves to DB" do
      post :create, gram: {message: "Test gram check check"}
      expect(response).to redirect_to root_path
      gram = Gram.last
      expect(gram.message).to eq("Test gram check check")
    end

    it "will not process invalid entries" do
      post :create, gram: {message: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
  end
end
