# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  subject { user.errors.details[:name][0][:error] }

  context "必要な情報が揃っている場合" do
    let(:user) { build(:user) }
    it "ユーザーが作られる" do
      expect(user).to be_valid
    end
  end

  context "name が空白のとき" do
    let(:user) { build(:user, name: nil) }
    it "エラーとなる" do
      expect(user).to be_invalid
      expect(subject).to eq :blank
    end
  end

  # validation変更したのでコメントアウト
  # context "name が登録済のとき" do
  #   let(:user) { build(:user, name: "test") }
  #   it "エラーとなる" do
  #     create(:user, name: "test")
  #     binding.pry
  #     expect(user).to be_invalid
  #     expect(subject).to eq :taken
  #   end
  # end

  context "email が登録済のとき" do
    let(:user) { build(:user, email: "test@ex.com") }
    it "エラーとなる" do
      create(:user, email: "test@ex.com")
      expect(user).to be_invalid
      expect(user.errors.details[:email][0][:error]).to eq :taken
    end
  end

  context "password が空白のとき" do
    let(:user) { build(:user, password: nil) }
    it "エラーとなる" do
      expect(user).to be_invalid
      expect(user.errors.details[:password][0][:error]).to eq :blank
    end
  end
end
