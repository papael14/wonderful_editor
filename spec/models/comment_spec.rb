# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"
RSpec.describe Comment, type: :model do
  before do
    @user = create(:user)
    @article = create(:article)
  end

  xcontext "body が入力されているとき" do
    let(:comment) { build(:comment)}
    it "user が作成される" do
      expect(comment).to be_valid
    end
  end

  context "body が空白のとき" do
    it "エラーとなる" do
      comment = build(:comment, body: nil)
      expect(comment).to be_invalid
      expect(comment.errors.details[:body][0][:error]).to eq :blank
    end
  end
end
