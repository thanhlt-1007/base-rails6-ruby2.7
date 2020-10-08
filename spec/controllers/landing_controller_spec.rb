require 'rails_helper'

RSpec.describe LandingController, type: :controller do
  describe "GET /index" do
    context "when user log_in success" do
      it "allows authenticated access" do
        signed_in nil
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
      
    context "when user log_in faile" do
      it "allows authenticated access" do
        signed_in
        get :index 
        expect(response).to have_http_status(200)
      end
    end  
  end
end
