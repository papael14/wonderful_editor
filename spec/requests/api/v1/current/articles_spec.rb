require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { current_user.create_new_auth_token }

  describe "GET /current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let!(:article1) { create(:article, :published, user: current_user, updated_at: 3.days.ago) }
    let!(:article2) { create(:article, :published, user: current_user, updated_at: 2.days.ago) }
    let!(:article3) { create(:article, :published) }

    before { create(:article, :draft, user: current_user) }

    it "自分の公開記事一覧が取得できる" do
      subject
      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 2
      expect(res.map {|d| d["id"] }).to eq [article2.id, article1.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end
end
