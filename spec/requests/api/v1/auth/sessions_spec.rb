require "rails_helper"

RSpec.describe "Api/V1::Auth::Session", type: :request do
  describe "GET /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "必要な情報が存在するとき" do
      let(:params) { attributes_for(:user) }

      it "ログインできる" do
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
        expect(res["data"]["email"]).to eq(User.last.email)
      end
    end
  end
end
