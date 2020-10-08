require 'rails_helper'

RSpec.describe LandingController, type: :controller do
  describe "GET /index" do
    let(:user) {FactoryBot.create(:user)}

    context "when user log_in" do
      login_user

      it "returns http success" do
        get :index
        expect(response).to render_template :index
      end
    end

    context "when user is not log_in" do
      it "returns http faile" do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
    end  
  end
end
