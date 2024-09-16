require 'rails_helper'

RSpec.describe StreamsController, type: :controller do
  describe "POST #auth" do
    it "returns http success" do
      post :auth
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #start" do
    it "returns http success" do
      post :start, params: { name: 'test_stream' }  # Pass the required stream_key parameter
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #stop" do
    let!(:stream) { create(:stream, stream_key: 'test_stream') } # Create a stream for the test

    it "returns http success" do
      post :stop, params: { name: 'test_stream' }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let!(:stream) { create(:stream, stream_key: 'test_stream') }

    it "returns http success" do
      get :show, params: { id: stream.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
