require 'rails_helper'

RSpec.describe "ScoreDetails", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/score_details/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/score_details/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/score_details/show"
      expect(response).to have_http_status(:success)
    end
  end

end
