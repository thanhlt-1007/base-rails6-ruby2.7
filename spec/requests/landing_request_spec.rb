require 'rails_helper'

RSpec.describe "Landings", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/"
      expect(response).to render_template :index
    end
  end
end
