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
FactoryBot.define do
  factory :comment do
    body { Faker::Job.field }
    sequence(:user_id) {|n| n.to_s }
    sequence(:article_id) {|n| n.to_s }
    sequence(:id) {|n| n.to_s }
    #    user_id { 1 }
    #    article_id { 1 }
  end
end
