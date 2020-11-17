require "rails_helper"

RSpec.describe "Api/V1::Auth::Session", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "ログイン情報が正しいとき" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: user.password) }

      it "ログインできる" do
        subject
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["uid"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "emailが間違っているとき" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: "999", password: user.password) }

      it "エラーとなる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        header = response.header
        expect(header["access-token"]).to be nil
        expect(header["client"]).to be nil
        expect(header["uid"]).to be nil
      end
    end

    context "passwordが間違っているとき" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: "888") }

      it "エラーとなる" do
        subject

        res = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        header = response.header
        expect(header["access-token"]).to be nil
        expect(header["client"]).to be nil
        expect(header["uid"]).to be nil
      end
    end
  end
end
