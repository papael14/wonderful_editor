# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :string           default("draft")
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"
RSpec.describe Article, type: :model do
  before do
    @user = create(:user)
  end

  context "title が入力されているとき" do
    it "下書き状態の記事が作成される" do
      article = build(:article)
      expect(article).to be_valid
      expect(article.status).to eq "draft"
    end
  end

  context "title が空白のとき" do
    it "エラーとなる" do
      article = build(:article, title: nil)
      expect(article).to be_invalid
      expect(article.errors.details[:title][0][:error]).to eq :blank
    end
  end

  context "status が下書きのとき" do
    let(:article) { build(:article, :draft)}
    it "下書き記事が作成できる" do
      expect(article).to be_valid
      expect(article.status).to eq "draft"
    end
  end

  context "status が公開のとき" do
    let(:article) { build(:article, :published)}
    it "公開記事が作成できる" do
      expect(article).to be_valid
      expect(article.status).to eq "published"
    end
  end

  # statusの入力条件はなし、後で変えるかも
  # context "status が空白のとき" do
  #   it "エラーとなる" do
  #     article = build(:article, status: nil)
  #     expect(article).to be_invalid
  #     expect(article.errors.details[:status][0][:error]).to eq :blank
  #   end
  # end
end
