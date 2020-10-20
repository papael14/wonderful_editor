require "rails_helper"

RSpec.describe "Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get api_v1_articles_path }

    before { create_list(:user, user_count) }

    before { create_list(:article, article_count) }

    let(:user_count) {3}
    let(:article_count) {3}

    fit "記事一覧が取得できる" do
      subject

      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res.values[0].length).to eq 3
      expect(res.values[0][0]["attributes"]).to include "title"
      expect(res.values[0][0]["attributes"]).to include "updated-at"
      expect(response).to have_http_status(:ok)
    end
  end
end

# RSpec.describe "Api::V1::Articles", type: :request do
#   describe "GET /articles" do
#     subject { get(api_v1_articles_path) }

#     let!(:article1) { create(:article, updated_at: 1.days.ago) }
#     let!(:article2) { create(:article, updated_at: 2.days.ago) }
#     let!(:article3) { create(:article) }

#     fit "記事の一覧が取得できる" do
#       subject
#       res = JSON.parse(response.body)

#       expect(response).to have_http_status(:ok)
#       expect(res.length).to eq 3
#       expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
#       expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
#       expect(res[0]["user"].keys).to eq ["id", "name", "email"]
#     end
#   end
# end