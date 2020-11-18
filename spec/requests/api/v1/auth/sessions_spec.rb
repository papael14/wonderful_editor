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

  describe "DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    context "ユーザーがログインしているとき" do
      let(:user) { create(:user) }
      let!(:headers) { user.create_new_auth_token }

      it "ログアウトできる" do
        expect { subject }.to change { user.reload.tokens }.from(be_present).to(be_blank)
        expect(response).to have_http_status(:ok)
      end
    end

    context "ユーザーがログインしていないとき" do
      let(:user) { create(:user) }
      let!(:token) { user.create_new_auth_token }
      let!(:headers) { { "access-token" => "", "token-type" => "", "client" => "", "expiry" => "", "uid" => "" } }

      it "エラーとなる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(res["errors"]).to include "User was not found or was not logged in."
      end
    end
  end
end
