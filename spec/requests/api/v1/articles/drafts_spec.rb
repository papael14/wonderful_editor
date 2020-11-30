require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  let(:current_user) { create(:user, id: 99) }
  let!(:headers) { current_user.create_new_auth_token }

  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    let!(:article1) { create(:article, user_id: 99, updated_at: 3.days.ago) }
    let!(:article2) { create(:article, user_id: 99, updated_at: 2.days.ago) }
    let!(:article3) { create(:article, :published, user_id: 99) }

    it "自分の下書き記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 2
      expect(res.map {|d| d["id"] }).to eq [article2.id, article1.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET /api/vi/articles/draft/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    context "指定した id の記事が下書き公開状態の場合" do
      let!(:article) { create(:article, :draft, user_id: 99) }
      let(:article_id) { article.id }

      it "下書き記事の詳細が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["status"]).to eq article.status
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"].keys).to eq ["id", "name", "email"]
      end
    end

    context "指定したidの記事が他ユーザーの下書きの場合" do
      let!(:article) { create(:article, :draft) }
      let(:article_id) { article.id }

      it "エラーとなる" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
