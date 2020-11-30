require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, :published, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, :published, updated_at: 2.days.ago) }
    let!(:article3) { create(:article, :published) }

    before { create(:article, :draft) }

    it "公開記事の一覧が取得できる" do
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

    context "指定した id の記事が公開状態の場合" do
      let!(:article) { create(:article, :published) }
      let!(:article_id) { article.id }

      it "記事の詳細が取得できる" do
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

    context "指定した id の記事が下書き状態の場合" do
      let!(:article) { create(:article, :draft) }
      let!(:article_id) { article.id }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "指定した id の記事が存在しない場合" do
      let!(:article) { create(:article) }
      let(:article_id) { 10000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    let!(:headers) { current_user.create_new_auth_token }

    # stub
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    it "記事のレコードが作成できる" do
      expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
      res = JSON.parse(response.body)
      expect(res["title"]).to eq params[:article][:title]
      expect(res["body"]).to eq params[:article][:body]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let!(:current_user) { create(:user) }
    let!(:headers) { current_user.create_new_auth_token }
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    context "自分が所持している記事のレコードを更新しようとするとき" do
      let(:article) { create(:article, user: current_user) }

      it "記事を更新できる" do
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              change { article.reload.body }.from(article.body).to(params[:article][:body])
        expect(response).to have_http_status(:ok)
      end
    end

    context "自分が所持していない記事のレコードを更新しようとするとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end

  describe "DELETE /articles/:id" do
    subject { delete(api_v1_article_path(article.id), headers: headers) }

    let(:current_user) { create(:user) }
    let!(:headers) { current_user.create_new_auth_token }
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    context "自分の記事を削除しようとするとき" do
      let!(:article) { create(:article, user: current_user) }

      it "記事を削除できる" do
        expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "他人が所持している記事のレコードを削除しようとするとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "記事を削除できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end
end

# 備忘録
# describe "POST /articles" do
#   subject { post(api_v1_articles_path, params: params) }

#   before { create_list(:user, user_count) }

#   before { create_list(:article, article_count) }

#   let(:user_count) {1}
#   let(:article_count) {1}
#   before do
#     @baseapicontroller = Api::V1::BaseApiController.new
#     @baseapicontroller = @baseapicontroller.current_user
#   end

#   context "適切なパラメーターを送信したとき" do
#     let!(:params) do
#       {
#         title: Faker::Lorem.word,
#         body: Faker::Lorem.sentence,
#         user_id: @baseapicontroller.id,
#         User: @baseapicontroller,
#       }
#     end
#     fit "記事を作成できる" do
#       expect { subject }.to change { Article.count }.by(1)
#       res = JSON.parse(response.body)
#       expect(res["title"]).to eq params[:title]
#       expect(res["body"]).to eq params[:body]
#       expect(response).to have_http_status(:ok)
#     end
#   end

#   context "不適切なパラメーターを送信したとき" do
#     let!(:params) { attributes_for(:article)}

#     fit "エラーになる" do
#       expect { subject }.to raise_error ActiveRecord::RecordInvalid
#     end
#   end
# end
