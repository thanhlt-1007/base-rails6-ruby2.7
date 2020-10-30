# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::V1::Users, type: :request do
  describe "Resource users" do
    # let!(:restaurant){create :restaurant}
    # let!(:token){Doorkeeper::AccessToken.create(resource_owner_id: user.id)}
    # let(:json){JSON.parse(response.body)}

    describe "GET /api/v1/users" do
      let(:path){"/api/v1/users"}

      context "responds with 200 when authorized" do
        before {FactoryBot.create :user}

        it do
          # get path, params: {access_token: token.token}
          get path
          expect(response.status).to eq 200
          expect(response.body).to eq User.all.to_json
        end
      end

      # context "responds with 401 when unauthorized" do
      #   it do
      #     get path
      #     expect(response.status).to eq 401
      #   end
      # end
    end

    # describe "PUT /api/v1/restaurants/update/:id" do
    #   let(:path){"/api/v1/restaurants/update/#{restaurant.id}"}

    #   context "responds with 401 when unauthorized" do
    #     it do
    #       put path
    #       expect(response.status).to eq 401
    #     end
    #   end

    #   context "responds with 200 when param's valid" do
    #     it do
    #       put path, params: {name: "test", total_seats: 1, access_token: token.token}
    #       expect(response.status).to eq 200
    #     end
    #   end
    # end

    # describe "POST /api/v1/restaurants/create" do
    #   let(:path){"/api/v1/restaurants/create"}

    #   context "responds with 401 when unauthorized" do
    #     it do
    #       post path
    #       expect(response.status).to eq 401
    #     end
    #   end

    #   context "responds with 200 when param's valid" do
    #     it do
    #       post path, params: {name: "test", total_seats: 1, access_token: token.token}
    #       expect(response.status).to eq 201
    #     end
    #   end

    #   context "responds with 400 when param's invalid" do
    #     it do
    #       post path, params: {name: "test", total_seats: "1asdf", access_token: token.token}
    #       expect(response.status).to eq 400
    #     end
    #   end
    # end

    # describe "POST /api/v1/restaurants/delete/:id" do
    #   let(:path){"/api/v1/restaurants/delete/#{restaurant.id}"}

    #   context "responds with 401 when unauthorized" do
    #     it do
    #       delete path
    #       expect(response.status).to eq 401
    #     end
    #   end

    #   context "responds with 200 when authorized" do
    #     it do
    #       delete path, params: {access_token: token.token}
    #       expect(response.status).to eq 200
    #     end
    #   end
    # end

    # describe "POST /api/v1/restaurants/show/:id" do
    #   let(:path){"/api/v1/restaurants/show/#{restaurant.id}"}

    #   context "responds with 401 when unauthorized" do
    #     it do
    #       get path
    #       expect(response.status).to eq 401
    #     end
    #   end

    #   context "responds with 200 when authorized" do
    #     it do
    #       get path, params: {access_token: token.token}
    #       expect(response.status).to eq 200
    #     end
    #   end
    # end
  end
end
