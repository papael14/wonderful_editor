# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :string
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
FactoryBot.define do
  factory :article do
    title { Faker::Job.title }
    body { Faker::Job.field }
    status { Faker::Job.seniority }
    sequence(:user_id) { |n| "#{n}" }
    sequence(:id) { |n| "#{n}" }
#    id { 1 }
#    user_id { 1 }
  end
end
