require "rails_helper"

# RSpec.describe "Articles", type: :request do
#   describe "GET /api/v1/articles" do
#     subject { get api_v1_articles_path }
#     before { create_list(:user, user_count) }
#     before { create_list(:article, article_count) }

#     let(:user_count) {3}
#     let(:article_count) {3}

#     fit "記事一覧が取得できる" do
#       subject
#       res = JSON.parse(response.body)
#       binding.pry
#       expect(response).to have_http_status(:ok)
#       # expect(res.values[0].length).to eq 3
#       # expect(res.values[0][0]["attributes"]).to include "title"
#       # expect(res.values[0][0]["attributes"]).to include "updated-at"
#       expect(response).to have_http_status(:ok)
#     end
#   end
# end

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article) }

    it "記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定した id の記事が存在する場合" do
      let!(:article) { create(:article) }
      let!(:article_id) { article.id }

      it "記事の詳細が取得できる" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"].keys).to eq ["id", "name", "email"]
      end
    end

    context "指定した id の記事が存在しない場合" do
      let(:article_id) { 10000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params) }
    before { create_list(:user, user_count) }
    before { create_list(:article, article_count) }
    let(:user_count) {1}
    let(:article_count) {1}
    before do
      @baseapicontroller = Api::V1::BaseApiController.new
      @baseapicontroller = @baseapicontroller.current_user
    end

    context "適切なパラメーターを送信したとき" do
      let!(:params) do
        {
          title: Faker::Lorem.word,
          body: Faker::Lorem.sentence,
          user_id: @baseapicontroller.id,
          User: @baseapicontroller
        }
      end
      it "記事を作成できる" do
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:title]
        expect(res["body"]).to eq params[:body]
        expect(response).to have_http_status(200)
      end
    end

    context "不適切なパラメーターを送信したとき" do
      let!(:params) { attributes_for(:article)}

      fit "エラーになる" do
        expect{ subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
